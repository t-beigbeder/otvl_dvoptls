class AppConfig:
    def __init__(self, **kwargs):
        self.pass_file = kwargs.pop("pass_file", None)


config = None


def NewAppConfig(**kwargs):
    global config
    config = AppConfig(**kwargs)
