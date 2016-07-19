#!/bin/sh
echo "┌┬┐┌─┐┌┐┌┬┌─┐┬ ┬  ┌┬┐┌─┐┬─┐┬┌┬┐┬┌┬┐┌─┐  ┌─┐┬ ┬┌┬┐┬ ┬┌─┐┬─┐┬┌┬┐┬ ┬";
echo " ││├─┤││││└─┐├─┤  │││├─┤├┬┘│ │ ││││├┤   ├─┤│ │ │ ├─┤│ │├┬┘│ │ └┬┘";
echo "─┴┘┴ ┴┘└┘┴└─┘┴ ┴  ┴ ┴┴ ┴┴└─┴ ┴ ┴┴ ┴└─┘  ┴ ┴└─┘ ┴ ┴ ┴└─┘┴└─┴ ┴  ┴ ";
#script to create and deploy all containers needed for deployment of balticweb

#pull images and create network and containers
full () {
    #pull the latest images
    echo "Pulling latest images"
    docker pull dmadk/balticweb
    docker pull dmadk/embryo-couchdb
    docker pull mysql
   # docker pull centurylink/watchtower

    #create a network called baltic
    echo "Creating network"
    docker network create baltic

    #create the containers and link them
    echo "Creating containers"
     # --log-opt fluentd-async-connect=true
    docker create --name db --net=baltic --log-driver=fluentd --restart=unless-stopped -v $HOME/balticweb/mysql/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=embryo -e MYSQL_PASSWORD=embryo -e MYSQL_DATABASE=embryo -p 3306:3306 mysql

    docker create --name couch --net=baltic --log-driver=fluentd --restart=unless-stopped -v $HOME/balticweb/couchdb:/data  -p 5984:5984 dmadk/embryo-couchdb

    docker create --name balticweb --net=baltic --log-driver=fluentd --restart=unless-stopped -p 8080:8080 -p 9990:9990 -v $HOME/balticweb/properties:/opt/jboss/wildfly/balticweb_properties dmadk/balticweb

    #docker create --name watchtower --log-driver=fluentd --log-opt fluentd-async-connect=true --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock centurylink/watchtower balticweb --cleanup
}

$1

# start logging
echo "Starting logging"
docker-compose -f logging/docker-compose.yml up -d

# start all containers
echo "Starting containers"
docker start db couch balticweb

# the web administrative DOCKER UI     
#docker rm mgmt-Docker-UI              
docker run --name mgmt-Docker-UI -d -p 9999:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker

# Cadvisor monitor and 
docker run   --volume=/:/rootfs:ro   --volume=/var/run:/var/run:rw   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --publish=9998:8080   --detach=true   --name=mgmt-cadvisor  google/cadvisor:latest


echo "# watchtower - disabled";
echo "# the web application (WILDFLY)                     http://localhost:8080";
echo "# the web administrative application (WILDFLY)      http://localhost:9990";
echo "# the web administrative DOCKER UI                  http://localhost:9999";
echo "# Cadvisor                                          http://localhost:9998";

echo "# Couch DB                                          http://localhost:5984/_utils/index.html";
echo "# MYSQL localhost:3306 use desktop client like mysql workbench";
echo "# Logging user interface Kibana                     http://localhost:5601/app/kibana#/";
echo "# fluentd https://github.com/fluent/fluentd Fluentd: Open-Source Log Collector";

exit 0
