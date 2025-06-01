class AppConfig:
    def __init__(self, **kwargs):
        self.pass_file = kwargs.pop("pass_file", None)
        self.admin_digest = kwargs.pop("admin_digest", None)


config = None


def new_app_config(**kwargs):
    global config
    config = AppConfig(**kwargs)
