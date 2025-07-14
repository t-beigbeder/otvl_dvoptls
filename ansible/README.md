# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- synchronize (rsync, cabri) home / tools / data directories through configuration
  - /configmap/sprik  /configmap/spubk trap hdl_shutd SIGTERM
- handle single private network interface (tf modules, ip routes, k3s config check) (needed?)
- add python virtualenv jq make to various CS derived images

## FIXME

- configure CS custom image for various users

## RELEASED

- ansible-galaxy collection community.crypto
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
