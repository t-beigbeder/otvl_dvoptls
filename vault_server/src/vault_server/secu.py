import hashlib
import logging

from fastapi.security import HTTPBasicCredentials

from vault_server import app_config
from vault_server.model import Host

logger = logging.getLogger(__name__)


def _ba_digest(creds: HTTPBasicCredentials):
    m = hashlib.sha256()
    m.update(creds.username.encode("utf8"))
    m.update(":".encode("utf8"))
    m.update(creds.password.encode("utf8"))
    return m.hexdigest()


def server_digest(host: Host):
    m = hashlib.sha256()
    m.update(host.name.encode("utf8"))
    m.update(":".encode("utf8"))
    m.update(host.password.encode("utf8"))
    return m.hexdigest()


def is_admin(creds: HTTPBasicCredentials):
    hd = _ba_digest(creds)
    res = hd == app_config.config.admin_digest
    if not res:
        logger.debug(f"admin digest not match {hd}")
    return res


def is_host(creds: HTTPBasicCredentials, hs: dict):
    hd = _ba_digest(creds)
    res = hd == hs["_hex_digest"]
    if not res:
        logger.debug(f"server digest {hs} not match {hd}")
    return res
