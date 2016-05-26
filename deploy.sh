#!/bin/sh

docker pull dmadk/balticweb
docker pull dmadk/embryo-couchdb
docker pull mysql

docker network create --internal baltic 

docker run --name db -d --net=baltic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql

docker run --name couch -d --net=baltic -v $HOME/balticweb/couchdb:/data dmadk/embryo-couchdb

docker run --name balticweb --net=baltic --link db:db --link couch:couch -p 8080:8080 -v $HOME/balticweb/properties:/opt/jboss/wildfly/balticweb_properties dmadk/balticweb

docker network connect bridge balticweb
