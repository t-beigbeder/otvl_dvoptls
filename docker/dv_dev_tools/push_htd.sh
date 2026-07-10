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
    if [ ! -e $HOME/.ssh/id_ssh_sync ] ; then
        base64 -d < $vb64f > $HOME/.ssh/id_ssh_sync && \
        chmod go-rw $HOME/.ssh/id_ssh_sync && \
        true || return 1
    fi
}

push_htd_vsync() {
    vop="-dryrun"
    if [ "$1" = "p" ] ; then
        vop=""
    fi
    if [ "$1" = "c" ] ; then
        vop="-check -dryrun"
    fi
    vdd=$2
    if [ $vdd = home ] ; then
        vld=/home/dv-user
    else
        vld=/$vdd
    fi
    log push_htd_vsync $vop $vdd start
    cmd vdasync -source $vld -target dss://$vsh:9443/data/home/$vsu/$vdd -ca /etc/vdasync/ca_cert -clientcert /etc/vdasync/client_cert -clientkey /etc/vdasync/client_key -conc 4 $vop -rm
}

push_htd_ssh() {
    vop="--dry-run"
    if [ "$1" = "p" ] ; then
        vop=""
    fi
    if [ "$1" = "c" ] ; then
        vop="-c --dry-run"
    fi
    vdd=$2
    if [ $vdd = home ] ; then
        vld=/home/dv-user
    else
        vld=/$vdd
    fi
    log push_htd_ssh $vop $vdd start
    log rsync -i --partial -rlptD --delete $vop -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $HOME/.ssh/id_ssh_sync" $vld/ $vsu@$vsh:/data/home/$vsu/$vdd
    rsync -i --partial -rlptD --delete $vop -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $HOME/.ssh/id_ssh_sync" $vld/ $vsu@$vsh:/data/home/$vsu/$vdd

}

push_htd_any() {
    push_htd_vsync $*
    if [ $? -ne 0 ] ; then
        push_htd_ssh $*
    fi
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
    vsh=t-sk3s-sv-ext
fi
push_htd_any $* || fat $* failed
log $@ stopping
exit 0
