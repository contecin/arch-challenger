.PHONY: create-axonserver stop rmc rmn rmv axonserver-network axonserver-volumes axonserver-run eureka-build eureka-run api-gateway-build api-gateway-run produtos-ms-build produtos-ms-run

help:
	@echo "    create-axonserver"
	@echo "        Shell de configuração de pastas do axonserver"
	@echo "    stop"
	@echo "        Para a execução de todos os containers docker"
	@echo "    rmc"
	@echo "        Remove todos os containers docker"
	@echo "    rmn"
	@echo "        Remove todos os networks docker"
	@echo "    rmv"
	@echo "        Remove todos os volumes docker"
	@echo "    axonserver-volumes"
	@echo "        Cria os volumes para o axonserver"
	@echo "    axonserver-run"
	@echo "        Executa a imagem axonserver"
	@echo "    eureka-build"
	@echo "        Builda imagem docker discovery-server"
	@echo "    eureka-run"
	@echo "        Executa a imagem discovery-server"
	@echo "    api-gateway-run"
	@echo "       Executa a imagem api-gateway"
	@echo "    up"
	@echo "       Executa o docker compose"
	@echo "    produtos-ms-build"
	@echo "        Builda imagem docker produtos-ms"
	@echo "    produtos-ms-run"
	@echo "        Executa a imagem produtos-ms"
	@echo "    api-gateway-build"
	@echo "       Builda imagem docker api-gateway"


### SCRIPTS ###

create-axonserver:
	./my-axon-server/create-axonserver.sh


### DOCKER ###

stop:
	if [ -n "$(DOCKER_CONTAINER_LIST_UP)" ]; \
	then \
		docker stop $(DOCKER_CONTAINER_LIST_UP); \
	fi

rmc: stop
	if [ -n "$(DOCKER_CONTAINER_LIST)" ]; \
	then \
		docker rm $(DOCKER_CONTAINER_LIST); \
	fi

rmn: rmc
	if [ -n "$(DOCKER_NETWORK_LIST)" ]; \
	then \
		docker network rm $(DOCKER_NETWORK_LIST); \
	fi

rmv: rmc
	if [ -n "$(DOCKER_VOLUMES_LIST)" ]; \
	then \
		docker volume rm $(DOCKER_VOLUMES_LIST); \
	fi

axonserver-network: rmn
	docker network create -d bridge ms-network

axonserver-volumes: rmv
	docker volume create -d local -o type=none -o device=$(CONFIG_DIR) -o o=bind --name my-axon-server-config
	docker volume create -d local -o type=none -o device=$(DATA_DIR) -o o=bind --name my-axon-server-data
	docker volume create -d local -o type=none -o device=$(EVENTS_DIR) -o o=bind --name my-axon-server-events


### DOCKER BUILD ###
eureka-build:
	docker build -t discovery-server  ./discovery-server

api-gateway-build:
	docker build -t api-gateway  ./api-gateway

produtos-ms-build:
	docker build -t produtos-ms  ./produtos-ms

### DOCKER RUN ###

axonserver-run: create-axonserver axonserver-network axonserver-volumes
	docker run -d -p 8024:8024/tcp -p 8124:8124/tcp -v my-axon-server-config:/config:ro -v my-axon-server-data:/data -v my-axon-server-events:/eventdata --network ms-network -t axoniq/axonserver

eureka-run:
	docker run -d -p 8761:8761/tcp -e "JAVA_OPTS=-Dinstance.prefer-ip-address=false -Deureka.eureka.instance.hostname=eureka-server -Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-discovery-server

api-gateway-run:
	docker run -d -p 8082:8082 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-api-gateway

produtos-ms-run:
	docker run -d -p 8090:8090 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" "SERVER_PORT=8090" --network ms-network -t arch-challenger-produtos-ms


### DOCKER COMPOSE ###
up: create-axonserver
	docker-compose up

### VARIAVEIS ###
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))

CONFIG_DIR := $(MKFILE_DIR)my-axon-server/config
DATA_DIR := $(MKFILE_DIR)my-axon-server/data
EVENTS_DIR := $(MKFILE_DIR)my-axon-server/events

DOCKER_CONTAINER_LIST_UP := $(shell docker ps -q)
DOCKER_CONTAINER_LIST := $(shell docker ps -a -q)
DOCKER_NETWORK_LIST := $(shell docker network ls -q --filter dangling=true)
DOCKER_VOLUMES_LIST := $(shell docker volume ls -q --filter dangling=true)