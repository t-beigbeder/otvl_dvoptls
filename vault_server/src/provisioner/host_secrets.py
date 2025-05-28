import os
import uuid

from utils import xdg, files


def _suid(uid):
    return uid[0:16], uid[16:]


def host_credentials(host):
    path = f"{xdg.xdg_config_dir()}/{host}"
    if os.path.exists(path):
        return _suid(files.read_pass_file(path))
    uid = uuid.uuid4().hex
    with open(path, "w") as f:
        f.write(f"{uid}\n")
    return _suid(uid)
