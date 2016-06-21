#!/bin/bash

echo "Stopping containers"
docker stop balticweb db couch watchtower

full ()
{
    echo "Removing containers"
    docker rm balticweb db couch watchtower
    docker network rm baltic
    docker-compose -f logging/docker-compose.yml down
}

$1

exit 0
