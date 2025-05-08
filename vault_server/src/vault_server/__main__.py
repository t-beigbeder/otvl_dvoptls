import ssl

import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

uvicorn.run(
        app,
        host="127.0.0.1",
        port=5000,
        log_level="trace",
        ssl_certfile='/tmp/srv.otvl.c.pem',
        ssl_keyfile='/tmp/srv.otvl.k.pem',
        ssl_cert_reqs=ssl.CERT_REQUIRED,
        #ssl_cert_reqs=ssl.CERT_NONE,
        ssl_ca_certs="/tmp/fca.otvl.c.pem",
)
