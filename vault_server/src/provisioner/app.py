import argparse
import http
import logging
import subprocess

import requests

from provisioner import host_secrets
from utils import files
from utils.aes import encrypt

logger = logging.getLogger('provisioner')


def _base_url(args: argparse.Namespace) -> str:
    return f"https://{args.server}:{args.port}/"


def run(args: argparse.Namespace) -> bool:
    hcreds = {}
    for host in args.hosts:
        pw, ek = host_secrets.host_credentials(host)
        hcreds[host] = {"password": pw, "ekey": ek}
    auth = None
    if args.creds_file:
        auth = files.read_creds_file(args.creds_file)
    req_args = dict(
        cert=(args.cert, args.key),
        verify=args.cas,
        auth=auth)
    for hn, hc in hcreds.items():
        logger.info(f"Provisioning host {hn}")
        rsp = requests.post(
            _base_url(args) + f"host?force={args.force_host}",
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
            _base_url(args) + f"host/{hn}/secret?force={args.force_secret}",
            **req_args,
            json={"key": "secrets", "value": hs})
        if rsp.status_code != http.HTTPStatus.OK and rsp.status_code != http.HTTPStatus.CREATED:
            logger.error(f"Failed to provision secret for host {hn}, status {rsp.status_code}")
            return False
    return True
