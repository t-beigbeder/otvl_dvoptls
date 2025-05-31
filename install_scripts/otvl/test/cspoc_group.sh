#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

doit() {
  cmd $sd/../../common/install_f2b.sh && \
  cmd $sd/../../common/install_code_server_poc.sh && \
  true
  return $?
}

log $0 starting
doit || fat $0 failed
log $0 stopping
