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

log $@ starting
for vr in $HOME/locgit/* ; do
    if [ ! -d $vr/.otvl/init.d ] ; then continue ; fi
    for vs in `ls $vr/.otvl/init.d/*.sh 2> /dev/null` ; do
        cmd $vs
    done
done
log $@ stopping
exit 0
