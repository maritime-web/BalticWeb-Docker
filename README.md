# BalticWeb Docker
A dockerized container for the BalticWeb project. The container deploys the latest successful build of BalticWeb on a Wildfly 8.2.0 web server. It also has the required CouchDB and MySQL as described in the [BalticWeb](https://github.com/maritime-web/BalticWeb#balticweb) guide. 

## Prerequisties
* Docker 1.10.0+
* Docker Compose 1.6.0+
* A file called balticweb.properties
* Two configuration files for Keycloak as described in [BalticWeb](https://github.com/maritime-web/BalticWeb#configure-keycloak)

## Initial Setup
Clone the repository to a choosen directory using

    $ git clone https://github.com/maritime-web/BalticWeb-Docker.git

In your home directory you need to make two new directories - 'balticweb/properties' and 'balticweb/couchdb'. The latter needs to have the subdirectory 'couchdb/etc/local.d'.
In the 'balticweb/properties' directory you should put the 'balticweb.properties' file, and in 'balticweb/couchdb/etc/local.d' you should put the configuration files you wish to use for the CouchDB.

It is recommended to also put the configuration files for Keycloak in the 'balticweb/properties' directory. In 'balticweb.properties' you should then override the default configuration with the following:

	enav-service.keycloak.service-client.configuration.url=file:///opt/jboss/wildfly balticweb_properties/<path_to_first_file>/<your_first_file>.json
	enav-service.keycloak.web-client.configuration.url=file:///opt/jboss/wildfly/balticweb_properties/<path_to_second_file>/<your_second_file>.json


If you want to build the BalticWeb container yourself, but you only need to do this if you have a specific reason to do it 

    $ docker build -t dmadk/balticweb .

To start the balticweb container and the two databases execute the following command
    
    $ docker-compose up

On subsequent startups you can start with either

    $ docker-compose up

Or

    $ docker-compose start
