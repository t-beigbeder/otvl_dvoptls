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

installf2b() {
  ls badfile && \
  true
  return $?
}

log $0 starting
installf2b || fat $0 failed
log $0 stopping
