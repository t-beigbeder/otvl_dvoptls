#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

vrrd=`realpath $sd/../..`

git_clone_or_pull() {
  vlrd="$HOME/locgit/`basename $1`"
  if [ -d $vlrd ] ; then
    cmd cd $vlrd && \
    cmd git pull
  else
    cmd curl -I $1 && \
    cmd cd $HOME/locgit && \
    cmd git clone --single-branch $1 && \
    true
  fi
  return $?
}

gen_ansible_hosts() {
  for g in `cat .config/.otvl/install_groups` ; do
    echo "$g:"
    echo "  hosts:"
    echo "    localhost:"
  done
}

get_ci_val() {
  echo '"'`. .config/.otvl/ci_env ; eval echo '$'$1`'"'
}

gen_ansible_group_vars() {
  echo "otvl_meta:"
  for p in `cat .config/.otvl/install_otvl_meta` ; do
    echo "  $p: true"
  done
  echo "install_env: `cat .config/.otvl/install_env`"
  echo "ci_env:"
  for vk in `cat .config/.otvl/ci_env | cut -d= -f1 | sed -e 's/export //'` ; do
    echo "  $vk: `get_ci_val $vk`"
  done
  echo "ext_hosts:"
  for vh in `cat .config/.otvl/ext_hosts | cut -d' ' -f2` ; do
    echo "  $vh: `cat .config/.otvl/ext_hosts | grep $vh | cut -d' ' -f1`"
  done
  echo "private_itf: FIXME"
}

as_deb_install_dot() {
  cmd git config --global credential.helper store && \
  cmd git_clone_or_pull $1 && \
  cmd ${vrrd}/lops_repo/scripts/install_dot_custo.sh && \
  cd && \
  cmd mkdir -p .config/.otvl/group_vars && \
  cmd gen_ansible_hosts > .config/.otvl/hosts.yml && \
  cmd gen_ansible_group_vars > .config/.otvl/group_vars/all.yaml && \
  cd $sd/../../ansible && \
  cmd make venv-ins && \
  cmd venv/bin/ansible-galaxy collection install kubernetes.core community.crypto ansible.posix && \
  true
  return $?
}

log $0 starting
as_deb_install_dot $1 || fat $0 failed
log $0 stopping
# cd $HOME/locgit/otvl_dvoptls && install_scripts/common/as_deb_install_dot.sh https://github.com/t-beigbeder/otvl_lops
# cd $HOME/locgit/otvl_dvoptls && install_scripts/run_ansible.sh
