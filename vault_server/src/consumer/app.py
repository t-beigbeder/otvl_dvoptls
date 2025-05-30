import argparse
import http
import json
import logging

import requests

from utils import xdg
from utils.aes import decrypt
from utils.vlts_client import request_args, base_url, decrypt_token

logger = logging.getLogger("consumer")


def run(args: argparse.Namespace) -> bool:
    req_args = request_args(args, True)
    rsp = requests.get(base_url(args) + f"host/{args.host}/secret/secrets",
                       **req_args)
    if rsp.status_code != http.HTTPStatus.OK:
        logger.error(f"Failed to read secret for host {args.host}, status {rsp.status_code}")
        return False
    jo = json.loads(rsp.content)
    yd = decrypt(jo["value"], decrypt_token(args))
    path = f"{xdg.xdg_config_dir()}/{args.host}.yaml"
    with open(path, "w") as f:
        f.write(yd)
    return True
