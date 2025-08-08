#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

vrrd=`realpath $sd/..`

launch_test_vlts() {
  log launch_test_vlts
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
  loop "test vault server first start" "wait_test_vlts_1st" 10
  log wait for unsecure server shutdown
  cmd sleep 2
  loop "test vault server restart" "wait_test_vlts_rst" 10
}

wait_test_vlts_1st() {
  log wait_test_vlts_1st
  cmd curl -k -I https://tvlts.otvl.org:9443/healthcheck --retry 3 --connect-timeout 1
  if [ $? -ne 0 ] ; then return 1 ; fi
  cmd curl -k --data-binary @$vrrd/dvoptls/secrets/test/pki_pf https://tvlts.otvl.org:9443/ssl_keyfile_password
}

wait_test_vlts_rst() {
  log wait_test_vlts_rst
  cd $vrrd/vault_server
  vpf=$vrrd/dvoptls/secrets/test/va_pf
  pkd=$vrrd/dvoptls/pki/test
  lrd=$vrrd/lops_repo
  vopts="--server tvlts.otvl.org --creds-file $vpf -c $pkd/cli.otvl.c.pem -k $pkd/cli.otvl.k.pem --cas $pkd/fca.otvl.c.pem --force-host --secrets-dir $lrd/vlts_secrets/otvl/test"
  PYTHONPATH=src cmd venv/bin/python -m provisioner $vopts --hosts dummy
}

provision_test_vlts() {
  log provision_test_vlts
  cd $vrrd/vault_server
  vpf=$vrrd/dvoptls/secrets/test/va_pf
  pkd=$vrrd/dvoptls/pki/test
  lrd=$vrrd/lops_repo
  vlh=`ls $lrd/vlts_secrets/otvl/test | sed -e 's/.enc.yaml//'`
  vopts="--server tvlts.otvl.org --creds-file $vpf -c $pkd/cli.otvl.c.pem -k $pkd/cli.otvl.k.pem --cas $pkd/fca.otvl.c.pem --force-host --secrets-dir $lrd/vlts_secrets/otvl/test"
  PYTHONPATH=src cmd venv/bin/python -m provisioner $vopts --hosts $vlh
}

launch_test_hosting() {
  log launch_test_hosting
  cd $vrrd/tf/otvl/test/vlts
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  cd $vrrd/tf/otvl/test/hosting
  vaa="-auto-approve"
  vaa=
  cmd tofu apply $vaa -var vlts_hostname=$vipv4s
}

reset_ovh_dns() {
  log reset_ovh_dns
  cd $vrrd/ovh_dns
  PYTHONPATH=src cmd venv/bin/python -m ovh_dns -i $INGRESS --ip 0.0.0.0
}

set_ovh_dns() {
  log set_ovh_dns
  cd $vrrd/tf/otvl/test/hosting
  vip=`tofu output -json ipv4s | jq .[1][0] | sed -e 's="==g'`
  cd $vrrd/ovh_dns
  PYTHONPATH=src cmd venv/bin/python -m ovh_dns -i $INGRESS --ip $vip
}

destroy_test_hosting() {
  log destroy_test_hosting
  cd $vrrd/tf/otvl/test/hosting
  tofu destroy -exclude module.compute.module.instances.openstack_blockstorage_volume_v3.volumes
}

destroy_test_vlts() {
  log destroy_test_vlts
  cd $vrrd/tf/otvl/test/vlts
  tofu destroy
}

log $0 starting
. $HOME/.osenvrc
INGRESS="t-ctr t-cs t-cs-bis"
icmd "launch test vault server" launch_test_vlts n
icmd "provision test secrets" provision_test_vlts n
icmd "launch test hosting" launch_test_hosting n
icmd "set OVH DNS for $INGRESS" set_ovh_dns n
icmd "destroy test hosting" destroy_test_hosting n
icmd "destroy test vault server" destroy_test_vlts n
icmd "reset OVH DNS for $INGRESS" reset_ovh_dns n

log $0 stopping
