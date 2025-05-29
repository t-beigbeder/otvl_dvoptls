import argparse
import logging

import app

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--server", default="127.0.0.1")
parser.add_argument("-p", "--port", default=9443, type=int)
parser.add_argument("-l", "--level", default="INFO")
parser.add_argument("-c", "--cert", default="/tmp/cli.otvl.c.pem")
parser.add_argument("-k", "--key", default="/tmp/cli.otvl.k.pem")
parser.add_argument("--cas", default="/tmp/fca.otvl.c.pem")
parser.add_argument("--no-ssl", default=False, action="store_true")
parser.add_argument("--creds-file")
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
