#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_git_exfile() {
  cat > $HOME/.gitignore <<EOF
.idea/
tmp/
logs/
__pycache__/
build/
EOF

}

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

git_clone_or_checkout() {
  vlrd="$HOME/locgit/`basename $1`"
  cmd curl -I $1 && \
  cmd cd $HOME/locgit && \
  cmd rm -rf `basename $1` && \
  cmd git clone --single-branch $1 && \
  true
  return $?
}

as_deb_install_ansible() {
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  cmd install_git_exfile && \
  cmd git config --global credential.helper store && \
  cmd git config --global core.excludesFile '~/.gitignore' && \
  cmd git config --global core.editor 'vi' && \
  cmd git config --global user.name 'dvo' && \
  cmd git config --global user.email 'dvo@none.org' && \
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
  cmd ${rrd}/lops_repo/scripts/install_dvo_plus && \
  true
  return $?
}

log $0 starting
as_deb_install_ansible $1 || fat $0 failed
log $0 stopping
# cd $HOME/locgit/otvl_dvoptls && install_scripts/common/as_deb_install_ansible.sh https://github.com/t-beigbeder/otvl_lops
# cd $HOME/locgit/otvl_dvoptls/ansible && venv/bin/ansible-playbook otvl_sk3s.yml -i ../lops_repo/ansible/otvl/test -i ~/.config/.otvl/hosts.yml