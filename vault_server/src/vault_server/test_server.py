import ipaddress
import multiprocessing
import os
import signal
import ssl
import sys
import tempfile
import time
import unittest

import uvicorn

from test_pki.__main__ import build_certs
from vault_server import asgi


def _uvicorn():
    uvicorn.run(
        asgi.app,
        host="127.0.0.1",
        port=5443,
        log_level="info",
    )


class TestServer(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.ccert = ssl.CERT_REQUIRED

    def setUp(self):
        self.td = tempfile.TemporaryDirectory(self.id().split('.')[-1])
        build_certs(self.td.name, self.td.name,
                    ["localhost"],
                    [ipaddress.IPv4Address("127.0.0.1")])

    def tearDown(self):
        time.sleep(1)
        sys.stderr.write("TestServer.tearDown\n")
        os.kill(self.p.pid, signal.SIGTERM)
        self.p.join()

    def _run_server(self):
        self.p = multiprocessing.Process(target=_uvicorn)
        self.p.start()

    def test_server_basic(self):
        self._run_server()

    def test_server_nocc(self):
        self.ccert = ssl.CERT_NONE
        self._run_server()
