class AppConfig:
    def __init__(self, **kwargs):
        self.ssl_keyfile_password = kwargs.pop("ssl_keyfile_password")


config = None


def NewAppConfig(**kwargs):
    global config
    config = AppConfig(**kwargs)
