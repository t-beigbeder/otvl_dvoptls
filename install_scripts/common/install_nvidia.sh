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
export DEBIAN_FRONTEND=noninteractive
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.1-1
cmd cd /tmp && \
cmd wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb && \
cmd dpkg -i cuda-keyring_1.1-1_all.deb && \
cmd rm cuda-keyring_1.1-1_all.deb && \
cmd apt-get update && \
cmd apt-get install -y linux-headers-`uname -r` && \
cmd apt-get install -y cuda-toolkit-13-1 && \
cmd apt-get install -y cuda-drivers && \
cmd wget https://nvidia.github.io/libnvidia-container/gpgkey && \
cmd rm -f /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
cmd gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg < gpgkey && \
cmd rm gpgkey && \
cmd wget https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list && \
cmd sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  < nvidia-container-toolkit.list \
  > /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
cmd rm nvidia-container-toolkit.list && \
cmd apt-get update && \
cmd apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION} && \
true || fat $0 failed
log $0 stopping
