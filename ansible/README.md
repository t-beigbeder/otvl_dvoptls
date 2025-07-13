# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- create env with home / tools / data / ephemeral directories
- exit NFS
- synchronize (rsync, cabri) home / tools / data directories through configuration
- handle single private network interface (tf modules, ip routes, k3s config check) (needed?)
- backup-restore registry (needed?)

## FIXME

- configure CS custom image for various users

## RELEASED

- add bash-completion to code-server image
- add swap to debian VMs

## DONE

- Install nfs-common on agents
- code-server in container
- flannel iface retrieve dynamic
- code-server user configuration
- agent node label missing
