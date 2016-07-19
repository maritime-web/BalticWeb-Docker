#!/bin/bash

echo "Stopping containers"
docker stop balticweb db couch mgmt-cadvisor mgmt-Docker-UI

full ()
{
    echo "Removing containers"
    docker rm balticweb db couch mgmt-cadvisor mgmt-Docker-UI
    docker network rm baltic
    docker-compose -f logging/docker-compose.yml down
}

$1

exit 0
