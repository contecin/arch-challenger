### IMAGES ###

eureka-build:
	docker build -t arch-challenger-discovery-server  ./discovery-server

eureka-run:
	docker run -p 8761:8761/tcp -e "JAVA_OPTS=-Dinstance.prefer-ip-address=false -Deureka.eureka.instance.hostname=eureka-server -Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-discovery-server

produtos-build:
	docker build -t arch-challenger-produtos-ms  ./produtos-ms

produtos-run:
	docker run -p 8090:8090 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" "SERVER_PORT=8090" --network ms-network -t arch-challenger-produtos-ms

api-gateway-build:
	docker build -t arch-challenger-api-gateway  ./api-gateway

api-gateway-run:
	docker run -p 8082:8082 -e "JAVA_OPTS=-Deureka.client.serviceUrl.defaultZone=http://eureka-server:8761/eureka" --network ms-network -t arch-challenger-api-gateway


### COMPOSE ###

up:
	docker-compose up