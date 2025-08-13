import argparse
import http
import json
import logging

import requests
import yaml

from utils import xdg
from utils.aes import decrypt
from utils.vlts_client import request_args, base_url, decrypt_token

logger = logging.getLogger("consumer")


def run(args: argparse.Namespace) -> bool:
    if not args.creds_file:
        args.creds_file = f"{xdg.xdg_config_dir()}/{args.host}"
    req_args = request_args(args, True)
    if not args.get_hosts:
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
    else:
        rsp = requests.get(base_url(args) + f"host/{args.host}/secret/_hosts",
                           **req_args)
        if rsp.status_code != http.HTTPStatus.OK:
            logger.error(f"Failed to read _hosts for host {args.host}, status {rsp.status_code}")
            return False
        jo = json.loads(rsp.content)
        path = f"{xdg.xdg_config_dir()}/ext_hosts"
        jo2 = {}
        with open(path, "w") as f:
            for host, ip in jo["value"].items():
                f.write(f"{ip} {host}\n")
                jo2[host+"-ext"] = ip
        path2 = f"{xdg.xdg_config_dir()}/ext_hosts.yaml"
        with open(path2, "w") as f:
            yaml.dump({"ext_hosts": jo2}, f, default_flow_style=False)

    return True
