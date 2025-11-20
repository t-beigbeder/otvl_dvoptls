#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

log $0 starting
export NVM_DIR="$HOME/.nvm"
cmd echo apt-get update && \
cmd apt-get install -y make gcc pkg-config build-essential libx11-dev libxkbfile-dev libsecret-1-dev && \
true || fat $0 failed
log $0 stopping
