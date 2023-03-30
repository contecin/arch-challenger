.PHONY: eureka-build eureka-run produtos-ms-build produtos-ms-run api-gateway-build api-gateway-run

help:
	@echo "    eureka-build"
	@echo "        Builda imagem docker discovery-server"
	@echo "    eureka-run"
	@echo "        Executa a imagem discovery-server"
	@echo "    produtos-ms-build"
	@echo "        Builda imagem docker produtos-ms"
	@echo "    produtos-ms-run"
	@echo "        Executa a imagem produtos-ms"
	@echo "    api-gateway-build"
	@echo "       Builda imagem docker api-gateway"
	@echo "    api-gateway-run"
	@echo "       Executa a imagem api-gateway"
	@echo "    up"
	@echo "       Executa o docker compose"


### IMAGES DOCKER ###

eureka-build:
	docker build -t discovery-server  ./discovery-server

eureka-run:
	docker run -p 8761:8761/tcp -e "JAVA_OPTS=-Dinstance.prefer-ip-address=false -Deureka.eureka.instance.hostname=eureka-server -Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-discovery-server

produtos-ms-build:
	docker build -t produtos-ms  ./produtos-ms

produtos-ms-run:
	docker run -p 8090:8090 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" "SERVER_PORT=8090" --network ms-network -t arch-challenger-produtos-ms

api-gateway-build:
	docker build -t api-gateway  ./api-gateway

api-gateway-run:
	docker run -p 8082:8082 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-api-gateway


### DOCKER COMPOSE ###

up:
	docker-compose up