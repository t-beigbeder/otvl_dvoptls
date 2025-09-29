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

log $0 starting
cmd base64 -d < $OWS_SYNC_KEY.b64 > $HOME/.ssh/id_ows_sync_dec
cmd chmod go-rw $HOME/.ssh/id_ows_sync_dec
while [ true ] ; do
  cmd /shell/synchronizer.sh
  cmd sleep $OWS_PERIOD_SECONDS
done
log $0 stopping
