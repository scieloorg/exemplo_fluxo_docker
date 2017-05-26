default: test

COMPOSE_FILE_DEV = docker-compose-dev.yml
COMPOSE_FILE_BUILD = docker-compose-build.yml
COMPOSE_FILE_PROD = docker-compose.yml

############################################
## atalhos docker-compose desenvolvimento ##
############################################

dev_compose_up:
	@docker-compose -f $(COMPOSE_FILE_DEV) up -d

dev_compose_logs:
	@docker-compose -f $(COMPOSE_FILE_DEV) logs -f

dev_compose_stop:
	@docker-compose -f $(COMPOSE_FILE_DEV) stop

dev_compose_ps:
	@docker-compose -f $(COMPOSE_FILE_DEV) ps

dev_compose_rm:
	@docker-compose -f $(COMPOSE_FILE_DEV) rm -f

dev_compose_exec_shell_webapp:
	@docker-compose -f $(COMPOSE_FILE_DEV) exec flapp_webapp bash

dev_compose_make_test:
	@docker-compose -f $(COMPOSE_FILE_DEV) exec flapp_webapp make test


#####################################################
## atalhos docker-compose build e testes no traivs ##
#####################################################

travis_compose_build:
	@docker-compose -f $(COMPOSE_FILE_BUILD) build

travis_compose_up:
	@docker-compose -f $(COMPOSE_FILE_BUILD) up -d

travis_compose_make_test:
	@docker-compose -f $(COMPOSE_FILE_BUILD) exec flapp_webapp make test

travis_run_audit:
	@docker run \
	-it --net host --pid host \
	--cap-add audit_control \
	-v /var/lib:/var/lib \
  	-v /var/run/docker.sock:/var/run/docker.sock \
  	-v /usr/lib/systemd:/usr/lib/systemd \
  	-v /etc:/etc \
  	--label docker_bench_security \
	docker/docker-bench-security


###########################################################
## atalhos docker-compose build e push para o Docker Hub ##
###########################################################

release_docker_build:
	@echo "[Building] Target image -> $(TRAVIS_REPO_SLUG):$(COMMIT)"
	@docker build -t $(TRAVIS_REPO_SLUG):$(COMMIT) .

release_docker_tag:
	@echo "[Tagging] Target image -> $(TRAVIS_REPO_SLUG):$(COMMIT)"
	@echo "[Tagging] Image name:latest -> $(TRAVIS_REPO_SLUG):latest"
	@docker tag $(TRAVIS_REPO_SLUG):$(COMMIT) $(TRAVIS_REPO_SLUG):latest
	@echo "[Tagging] Image name:latest -> $(TRAVIS_REPO_SLUG):travis-$(TRAVIS_BUILD_NUMBER)"
	@docker tag $(TRAVIS_REPO_SLUG):$(COMMIT) $(TRAVIS_REPO_SLUG):travis-$(TRAVIS_BUILD_NUMBER)

release_scielo_tag:
	@echo "[Tagging] Target image -> $(TRAVIS_REPO_SLUG):$(COMMIT)"
	@echo "[Tagging] Image namespace:name:tag -> $(REGISTRY_SCIELO)/$(TRAVIS_REPO_SLUG):latest"
	@docker tag $(TRAVIS_REPO_SLUG):$(COMMIT) $(REGISTRY_SCIELO)/$(TRAVIS_REPO_SLUG):latest

release_docker_push:
	@echo "[Pushing] pushing image to docker registry: $(TRAVIS_REPO_SLUG)"
	@docker push $(TRAVIS_REPO_SLUG)
	@echo "[Pushing] push $(TRAVIS_REPO_SLUG) done!"

release_scielo_push:
	@echo "[Pushing] pushing image to scielo registry: $(REGISTRY_SCIELO)/$(TRAVIS_REPO_SLUG):latest"
	@docker push $(REGISTRY_SCIELO)/$(TRAVIS_REPO_SLUG):latest
	@echo "[Pushing] push $(TRAVIS_REPO_SLUG) done!"

test:
	cd /app/flapp && python -m unittest discover -v
