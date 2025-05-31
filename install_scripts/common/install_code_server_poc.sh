#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/../locenv
## endpre

patch_fail2ban_install() {
  cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
# Debian 12 has no log files, just journalctl
backend = systemd

# "bantime" is the number of seconds that a host is banned.
bantime  = 1d
# "maxretry" is the number of failures before a host get banned.
maxretry = 5
# A host is banned if it has generated "maxretry" during the last "findtime"
findtime  = 1h

[sshd]
enabled = true

EOF

}

install_csp() {
  log running "curl -fsSL https://code-server.dev/install.sh | sh"
  curl -fsSL https://code-server.dev/install.sh | sh && \
  cmd useradd guest -s /bin/bash && \
  cmd systemctl enable --now code-server@guest && \
  cmd cp -rp /home/debian/.ssh /home/guest && \
  cmd chown -R guest:guest /home/guest/.ssh && \
  cmd su - guest -c "sed -i.bak 's/auth: password/auth: none/' .config/code-server/config.yaml" && \
  cmd systemctl restart code-server@guest && \
  true
  return $?
}

log $0 starting
install_csp || fat $0 failed
log $0 stopping
