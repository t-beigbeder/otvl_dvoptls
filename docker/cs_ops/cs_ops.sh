#!/bin/sh
# - /configmap/sprik  /configmap/spubk trap hdl_shutd SIGTERM
disp() {
    echo >&2 "$@"
}

log() {
    disp "`date -Iseconds`" "$@"
}

err() {
    disp "`date -Iseconds`" "ERROR:" "$@"
}

fat() {
    disp "`date -Iseconds`" "ERROR:" "$@"
    exit 1
}

cmd() {
    log running "$@"
    "$@"
    st=$?
    if [ $st -ne 0 ] ; then
      err "running" "$@" "failed"
    fi
    return $st
}

cso_restore() {
    log restore $1
    sleep 10
}

cso_backup() {
    log backup $1
    vpidh=$!
    sleep 10
}

if [ $# -ne 2 ] ; then
    fat "usage: $0 restore|backup home|tools|data|all"
fi
if [ $1 = restore ] ; then
    cso_restore $2 || fat $0 failed
    log $@ stopping
    exit 0
fi
if [ $1 = backup ] ; then
    cso_backup $2 || fat $0 failed
    log $@ stopping
    exit 0    
fi