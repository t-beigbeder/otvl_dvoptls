import os


def _home():
    return os.path.expanduser('~')


def xdg_config_dir():
    cd = os.environ.get("XDG_CONFIG_DIR", _home() + "/.config") + "/otvl_vlts"
    if os.path.exists(cd):
        return cd
    os.makedirs(cd, 0o700)
    return cd
