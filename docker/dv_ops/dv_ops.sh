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
    base64 -d < $vb64f > /tmp/id_ssh_sync && \
    chmod go-rw /tmp/id_ssh_sync && \
    true || return 1
}

dvo_restore() {
    vdd=$1
    if [ $vdd = home ] ; then
        vld=/home/dv-user
    else
        vld=/$vdd
    fi    
    log dvo_restore $vdd start
    log "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/id_ssh_sync $vsu@$vsh tar -C /data/home/$vsu/$vdd -cf - . | tar -C $vld --no-overwrite-dir -xf -"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /tmp/id_ssh_sync $vsu@$vsh tar -C /data/home/$vsu/$vdd -cf - . | tar -C $vld --no-overwrite-dir -xf - || return $?
    log dvo_restore $vdd done
}

if [ $# -ne 2 ] ; then
    fat "usage: $0 restore home|tools|data|all"
fi
if [ $1 = setup ] ; then
    cmd mkdir /local/cache /local/tmp && \
    cmd chown 2001:2001 /home/dv-user /tools /data /local /local/cache /local/tmp && \
    cmd chmod go-w /home/dv-user /tools /data /local /local/cache /local/tmp || fat $@ failed
    log $@ stopping
    exit 0
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
if [ $1 = restore ] ; then
    if [ $2 = all ] ; then
        for vt in home tools data ; do
            dvo_restore $vt || fat $* failed
        done
    else
        dvo_restore $2 || fat $* failed
    fi
    log $@ stopping
    exit 0
fi
