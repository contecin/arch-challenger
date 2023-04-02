.PHONY: create-axonserver stop rmc rmn rmv ms-network axon-config axon-data axon-events axonserver-volumes axonserver-run eureka-build build-all eureka-run api-gateway-build api-gateway-run produtos-ms-build produtos-ms-run

help:
	@echo "    create-axonserver"
	@echo "        Shell de configuracao de pastas do axonserver"
	@echo "    stop"
	@echo "        Para a execucao de todos os containers docker"
	@echo "    rmc"
	@echo "        Remove todos os containers docker"
	@echo "    rmn"
	@echo "        Remove todos os networks docker"
	@echo "    rmv"
	@echo "        Remove todos os volumes docker"
	@echo "    ms-network"
	@echo "        Cria o network ms-network"
	@echo "    axon-config"
	@echo "        Cria o volume my-axon-server-config"
	@echo "    axon-data"
	@echo "        Cria o volume my-axon-server-data"
	@echo "    axon-events"
	@echo "        Cria o volume my-axon-server-events"
	@echo "    axonserver-volumes"
	@echo "        Cria os volumes para o axonserver"
	@echo "    axonserver-run"
	@echo "        Executa a imagem axonserver"
	@echo "    eureka-build"
	@echo "        Builda imagem docker discovery-server"
	@echo "    api-gateway-build"
	@echo "       Builda imagem docker api-gateway"
	@echo "    produtos-ms-build"
	@echo "        Builda imagem docker produtos-ms"
	@echo "    build-all"
	@echo "        Builda todas as imagens"
	@echo "    eureka-run"
	@echo "        Executa a imagem discovery-server"
	@echo "    api-gateway-run"
	@echo "       Executa a imagem api-gateway"
	@echo "    produtos-ms-run"
	@echo "        Executa a imagem produtos-ms"
	@echo "    up"
	@echo "       Executa o docker compose"


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

ms-network:
	if [ -z $(shell docker network ls --filter name=^ms-network --format="{{ .Name }}") ]; then \
		docker network create -d bridge ms-network; \
	fi

axon-config:
	if [ -z $(shell docker volume ls --filter name=^my-axon-server-config --format="{{ .Name }}") ]; then \
		docker volume create -d local -o type=none -o device=$(CONFIG_DIR) -o o=bind --name my-axon-server-config; \
	fi

axon-data:
	if [ -z $(shell docker volume ls --filter name=^my-axon-server-data --format="{{ .Name }}") ]; then \
		docker volume create -d local -o type=none -o device=$(CONFIG_DIR) -o o=bind --name my-axon-server-data; \
	fi

axon-events:
	if [ -z $(shell docker volume ls --filter name=^my-axon-server-events --format="{{ .Name }}") ]; then \
		docker volume create -d local -o type=none -o device=$(CONFIG_DIR) -o o=bind --name my-axon-server-events; \
	fi

axonserver-volumes: axon-config axon-data axon-events


### DOCKER BUILD ###
eureka-build:
	docker build -t discovery-server  ./discovery-server

api-gateway-build:
	docker build -t api-gateway  ./api-gateway

produtos-ms-build:
	docker build -t produtos-ms  ./produtos-ms

build-all: eureka-build api-gateway-build produtos-ms-build

### DOCKER RUN ###

axonserver-run: create-axonserver ms-network axonserver-volumes
	docker run -d --name axon-server -p 8024:8024/tcp -p 8124:8124/tcp -v my-axon-server-config:/config:ro -v my-axon-server-data:/data -v my-axon-server-events:/eventdata --network ms-network -t axoniq/axonserver

eureka-run: ms-network
	docker run -d --name eureka -p 8761:8761/tcp -e "JAVA_OPTS=-Dinstance.prefer-ip-address=false -Deureka.eureka.instance.hostname=eureka-server -Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t discovery-server

api-gateway-run: ms-network
	docker run -d --name api-gateway -p 8082:8082 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t api-gateway

produtos-ms-run: ms-network
	docker run --name produtos-ms$(PORT) -d -p $(PORT):$(PORT) -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" -e "SERVER_PORT=$(PORT)" --network ms-network -t produtos-ms


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

### DEFAULT ###
ifndef PORT
	override PORT = 8090
endif