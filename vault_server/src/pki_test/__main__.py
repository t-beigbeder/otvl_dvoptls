import argparse
import ipaddress

from pki_test import build_certs

parser = argparse.ArgumentParser()
parser.add_argument("--cdir", default="/tmp")
parser.add_argument("--kdir", default="/tmp")
parser.add_argument("--host", nargs="*", default=["localhost"])
parser.add_argument("-a", "--addr", nargs="*", default=["127.0.0.1"])
parser.add_argument("-d", "--days", type=int, default=365)
parser.add_argument("--pass-file")
args = parser.parse_args()
addrs = []
for addr in args.addr:
    addrs.append(ipaddress.ip_address(addr))
build_certs(args.kdir, args.cdir, args.host, addrs, args.days, args.pass_file)
