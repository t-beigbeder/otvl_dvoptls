import ipaddress

from test_pki import build_certs

build_certs("/tmp", "/tmp",
            ["localhost", "devalias"],
            [ipaddress.IPv4Address("192.168.0.1"), ipaddress.IPv4Address("127.0.0.1")])
