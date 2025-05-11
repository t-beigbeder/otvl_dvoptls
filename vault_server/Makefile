all:
	@echo "nothing is done when 'all' is done, try make help"
help:	## show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: venv
venv: ## create a virtualenv and install dev dependencies
	virtualenv venv
	venv/bin/pip install pip-tools
	venv/bin/pip-compile requirements-dev.in
	venv/bin/pip-compile requirements.in
	venv/bin/pip install -r requirements.txt -r requirements-dev.txt

.PHONY: qa
qa:	## launch QA tests
	venv/bin/flake8 src

.PHONY: run
run: export PYTHONPATH=src
run: ## run vault server
	venv/bin/python -m vault_server

.PHONY: test
test: export PYTHONPATH=src
test: ## test vault server
	venv/bin/python -m unittest discover -s src
