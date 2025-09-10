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
if [ ! -f /web/current/index.html ] ; then
    cmd mkdir -p /web/current/ && \
    cmd chmod go+rwX /web/current/ && \
    log echo "'<html><body><h1>It works!</h1></body></html>' > /web/current/index.html" && \
    cmd echo '<html><body><h1>It works!</h1></body></html>' > /web/current/index.html && \
    true || fat init failed
fi
cmd exec /usr/local/bin/httpd-foreground
