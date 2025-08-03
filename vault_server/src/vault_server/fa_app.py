import logging
import os
import signal
from contextlib import asynccontextmanager
from typing import Annotated

from fastapi import FastAPI, Depends, status, Response, Request, HTTPException
from fastapi.security import HTTPBasic, HTTPBasicCredentials

from vault_server import app_config
from vault_server import store as vault_store
from vault_server.asgi import TlsMiddleware
from vault_server.model import Host, Secret
from vault_server.secu import is_admin, server_digest, is_host


@asynccontextmanager
async def lifespan(app: FastAPI):
    if app_config.config.pass_file is not None:
        logger.info(f"Using self-signed certificate until {app_config.config.pass_file} is provisioned")
    else:
        logger.info("Using PKI SSL key file")
    yield


app = FastAPI(lifespan=lifespan)
app.add_middleware(TlsMiddleware)
logger = logging.getLogger(__name__)
security = HTTPBasic()


@app.get("/healthcheck")
async def healthcheck():
    return {"message": "healthy"}


@app.post("/ssl_keyfile_password")
async def store_ssl_keyfile_password(req: Request, rsp: Response):
    if app_config.config.pass_file is None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="pass_file is not set")
    if os.path.exists(app_config.config.pass_file):
        raise HTTPException(status_code=status.HTTP_409_CONFLICT,
                            detail=f"passw file {app_config.config.pass_file} already exists")
    bts = await req.body()
    try:
        with open(app_config.config.pass_file, "wb") as key_file:
            key_file.write(bts)
            key_file.write("\n".encode())
        rsp.status_code = status.HTTP_201_CREATED
        # time for systemd to restart us with the certificate issued by a PKI
        logger.info(f"{app_config.config.pass_file} created, shutting down")
        os.kill(os.getpid(), signal.SIGTERM)
    except FileNotFoundError:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="pass_file cannot be created")


@app.post("/host")
async def create_host(host: Host,
                      store: Annotated[dict, Depends(vault_store.store)],
                      creds: Annotated[HTTPBasicCredentials, Depends(security)],
                      rsp: Response,
                      force: bool | None = None):
    if not is_admin(creds):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="only admin can do that")
    if host.name in store and not force:
        rsp.status_code = status.HTTP_409_CONFLICT
        return
    present = host.name in store
    store[host.name] = {"_hex_digest": server_digest(host)}
    logger.info(f"Creating new host {host.name} digest {store[host.name]['_hex_digest']}")
    rsp.status_code = status.HTTP_201_CREATED if not present else status.HTTP_200_OK


@app.post("/host/{name}/secret")
async def add_secret(name: str, secret: Secret,
                     store: Annotated[dict, Depends(vault_store.store)],
                     creds: Annotated[HTTPBasicCredentials, Depends(security)],
                     rsp: Response,
                     force: bool | None = None):
    if not is_admin(creds):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="only admin can do that")
    if name not in store:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return
    if secret.key in store[name] and not force:
        rsp.status_code = status.HTTP_409_CONFLICT
        return
    present = secret.key in store[name]
    store[name][secret.key] = secret.value
    rsp.status_code = status.HTTP_201_CREATED if not present else status.HTTP_200_OK


@app.get("/host/{name}/secret/{key}")
async def get_secret(name: str, key: str,
                     store: Annotated[dict, Depends(vault_store.store)],
                     creds: Annotated[HTTPBasicCredentials, Depends(security)],
                     req: Request,
                     rsp: Response):
    if name not in store:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "host not found"}
    if not is_host(creds, store[name]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"host {name} unauthenticated")
    if key == "_hosts":
        return {"value": store[key]}
    if key not in store[name]:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "secret not found"}
    store["_hosts"][name] = req.client.host
    return {"value": store[name][key]}
