# DevOps tools for otvl projects

## Useful commands

### Helm

    helm install --dry-run --debug -f ~/helm_values/t-cs-bis.yaml t-cs-bis ../otvl_dvoptls/helm/code_server/
    helm template --dry-run --debug -f ~/helm_values/t-cs-bis.yaml t-cs-bis ../otvl_dvoptls/helm/code_server/    