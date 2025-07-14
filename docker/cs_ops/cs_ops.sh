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
    if [ -f /configmap/sprik ] ; then 
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
    vssho="ssh -o StrictHostKeyChecking=no -i /configmap/sprik"
    #vcl=rsync -e "$vssho"
    log cso_restore $vdd start
    if [ $vdd = home ] ; then
        vld=/home/$vsu
    else
        vld=/$vdd
    fi
    cmd rsync -i --partial -a --delete -e "ssh -o StrictHostKeyChecking=no -i /tmp/id_ssh_sync" $vsu@$vsh:/data/$vdd/$vsu/ $vld
    cmd sleep 5
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
    log backup_term $vdir
    exit 0
}

do_backup_dir() {
    vdd=$1
    vssho="ssh -o StrictHostKeyChecking=no -i /configmap/sprik"
    #vcl=rsync -e "$vssho"
    log do_backup_dir $vdd start
    cmd sleep 10
    log do_backup_dir $vdd done
}

cso_backup_dir() {
    vdir=$1
    vssho="ssh -o StrictHostKeyChecking=no -i /configmap/sprik"
    #vcl=rsync -e "$vssho"
    log backup_dir $1 start
    while [ true ] ; do
        trap - TERM
        cmd sleep 7
        trap backup_term TERM
        cmd do_backup_dir $vdir
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