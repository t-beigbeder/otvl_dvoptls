import ipaddress
import ssl
import sys
import unittest
import subprocess
import tempfile

from test_pki.__main__ import build_certs


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
        sys.stderr.write("TestServer.tearDown\n")

    def _run_server(self):
        self.sp = subprocess.Popen(
            ["/usr/bin/echo", sys.executable, "-m", "vault_server.test_server"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        for line in self.sp.stdout.readlines():
            sys.stderr.write(line.decode())

    def test_server_basic(self):
        self._run_server()

    def test_server_nocc(self):
        self.ccert = ssl.CERT_NONE
        self._run_server()
