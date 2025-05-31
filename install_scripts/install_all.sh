#!/bin/sh

## pre
if [ `echo $0 | cut -c 1` = "/" ] ; then
  sd=`dirname $0`
else
  sd="${PWD}/`dirname $0`"
fi
. $sd/locenv
## endpre

log $0 starting
ins_env=`cat /root/.config/otvl_vlts/install_env`
ins_grps=`cat /root/.config/otvl_vlts/install_groups`
ins_root=${sd}/${ins_env}
for grp in $ins_grps ; do
  cmd $ins_root/$grp.sh
  if [ $? -ne 0 ] ; then
    log "Error running $ins_root/$grp.sh, exiting"
  fi
done
log $0 stopping
