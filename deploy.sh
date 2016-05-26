#!/bin/sh

#script to create and deploy all containers needed for deployment of balticweb

#pull the latest images
docker pull dmadk/balticweb
docker pull dmadk/embryo-couchdb
docker pull mysql

#create an internal network called baltic
docker network create --internal baltic 

#create the containers and link them
docker create --name db --net=baltic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql

docker create --name couch --net=baltic -v $HOME/balticweb/couchdb:/data dmadk/embryo-couchdb

docker create --name balticweb --net=baltic --link db:db --link couch:couch -p 8080:8080 -v $HOME/balticweb/properties:/opt/jboss/wildfly/balticweb_properties dmadk/balticweb

#connect the balticweb container to the default docker bridge
docker network connect bridge balticweb

# start all containers
docker start db couch balticweb
