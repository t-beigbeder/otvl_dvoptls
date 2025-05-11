import unittest

from fastapi.testclient import TestClient

from .asgi import app

client = TestClient(app)


class TestApi(unittest.TestCase):
    def test_healthcheck(self):
        response = client.get("/healthcheck")
        self.assertEqual(200, response.status_code)
