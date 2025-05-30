import argparse
import logging

import app
from utils.vlts_client import client_argparser

parser = argparse.ArgumentParser()
client_argparser(parser)
parser.add_argument("--hosts", nargs="*", default=[])
parser.add_argument("--force-host", default=False, action="store_true")
parser.add_argument("--secrets-dir", default="lops_repo/vlts_secrets/otvl/prod")
parser.add_argument("--force-secret", default=False, action="store_true")
args = parser.parse_args()

logger = logging.getLogger('provisioner')
logger.setLevel(args.level)
ch = logging.StreamHandler()
ch.setLevel(args.level)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

logger.info("Starting provisioner")
app.run(args)
logger.info("Ending provisioner")
