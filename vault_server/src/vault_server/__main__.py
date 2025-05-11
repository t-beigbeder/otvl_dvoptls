import argparse
import ssl

import uvicorn

from vault_server import asgi

parser = argparse.ArgumentParser()
parser.add_argument("--host", default="127.0.0.1")
parser.add_argument("-p", "--port", default=5443, type=int)
parser.add_argument("-l", "--level", default="info")
parser.add_argument("--log-config", default="log_config.yml")
parser.add_argument("-c", "--cert", default="/tmp/srv.otvl.c.pem")
parser.add_argument("-k", "--key", default="/tmp/srv.otvl.k.pem")
parser.add_argument("--no-ccert", default=ssl.CERT_REQUIRED, action="store_const", const=ssl.CERT_NONE)
parser.add_argument("--cas", default="/tmp/fca.otvl.c.pem")
parser.add_argument("--no-ssl", default=False, action="store_true")
args = parser.parse_args()

if args.no_ssl:
    add_args = dict()
else:
    add_args = dict(
        ssl_certfile=args.cert,
        ssl_keyfile=args.key,
        ssl_cert_reqs=args.no_ccert,
        ssl_ca_certs=args.cas,
    )

uvicorn.run(
    asgi.app,
    host=args.host,
    port=args.port,
    log_level=args.level,
    log_config=args.log_config,
    **add_args
)
