import argparse
import os
import ssl

import uvicorn

from utils import files
from vault_server import fa_app
from vault_server.app_config import new_app_config

parser = argparse.ArgumentParser()
parser.add_argument("--host", default="127.0.0.1")
parser.add_argument("-p", "--port", default=9443, type=int)
parser.add_argument("-l", "--level", default="info")
parser.add_argument("--log-config", default="log_config.yml")
parser.add_argument("-c", "--cert", default="/tmp/srv.otvl.c.pem")
parser.add_argument("-k", "--key", default="/tmp/srv.otvl.k.pem")
parser.add_argument("--self-cert", default="/tmp/slf.otvl.c.pem")
parser.add_argument("--self-key", default="/tmp/slf.otvl.k.pem")
parser.add_argument("--pass-file")
parser.add_argument("--no-ccert", default=ssl.CERT_REQUIRED, action="store_const", const=ssl.CERT_NONE)
parser.add_argument("--cas", default="/tmp/fca.otvl.c.pem")
parser.add_argument("--no-ssl", default=False, action="store_true")
parser.add_argument("--admin-digest", default="04efdddb07ba603cc25b1c93115fbb2a9fc4b4093eeb2faee9cb226f0b02c6a8")
args = parser.parse_args()

acd = {"pass_file": None, "admin_digest": args.admin_digest}
if args.no_ssl:
    add_args = dict()
elif args.pass_file is not None and not os.path.exists(args.pass_file):
    acd["pass_file"] = args.pass_file
    add_args = dict(
        ssl_certfile=args.self_cert,
        ssl_keyfile=args.self_key,
    )
else:
    skp = files.read_pass_file(args.pass_file) if args.pass_file else None
    add_args = dict(
        ssl_certfile=args.cert,
        ssl_keyfile=args.key,
        ssl_keyfile_password=skp,
        ssl_cert_reqs=args.no_ccert,
        ssl_ca_certs=args.cas,
    )

new_app_config(**acd)
uvicorn.run(
    fa_app.app,
    host=args.host,
    port=args.port,
    log_level=args.level,
    log_config=args.log_config,
    **add_args
)
