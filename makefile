MAKEFLAGS += --silent

PROJECT_NAME = cherrycake-app

DOCKER_NGINX = ${PROJECT_NAME}-nginx
DOCKER_PHP = ${PROJECT_NAME}-php
DOCKER_CRON = ${PROJECT_NAME}-cron
DOCKER_REDIS = ${PROJECT_NAME}-redis

## Docker commands

help: ## Show this help message
	echo ${PROJECT_NAME}' docker make'
	echo 'usage: make [command]'
	echo
	echo 'commands:'
	egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

start: ## Start the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml up -d
stop: ## Stop the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml stop
down: ## Remove the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml down
restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start
status: ## Information about the containers
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml ps
nginx-build: ## Build the Nginx container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build nginx
nginx-log: ## Tail the Nginx log
	docker logs -f --details ${DOCKER_NGINX}
nginx-ssh: ## SSH into the Nginx container
	docker exec -it -u root ${DOCKER_NGINX} bash
nginx-restart: ## Restarts the Nginx container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart nginx
php-build: ## Build the PHP container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build php
php-log: ## Tail the PHP log
	docker logs -f --details ${DOCKER_PHP}
php-ssh: ## SSH into the PHP container
	docker exec -it -u root ${DOCKER_PHP} bash
php-restart: ## Restarts the PHP container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart php
cron-ssh: ## SSH into the Cron container
	docker exec -it -u root ${DOCKER_CRON} bash
cron-restart: ## Restarts the Cron container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart cron
db-build: ## Build the Database container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml build mariadb
db-log: ## Tail the Database container log
	docker logs -f --details ${DOCKER_DB}
db-ssh: ## SSH into the Database container
	docker exec -it -u root ${DOCKER_DB} bash
db-restart: ## Restarts the Database container
	docker-compose -p ${PROJECT_NAME} --file docker/docker-compose.yml restart mariadb
install-skeleton: ## Sets up a base Cherrycake installation
	docker exec -it -u root ${DOCKER_PHP} /scripts/install-skeleton
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-config
	docker exec -it -u root ${DOCKER_NGINX} /scripts/install-base-database
setup-config: ## Creates the Cherrycake config files
	docker exec -it -u root ${DOCKER_NGINX} /scripts/setup-config
composer-install: ## Installs Cherrycake's composer dependencies
	docker exec -it -u root ${DOCKER_PHP} /scripts/composer-install
composer-update: ## Updates Cherrycake's composer dependencies
	docker exec -it -u root ${DOCKER_PHP} /scripts/composer-update
composer-dump-autoload: ## Recreates composer autloading
	docker exec -it -u root ${DOCKER_PHP} /scripts/composer-update
install-base-database: ## Installs an initial Cherrycake database on the MariaDB container
	docker exec -it -u root ${DOCKER_NGINX} /scripts/install-base-database
cli: ## Executes a Cherrycake cli action. Pass the action name as value
	docker exec -it -u root ${DOCKER_PHP} /var/www/app/cherrycake $2
janitor: ## Runs the janitor
	docker exec -it -u root ${DOCKER_PHP} /var/www/app/cherrycake janitorRun
janitorStatus: ## Shows the status of the Janitor tasks
	docker exec -it -u root ${DOCKER_PHP} /var/www/app/cherrycake janitorStatus
redis-flush-all: ## Flushes the entire Redis cache (Uncomitted queues will be lost)
	docker exec -it -u root ${DOCKER_REDIS} redis-cli flushall
