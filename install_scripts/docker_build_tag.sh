#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

docker_build_tag() {
  return 0
}

log $0 starting
docker_build_tag $@ || fat $0 failed
log $0 stopping
