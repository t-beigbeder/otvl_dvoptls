#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

log $0 starting
cmd sudo $sd/install_theia_prereqs.sh && \
cmd cd $HOME/locgit && \
cmd echo git clone https://github.com/eclipse-theia/theia && \
true || fat $0 failed
log $0 stopping
