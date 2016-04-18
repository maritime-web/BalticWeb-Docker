FROM jboss/wildfly:8.2.0.Final

# need root to install dependencies
USER root

# remove jdk 7 and install jdk 8
RUN yum remove -y java-1.7.0-openjdk-devel

RUN yum install -y java-1.8.0-openjdk-devel

RUN yum install -y epel-release

RUN yum install -y nodejs npm --enablerepo=epel

RUN npm install grunt

USER jboss

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

COPY standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml

COPY mysql-connector-java-5.1.38-bin.jar /opt/jboss/wildfly/modules/com/mysql/main/mysql-connector-java-5.1.38-bin.jar

COPY module.xml /opt/jboss/wildfly/modules/com/mysql/main/module.xml

RUN curl -o /opt/jboss/wildfly/standalone/deployments/baltic-web.war https://dma.ci.cloudbees.com/job/BalticWeb/lastSuccessfulBuild/dk.dma.enav.balticweb\$baltic-web/artifact/dk.dma.enav.balticweb/baltic-web/2.7-SNAPSHOT/baltic-web-2.7-SNAPSHOT.war

RUN ls -la /opt/jboss/wildfly/standalone/deployments

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
