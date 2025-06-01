import unittest

from cryptography.exceptions import InvalidTag

from utils import aes


class TestAes(unittest.TestCase):
    def test_aes_ok(self):
        tk = aes.new_token()
        em = aes.encrypt("test_aes", tk)
        cm = aes.decrypt(em, tk)
        self.assertEqual("test_aes", cm)

    def test_aes_nok(self):
        tk = aes.new_token()
        em = aes.encrypt("test_aes", tk)
        tk2 = aes.new_token()
        self.assertRaises(InvalidTag, aes.decrypt, em, tk2)
