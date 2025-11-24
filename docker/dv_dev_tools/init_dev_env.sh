#!/bin/sh

disp() {
    echo >&2 "$@"
    if [ "$vlog" ] ; then
        echo "$@" >> $vlog
    fi
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

vlog=
if [ "$1" = "--batch" ] ; then
    vlog=/local/logs/idevenv/out-and-err.log
    cmd mkdir -p /local/logs/idevenv || fat exiting
fi
log $0 $@ starting
for vr in $HOME/locgit/* ; do
    if [ ! -d $vr/.otvl/init.d ] ; then continue ; fi
    for vs in `ls $vr/.otvl/init.d/*.sh 2> /dev/null` ; do
        cmd $vs $@
    done
done
log $0 $@ stopping

exit 0
