# ******************************************************************************
#  Oracle WebLogic Server 12.2.1.4.0 Dockerfile.
#
#  Since : February, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM docker/remal/oracle-java-8:1.0.0
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

# common environment variables required for this build
ENV ORACLE_HOME=/home/oracle

ENV WL_HOME=${ORACLE_HOME}/wlserver \
    PATH=$PATH:${JAVA_HOME}/bin:${ORACLE_HOME}/oracle_common/common/bin:${ORACLE_HOME}/wlserver/common/bin \
    FMW_PKG=fmw_12.2.1.4.0_wls_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.4.0_wls.jar \
    RESPONSEFILE=responses.txt \
    INVENTORY_LOCATION_FILE=oraInst.loc

# create a new system user
RUN groupadd -r oracle -g 901 && \
    useradd -b /home -d $ORACLE_HOME -m -s /bin/bash -u 901 -r -g oracle oracle
USER oracle:oracle

# copy weblogic install files
RUN mkdir -p $ORACLE_HOME/temp
COPY --chown=oracle:oracle properties/domain.properties $ORACLE_HOME/properties/
COPY --chown=oracle:oracle bin/oracle/$FMW_PKG properties/$RESPONSEFILE properties/$INVENTORY_LOCATION_FILE $ORACLE_HOME/temp/

# copy tools
COPY --chown=oracle:oracle bin/sql-runner/*.* $ORACLE_HOME/bin/sql-runner/
COPY --chown=oracle:oracle bin/jms-message-sender/*.* $ORACLE_HOME/bin/jms-message-sender/
COPY --chown=oracle:oracle bin/oracle/ojdbc8.jar $ORACLE_HOME/bin/oracle/

# install weblogic server
RUN cd $ORACLE_HOME/temp/ && \
    $JAVA_HOME/bin/jar xf $FMW_PKG && \
    $JAVA_HOME/bin/java -jar $FMW_JAR -silent -responseFile $ORACLE_HOME/temp/$RESPONSEFILE -invPtrLoc $ORACLE_HOME/temp/$INVENTORY_LOCATION_FILE -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
    rm -r $ORACLE_HOME/temp/

# install the Oracle JDBC Driver to the locale Maven repository
RUN mvn install:install-file -Dfile=$ORACLE_HOME/bin/oracle/ojdbc8.jar \
                             -DgroupId=com.oracle.jdbc \
                             -DartifactId=ojdbc8 \
                             -Dversion=12.2.0.1 \
                             -Dpackaging=jar

WORKDIR $ORACLE_HOME
