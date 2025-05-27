import argparse
import logging
import http.client
import ssl

import requests

logger = logging.getLogger('provisioner')

def run(args: argparse.Namespace):
    auth = None
    if args.creds_file:
        with open(args.creds_file) as f:
            line = f.readline()
            if line.endswith('\n'):
                line = line[:-1]
            auth = line.split(':')
    logger.info("run")
    result = requests.get(
        f"https://{args.server}:{args.port}/healthcheck",
        cert=(args.cert, args.key),
        verify=args.cas,
        auth=auth)