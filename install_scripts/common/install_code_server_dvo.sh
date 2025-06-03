#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

install_csp() {
  log running "curl -fsSL https://code-server.dev/install.sh | sh"
  curl -fsSL https://code-server.dev/install.sh | sh && \
  cmd systemctl enable --now code-server@debian && \
  cmd sleep 5 && \
  cmd su - debian -c "sed -i.bak 's/auth: password/auth: none/' .config/code-server/config.yaml" && \
  cmd systemctl restart code-server@debian && \
  true
  return $?
}

log $0 starting
install_csp || fat $0 failed
log $0 stopping
# ssh -N -L 8080:127.0.0.1:8080 debian@ip