#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

run_parted() {
  if [ "`lsblk -P -o NAME | grep $vdk | wc -l`" != "1" ] ; then
    return 0
  fi
  cmd apt-get install -y --no-install-recommends parted nfs-kernel-server && \
  cmd parted -s /dev/${vdk} mklabel msdos && \
  cmd parted -s -a optimal /dev/${vdk} mkpart primary ext4 0% 100% && \
  true
  return $?
}

run_mkfs() {
  if [ "`lsblk -fP -o NAME,FSTYPE | grep ${vdk}1 | grep ext4`" != "" ] ; then
    return 0
  fi
  cmd mkfs.ext4 /dev/${vdk}1 && \
  cmd systemctl daemon-reload && \
  true
  return $?
}

upd_fstab_and_mount() {
    if [ "`grep /dev/${vdk}1 /etc/fstab`" != "" ] ; then
      return 0
    fi
    echo "/dev/${vdk}1 /data ext4 nofail 0 0" >> /etc/fstab && \
    cmd mount /data && \
    true
    return $?
}

upd_exp_and_run() {
    if [ "`grep /data /etc/exports`" != "" ] ; then
      return 0
    fi
    echo "/data ${CI_LOC_CIDR}(rw,sync,no_subtree_check)" >> /etc/exports && \
    cmd exportfs -av && \
    true
    return $?
}

log $0 starting
if [ -z "$CI_LOC_CIDR" ] ; then
  fat "variable CI_LOC_CIDR is unset"
fi
vdk=`lsblk -P -o NAME,TYPE | fgrep disk | tail -1 | sed -e s/NAME=.// | sed -e 's/" .*$//'`
cmd run_parted && \
cmd run_mkfs && \
cmd mkdir -p /data && \
cmd upd_fstab_and_mount && \
cmd upd_exp_and_run && \
true || fat $0 failed
log $0 stopping
