#! /bin/sh

echo "Checar estrutura de pastas e arquivos do Axon Server..."

# verifica se o diretório axonserver não existe
if [ ! -d "./axonserver" ]; then
  mkdir ./axonserver
fi

# verifica se o diretório axonserver/config não existe
if [ ! -d "./axonserver/config" ]; then
  mkdir -p ./axonserver/config
fi

# verifica se o diretório axonserver/data não existe
if [ ! -d "./axonserver/data" ]; then
  mkdir -p ./axonserver/data
fi

# verifica se o diretório axonserver/events não existe
if [ ! -d "./axonserver/events" ]; then
  mkdir -p ./axonserver/events
fi

# atualiza o arquivo de configuração do axon server
cp -Rf ./axonserver.yml ./axonserver/config/

echo "Checagem finalizada!!!"
