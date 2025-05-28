def cat(target, *origins):
    with open(target, "wb") as fo:
        for origin in origins:
            with open(origin, "rb") as fi:
                fo.write(fi.read())


def read_pass_file(path):
    with open(path, "r") as f:
        for line in f:
            password = line[:-1] if line.endswith("\n") else line
            return password
    return None


def read_creds_file(path):
    with open(path, "r") as f:
        for line in f:
            if line.endswith('\n'):
                line = line[:-1]
            auth = line.split(':')
            if len(auth) == 2:
                return auth
            break
        return "", ""
