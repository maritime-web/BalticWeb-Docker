#!/bin/sh

#script to create and deploy all containers needed for deployment of balticweb

#pull images and create network and containers
full () {
    #pull the latest images
    echo "Pulling latest images"
    docker pull dmadk/balticweb
    docker pull dmadk/embryo-couchdb
    docker pull mysql:5.7

    #create a network called baltic
    echo "Creating network"
    docker network create baltic

    #create the containers and link them
    echo "Creating containers"
    docker create --name db --net=baltic --restart=unless-stopped -v $HOME/balticweb/mysql/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql:5.7 

    docker create --name couch --net=baltic --restart=unless-stopped -v $HOME/balticweb/couchdb:/data dmadk/embryo-couchdb

    docker create --name balticweb --net=baltic --restart=unless-stopped -p 8080:8080 -v $HOME/balticweb/properties:/opt/jboss/wildfly/balticweb_properties dmadk/balticweb

}

$1

# start all containers
echo "Starting containers"
docker start db couch balticweb 

exit 0
