# Ansible setup for otvl_web

    make venv
    cp ansible_sample.cfg ansible.cfg
    . venv/bin/activate

# WIP

## TODO

- code-server user configuration

      - name: "Create /usr/local/bin utilities shell scripts"
        copy:
          src: "ulb/{{ item }}"
          dest: "/usr/local/bin/{{ item }}"
          owner: root
          group: root
          mode: 0755
        loop:
          - otvl_default_route.sh

- handle single private network interface (tf modules, ip routes, k3s config check)


## FIXME

- nfs server hard coded
- agent name label missing
- flannel iface retrieve dynamic

## DONE

- Install nfs-common on agents
- code-server in container
