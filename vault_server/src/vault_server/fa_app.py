import logging
import os
from typing import Annotated

from fastapi import FastAPI, Depends, status, Response, Request, HTTPException

from vault_server import store as vault_store
from vault_server.model import Host, Secret
from  vault_server import app_config
from vault_server.asgi import TlsMiddleware

app = FastAPI()
app.add_middleware(TlsMiddleware)
logger = logging.getLogger(__name__)


@app.get("/healthcheck")
async def healthcheck():
    return {"message": "healthy"}


@app.post("/ssl_keyfile_password")
async def store_ssl_keyfile_password(req: Request, rsp: Response):
    if app_config.config.ssl_keyfile_password is None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="ssl_keyfile_password is not set")
    if os.path.exists(app_config.config.ssl_keyfile_password):
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="ssl_keyfile_password already exists")
    bts = await req.body()
    try:
        with open(app_config.config.ssl_keyfile_password, "wb") as key_file:
            key_file.write(bts)
            key_file.write("\n".encode())
        rsp.status_code = status.HTTP_201_CREATED
    except FileNotFoundError:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="ssl_keyfile_password cannot be created")


@app.post("/host")
async def create_host(host: Host, store: Annotated[dict, Depends(vault_store.store)], rsp: Response):
    if host.name in store:
        rsp.status_code = status.HTTP_409_CONFLICT
        return
    store[host.name] = dict()
    rsp.status_code = status.HTTP_201_CREATED


@app.post("/host/{name}/secret")
async def add_secret(name: str, secret: Secret, store: Annotated[dict, Depends(vault_store.store)], rsp: Response):
    if name not in store:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return
    if secret.key in store[name]:
        rsp.status_code = status.HTTP_409_CONFLICT
        return
    store[name][secret.key] = secret.value
    rsp.status_code = status.HTTP_201_CREATED


@app.get("/host/{name}/secret/{key}")
async def get_secret(name: str, key: str, store: Annotated[dict, Depends(vault_store.store)], req: Request,
                     rsp: Response):
    if name not in store:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "host not found"}
    if key not in store[name]:
        rsp.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "secret not found"}
    return {"value": store[name][key]}
