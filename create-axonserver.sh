#! /bin/sh

cd "$(dirname "$0")" || { echo "Mover de diretório falhou"; exit 127; }

echo "Checar estrutura de pastas e arquivos do Axon Server..."

# verifica se o diretório config não existe
if [ ! -d "./config" ]; then
  mkdir -p ./config
fi

# verifica se o diretório data não existe
if [ ! -d "./data" ]; then
  mkdir -p ./data
fi

# verifica se o diretório events não existe
if [ ! -d "./events" ]; then
  mkdir -p ./events
fi

# atualiza o arquivo de configuração do axon server
cp -Rf ./axonserver.yml ./config/

echo "Checagem finalizada!!!"

cd "$(pwd)" || { echo "Mover de diretório falhou"; exit 127; }
