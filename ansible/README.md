# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- handle single private network interface (tf modules, ip routes, k3s config check)
- backup-restore registry

## FIXME

## RELEASED

- upgrade traefik proxy version
- k3s conf Jun 30 16:56:44 t-sk3s-sv k3s[5761]: time="2025-06-30T16:56:44Z" level=error msg="Failed to process config: failed to process /var/lib/rancher/k3s/server/manifests/traefik-config.yaml: yaml: line 22: did not find expected key"

## DONE

- Install nfs-common on agents
- code-server in container
- flannel iface retrieve dynamic
- code-server user configuration
- agent node label missing
