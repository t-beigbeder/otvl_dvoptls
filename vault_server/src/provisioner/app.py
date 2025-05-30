import argparse
import http
import logging
import subprocess

import requests

from provisioner import host_secrets
from utils.aes import encrypt
from utils.vlts_client import request_args, base_url

logger = logging.getLogger('provisioner')


def run(args: argparse.Namespace) -> bool:
    hcreds = {}
    for host in args.hosts:
        pw, ek = host_secrets.host_credentials(host)
        hcreds[host] = {"password": pw, "ekey": ek}
    req_args = request_args(args)
    for hn, hc in hcreds.items():
        logger.info(f"Provisioning host {hn}")
        rsp = requests.post(
            base_url(args) + f"host?force={args.force_host}",
            **req_args,
            json={"name": hn, "password": hc["password"]})
        if rsp.status_code != http.HTTPStatus.OK and rsp.status_code != http.HTTPStatus.CREATED:
            logger.error(f"Failed to provision host {hn}, status {rsp.status_code}")
            return False
        logger.info(f"Provisioning secrets for host {hn}")
        cp = subprocess.run(
            ["sops", "-d", f"{args.secrets_dir}/{hn}.enc.yaml"],
            stdout=subprocess.PIPE)
        cp.check_returncode()
        hs = encrypt(cp.stdout.decode("utf-8"), hc["ekey"]).decode("utf-8")
        rsp = requests.post(
            base_url(args) + f"host/{hn}/secret?force={args.force_secret}",
            **req_args,
            json={"key": "secrets", "value": hs})
        if rsp.status_code != http.HTTPStatus.OK and rsp.status_code != http.HTTPStatus.CREATED:
            logger.error(f"Failed to provision secret for host {hn}, status {rsp.status_code}")
            return False
    return True
