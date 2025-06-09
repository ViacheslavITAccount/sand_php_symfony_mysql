.DEFAULT_GOAL=help

.PHONY: help
help: ## Show all command
	@echo "List of all available commands"
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: build
build: ## Command build dependency and run application
	@echo "Start build nginx image..."
	@docker build -t sandbox_nginx_128 ./docker/nginx --no-cache
	@echo "Start build php image..."
	@docker build -t sandbox_php_83 ./docker/php --no-cache
	@echo "Run application..."
	@docker compose -f ./docker/docker-compose.yaml up --detach --remove-orphans
	@echo "Init application..."
	@docker exec -it fpm sh -lc 'composer install'
	@echo "Clear application cache..."
	@docker exec -it fpm sh -lc 'bin/console c:c'
	@echo "Please run command 'make migration' before using project"
	@echo "Building application successfully finished and now application is available in browser 'http://localhost:8080'"

.PHONY: migration
check-migration: ## Check connect to DB and available migrations
	@echo "Check DB migrations..."
	@docker exec -it fpm sh -lc 'bin/console d:m:list'

.PHONY: migration
migration: ## Execute migrations
	@echo "Run DB migrations..."
	@docker exec -it fpm sh -lc 'bin/console d:m:m'

.PHONY: up
up: ## Run application
	@echo "Start application services..."
	@docker compose -f ./docker/docker-compose.yaml up --detach
	@echo "Now application is available in browser 'http://pet-project.sandbox.local' or 'https://pet-project.sandbox.local'"

.PHONY: down
down: ## Shut down application
	@echo "Stop application services..."
	@docker compose -f ./docker/docker-compose.yaml down

.PHONY: ps
ps: ## Show all run containers
	@echo "Show all run containers..."
	@docker ps -a

.PHONY: php_container
php_container: ## Run shell in php container
	@echo "Entering php container..."
	@docker exec -it fpm sh

.PHONY: composer-install
composer-install:
	@echo "Run installing packages..."
	@docker exec -it fpm sh -lc 'composer install'

.PHONY: composer-update
composer-update:
	@echo "Run updating packages..."
	@docker exec -it fpm sh -lc 'composer update'

.PHONY: clear-cache
clear-cache: ## Clear cache
	@echo "Clear application cache..."
	@docker exec -it fpm sh -lc 'bin/console c:c'

.PHONY: xdebug-start
xdebug-start:
	@echo "Start php container with xdebug..."
	@docker exec -it fpm sh -lc 'sed -i "s/^;zend_extension=/zend_extension=/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
	@docker compose -f ./docker/docker-compose.yaml restart fpm

.PHONY: xdebug-stop
xdebug-stop:
	@echo "Start php container without xdebug..."
	@docker exec -it fpm sh -lc 'sed -i "s/^zend_extension=/;zend_extension=/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
	@docker compose -f ./docker/docker-compose.yaml restart fpm

.PHONY: run-phpunit
run-phpunit: ## Run PhpUnit tests
	@echo "Clear application cache..."
	@docker exec -it fpm sh -lc 'bin/phpunit'

.PHONY: run-codeception
run-codeception: ## Run Codeception tests
	@echo "Clear application cache..."
	@docker exec -it fpm sh -lc 'vendor/bin/codecept run'