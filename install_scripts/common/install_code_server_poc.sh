#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_csp() {
  log running "curl -fsSL https://code-server.dev/install.sh | sh"
  curl -fsSL https://code-server.dev/install.sh | sh && \
  cmd useradd guest -s /bin/bash && \
  cmd mkdir -p /home/guest/.ssh && \
  cmd chown -R guest:guest /home/guest && \
  cmd systemctl enable --now code-server@guest && \
  cmd cp -rp /home/debian/.ssh /home/guest/ && \
  cmd chown -R guest:guest /home/guest/.ssh && \
  cmd sleep 5 && \
  cmd su - guest -c "sed -i.bak 's/auth: password/auth: none/' .config/code-server/config.yaml" && \
  cmd systemctl restart code-server@guest && \
  true
  return $?
}

log $0 starting
install_csp || fat $0 failed
log $0 stopping
