import datetime

from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.x509.oid import NameOID

from utils import files
from utils.certs import save_key_pem, save_cert_pem
from utils.files import cat


def build_root_ca():
    root_key = ec.generate_private_key(ec.SECP256R1())
    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "otvl"),
        x509.NameAttribute(NameOID.COMMON_NAME, "Tests Root CA"),
    ])

    root_cert = x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        issuer
    ).public_key(
        root_key.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        datetime.datetime.now(datetime.timezone.utc)
    ).not_valid_after(
        datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=365 * 10)
    ).add_extension(
        x509.BasicConstraints(ca=True, path_length=None),
        critical=True,
    ).add_extension(
        x509.KeyUsage(
            digital_signature=True,
            content_commitment=False,
            key_encipherment=False,
            data_encipherment=False,
            key_agreement=False,
            key_cert_sign=True,
            crl_sign=True,
            encipher_only=False,
            decipher_only=False,
        ),
        critical=True,
    ).add_extension(
        x509.SubjectKeyIdentifier.from_public_key(root_key.public_key()),
        critical=False,
    ).sign(root_key, hashes.SHA256())
    return root_key, root_cert


def build_int_ca(rkey, rcert):
    ikey = ec.generate_private_key(ec.SECP256R1())
    subject = x509.Name([
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "otvl"),
        x509.NameAttribute(NameOID.COMMON_NAME, "Tests Intermediate CA"),
    ])
    icert = x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        rcert.subject
    ).public_key(
        ikey.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        datetime.datetime.now(datetime.timezone.utc)
    ).not_valid_after(
        datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=365 * 3)
    ).add_extension(
        x509.BasicConstraints(ca=True, path_length=0),
        critical=True,
    ).add_extension(
        x509.KeyUsage(
            digital_signature=True,
            content_commitment=False,
            key_encipherment=False,
            data_encipherment=False,
            key_agreement=False,
            key_cert_sign=True,
            crl_sign=True,
            encipher_only=False,
            decipher_only=False,
        ),
        critical=True,
    ).add_extension(
        x509.SubjectKeyIdentifier.from_public_key(ikey.public_key()),
        critical=False,
    ).add_extension(
        x509.AuthorityKeyIdentifier.from_issuer_subject_key_identifier(
            rcert.extensions.get_extension_for_class(x509.SubjectKeyIdentifier).value
        ),
        critical=False,
    ).sign(rkey, hashes.SHA256())
    return ikey, icert


def build_ecert(ikey, icert, dnsns, ips, days):
    ekey = ec.generate_private_key(ec.SECP256R1())
    is_server = len(dnsns) + len(ips) > 0
    cn = ",".join(dnsns) if is_server else "client"
    subject = x509.Name([
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "otvl"),
        x509.NameAttribute(NameOID.COMMON_NAME, cn),
    ])
    sans = [x509.DNSName(dnsn) for dnsn in dnsns]
    sans.extend([x509.IPAddress(ip) for ip in ips])
    ecert = x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        icert.subject
    ).public_key(
        ekey.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        datetime.datetime.now(datetime.timezone.utc)
    ).not_valid_after(
        datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=days)
    ).add_extension(
        x509.SubjectAlternativeName(sans),
        critical=False,
    ).add_extension(
        x509.BasicConstraints(ca=False, path_length=None),
        critical=True,
    ).add_extension(
        x509.KeyUsage(
            digital_signature=True,
            content_commitment=False,
            key_encipherment=True,
            data_encipherment=False,
            key_agreement=False,
            key_cert_sign=False,
            crl_sign=True,
            encipher_only=False,
            decipher_only=False,
        ),
        critical=True,
    ).add_extension(
        x509.ExtendedKeyUsage([
            x509.ExtendedKeyUsageOID.SERVER_AUTH if is_server else x509.ExtendedKeyUsageOID.CLIENT_AUTH,
        ]),
        critical=False,
    ).add_extension(
        x509.SubjectKeyIdentifier.from_public_key(ekey.public_key()),
        critical=False,
    ).add_extension(
        x509.AuthorityKeyIdentifier.from_issuer_subject_key_identifier(
            icert.extensions.get_extension_for_class(x509.SubjectKeyIdentifier).value
        ),
        critical=False,
    ).sign(ikey, hashes.SHA256())
    return ekey, ecert


def build_self_signed(dnsns, ips, days):
    ekey = ec.generate_private_key(ec.SECP256R1())
    cn = ",".join(dnsns) + ",self-signed"
    subject = x509.Name([
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "otvl"),
        x509.NameAttribute(NameOID.COMMON_NAME, cn),
    ])
    sans = [x509.DNSName(dnsn) for dnsn in dnsns]
    sans.extend([x509.IPAddress(ip) for ip in ips])
    ecert = x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        subject
    ).public_key(
        ekey.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        datetime.datetime.now(datetime.timezone.utc)
    ).not_valid_after(
        datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=days)
    ).add_extension(
        x509.SubjectAlternativeName(sans),
        critical=False,
    ).sign(ekey, hashes.SHA256())
    return ekey, ecert


def build_certs(pri_dir, pub_dir, dnsns, ips, days, pass_file):
    password = None
    if pass_file is not None:
        password = files.read_pass_file(pass_file)
        with open(pass_file, "r") as f:
            for line in f:
                password = line[:-1] if line.endswith("\n") else line
                break
    rkey, rcert = build_root_ca()
    save_key_pem(rkey, f"{pri_dir}/rca.otvl.k.pem", None)
    save_cert_pem(rcert, f"{pub_dir}/rca.otvl.c.pem")
    ikey, icert = build_int_ca(rkey, rcert)
    save_key_pem(ikey, f"{pri_dir}/ica.otvl.k.pem", None)
    save_cert_pem(icert, f"{pub_dir}/ica.otvl.c.pem")
    cat(f"{pub_dir}/fca.otvl.c.pem", f"{pub_dir}/rca.otvl.c.pem", f"{pub_dir}/ica.otvl.c.pem")
    ekey, ecert = build_ecert(ikey, icert, dnsns, ips, days)
    save_key_pem(ekey, f"{pri_dir}/srv.otvl.k.pem", password)
    save_cert_pem(ecert, f"{pub_dir}/srv.otvl.c.pem")
    sskey, sscert = build_self_signed(dnsns, ips, days)
    save_key_pem(sskey, f"{pri_dir}/slf.otvl.k.pem", None)
    save_cert_pem(sscert, f"{pub_dir}/slf.otvl.c.pem")
    ekey, ecert = build_ecert(ikey, icert, [], [], days)
    save_key_pem(ekey, f"{pri_dir}/cli.otvl.k.pem", None)
    save_cert_pem(ecert, f"{pub_dir}/cli.otvl.c.pem")
