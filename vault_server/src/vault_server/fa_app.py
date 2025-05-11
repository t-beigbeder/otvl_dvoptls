import logging
from typing import Annotated

from fastapi import FastAPI, Depends, status, Response, Request

from vault_server import store as vault_store
from vault_server.model import Host, Secret

app = FastAPI()
logger = logging.getLogger(__name__)


@app.get("/healthcheck")
async def healthcheck():
    return {"message": "healthy"}


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
