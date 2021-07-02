# ******************************************************************************
#  Oracle WebLogic Server 12.2.1.4.0 Managed Server Dockerfile.
#
#  Since : February, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM docker/images/oracle-weblogic-12.2.1.4:1.0.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

# common environment variables with default values required for this build
# values can be overwtitten from the docker-compose.yml file
ENV ADMIN_SERVER_NAME=ADMIN_SERVER
ENV ADMIN_SERVER_HOST=weblogic-admin-server
ENV ADMIN_SERVER_PORT=7001
ENV CLUSTER_NAME=DEV_CLUSTER
ENV DOMAIN_NAME=DEV_DOMAIN
ENV MANAGED_SERVER_NAME=MANAGED_SERVER
ENV MANAGED_SERVER_PORT=8001
ENV ORACLE_HOME=/home/oracle
ENV PRODUCTION_MODE=true
ENV NODE_MANAGER_PORT=5556

# JVM specific variables
ENV MANAGED_SERVER_JAVA_OPTIONS="-Dweblogic.rjvm.enableprotocolswitch=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4001 -XX:+UnlockCommercialFeatures -XX:+ResourceManagement -Djava.security.properties==$JAVA_HOME/jre/lib/security/java.security -Dweblogic.security.allowCryptoJDefaultJCEVerification=true"
ENV CLASSPATH=$CLASSPATH:$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/app-config:$ORACLE_HOME/wlserver/server/lib/jcmFIPS.jar:$ORACLE_HOME/wlserver/server/lib/sslj.jar

# copy WebLogic configuration files
COPY --chown=oracle:oracle properties/boot.properties $ORACLE_HOME/properties/
COPY --chown=oracle:oracle container-scripts/*.* $ORACLE_HOME/

# copy FIPS files
COPY --chown=oracle:oracle bin/fips/*.jar $JAVA_HOME/jre/lib/security/
COPY --chown=oracle:oracle bin/fips/java.security $JAVA_HOME/jre/lib/security/java.security

# default command, which can be executed when docker container runs
USER oracle:oracle
CMD $ORACLE_HOME/startup.sh
