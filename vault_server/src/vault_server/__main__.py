import ssl
import argparse

import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

parser = argparse.ArgumentParser()
parser.add_argument("--host", default="127.0.0.1")
parser.add_argument("-p", "--port", default=5443, type=int)
parser.add_argument("-l", "--level", default="info")
parser.add_argument("-c", "--cert", default="/tmp/srv.otvl.c.pem")
parser.add_argument("-k", "--key", default="/tmp/srv.otvl.k.pem")
parser.add_argument("--ccert", default=ssl.CERT_NONE, action="store_const", const=ssl.CERT_REQUIRED)
parser.add_argument("--cas", default="/tmp/fca.otvl.c.pem")
args = parser.parse_args()

uvicorn.run(
        app,
        host=args.host,
        port=args.port,
        log_level=args.level,
        ssl_certfile=args.cert,
        ssl_keyfile=args.key,
        ssl_cert_reqs=args.ccert,
        ssl_ca_certs=args.cas,
)
