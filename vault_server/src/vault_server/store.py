import datetime

_store = {"_create_at": datetime.datetime.now(datetime.timezone.utc).isoformat()}


async def store():
    return _store
