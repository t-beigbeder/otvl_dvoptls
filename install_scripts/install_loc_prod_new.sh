#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

vrrd=`realpath $sd/..`
vlrrd=`realpath $vrrd/lops_repo`

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

launch_prod_k3sm() {
  log launch_prod_k3sm
  cd $vlrrd/tf/otvl/test/vlts
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  cd $vlrrd/tf/otvl/test/k3sm
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
  cd $vlrrd/tf/otvl/prod/k3sm
  vip=`tofu output -json ipv4s | jq .[0][0] | sed -e 's="==g'`
  cd $vrrd/ovh_dns
  PYTHONPATH=src cmd venv/bin/python -m ovh_dns -i $INGRESS --ip $vip
}

destroy_prod_k3sm() {
  log destroy_prod_k3sm
  cd $vlrrd/tf/otvl/test/vlts
  vipv4s=`tofu output -json ipv4s | sed -e 's/.//' | sed -e 's/.$//' | sed -e 's/"//g'| sed -e 's/,/ /'`
  cd $vlrrd/tf/otvl/prod/k3sm
  cmd tofu destroy -exclude module.compute.module.instances.openstack_blockstorage_volume_v3.volumes -var vlts_hostname=$vipv4s
}

log $0 starting
. $HOME/.osenvrc
INGRESS="blog"
icmd "provision prod secrets" provision_prod_vlts n
icmd "launch prod k3sm" launch_prod_k3sm n
icmd "set OVH DNS for $INGRESS" set_ovh_dns n
icmd "destroy prod k3sm" destroy_prod_k3sm n
icmd "reset OVH DNS for $INGRESS" reset_ovh_dns n

log $0 stopping
