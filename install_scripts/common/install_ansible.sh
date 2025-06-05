#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_ansible() {
  cd $sd/../../ansible && \
  cmd mkdir -p /home/debian/.config/.otvl/.secrets && \
  get_secret ansible_vault_pass > /home/debian/.config/.otvl/.secrets/otvl_lops_an_vl.txt && \
  get_secret ghp_creds > /home/debian/.git-credentials && \
  cmd cp /root/.config/otvl_vlts/install_env /home/debian/.config/.otvl/install_env && \
  cmd cp /root/.config/otvl_vlts/install_groups /home/debian/.config/.otvl/install_groups && \
  cmd chmod -R go-rwX /home/debian/.config/.otvl/.secrets /home/debian/.git-credentials && \
  cmd chown -R debian:debian /home/debian && \
  cmd su - debian -c "$sd/as_deb_install_ansible.sh $CI_LOPS_REPO" && \
  cmd su - debian -c "$sd/as_deb_install_with_ansible.sh $CI_LOPS_REPO" && \
  true
  return $?
}

log $0 starting
install_ansible || fat $0 failed
log $0 stopping
