# ******************************************************************************
#  Oracle WebLogic Server 12.2.1.4.0 Managed Server + Splunk dockerfile.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM docker/remal/oracle-weblogic-managed-12.2.1.4:2.1.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

ENV SPLUNK_HOME=/opt/splunkforwarder
ENV SPLUNK_USERNAME=admin
ENV SPLUNK_PASSWORD=password

ARG SPLUNK_INSTALL_FILE=splunkforwarder-8.2.1-ddff1c41e5cf-linux-2.6-x86_64.rpm
ARG SPLUNK_MANAGEMENT_URL=splunk:8089
ARG SPLUNK_FORWARDER_URL=splunk:9997

COPY --chown=oracle:oracle bin/splunk/$SPLUNK_INSTALL_FILE $ORACLE_HOME/bin/splunk/
COPY --chown=oracle:oracle container-scripts/* $ORACLE_HOME/

USER root:root
RUN set -eux; \
    echo "installing Splunk Universal Forwarder..."; \
    rpm -i $ORACLE_HOME/bin/splunk/$SPLUNK_INSTALL_FILE; \
    rm $ORACLE_HOME/bin/splunk/$SPLUNK_INSTALL_FILE; \
    \
    echo "configuring Splunk Universal Forwarder..."; \
    $SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --no-prompt --auto-ports --seed-passwd $SPLUNK_PASSWORD; \
    $SPLUNK_HOME/bin/splunk set deploy-poll "$SPLUNK_MANAGEMENT_URL" --accept-license --answer-yes --auto-ports --no-prompt -auth $SPLUNK_USERNAME:$SPLUNK_PASSWORD; \
    $SPLUNK_HOME/bin/splunk add forward-server $SPLUNK_FORWARDER_URL -auth $SPLUNK_USERNAME:$SPLUNK_PASSWORD; \
    \
    echo "setting up splunk software to run as a non-root user..."; \
    chown -R oracle:oracle $SPLUNK_HOME;

USER oracle:oracle
