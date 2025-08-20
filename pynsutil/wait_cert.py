import argparse
import sys
from urllib import request
import time


parser = argparse.ArgumentParser()
parser.add_argument("-u", "--url", required=True)
args = parser.parse_args()
while True:
    try:
        r = request.urlopen(args.url)
        sys.exit(0)
    except Exception as ex:
        sys.stderr.write(f"{ex}\n")
        time.sleep(60)
