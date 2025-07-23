#!/bin/sh

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

set_sprik() {
    if [ -e /configmap/sprik ] ; then 
        vb64f=/configmap/sprik
    else
        vb64f=/tmp/sprik
    fi
    base64 -d < $vb64f > $HOME/.ssh/id_ssh_sync && \
    chmod go-rw $HOME/.ssh/id_ssh_sync && \
    true || return 1
}

if [ $# -ne 2 ] ; then
    fat "usage: $0 d|p|c home|tools|data"
fi
set_sprik || fat $0 failed
vsu=$SYNC_USER
if [ -z "$vsu" ] ; then
    vsu=$USER
fi
vsh=$SYNC_SERVER
if [ -z "$vsh" ] ; then
    vsh=172.25.0.7
fi
if [ $1 = restore ] ; then
    cso_restore $2 || fat $* failed
    log $@ stopping
    exit 0
fi
