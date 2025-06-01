import argparse

from utils import files


def client_argparser(parser):
    parser.add_argument("-s", "--server", default="127.0.0.1")
    parser.add_argument("-p", "--port", default=9443, type=int)
    parser.add_argument("-l", "--level", default="INFO")
    parser.add_argument("-c", "--cert", default="/tmp/cli.otvl.c.pem")
    parser.add_argument("-k", "--key", default="/tmp/cli.otvl.k.pem")
    parser.add_argument("--cas", default="/tmp/fca.otvl.c.pem")
    parser.add_argument("--no-ssl", default=False, action="store_true")
    parser.add_argument("--creds-file")


def base_url(args: argparse.Namespace) -> str:
    return f"https://{args.server}:{args.port}/"


def request_args(args: argparse.Namespace, is_consumer: bool = False) -> dict:
    auth = None
    if args.creds_file:
        auth = files.read_creds_file(args.creds_file)
        if is_consumer:
            auth = args.host, auth[0]
    return dict(
        cert=(args.cert, args.key),
        verify=args.cas,
        auth=auth)


def decrypt_token(args: argparse.Namespace) -> str:
    return files.read_creds_file(args.creds_file)[1] if args.creds_file else None
