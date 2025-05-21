import json
import unittest

from fastapi import status
from fastapi.testclient import TestClient

from . import store
from .app_config import new_app_config
from .fa_app import app
from .model import Host, Secret

client = TestClient(app)


class TestApi(unittest.TestCase):
    def setUp(self):
        new_app_config(admin_digest="8ab70636e423eed09f1cb41b288f8f94d6afb823ef82b08e2ce10dfdf0a55adf")

    def tearDown(self):
        store.reset()

    def test_healthcheck(self):
        rsp = client.get("/healthcheck")
        self.assertEqual(200, rsp.status_code)

    def test_create_host_base(self):
        h1 = Host(name="h1", password="p1")
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        self.assertIn("h1", store.get())
        h2 = Host(name="h2", password="p2")
        rsp = client.post("/host", auth=("localhost", "p"), content=h2.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        self.assertIn("h1", store.get())
        self.assertIn("h2", store.get())

    def test_create_host_dupl(self):
        self.assertNotIn("h1", store.get())
        h1 = Host(name="h1", password="p1")
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_409_CONFLICT, rsp.status_code)

    def test_add_secret(self):
        h1 = Host(name="h1", password="p1")
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        s1 = Secret(key="s1", value="value1")
        rsp = client.post("/host/h1/secret", auth=("localhost", "p"), content=s1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        rsp = client.get("/host/h1/secret/s1", auth=("h1", "p1"))
        self.assertEqual(status.HTTP_200_OK, rsp.status_code)
        gs1 = json.loads(rsp.content)
        self.assertIn("value", gs1)
        self.assertEqual(s1.value, gs1["value"])

    def test_update_host(self):
        self.assertNotIn("h1", store.get())
        h1 = Host(name="h1", password="p1")
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        h1d = Host(name="h1", password="p1d")
        rsp = client.post("/host?force=1", auth=("localhost", "p"), content=h1d.model_dump_json())
        self.assertEqual(status.HTTP_200_OK, rsp.status_code)
        s1 = Secret(key="s1", value="value1")
        rsp = client.post("/host/h1/secret", auth=("localhost", "p"), content=s1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        rsp = client.get("/host/h1/secret/s1", auth=("h1", "p1d"))
        self.assertEqual(status.HTTP_200_OK, rsp.status_code)

    def test_update_secret(self):
        h1 = Host(name="h1", password="p1")
        rsp = client.post("/host", auth=("localhost", "p"), content=h1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        s1 = Secret(key="s1", value="value1")
        rsp = client.post("/host/h1/secret", auth=("localhost", "p"), content=s1.model_dump_json())
        self.assertEqual(status.HTTP_201_CREATED, rsp.status_code)
        s1b = Secret(key="s1", value="value1b")
        rsp = client.post("/host/h1/secret", auth=("localhost", "p"), content=s1b.model_dump_json())
        self.assertEqual(status.HTTP_409_CONFLICT, rsp.status_code)
        rsp = client.post("/host/h1/secret?force=1", auth=("localhost", "p"), content=s1b.model_dump_json())
        self.assertEqual(status.HTTP_200_OK, rsp.status_code)
        rsp = client.get("/host/h1/secret/s1", auth=("h1", "p1"))
        self.assertEqual(status.HTTP_200_OK, rsp.status_code)
        gs1 = json.loads(rsp.content)
        self.assertIn("value", gs1)
        self.assertEqual(s1b.value, gs1["value"])
