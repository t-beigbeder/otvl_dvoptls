#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

as_deb_install_ansible() {
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  cmd git config --global credential.helper store && \
  cmd cd locgit && git clone --single-branch $1 && \
  true
  return $?
}

log $0 starting
as_deb_install_ansible $1 || fat $0 failed
log $0 stopping
