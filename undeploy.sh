#!/bin/sh

#stop all containers
echo "Stopping containers"
docker stop balticweb db couch

#remove all containers
echo "Removing containers"
docker rm balticweb db couch

docker network rm baltic
