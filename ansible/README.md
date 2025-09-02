# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- cuda in debian
- debian13
- backup sync server data as object storage

## FIXME

## RELEASED

- active hosts to periodically reconnect to vault server when reprovisioned
  
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
- wait for ctr cert before build
- do not use sda1 when sync server data volume fails to attach
