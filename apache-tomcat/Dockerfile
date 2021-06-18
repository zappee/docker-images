# ******************************************************************************
#  Apache-Tomcat dockerfile.
#
#  Since : February, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM tomcat:10.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

# directories for sharing files between the host and docker container
RUN mkdir -p /home/tomcat/upload

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y telnet && \
    apt-get install -y mc

# set bash aliases
RUN echo 'alias ll="ls -all"' >> ~/.bashrc

RUN mv /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps && \
    rm -d /usr/local/tomcat/webapps.dist/

RUN  rm -f /usr/local/tomcat/conf/tomcat-users.xml && \
     rm -f /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY container-scripts/tomcat-users.xml /usr/local/tomcat/conf/
COPY container-scripts/context.xml /usr/local/tomcat/webapps/manager/META-INF/
COPY container-scripts/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/
