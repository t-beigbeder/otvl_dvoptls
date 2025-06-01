import os
import uuid

from utils import xdg, files, aes


def _suid(uid):
    return uid[0:16], uid[16:]


def host_credentials(host):
    path = f"{xdg.xdg_config_dir()}/{host}"
    if os.path.exists(path):
        return tuple(files.read_pass_file(path).split(":"))
    password = uuid.uuid4().hex
    token = aes.new_token()
    with open(path, "w") as f:
        f.write(f"{password}:{token}\n")
    return password, token
