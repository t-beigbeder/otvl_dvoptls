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
    if [ "`grep " /data " /etc/fstab`" != "" ] ; then
      return 0
    fi
    vuid=`blkid -o value /dev/${vdk}1 | head -1`
    echo "UUID=$vuid /data ext4 defaults 0 0" >> /etc/fstab && \
    cmd mount /data && \
    true
    return $?
}

log $0 starting
vdk=`lsblk -P -x NAME -o NAME,TYPE | fgrep disk | tail -1 | sed -e s/NAME=.// | sed -e 's/" .*$//'`
cmd apt-get install -y --no-install-recommends parted rsync && \
cmd run_parted && \
cmd run_mkfs && \
cmd mkdir -p /data && \
cmd upd_fstab_and_mount && \
true || fat $0 failed
log $0 stopping
