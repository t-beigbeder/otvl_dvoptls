#!/bin/sh
set -eu
env | sort
cd $HOME
exec "$@"  # /usr/local/bin/code-server ...
