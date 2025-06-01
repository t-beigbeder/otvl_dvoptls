#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_ansible() {
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  true
  return $?
}

log $0 starting
install_ansible || fat $0 failed
log $0 stopping
