#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

vrrd=`realpath $sd/..`

launch_vlts() {
  log launch_vlts
  cd $vrrd/tf/otvl/test/vlts
  tofu apply -auto-approve
  tofu output -json ipv4s
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  for vip in $vipv4s ; do
    if [ -z "`echo $vip | fgrep 172.`" ] ; then
      vip4=$vip
      break
    fi
  done
  if [ -z "$vip4" ] ; then
    err "no IPv4 found"
    return 1
  fi
  cat /etc/hosts | sed "s/.*tvlts.otvl.org/${vip4} tvlts.otvl.org/" > /tmp/t.$$
  sudo su - -c bash -c "cp /tmp/t.$$ /etc/hosts"
  grep $vip4 /etc/hosts
  loop "vault server first start" "wait_vlts_1st" 10
  log wait for unsecure server shutdown
  cmd sleep 2
  loop "vault server restart" "wait_vlts_rst" 10
}

wait_vlts_1st() {
  log wait_vlts_1st
  cmd curl -k -I https://tvlts.otvl.org:9443/healthcheck --retry 3 --connect-timeout 1
  if [ $? -ne 0 ] ; then return 1 ; fi
  cmd curl -k --data-binary @$vrrd/dvoptls/secrets/test/pki_pf https://tvlts.otvl.org:9443/ssl_keyfile_password
}

wait_vlts_rst() {
  log wait_vlts_rst
  cd $vrrd/vault_server
  vpf=$vrrd/dvoptls/secrets/test/va_pf
  pkd=$vrrd/dvoptls/pki/test
  lrd=$vrrd/lops_repo
  vopts="--server tvlts.otvl.org --creds-file $vpf -c $pkd/cli.otvl.c.pem -k $pkd/cli.otvl.k.pem --cas $pkd/fca.otvl.c.pem --force-host --secrets-dir $lrd/vlts_secrets/otvl/test"
  PYTHONPATH=src cmd venv/bin/python -m provisioner $vopts --hosts dummy
}

provision_prod_vlts() {
  log provision_prod_vlts
  cd $vrrd/vault_server
  vpf=$vrrd/dvoptls/secrets/test/va_pf
  pkd=$vrrd/dvoptls/pki/test
  lrd=$vrrd/lops_repo
  vlh=`ls $lrd/vlts_secrets/otvl/prod | sed -e 's/.enc.yaml//'`
  vopts="--server tvlts.otvl.org --creds-file $vpf -c $pkd/cli.otvl.c.pem -k $pkd/cli.otvl.k.pem --cas $pkd/fca.otvl.c.pem --force-host --secrets-dir $lrd/vlts_secrets/otvl/prod"
  PYTHONPATH=src cmd venv/bin/python -m provisioner $vopts --hosts $vlh
}

launch_prod_hosting() {
  log launch_prod_hosting
  cd $vrrd/tf/otvl/test/vlts
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  cd $vrrd/tf/otvl/prod/hosting
  vaa="-auto-approve"
  #vaa=
  cmd tofu apply $vaa -var vlts_hostname=$vipv4s
}

reset_ovh_dns() {
  log reset_ovh_dns
  cd $vrrd/ovh_dns
  PYTHONPATH=src cmd venv/bin/python -m ovh_dns -i $INGRESS --ip 0.0.0.0
}

set_ovh_dns() {
  log set_ovh_dns
  cd $vrrd/tf/otvl/prod/hosting
  vip=`tofu output -json ipv4s | jq .[0][0] | sed -e 's="==g'`
  cd $vrrd/ovh_dns
  PYTHONPATH=src cmd venv/bin/python -m ovh_dns -i $INGRESS --ip $vip
}

destroy_prod_hosting() {
  log destroy_prod_hosting
  cd $vrrd/tf/otvl/test/vlts
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  cd $vrrd/tf/otvl/prod/hosting
  cmd tofu destroy -exclude module.compute.module.instances.openstack_blockstorage_volume_v3.volumes -var vlts_hostname=$vipv4s
}

destroy_vlts() {
  log destroy_vlts
  cd $vrrd/tf/otvl/test/vlts
  tofu destroy
}

log $0 starting
. $HOME/.osenvrc
INGRESS="blog"
icmd "launch vault server" launch_vlts n
icmd "provision prod secrets" provision_prod_vlts n
icmd "launch prod hosting" launch_prod_hosting n
icmd "set OVH DNS for $INGRESS" set_ovh_dns n
icmd "destroy prod hosting" destroy_prod_hosting n
icmd "destroy vault server" destroy_vlts n
icmd "reset OVH DNS for $INGRESS" reset_ovh_dns n

log $0 stopping
