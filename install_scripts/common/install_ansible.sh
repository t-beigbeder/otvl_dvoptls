#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

patch_fail2ban_install() {
  cat > ansible.cfg <<EOF
[defaults]
deprecation_warnings=False
vault_identity_list = otvl@~/.config/.otvl/.secrets/otvl_lops_an_vl.txt

[inventory]
enable_plugins = ini, yaml

EOF

}

install_ansible() {
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  cmd patch_fail2ban_install && \
  cmd mkdir -p /home/debian/.config/.otvl/.secrets && \
  get_secret ansible_vault_pass > /home/debian/.config/.otvl/.secrets/otvl_lops_an_vl.txt && \
  cd $sd/../../.. && \
  cmd git clone --single-branch $CI_LOPS_REPO && \
  cmd chown -R debian:debian /home/debian && \
  true
  return $?
}

log $0 starting
install_ansible || fat $0 failed
log $0 stopping
