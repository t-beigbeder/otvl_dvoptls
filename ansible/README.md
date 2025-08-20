# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- debian13
- cuda in debian
- backup sync server data as object storage

## FIXME

- do not use sda1 when sync server data volume fails to attach
- wait for ctr cert before build
  - python3 /home/debian/locgit/otvl_dvoptls/pynsutil/wait_ns.py -l t-sk3s-sv-ext -n t-ctr.otvl.org
  - python3 /home/debian/locgit/otvl_dvoptls/pynsutil/wait_cert.py -u https://t-ctr.otvl.org

## RELEASED
  
## DONE

- Install nfs-common on agents
- code-server in container
- flannel iface retrieve dynamic
- code-server user configuration
- agent node label missing
- create env with home / tools / data / ephemeral directories
- add bash-completion to code-server image
- ansible-galaxy collection community.crypto
- add swap to debian VMs
- exit NFS
- synchronize home / tools / data directories through configuration
- kube in cs
- pubnet -var vlts_hostname=1.2.3.4
- docker in cs
