# vault_server HTTP API server to load and distribute secrets securely

This HTTP API server enables http client to load secrets from a trusted environment
that can be retrieved from a provisioned VM from cloud-init.

## Development

vitualenv venv
pip install pip-tools
pip-compile requirements-dev.in && pip-compile requirements.in
pip install -r requirements.txt -r requirements-dev.txt 