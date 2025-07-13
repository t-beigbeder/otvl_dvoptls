#!/bin/sh
set -eu
env | sort
cd $HOME
if ! grep '^${CSUSER}:' /etc/passwd > /dev/null ; then
    echo adduser --gecos '' --disabled-password --uid $CSUID --shell /bin/bash $CSUSER
    adduser --gecos '' --disabled-password --uid $CSUID --shell /bin/bash $CSUSER
fi

exec "$@"  # /usr/local/bin/code-server ...
