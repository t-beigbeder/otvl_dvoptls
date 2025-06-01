import os
import tempfile
import unittest

from provisioner.host_secrets import host_credentials
from utils import xdg


class TestHostSecrets(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(self.id().split('.')[-1])
        os.environ["XDG_CONFIG_DIR"] = self.td.name

    def tearDown(self):
        del os.environ["XDG_CONFIG_DIR"]
        self.td.cleanup()

    def test_host_creds(self):
        self.assertEqual(xdg.xdg_config_dir(), self.td.name + "/otvl_vlts")
        hc1p, hc1k = host_credentials("h1")
        hc1bp, hc1bk = host_credentials("h1")
        self.assertEqual(hc1p, hc1bp)
        self.assertEqual(hc1k, hc1bk)
