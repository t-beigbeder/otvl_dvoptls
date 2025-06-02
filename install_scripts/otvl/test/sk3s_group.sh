#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../../locenv
## endpre

doit() {
  cmd true && \
  true
  return $?
}

log $0 starting
doit || fat $0 failed
log $0 stopping
