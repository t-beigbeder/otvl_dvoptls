#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

run_ansible() {
  cd $sd/../../ansible && \
  cmd venv/bin/ansible-playbook otvl_sk3s.yml -i ../lops_repo/ansible/otvl/test -i ~/.config/.otvl/hosts.yml
  true
  return $?
}

log $0 starting
run_ansible || fat $0 failed
log $0 stopping
