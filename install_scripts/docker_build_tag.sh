#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

docker_build_tag() {
  vcd=$1
  vad=$2
  vdf=$3
  vim=$4
  vih=$5
  vdl=$6
  shift 6
  vaa=$*
  cmd cd $vlg/$vcd && \
  cmd docker build -f $vdf $vaa --progress=plain -t $vih/$vim $vad && \
  cmd docker login $vih -u $vdl --password-stdin < $HOME/.config/.otvl/.secrets/ctr_password && \
  cmd docker push $vih/$vim && \
  true || return 1
  return 0
}

vlg=`realpath $sd/../..`
log $0 starting
docker_build_tag "$@" || fat $0 failed
log $0 stopping
