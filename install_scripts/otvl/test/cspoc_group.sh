#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

log $0 starting
cmd $sd/../../common/install_f2b.sh
log $0 stopping
