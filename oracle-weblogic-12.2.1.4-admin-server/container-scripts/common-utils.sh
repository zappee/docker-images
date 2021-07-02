#!/bin/bash
# ******************************************************************************
# This bash script contains common functions that can be called from another
# bash scripts.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# creates a new database schema
# ------------------------------------------------------------------------------
function createDbSchema {
    local _USER=$1
    local _PASSWORD=$2
    echo "creating database schema for '$_USER'..."
    local _SQL_TOOL=$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar
    java -jar $_SQL_TOOL \
              -U "$DB_USER" \
              -P $DB_PASSWORD \
              -j jdbc:oracle:thin:@$DB_HOST:$DB_PORT/$DB_NAME \
              -s "CREATE USER $_USER IDENTIFIED BY $_PASSWORD DEFAULT TABLESPACE USERS; \
                  GRANT CONNECT, RESOURCE, QUERY REWRITE, CREATE SYNONYM, CREATE VIEW, CREATE MATERIALIZED VIEW, CREATE JOB, CREATE ANY TRIGGER TO $_USER; \
                  GRANT UNLIMITED TABLESPACE TO $_USER; \
                  GRANT CREATE SESSION TO $_USER; \
                  GRANT ALL PRIVILEGES TO $_USER; \
                  COMMIT;"
}

# ------------------------------------------------------------------------------
# SQL statement executor
# ------------------------------------------------------------------------------
function sqlCommandExecutor {
    echo "executing SQL statements..."
    local _SCHEMA_USER=$1
    local _SCHEMA_PASSWORD=$2
    local _SQL=$3
    local _SQL_TOOL=$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar

    echo "variables for sqlCommandExecutor():"
    echo "   schema user       : $_SCHEMA_USER"
    echo "   schema password   : $_SCHEMA_PASSWORD"
    echo "   sql to be executed: $_SQL"

    java -jar $_SQL_TOOL \
                -U "$_SCHEMA_USER" \
                -P $_SCHEMA_PASSWORD \
                -j jdbc:oracle:thin:@$DB_HOST:$DB_PORT/$DB_NAME \
                -s "$_SQL"
}


# ------------------------------------------------------------------------------
# SQL Script file executor
# ------------------------------------------------------------------------------
function sqlScriptFileExecutor {
    echo "executing an SQL script file..."
    local _SCHEMA_USER=$1
    local _SCHEMA_PASSWORD=$2
    local _SQL_SCRIPT_FILE=$3
    local _SQL_TOOL=$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar

    echo "variables for sqlCommandExecutor():"
    echo "   schema user    : $_SCHEMA_USER"
    echo "   schema password: $_SCHEMA_PASSWORD"
    echo "   sql script file: $_SQL_SCRIPT_FILE"

    java -jar $_SQL_TOOL \
                -U "$_SCHEMA_USER" \
                -P $_SCHEMA_PASSWORD \
                -j jdbc:oracle:thin:@$DB_HOST:$DB_PORT/$DB_NAME \
                -f "$_SQL_SCRIPT_FILE"
}

# ------------------------------------------------------------------------------
# executes a liquibase
# ------------------------------------------------------------------------------
function executeLiquibase {
    local _LIQUIBASE_HOME=$1
    echo "executing liquibase from '$_LIQUIBASE_HOME' directory..."
    cd $_LIQUIBASE_HOME
    mvn liquibase:update
}

# ------------------------------------------------------------------------------
# deploy the given WAR or EAR to WebLogic as an application
# ------------------------------------------------------------------------------
function deployApplication() {
    local _ARTIFACT=$1
    local _ADMIN_SERVER_URL="t3://localhost:$ADMIN_SERVER_PORT"
    echo
    echo "deploying '$_ARTIFACT' artifact to '$_ADMIN_SERVER_URL' as an application..."
    echo "   admin URL:    $_ADMIN_SERVER_URL"
    echo "   user:         $ADMIN_SERVER_USER"
    echo "   password:     $ADMIN_SERVER_PASSWORD"
    echo "   cluster name: $CLUSTER_NAME"
    echo "   artifact:     $_ARTIFACT"

    source $ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh
    java weblogic.Deployer -verbose \
                           -adminurl $_ADMIN_SERVER_URL \
                           -username $ADMIN_SERVER_USER \
                           -password $ADMIN_SERVER_PASSWORD \
                           -usenonexclusivelock \
                           -targets $CLUSTER_NAME \
                           -deploy $_ARTIFACT

    local _RETURN_VALUE=$?
    if [ $? -ne 0 ]; then
        echo "ERROR: deploy of the $5 artifact has been failed, return code: $_RETURN_VALUE."
        exit 1
    fi
    echo "'$_ARTIFACT' has been deployed successfully"
}

# ------------------------------------------------------------------------------
# deploy the given WAR or JAR to WebLogic as a library
# ------------------------------------------------------------------------------
function deployLibrary() {
    local _ARTIFACT=$1
    local _ADMIN_SERVER_URL="t3://localhost:$ADMIN_SERVER_PORT"
    echo
    echo "deploying '$_ARTIFACT' artifact to '$_ADMIN_SERVER_URL' as a library..."
    echo "   admin URL:    $_ADMIN_SERVER_URL"
    echo "   user:         $ADMIN_SERVER_USER"
    echo "   password:     $ADMIN_SERVER_PASSWORD"
    echo "   cluster name: $CLUSTER_NAME"
    echo "   artifact:     $_ARTIFACT"

    source $ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh
    java weblogic.Deployer -verbose \
                           -adminurl $_ADMIN_SERVER_URL \
                           -username $ADMIN_SERVER_USER \
                           -password $ADMIN_SERVER_PASSWORD \
                           -usenonexclusivelock \
                           -targets $CLUSTER_NAME \
                           -library \
                           -deploy $_ARTIFACT

    local _RETURN_VALUE=$?
    if [ $? -ne 0 ]; then
        echo "ERROR: deploy of the $5 artifact has been failed, return code: $_RETURN_VALUE."
        exit 1
    fi
    echo "'$_ARTIFACT' library has been deployed successfully"
}

# ------------------------------------------------------------------------------
# read value from property file
# ------------------------------------------------------------------------------
getValue() {
    local _PROPERTIES_FILE=$1
    local _KEY=$2
    local _VALUE=`awk '{print $1}' $_PROPERTIES_FILE | grep $_KEY | cut -d "=" -f2`
    echo "$_VALUE"
}
