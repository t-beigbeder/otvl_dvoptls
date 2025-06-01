import argparse
import logging

from consumer import app
from utils.vlts_client import client_argparser

parser = argparse.ArgumentParser()
client_argparser(parser)
parser.add_argument("--host", required=True)
args = parser.parse_args()

logger = logging.getLogger("consumer")
logger.setLevel(args.level)
ch = logging.StreamHandler()
ch.setLevel(args.level)
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
ch.setFormatter(formatter)
logger.addHandler(ch)

logger.info("Starting consumer")
app.run(args)
logger.info("Ending consumer")
