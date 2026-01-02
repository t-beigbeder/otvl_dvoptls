#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

run_vlts_get_hosts() {
  cd /home/debian/locgit/otvl_dvoptls/vault_server && \
  PYTHONPATH=src /root/venv/bin/python -m consumer \
    -s tvlts.otvl.org -p $CI_VLTS_PORT \
    -c /root/pki/cli.otvl.c.pem -k /root/pki/cli.otvl.k.pem \
    --cas /root/pki/fca.otvl.c.pem \
    --host $CI_LHN --get-hosts
}

get_hip_from_vlts() {
  log running get_hip_from_vlts
  vundone=
  vhf=/root/.config/otvl_vlts/ext_hosts
  while [ -z "$vundone" ] ; do
    cmd run_vlts_get_hosts
    vundone=1
    for vhi in $CI_HN_LIST ; do
      if [ $vhi = $CI_LHN ] ; then
        continue
      fi
      vt=`grep " $vhi" $vhf`
      if [ -z "$vt" ] ; then
        log get_hip_from_vlts: host $vhi not yet registered
        vundone=
      fi
    done
    if [ -z "$vundone" ] ; then sleep 10 ; fi
  done
  cat $vhf | sed -e 's/ .*$/&-ext/' > /home/debian/.config/.otvl/ext_hosts && \
  cp /root/.config/otvl_vlts/ext_hosts.yaml /home/debian/.config/.otvl/ext_hosts.yaml && \
  cmd chown debian:debian /home/debian/.config/.otvl/ext_hosts && \
  cat /home/debian/.config/.otvl/ext_hosts >> /etc/hosts && \
  true
  return $?
}

install_dot() {
  cd $sd/../ansible && \
  cmd mkdir -p /root/.config/.otvl/.secrets /home/debian/.config/.otvl/.secrets && \
  get_secret ansible_vault_pass > /home/debian/.config/.otvl/.secrets/otvl_lops_an_vl.txt && \
  get_secret ghp_creds > /home/debian/.git-credentials && \
  get_secret k3s_token > /root/.config/.otvl/.secrets/k3s_token && \
  chmod go-rw /root/.config/.otvl/.secrets/k3s_token && \
  cmd cp /root/.config/otvl_vlts/install_env /home/debian/.config/.otvl/install_env && \
  cmd cp /root/.config/otvl_vlts/install_otvl_meta /home/debian/.config/.otvl/install_otvl_meta && \
  cmd cp /root/.config/otvl_vlts/install_groups /home/debian/.config/.otvl/install_groups && \
  cmd cp /root/.otvl_ci_env /home/debian/.config/.otvl/ci_env && \
  cmd chmod -R go-rwX /home/debian/.config/.otvl/.secrets /home/debian/.git-credentials && \
  cmd chown -R debian:debian /home/debian && \
  cmd su - debian -c "$sd/common/as_deb_install_dot.sh $CI_LOPS_REPO" && \
  true
  return $?
}

install_cs() {
  systemctl status code-server@debian > /dev/null
  if [ $? -eq 0 ] ; then
    log code-server@debian already installed
    return 0
  fi
  log running "curl -fsSL https://code-server.dev/install.sh | sh"
  curl -fsSL https://code-server.dev/install.sh | sh && \
  cmd systemctl enable --now code-server@debian && \
  cmd sleep 5 && \
  cmd su - debian -c "sed -i.bak 's/auth: password/auth: none/' .config/code-server/config.yaml" && \
  cmd systemctl restart code-server@debian && \
  true
  return $?
  # ssh -N -L 8080:127.0.0.1:8080 debian@ip
}

log $0 starting
if [ "`grep has_gpu /root/.config/otvl_vlts/install_otvl_meta`" != "" ] ; then
  if [ "`cat /root/clinit/persist/status`" = "phase0" ] ; then
    cmd $sd/common/install_nvidia.sh && \
    echo phase1 > /root/clinit/persist/status && \
    echo reboot > /root/clinit/persist/request && \
    log $0 requested reboot && \
    exit 0 || exit 1
  fi
  log nvidia installed with success
fi

if [ -f /root/.otvl_ci_env ] ; then
  . /root/.otvl_ci_env
fi
if [ "$CI_SYNC_SVR" = "1" ]; then
  cmd $sd/common/install_sync_svr.sh || fat $0 failed
fi

install_dot || fat $0 failed

if [ "$CI_CS_DVO" = "1" ] ; then
  install_cs || fat $0 failed
fi

get_hip_from_vlts || fat $0 failed
ins_env=`cat /root/.config/otvl_vlts/install_env`
ins_grps=`cat /root/.config/otvl_vlts/install_groups`
ins_root=${sd}/${ins_env}
for grp in $ins_grps ; do
  if [ ! -f $ins_root/$grp.sh ] ; then continue ; fi
  cmd $ins_root/$grp.sh
  if [ $? -ne 0 ] ; then
    fat "while running $ins_root/$grp.sh"
  fi
done

cmd su - debian -c "$sd/run_ansible.sh" || fat "while running $sd/run_ansible.sh" || fat $0 failed
echo final > /root/clinit/persist/status

log $0 stopping
