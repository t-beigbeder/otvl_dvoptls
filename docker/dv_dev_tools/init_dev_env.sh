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

idevenv() {
    log $@ starting
    for vr in $HOME/locgit/* ; do
        if [ ! -d $vr/.otvl/init.d ] ; then continue ; fi
        for vs in `ls $vr/.otvl/init.d/*.sh 2> /dev/null` ; do
            cmd $vs
        done
    done
    log $@ stopping
}

if [ "$1" = "--batch" ] ; then
    cmd mkdir -p /local/logs/idevenv || fat exiting
    (idevenv 2>&1) | tee -a /local/logs/idevenv/out-and-err.log
else
    idevenv
fi
exit 0
