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
    sleep 5
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