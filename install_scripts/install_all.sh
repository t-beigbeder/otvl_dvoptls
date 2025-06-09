#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

install_dot() {
  cd $sd/../ansible && \
  cmd mkdir -p /home/debian/.config/.otvl/.secrets && \
  get_secret ansible_vault_pass > /home/debian/.config/.otvl/.secrets/otvl_lops_an_vl.txt && \
  get_secret ghp_creds > /home/debian/.git-credentials && \
  cmd cp /root/.config/otvl_vlts/install_env /home/debian/.config/.otvl/install_env && \
  cmd cp /root/.config/otvl_vlts/install_groups /home/debian/.config/.otvl/install_groups && \
  cmd chmod -R go-rwX /home/debian/.config/.otvl/.secrets /home/debian/.git-credentials && \
  cmd chown -R debian:debian /home/debian && \
  cmd su - debian -c "$sd/as_deb_install_dot.sh $CI_LOPS_REPO" && \
  true
  return $?
}

install_cs() {
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
install_dot || fat $0 failed
if [ "$CI_CS_DVO" = "1" ] ; then
  install_cs || fat $0 failed
fi
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
cmd su - debian -c "$sd/run_ansible.sh" || fat "while running "$sd/run_ansible.sh"

log $0 stopping
