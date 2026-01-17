.DEFAULT_GOAL := help

# rgb plex
DEFAULT_PROJECTS = certbot grafana homeassistant nginx portainer wud smb nut ddns \
		iperf3 uptime
SERVICE ?=

ifeq ($(PROJECTS), all)
	_PROJECTS = $(DEFAULT_PROJECTS)
else ifdef PROJECTS
	_PROJECTS = $(PROJECTS)
endif

.PHONY: rebuild
rebuild: ## Builds & deploys with latest configs
	@for project in ${_PROJECTS}; do \
  		echo "Rebuilding project $$project"; \
  		make _compose CMD="up" PROJECT="$$project" FLAGS="--force-recreate --build -d"; \
	done

.PHONY: clean
clean: ## Removes old images
	docker image prune

.PHONY: upgrade
upgrade: _check_projects_variable ## Pulls images & rebuilds
	@for project in ${_PROJECTS}; do \
  		echo "Pulling image for project $$project"; \
  		make _compose PROJECT="$$project" CMD="pull"; \
	done
	make rebuild
	make clean

.PHONY: deploy
deploy: _check_projects_variable ## Brings up everything
	@for project in ${_PROJECTS}; do \
  		echo "Bringing up project $$project"; \
  		make _compose CMD="up" PROJECT="$$project" FLAGS="-d"; \
	done

.PHONY: _compose
_compose:
ifndef PROJECT
	$(error PROJECT is not set)
endif
	@cd "docker/${PROJECT}"; \
	if [ -f "compose.$$ENVIRONMENT.yaml" ]; then \
	  files="-f compose.yaml -f compose.$$ENVIRONMENT.yaml"; \
  	else \
  	  files="-f compose.yaml"; \
  	fi; \
  	echo "docker compose $$files ${CMD} ${FLAGS} ${SERVICE} ${OTHER_ARGS}"; \
	docker compose $$files ${CMD} ${FLAGS} ${SERVICE} ${OTHER_ARGS}

.PHONY: help
help: ## Get help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: shell
shell: ## make shell PROJECT=nginx SERVICE=nginx
ifeq ($(SERVICE),)
	SERVICE=$(PROJECT)
endif
	make _compose CMD="exec" OTHER_ARGS="sh"


.PHONY: _check_projects_variable
_check_projects_variable:
ifndef PROJECTS
	$(error PROJECTS is not set. Use 'all' for all projects)
endif