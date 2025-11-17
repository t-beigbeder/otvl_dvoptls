#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

log $0 starting
export NVM_DIR="$HOME/.nvm"

cmd sudo $sd/install_theia_prereqs.sh && \
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
cmd cd locgit && \
cmd git clone --single-branch --depth 1 https://github.com/eclipse-theia/theia && \
cmd cd theia && \
cmd npm install && \
cmd npm run build:browser && \
cmd npm run download:plugins && \
cmd npm run start:browser && \
true || fat $0 failed

log $0 stopping
