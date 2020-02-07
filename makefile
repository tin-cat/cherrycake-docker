MAKEFLAGS += --silent

PROJECT_NAME = cherrycake-app

DOCKER_NGINX = $(PROJECT_NAME)-nginx
DOCKER_PHP = $(PROJECT_NAME)-php
DOCKER_MARIADB = $(PROJECT_NAME)-mariadb
DOCKER_CRON = $(PROJECT_NAME)-cron
DOCKER_DB = $(PROJECT_NAME)-mariadb
DOCKER_REDIS = $(PROJECT_NAME)-redis

COLOR_WHITE = "\033[1m"
COLOR_RED = "\033[31m"
COLOR_GREEN = "\033[32m"
COLOR_YELLOW = "\033[33m"
COLOR_BLUE = "\033[34m"
COLOR_RED_LIGHT = "\033[35m"
COLOR_BLUE_LIGHT = "\033[36m"
COLOR_BG_RED = "\033[41m"
COLOR_BG_GREEN = "\033[42m"
COLOR_BG_YELLOW = "\033[43m"
COLOR_BG_BLUE = "\033[44m"
COLOR_RESET = "\033[0m"

COLOR_A = $(COLOR_RED_LIGHT)
COLOR_B = $(COLOR_RED_LIGHT)
COLOR_C = $(COLOR_BLUE_LIGHT)


help: ## Show this help message
	echo $(COLOR_A)'  _ |_   _  '$(COLOR_B)'_  _     '$(COLOR_C)'_  _  |   _'
	echo $(COLOR_A)' (_ | ) (- '$(COLOR_B)'|  |  \/ '$(COLOR_C)'(_ (_| |( (-'
	echo '                 '$(COLOR_B)'/        '$(COLOR_C)'docker'
	echo $(COLOR_RESET)
	echo 'usage: make ['$(COLOR_BLUE)'command'$(COLOR_RESET)']'
	echo
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\'$(COLOR_BLUE)'\1\'$(COLOR_RESET)':\2/' | column -c2 -t -s :)"

##
up: ## Start the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml up -d

stop: ## Stop the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml stop

down: ## Remove the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml down

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) up

ps: ## Information about the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml ps

nginx-build: ## Builds the Nginx image
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build nginx

nginx-log: ## Tail the PHP error log
	docker logs -f --details ${DOCKER_NGINX}

nginx-ssh: ## SSH into the Nginx container
	docker exec -it -u root ${DOCKER_NGINX} bash

php-build: ## Builds the PHP image
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build php

php-ssh: ## SSH into into the PHP container
	docker exec -it -u root ${DOCKER_PHP} bash

php-log: ## Tail the PHP error log
	docker logs -f --details ${DOCKER_PHP}

php-restart: ## Restarts the PHP container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart php

cron-build: ## Builds the cron image
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build cron

cron-ssh: ## SSH into into the cron container
	docker exec -it -u root ${DOCKER_CRON} bash

cron-log: ## Tail the cron error log
	docker logs -f --details ${DOCKER_CRON}

cron-restart: ## Restarts the cron container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart cron

db-ssh: ## SSH into the MariaDB container
	docker exec -it ${DOCKER_DB} mysql -uroot test

redis-ssh: ## SSH into the Redis container
	docker exec -it -u root ${DOCKER_REDIS} bash

##
install-skeleton: ## Installs a base Cherrycake installation, exposing the App under /app for development
	docker exec -it -u root ${DOCKER_NGINX} /scripts/install-skeleton
	docker exec -it -u root ${DOCKER_PHP} /scripts/composer-update
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-config
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-nginx
	docker exec -it -u root ${DOCKER_NGINX} /scripts/install-base-database

setup-config: ## Creates the Cherrycake config files
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-config

composer-update: ## Updates Cherrycake's composer dependencies
	docker exec -it -u root ${DOCKER_PHP} /scripts/composer-update

install-base-database: ## Installs an initial Cherrycake database on the MariaDB container. Existing database will be deleted.
	docker exec -it -u root ${DOCKER_NGINX} /scripts/install-base-database

setup-nginx: ## Sets up Nginx to work with Cherrycake
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-nginx

engine-developer-mode: ## Sets this installation in engine developer mode, suitable only to Cherrycake Engine developers. The Cherrycake Engine is exposed under /cherrycake-engine, and the app is under /app
	docker exec -it -u root ${DOCKER_PHP} /scripts/set-engine-developer-mode

app-developer-mode: ## Sets this installation in app developer mode (the default mode). The Cherrycake Engine is not exposed, the App is under /app
	docker exec -it -u root ${DOCKER_PHP} /scripts/set-app-developer-mode

##
redis-flush-all: ## Flushes the entire Redis cache (Uncomitted queues will be lost)
	docker exec -it -u root ${DOCKER_REDIS} redis-cli flushall