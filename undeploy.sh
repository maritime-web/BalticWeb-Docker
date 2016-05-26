#!/bin/sh

echo "Stopping containers"
docker stop balticweb db couch

echo "Removing containers"
docker rm balticweb db couch

docker network rm baltic
