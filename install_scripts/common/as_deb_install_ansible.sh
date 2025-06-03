#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_ansible_config() {
  cat > ansible.cfg <<EOF
[defaults]
deprecation_warnings=False
vault_identity_list = otvl@~/.config/.otvl/.secrets/otvl_lops_an_vl.txt

[inventory]
enable_plugins = ini, yaml

EOF

}

gen_ansible_hosts() {
  for g in `cat .config/.otvl/install_groups` ; do
    echo "$g:"
    echo "  hosts:"
    echo "    localhost:"
  done
}

as_deb_install_ansible() {
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  cmd git config --global credential.helper store && \
  cmd curl -I $1 && \
  cmd cd $HOME/locgit && \
  cmd rm -rf `basename $1` && \
  cmd git clone --single-branch $1 && \
  cd $sd/../../ansible && \
  cmd install_ansible_config && \
  cd && \
  cmd rm -f .ssh/id_lans && \
  cmd ssh-keygen -t ed25519 -C otvl-lans -f ~/.ssh/id_lans -q -N '' && \
  cmd cat .ssh/id_lans.pub >> .ssh/authorized_keys && \
  cmd ssh -i .ssh/id_lans -o StrictHostKeyChecking=no localhost true && \
  cmd mkdir -p .config/.otvl/ansible && \
  cmd gen_ansible_hosts > .config/.otvl/hosts.yml && \
  true
  return $?
}

log $0 starting
as_deb_install_ansible $1 || fat $0 failed
log $0 stopping
