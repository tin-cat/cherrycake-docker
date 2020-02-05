MAKEFLAGS += --silent

PROJECT_NAME = cherrycake-app

DOCKER_NGINX = $(PROJECT_NAME)-nginx
DOCKER_PHP = $(PROJECT_NAME)-php
DOCKER_MARIADB = $(PROJECT_NAME)-mariadb
DOCKER_CRON = $(PROJECT_NAME)-cron
DOCKER_DB = $(PROJECT_NAME)-mariadb
DOCKER_REDIS = $(PROJECT_NAME)-redis

## Docker commands

help: ## Show this help message
	echo 'Cherrycake docker make'
	echo 'usage: make [command]'
	echo
	echo 'commands:'
	egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

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

## Cherrycake app installation commands
install-skeleton: ## Installs the base Cherrycake source, nginx settings and more on the Nginx container.
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

redis-flush-all: ## Flushes the entire Redis cache (Uncomitted queues will be lost)
	docker exec -it -u root ${DOCKER_REDIS} redis-cli flushall