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
  log sync_from_git starting
  cmd git_clone_or_pull $OWS_SYNC_GREPO $OWS_SYNC_BRANCH && \
  true
  return $?
}

build_site() {
  log build_site starting
  grep 'Already up to date.' $HOME/.gstatus
  if [ $? -eq 0 ] ; then
    log build_site nothing to do
    return 0
  fi
  vlrd="$HOME/`basename $OWS_SYNC_GREPO`"
  cmd cd $vlrd && \
  cmd rm -rf site && \
  cmd /venv/bin/mkdocs build && \
  cmd sed -i -e "s=ows_ingress_host=${OWS_INGRESS_HOST}=" site/robots.txt && \
  cmd sed -i -e "s=ows_ingress_host=${OWS_INGRESS_HOST}=" site/sitemap.xml && \
  cmd rm site/sitemap.xml.gz && \
  cmd mkdir -p $OWS_EXPORT_SITE/new && \
  cmd mv site/* $OWS_EXPORT_SITE/new && \
  cmd rm -rf $OWS_EXPORT_SITE/new/5a7 && \
  log build_site done && \
  true
  return $?
}

export_site() {
  if [ ! -d $OWS_EXPORT_SITE/new ] ; then
    log export_site: nothing new
    return 0
  fi
  cmd cd $OWS_EXPORT_SITE && \
  cmd rm -rf previous && \
  cmd mv current previous && \
  cmd mv new current && \
  cmd mv previous/5a7 current && \
  true
  return $?
}

sync_from_server() {
  log sync_from_server starting
  cmd cd $OWS_EXPORT_SITE/current && \
  cmd mkdir -p 5a7 && \
  cmd rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $OWS_SYNC_KEY" -a -i --delete $OWS_SYNC_SREPO/ $OWS_EXPORT_SITE/current/5a7 > $HOME/.sstatus && \
  cmd cat $HOME/.sstatus && \
  true
  return $?
}

log $0 starting
cmd rm -rf $OWS_EXPORT_SITE/new && \
cmd mkdir -p $OWS_EXPORT_SITE/current && \
sync_from_git && \
build_site && \
export_site && \
sync_from_server && \
cmd $OWS_CUSTO_SITE && \
true || fat $0 failed
log $0 stopping
