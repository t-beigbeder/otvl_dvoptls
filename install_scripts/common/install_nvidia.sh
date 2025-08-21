#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

log $0 starting
if [ -f /root/.otvl_ci_env ] ; then
  . /root/.otvl_ci_env
fi
if [ -z "`grep has_gpu /root/.config/otvl_vlts/install_otvl_meta`" ] ; then
    err $CI_HN_LIST has no GPU
    fat $0 failed
fi
if [ -f /root/nvidia-installed ] ; then
    log $0 has restarted, nothing to do
    exit 0
fi
export DEBIAN_FRONTEND=noninteractive
cmd cd /tmp && \
cmd wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
cmd dpkg -i cuda-keyring_1.1-1_all.deb && \
cmd rm cuda-keyring_1.1-1_all.deb && \
cmd apt-get update && \
cmd apt-get install -y linux-headers-`uname -r` && \
cmd apt-get install -y software-properties-common && \
cmd add-apt-repository -y contrib && \
cmd apt-get install -y cuda-toolkit-13-0 && \
cmd apt-get install -y nvidia-driver-cuda nvidia-kernel-dkms && \
cmd touch /root/nvidia-installed && \
log $0 will reboot now && \
cmd reboot && \
true || fat $0 failed
log $0 stopping
