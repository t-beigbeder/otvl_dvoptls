import ipaddress
import multiprocessing
import ssl
import tempfile
import time
import unittest

import requests
import uvicorn

from pki_test import build_certs
from vault_server import fa_app


def _uvicorn(*args):
    td, ccert = args
    tdn = td.name
    add_args = dict()
    if ccert == ssl.CERT_REQUIRED:
        add_args["ssl_ca_certs"] = f"{tdn}/fca.otvl.c.pem"
    uvicorn.run(
        fa_app.app,
        host="127.0.0.1",
        port=5443,
        log_level="info",
        log_config=None,
        ssl_certfile=f"{tdn}/srv.otvl.c.pem",
        ssl_keyfile=f"{tdn}/srv.otvl.k.pem",
        ssl_cert_reqs=ccert,
        **add_args
    )


class TestServer(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.td = None
        self.sp = None
        self.ccert = ssl.CERT_REQUIRED

    def setUp(self):
        self.td = tempfile.TemporaryDirectory(self.id().split('.')[-1])
        build_certs(self.td.name, self.td.name,
                    ["localhost"],
                    [ipaddress.IPv4Address("127.0.0.1")])

    def tearDown(self):
        time.sleep(1e-1)
        if self.sp is not None:
            self.sp.terminate()
            self.sp.join()
        self.td.cleanup()

    def _run_server(self):
        self.sp = multiprocessing.Process(
            target=_uvicorn,
            args=(self.td, self.ccert,))
        self.sp.start()

    def test_server_basic(self):
        self._run_server()
        time.sleep(1e-1)
        tdn = self.td.name
        try:
            resp = requests.get(
                "https://127.0.0.1:5443/healthcheck",
                cert=(f"{tdn}/cli.otvl.c.pem", f"{tdn}/cli.otvl.k.pem"),
                verify=f"{tdn}/fca.otvl.c.pem"
            )
            self.assertEqual(resp.status_code, 200)
        except Exception as e:
            raise e

    def test_server_error(self):
        self._run_server()
        time.sleep(1e-1)
        tdn = self.td.name
        ee = None
        try:
            requests.get(
                "https://127.0.0.1:5443/healthcheck",
                verify=f"{tdn}/fca.otvl.c.pem"
            )
        except Exception as e:
            ee = e
        self.assertIsNotNone(ee)

    def test_server_nocc(self):
        self.ccert = ssl.CERT_NONE
        self._run_server()
        time.sleep(1e-1)
        tdn = self.td.name
        try:
            resp = requests.get(
                "https://127.0.0.1:5443/healthcheck",
                verify=f"{tdn}/fca.otvl.c.pem"
            )
            self.assertEqual(resp.status_code, 200)
        except Exception as e:
            raise e
