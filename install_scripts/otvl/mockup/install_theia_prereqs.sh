#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

log $0 starting
export NVM_DIR="$HOME/.nvm"

cmd cd /tmp && \
cmd wget -q https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh && \
cmd bash < /tmp/install.sh && \
cmd rm install.sh && \
true || fat $0 failed

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
cmd cd && \
cmd nvm install Jod && \
cmd node -v && \
cmd echo apt-get update && \
cmd apt-get install -y make gcc pkg-config build-essential libx11-dev libxkbfile-dev libsecret-1-dev && \
cmd echo git clone --single-branch --depth 1 https://github.com/eclipse-theia/theia && \
cmd cd theia && \
cmd echo npm install && \
cmd npm run build:browser && \
true || fat $0 failed
log $0 stopping
