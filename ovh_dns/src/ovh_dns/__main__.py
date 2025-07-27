import argparse
import sys

import ovh


parser = argparse.ArgumentParser()
parser.add_argument("-i", "--ingress", nargs="+")
parser.add_argument("--ip", required=True)
parser.add_argument("-a", "--all", default=False, action="store_true")
args = parser.parse_args()
oc = ovh.Client()  # ~/.ovh.conf, authorize GET and PUT on /domain/zone/*
recs = oc.get("/domain/zone/otvl.org/record?fieldType=A")
ing_recs = {}
for rec in recs:
    url = f"/domain/zone/otvl.org/record/{rec}"
    recc = oc.get(url)
    if recc["subDomain"] in args.ingress:
        ing_recs[recc["subDomain"]] = recc
        sys.stdout.write(f"{recc}\n")
    elif args.all:
        sys.stdout.write(f"{recc}\n")

if ing_recs:
    for rec in ing_recs.values():
        id = rec["id"]
        oc.put(f"/domain/zone/otvl.org/record/{id}", subDomain=rec["subDomain"], target=args.ip, ttl=0)
recs = oc.get("/domain/zone/otvl.org/record?fieldType=A")
for rec in recs:
    url = f"/domain/zone/otvl.org/record/{rec}"
    recc = oc.get(url)
    if recc["subDomain"] in args.ingress or args.all:
        sys.stdout.write(f"{recc}\n")

oc.post("/domain/zone/otvl.org/refresh")
