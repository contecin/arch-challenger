# arch-challenger

Projeto para base de conhecimento. \
Aplicação dos melhores design patterns atuais de arquitetura, boas práticas e SOLID
___

## REQUISITOS:

1. [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
2. [Gradle > 7.6.1](https://gradle.org/releases/)
3. [Docker](https://www.docker.com/)
4. configurar variáveis de ambiente:
    - JAVA_HOME
    - GRADLE_USER_HOME
    - adicionar o *path* dos bins para a variável **PATH**

> necessário executar os comandos apontando para a raiz do projeto ou à partir dela
---

### DOCKER COMPOSE

- editar o arquivo **HOSTS** como administrador da máquina:
  - no windows: C:\Windows\System32\drivers\etc\hosts
  - no linux: /etc/hosts

> mapear o domínio "eureka-server" para o IP da máquina local: \
> FORMATO: IPAddress DomainName DomainAliases(opcional) \
> 127.0.0.1 eureka-server

#### EXECUÇÃO
- `docker-compose up`
- com **MAKE** instalado: `make up`
