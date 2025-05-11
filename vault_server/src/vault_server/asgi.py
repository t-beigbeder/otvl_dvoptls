import logging
from typing import Annotated

from fastapi import FastAPI, Depends, status, Response

from vault_server import store as vault_store
from vault_server.model import Host

app = FastAPI()
logger = logging.getLogger(__name__)


@app.get("/healthcheck")
async def healthcheck():
    return {"message": "healthy"}


@app.post("/host")
async def host(host: Host, store: Annotated[dict, Depends(vault_store.store)], response: Response):
    if host.name in store:
        response.status_code = status.HTTP_409_CONFLICT
        return
    store[host.name] = dict()
