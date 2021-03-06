# ******************************************************************************
#  Oracle WebLogic Server 12.2.1.4.0 Administration Server Dockerfile.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM docker/remal/oracle-weblogic-12.2.1.4:2.0.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

# common environment variables with default values required for this build
# values can be overwtitten from the docker-compose.yml file
ENV ADMIN_SERVER_NAME=ADMIN_SERVER
ENV ADMIN_SERVER_PORT=7001
ENV CLUSTER_NAME=DEV_CLUSTER
ENV DOMAIN_NAME=DEV_DOMAIN
ENV ORACLE_HOME=/home/oracle
ENV PRODUCTION_MODE=true
ENV MANAGED_SERVER_PORT=8001
ENV NODE_MANAGER_PORT=5556
ENV READY_SIGNAL_PORT=1331

# JVM specific variables
ENV ADMIN_SERVER_JAVA_OPTIONS="-Dweblogic.rjvm.enableprotocolswitch=true -Dweblogic.data.canTransferAnyFile=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4001 -XX:+UnlockCommercialFeatures -XX:+ResourceManagement"
ENV JAVA_OPTIONS="-Djava.security.properties==$JAVA_HOME/jre/lib/security/java.security"
ENV PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_HOME/wlserver/common/bin

# copy WebLogic configuration files
COPY --chown=oracle:oracle properties/boot.properties $ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/
COPY --chown=oracle:oracle console-app/content.css $ORACLE_HOME/
COPY --chown=oracle:oracle container-scripts/* $ORACLE_HOME/

# app-cofig directory is added to the WebLogic classpath
RUN mkdir -p $ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/app-config

# extend JVM classpath
ENV CLASSPATH=$CLASSPATH:$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/app-config

# default command, which can be executed when docker container runs
USER oracle:oracle
CMD $ORACLE_HOME/startup.sh
