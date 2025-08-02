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

if [ "`networkctl | grep ether | grep routable | wc -l`" != 2 ] ; then
    log $0 "hasn't 2 routable interfaces..."
    log $0 `networkctl | grep ether | grep routable`
    log $0 exiting with no action
    exit 0
fi

while [ true ] ; do
    log $0 sleeping 15
    sleep 15
    vin1=`networkctl | grep ether | grep routable | head -1 | cut -d' ' -f4`
    vin2=`networkctl | grep ether | grep routable | head -2 | tail -1 | cut -d' ' -f4`
    if [ "`ip route | grep default | grep $vin2 | wc -l`" = "0" ] ; then
        log "route configured: `ip route | grep default | grep $vin1`"
        sleep 60
        continue
    fi
    vdr=`ip route | grep default | grep $vin2`
    log running ip route del $vdr
    ip route del $vdr
    if [ $? -ne 0 ] ; then
        fat $0 exiting
    fi
done