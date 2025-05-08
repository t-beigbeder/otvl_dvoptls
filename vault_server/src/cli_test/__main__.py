import requests

result = requests.get(
    'https://localhost:5000/',
    cert=('/tmp/cli.otvl.c.pem', '/tmp/cli.otvl.k.pem'),
    verify='/tmp/fca.otvl.c.pem')
