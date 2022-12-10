#!/bin/bash

docker-compose --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    docker_compose="docker-compose"
fi

docker compose version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    docker_compose="docker compose"
fi

if [ -z ${docker_compose+x} ]; then
    echo "Failed to find command for docker compose. Neither \"docker-compose\" nor \"docker compose\" ran successfully" >&2
fi