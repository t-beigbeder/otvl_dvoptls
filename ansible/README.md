# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- synchronize (rsync, cabri) home / tools / data directories through configuration
- handle single private network interface (tf modules, ip routes, k3s config check) (needed?)
- backup-restore registry (needed?)

## FIXME

- configure CS custom image for various users
- remove python from CS base image

## RELEASED

- add swap to debian VMs
- exit NFS

## DONE

- Install nfs-common on agents
- code-server in container
- flannel iface retrieve dynamic
- code-server user configuration
- agent node label missing
- create env with home / tools / data / ephemeral directories
- add bash-completion to code-server image
