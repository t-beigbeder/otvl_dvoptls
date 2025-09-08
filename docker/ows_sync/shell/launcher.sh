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

git_clone_or_pull() {
  vlrd="$HOME/`basename $1`"
  vosb="--single-branch"
  vob=
  if [ "$2" ] ; then
    vob="-b $2"
  fi
  if [ -d $vlrd ] ; then
    cmd cd $vlrd && \
    cmd git remote update && \
    cmd git pull | tee $HOME/.gstatus && \
    true
  else
    cmd cd $HOME && \
    cmd git clone $vosb $vob $1 && \
    cmd echo cloned > $HOME/.gstatus && \
    true
  fi
  return $?
}

sync_from_git() {
  cmd git_clone_or_pull $OWS_SYNC_GREPO $OWS_SYNC_BRANCH && \
  true
  return $?
}

sync_from_server() {
  cmd rsync -e "ssh -i $OWS_SYNC_KEY" -a -i $OWS_SYNC_SREPO/ /tmp/bb | tee $HOME/.sstatus && \
  true
  return $?
}

log $0 starting
sync_from_git && \
sync_from_server && \
true || fat $0 failed
# grep grep 'Already up to date.' $HOME/.gstatus
log $0 stopping
