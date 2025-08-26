#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

prepare_otvl_web_build() {
  vlg=`pwd`
  vrepo_dir=$vlg/$1
  vow=$vlg/otvl_web
  cmd cd $vrepo_dir && \
  cmd echo rm -fr otvl_web && \
  cmd echo cp -r $vow $vrepo_dir && \
  cmd false && \
  true || return 1
  return 0
}

vrp=`realpath $sd/..`
log $0 starting
prepare_otvl_web_build "$@" || fat $0 failed
log $0 stopping
