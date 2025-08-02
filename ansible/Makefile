all:
	@echo "nothing is done when 'all' is done, try make help"
help:	## show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: venv
venv: ## create a virtualenv and install dependencies
	virtualenv venv
	venv/bin/pip install pip-tools
	venv/bin/pip-compile requirements.in
	venv/bin/pip install -r requirements.txt

.PHONY: venv-ins
venv-ins: ## create a virtualenv for ansible installer and install dependencies
	virtualenv venv
	venv/bin/pip install pip-tools
	venv/bin/pip-compile requirements-ins.in
	venv/bin/pip install -r requirements-ins.txt
