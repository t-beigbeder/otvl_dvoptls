import argparse
import logging

import requests

from utils import files

logger = logging.getLogger('provisioner')


def run(args: argparse.Namespace):
    for host in args.hosts:
        pass
    auth = None
    if args.creds_file:
        auth = files.read_creds_file(args.creds_file)
    result = requests.get(
        f"https://{args.server}:{args.port}/healthcheck",
        cert=(args.cert, args.key),
        verify=args.cas,
        auth=auth)
