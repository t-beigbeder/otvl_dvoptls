#!/bin/sh

## pre
rp=`realpath $0`
sd=`dirname $rp`
. $sd/locenv
## endpre

log $0 starting
cmd $sd/common/install_ansible.sh || fat "while running $sd/common/install_ansible.sh"
if [ "$CI_CS_DVO" = "1" ] ; then
  cmd $sd/common/install_code_server_dvo.sh || fat "while running $sd/common/install_code_server_dvo.sh"
fi
ins_env=`cat /root/.config/otvl_vlts/install_env`
ins_grps=`cat /root/.config/otvl_vlts/install_groups`
ins_root=${sd}/${ins_env}
for grp in $ins_grps ; do
  if [ ! -f $ins_root/$grp.sh ] ; then continue ; fi
  cmd $ins_root/$grp.sh
  if [ $? -ne 0 ] ; then
    fat "while running $ins_root/$grp.sh"
  fi
done
cmd su - debian -c "$sd/common/as_deb_install_with_ansible.sh" || fat "while running "$sd/common/as_deb_install_with_ansible.sh"

log $0 stopping
