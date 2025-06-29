# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- code-server user configuration
- handle single private network interface (tf modules, ip routes, k3s config check)


## FIXME

- nfs server hard coded
- agent name label missing

## DONE

- Install nfs-common on agents
- code-server in container
- flannel iface retrieve dynamic
