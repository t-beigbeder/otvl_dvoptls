import os

from cryptography.hazmat.primitives import serialization


def save_key_pem(key, path, password):
    ea = serialization.NoEncryption() if password is None else serialization.BestAvailableEncryption(password.encode())

    kpem = key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=ea
    )
    with open(path, "wb") as f:
        f.write(kpem)
    os.chmod(path, 0o600)


def save_cert_pem(cert, path):
    cpem = cert.public_bytes(
        encoding=serialization.Encoding.PEM,
    )
    with open(path, "wb") as f:
        f.write(cpem)
