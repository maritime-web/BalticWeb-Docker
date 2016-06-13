#!/bin/bash

echo "Stopping containers"
docker stop balticweb db couch watchtower nginx

full ()
{
    echo "Removing containers"
    docker rm balticweb db couch watchtower nginx
    docker-compose -f logging/docker-compose.yml down
    docker network rm baltic
}

$1

exit 0
