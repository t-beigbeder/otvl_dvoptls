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

set_sprik() {
    if [ -e /configmap/sprik ] ; then 
        vb64f=/configmap/sprik
    else
        vb64f=/tmp/sprik
    fi
    base64 -d < $vb64f > /tmp/id_ssh_sync && \
    chmod go-rw /tmp/id_ssh_sync && \
    true || return 1
}

cso_restore() {
    vdd=$1
    if [ $vdd = home ] ; then
        vld=/home/cs-user
    else
        vld=/$vdd
    fi    
    log cso_restore $vdd start
    cmd rsync -i --partial -rlptDq --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/id_ssh_sync" $vsu@$vsh:/data/home/$vsu/$vdd/ $vld
    log cso_restore $vdd done
}

mon_term() {
    log mon_term
    cmd kill $vpidh $vpidt $vpidd
}

mon_wait() {
    log mon_wait start
    wait
    vst=$?
    log mon_wait done $vst
    return $vst
}

cso_backup_monitor() {
    log backup_monitor
    $0 backup home &
    vpidh=$!
    sleep 1
    $0 backup tools &
    vpidt=$!
    sleep 1
    $0 backup data &
    vpidd=$!
    sleep 1
    trap mon_term TERM INT
    while [ true ] ; do
        mon_wait && return 0
    done
}

backup_term() {
    log backup_term $1
    cmd do_backup_dir $1
    log backup_term $1: $0 exiting
    exit 0
}

do_backup_dir() {
    vdd=$1
    if [ $vdd = home ] ; then
        vld=/home/cs-user
    else
        vld=/$vdd
    fi    
    log do_backup_dir $vdd start
    cmd rsync -i --partial -rlptDq --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/id_ssh_sync" $vld/ $vsu@$vsh:/data/home/$vsu/$vdd
    log do_backup_dir $vdd done
}

cso_backup_dir() {
    log backup_dir $1 start
    while [ true ] ; do
        trap "backup_term $1" TERM
        cmd sleep 60
        trap "" TERM
        cmd do_backup_dir $1
    done
}

if [ $# -ne 2 ] ; then
    fat "usage: $0 restore|backup home|tools|data|all"
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
    cso_restore $2 || fat $0 failed
    log $@ stopping
    exit 0
fi
if [ $1 = backup ] ; then
    if [ $2 = all ] ; then
        cso_backup_monitor || fat $0 failed
        log $@ stopping
        exit 0    
    else
        cso_backup_dir $2 || fat $0 failed
        log $@ stopping
        exit 0    
    fi
fi