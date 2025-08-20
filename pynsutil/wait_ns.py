import argparse
import sys
import socket
import time

# this waits until the IP addresses provisioned locally (through vault server)
# and through DNS are identical

parser = argparse.ArgumentParser()
parser.add_argument("-l", "--local", required=True)
parser.add_argument("-n", "--fqdn", required=True)
args = parser.parse_args()
lip = socket.gethostbyname(args.local)
nip = socket.gethostbyname(args.fqdn)
while True:
    nip = socket.gethostbyname(args.fqdn)
    if nip == lip:
        sys.exit(0)
    sys.stderr.write(f"{args.local}:{lip} != {args.fqdn}:{nip}\n")
    time.sleep(60)
