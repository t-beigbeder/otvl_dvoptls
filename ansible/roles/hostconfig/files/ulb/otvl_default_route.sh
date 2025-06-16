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

while [ true ] ; do
    log $0 sleeping 15
    sleep 15
    vin=`networkctl |grep ether | grep routable | head -1 | cut -d' ' -f4`
    if [ "`ip route | grep default | grep $vin | wc -l`" = "2" ] ; then
        log "route configured: `ip route | grep default | grep $vin | head -1`"
        sleep 60
        continue
    fi
    vdr=`ip route | grep default | grep $vin | sed -e 's/ proto.*$//'`
    log running ip route add $vdr
    ip route add $vdr
    if [ $? -ne 0 ] ; then
        fat $0 exiting
    fi
done