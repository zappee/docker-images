# ******************************************************************************
#  Oracle WebLogic Administration Server Dockerfile.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM docker/remal/oracle-weblogic-admin-with-splunk:2.1.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

ENV ADMIN_SERVER_JAVA_OPTIONS="$ADMIN_SERVER_JAVA_OPTIONS"

USER oracle:oracle

COPY --chown=oracle:oracle bin/fips-checker/* $ORACLE_HOME/bin/fips-checker/
COPY --chown=oracle:oracle bin/hello-weblogic-world/* $ORACLE_HOME/bin/hello-weblogic-world/
COPY --chown=oracle:oracle container-scripts/*  $ORACLE_HOME/
COPY --chown=oracle:oracle liquibase $ORACLE_HOME/liquibase/

# calling the default CMD command defined in the previous image layer
