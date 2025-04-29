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
	venv/bin/pip install -r requirements.txt -r requirements-dev.txt pex
	pex pex -c pex -o ~/bin/pex

.PHONY: qa
qa:	## launch QA tests
	flake8 src

.PHONY: run
run: ## run vault server
	python -m fastapi dev src/vault_server/main.py

.PHONY: build
build: ## build vault server
	pex pex -r requirements.txt -m fastapi -o build/vault_server