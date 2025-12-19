.DEFAULT_GOAL := help

PROJECTS ?= certbot grafana homeassistant nginx plex portainer wud smb nut ddns \
	iperf3 rgb uptime

.PHONY: rebuild
rebuild: ## Builds & deploys with latest configs
	@for project in ${PROJECTS}; do \
  		echo "Rebuilding project $$project"; \
  		make _compose CMD="up" PROJECT="$$project" FLAGS="--force-recreate --build -d"; \
	done

.PHONY: clean
clean: ## Removes old images
	docker image prune

.PHONY: upgrade
upgrade: ## Pulls images & rebuilds
	@for project in ${PROJECTS}; do \
  		echo "Pulling image for project $$project"; \
  		make _compose PROJECT="$$project" CMD="pull"; \
	done
	make rebuild
	make clean

.PHONY: deploy
deploy: ## Brings up everything
	@for project in ${PROJECTS}; do \
  		echo "Bringing up project $$project"; \
  		make _compose CMD="up" PROJECT="$$project" FLAGS="-d"; \
	done

.PHONY: _compose
_compose:
	@cd "docker/${PROJECT}"; \
	if [ -f "compose.$$ENVIRONMENT.yaml" ]; then \
	  files="-f compose.yaml -f compose.$$ENVIRONMENT.yaml"; \
  	else \
  	  files="-f compose.yaml"; \
  	fi; \
	docker compose $$files ${CMD} ${FLAGS}

.PHONY: help
help: ## Get help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: shell
shell: ## make shell PROJECT=nxing
	make _compose CMD="exec -it $(PROJECT) sh"
