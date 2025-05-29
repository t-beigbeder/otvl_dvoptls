import argparse
import logging

import requests

from utils import files
from provisioner import host_secrets

logger = logging.getLogger('provisioner')


def run(args: argparse.Namespace):
    hcreds = {}
    for host in args.hosts:
        pw, ek = host_secrets.host_credentials(host)
        hcreds[host] = {"password": pw, "ekey": ek}
    auth = None
    if args.creds_file:
        auth = files.read_creds_file(args.creds_file)
    result = requests.get(
        f"https://{args.server}:{args.port}/healthcheck",
        cert=(args.cert, args.key),
        verify=args.cas,
        auth=auth)
