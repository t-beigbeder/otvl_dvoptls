#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

get_data_disk() {
  lsblk -P -o NAME,TYPE | fgrep disk | while read tdk ; do
    tdv=`echo $tdk | sed -e 's/NAME..//' | sed -e 's/. TYPE=.*$//'`
    # tct=`lsblk -P -o NAME,TYPE,MOUNTPOINT | fgrep ${tdv} | wc -l`
    trt=`lsblk -P -o NAME,TYPE,MOUNTPOINT | fgrep ${tdv} | grep MOUNTPOINT=\"/\"`
    if [ -z "$trt" ] ; then
      echo $tdv
      return
    fi
  done
}

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
    if [ "`grep " /$vmdir " /etc/fstab`" != "" ] ; then
      return 0
    fi
    vuid=`blkid -o value /dev/${vdk}1 | head -1`
    echo "UUID=$vuid /$vmdir ext4 defaults 0 0" >> /etc/fstab && \
    cmd mount /$vmdir && \
    true
    return $?
}

log $0 starting
vmdir=data
if [ "`grep /$vmdir /etc/fstab`" != "" ] ; then
  log $0 stopping, /$vmdir already in /etc/fstab
  exit 0
fi
# vdk=`lsblk -P -x NAME -o NAME,TYPE | fgrep disk | tail -1 | sed -e s/NAME=.// | sed -e 's/" .*$//'`
vdk=`get_data_disk`
if [ -z "$vdk" ] ; then
  fat "no data disk detected"
fi
cmd apt-get install -y --no-install-recommends parted rsync && \
cmd run_parted && \
cmd run_mkfs && \
cmd mkdir -p /$vmdir && \
cmd upd_fstab_and_mount && \
true || fat $0 failed
log $0 stopping
