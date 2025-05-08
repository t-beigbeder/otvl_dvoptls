def cat(target, *origins):
    with open(target, 'wb') as fo:
        for origin in origins:
            with open(origin, 'rb') as fi:
                fo.write(fi.read())
