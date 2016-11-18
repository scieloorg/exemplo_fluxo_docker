# Exemplo Fluxo Docker
Repositório destinado a exemplificar integração e entrega continua utilizando Docker.

[![Build Status](https://travis-ci.org/scieloorg/exemplo_fluxo_docker.svg?branch=master)](https://travis-ci.org/scieloorg/exemplo_fluxo_docker)

# Linha de comando para iniciar os containers:

## Iniciando o mongo:

```shell
docker run \
    --name=exemplo_mongo \
    -p 27017:27017 -v $(pwd)/data_mongo:/data/db \
    --privileged=true -d mongo
```


## Iniciando a aplicação exemplo:

```shell
docker run \
    --name exemplo_docker --restart always \
    -p 8000:8000 -v $(pwd):/app \
    --link exemplo_mongo \
    -e MONGODB_HOST=exemplo_mongo \
    -e MONGODB_NAME=exemplo_db_dev \
    -e DEBUG_MODE=True \
    -e SECRET_KEY=example \
    -d scieloorg/exemplo_fluxo_docker
```

OBS.: É necessário que o mongo seja iniciado antes da aplicação.

## Equipe responsável por instalação, desenvolvimento e manutenção


Jamil Atta Junior (Desenvolvimento) <jamil.atta@scielo.org> 

Juan Funez (Desenvolvimento) <juan.funez@scielo.org>

Rondineli Gama Saad (Infraestrutura) <rondineli.saad@gmail.com>
