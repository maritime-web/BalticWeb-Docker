#!/bin/sh

#script to create and deploy all containers needed for deployment of balticweb

#pull images and create network and containers
full () {
    #pull the latest images
    echo "Pulling latest images"
    docker pull dmadk/balticweb
    docker pull dmadk/embryo-couchdb
    docker pull mysql
    docker pull centurylink/watchtower
    docker pull nginx:stable

    #create a network called baltic
    echo "Creating network"
    docker network create baltic

    #create the containers and link them
    echo "Creating containers"
    docker create --name db --net=baltic --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/balticweb/mysql/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo mysql

    docker create --name couch --net=baltic --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/balticweb/couchdb:/data dmadk/embryo-couchdb

    docker create --name balticweb --net=baltic --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/balticweb/properties:/opt/jboss/wildfly/balticweb_properties dmadk/balticweb

    docker create --name watchtower --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock centurylink/watchtower balticweb --cleanup

    docker create --name nginx --net=baltic --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v $HOME/nginx/conf.d:/etc/nginx/conf.d -p 443:443 -p 80:80 nginx:stable
}

$1

# start the EFK stack for logging
echo "Starting logging"
docker-compose -f logging/docker-compose.yml up -d

# start all containers
echo "Starting containers"
docker start db couch balticweb watchtower nginx

exit 0
