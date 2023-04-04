# arch-challenger

Projeto para base de conhecimento. \
Aplicação dos melhores design patterns atuais de arquitetura, boas práticas e SOLID
___

## Usando Docker

### Requisitos
1. Instalar o [Docker](https://www.docker.com/)
2. Editar o arquivo **HOSTS**
   - no windows: > C:\Windows\System32\drivers\etc\hosts
   - no linux: > /etc/hosts
   - mapear o domínio "eureka-server" para o IP da máquina local
   > Formado: IPAddress DomainName DomainAliases(opcional) -> 127.0.0.1 eureka-server

### Executando com o Make
> o make possui somente tags com comandos docker
#### Windows

1. instalar o chocolatey com powershell:
    - `Get-ExecutionPolicy`: se retornar **Restricted** execute um dos comandos seguintes
    - `Set-ExecutionPolicy AllSigned`, `Set-ExecutionPolicy Bypass -Scope Process`
    - `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
2. instalar o make: `choco install make`

#### Linux
- `sudo apt update`
- `sudo apt install make`

#### Comandos
- acessar o menu de ajuda do make: `make help`
- executar todas as aplicações necessárias: `make up`

### Sem o Make
#### Configurar estrutura de arquivos para o Axon Server
1. criar os seguintes diretórios na raiz do projeto **my-axon-server**:
   - config/
   - data/
   - events/
2. copiar o arquivo **axonserver.yml** para o diretório **config/**
3. ou executar o comando shell: `./create-axonserver.sh` na raiz do projeto **my-axon-server**

#### Execução
- `docker-compose up`
---

## Usando Gradle

### Requisitos:
1. [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
2. [Gradle > 7.6.1](https://gradle.org/releases/)
3. configurar variáveis de ambiente para o sistema operacional:
   - windows
     >    use o comando **set** em vez do **setx** caso não queira criar a variável permanentemente

     >    remova o argumento **-m** caso queira criar as variáveis somente para o usuário
     - `setx JAVA_HOME "pasta_de_instalação_do_java\" -m`
     - `setx GRADLE_USER_HOME "pasta_de_instalação_do_gradle\" -m`
     - `setx path "%path%;%JAVA_HOME%\bin" -m`
     - `setx path "%path%;%GRADLE_USER_HOME%\bin" -m`
   - linux
     - `export JAVA_HOME=pasta_de_instalação_java_17/`
     - `export GRADLE_USER_HOME=pasta_de_instalação_do_gradle/`
     - `export PATH=$PATH:$JAVA_HOME/bin`
     - `export PATH=$PATH:GRADLE_USER_HOME/bin`

### Build

O build deve ser executado em cada projeto, em sua raiz menos no projeto **menos** no  projeto *my-axon-server*, através do comando:
- `gradle clean build`

### Execução
Após todos os projetos estarem buildados, realizar a execuação dos mesmos **segundo a ordem**:
1. subir o servidor **axon-server**
    > o projeto **my-axon-server** contém somente dados de configuração do servicor axon-server
    - baixar e extrair o [instalador](https://download.axoniq.io/axonserver/AxonServer.zip)
    - mover/copiar o arquivo **axonserver.jar** para a raiz do projeto **my-axon-server**
    - executar o comando shell `./axonserver.jar` na raiz do projeto **my-axon-server**
2. executar o projeto *discovery-server* e em seguida os demais projetos com o comando abaixo:
   - `gradle bootRun`
