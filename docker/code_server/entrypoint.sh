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

set -eu
cd $HOME
if [ ! -f .bashrc ] ; then
    cp /etc/skel/.bashrc .bashrc
fi
for vr in $HOME/locgit/* ; do
    if [ ! -d $vr/.otvl/init.d ] ; then continue ; fi
    for vs in `ls $vr/.otvl/init.d/*.sh 2> /dev/null` ; do
        cmd $vs
    done
done
exec "$@"