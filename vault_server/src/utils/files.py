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
