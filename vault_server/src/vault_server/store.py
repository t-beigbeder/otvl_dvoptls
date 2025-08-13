import datetime

_store = {
    "_create_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "_hosts": {}
}


async def store():
    return _store


def reset():
    global _store
    _store = {
        "_create_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "_hosts": {}
    }


def get():
    return _store
