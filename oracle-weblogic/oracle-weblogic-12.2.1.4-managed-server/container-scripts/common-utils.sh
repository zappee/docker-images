#!/bin/bash
# ******************************************************************************
#  This bash script contains common functions that can be called from another
#  bash scripts.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# creates a new database schema
# ------------------------------------------------------------------------------
function createDbSchema {
    local user password
    user="$1"
    password="$2"
    echo "creating database schema for $user with"
    echo "    DB_HOST        : $DB_HOST"
    echo "    DB_PORT        : $DB_PORT"
    echo "    DB_NAME        : $DB_NAME"
    echo "    DB_USER        : $DB_USER"
    echo "    DB_PASSWORD    : $DB_PASSWORD"
    echo "    schema user    : $user"
    echo "    schema password: $password"

    local sqlTool
    sqlTool="$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar"
    java -jar "$sqlTool" \
              -U "$DB_USER" \
              -P "$DB_PASSWORD" \
              -j jdbc:oracle:thin:@"$DB_HOST":"$DB_PORT"/"$DB_NAME" \
              -s "CREATE USER $user IDENTIFIED BY \"$password\" DEFAULT TABLESPACE USERS; \
                  GRANT CONNECT, RESOURCE, QUERY REWRITE, CREATE SYNONYM, CREATE VIEW, CREATE MATERIALIZED VIEW, CREATE JOB, CREATE ANY TRIGGER TO $user; \
                  GRANT UNLIMITED TABLESPACE TO $user; \
                  GRANT CREATE SESSION TO $user; \
                  GRANT ALL PRIVILEGES TO $user; \
                  COMMIT;"
}

# ------------------------------------------------------------------------------
# SQL statement executor
# ------------------------------------------------------------------------------
function sqlCommandExecutor {
    local user password sql tool
    user="$1"
    password="$2"
    sql="$3"
    tool="$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar"

    echo "executing SQL command(s) with"
    echo "    DB_HOST        : $DB_HOST"
    echo "    DB_PORT        : $DB_PORT"
    echo "    DB_NAME        : $DB_NAME"
    echo "    DB_USER        : $DB_USER"
    echo "    DB_PASSWORD    : $DB_PASSWORD"
    echo "    schema user    : $user"
    echo "    schema password: $password"
    echo "    SQL            : $sql"

    java -jar "$tool" \
                -U "$user" \
                -P "$password" \
                -j jdbc:oracle:thin:@"$DB_HOST":"$DB_PORT"/"$DB_NAME" \
                -s "$sql"
}


# ------------------------------------------------------------------------------
# SQL Script file executor
# ------------------------------------------------------------------------------
function sqlScriptFileExecutor {
    local user password file tool
    user="$1"
    password="$2"
    file="$3"
    tool="$ORACLE_HOME/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar"

    echo "executing an SQL script file with"
    echo "    DB_HOST        : $DB_HOST"
    echo "    DB_PORT        : $DB_PORT"
    echo "    DB_NAME        : $DB_NAME"
    echo "    DB_USER        : $DB_USER"
    echo "    DB_PASSWORD    : $DB_PASSWORD"
    echo "    schema user    : $user"
    echo "    schema password: $password"
    echo "    SQL script file: $file"

    java -jar "$tool" \
                -U "$user" \
                -P "$password" \
                -j jdbc:oracle:thin:@"$DB_HOST":"$DB_PORT"/"$DB_NAME" \
                -f "$file"
}

# ------------------------------------------------------------------------------
# executes a liquibase
# ------------------------------------------------------------------------------
function executeLiquibase {
    local liquibaseHome
    liquibaseHome="$1"

    echo "executing liquibase from $liquibaseHome directory..."
    cd "$liquibaseHome"  || { echo "Error while trying to change directory from $(pwd) to $liquibaseHome"; exit 1; }
    mvn liquibase:update
}

# ------------------------------------------------------------------------------
# deploy the given WAR or EAR to WebLogic as an application
#
# arguments:
#    param 1: admin server host
#    param 2: path to the artifact
#    param 3: path to the plan.xml file (optional)
# ------------------------------------------------------------------------------
function deployApplication() {
    local adminServerHost artifact adminServerUrl deploymentPlan
    adminServerHost="$1"
    artifact="$2"
    deploymentPlan=$3

    adminServerUrl="t3://$adminServerHost:$ADMIN_SERVER_PORT"

    echo
    echo "deploying $artifact artifact to $adminServerUrl as an application..."
    echo "   admin URL:       $adminServerUrl"
    echo "   user:            $ADMIN_SERVER_USER"
    echo "   password:        $ADMIN_SERVER_PASSWORD"
    echo "   cluster name:    $CLUSTER_NAME"
    echo "   artifact:        $artifact"
    echo "   deployment plan: $deploymentPlan"

    source "$ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh"
    if [ -z "$deploymentPlan" ]; then
        echo "deploying without plan.xml..."
        java weblogic.Deployer \
            -verbose \
            -adminurl "$adminServerUrl" \
            -username "$ADMIN_SERVER_USER" \
            -password "$ADMIN_SERVER_PASSWORD" \
            -usenonexclusivelock \
            -targets "$CLUSTER_NAME" \
            -deploy "$artifact"
    else
        echo "deploying with plan.xml..."
        java weblogic.Deployer \
            -verbose \
            -adminurl "$adminServerUrl" \
            -username "$ADMIN_SERVER_USER" \
            -password "$ADMIN_SERVER_PASSWORD" \
            -usenonexclusivelock \
            -targets "$CLUSTER_NAME" \
            -deploy "$artifact" \
            -plan "$deploymentPlan"
   fi

    local returnValue=$?
    if [ $returnValue -ne 0 ]; then
        echo "ERROR: the deployment of the $artifact has been failed, return code: $returnValue."
        exit 1
    fi
    echo "$artifact has been deployed successfully"
}

# ------------------------------------------------------------------------------
# deploy the given WAR or JAR to WebLogic as a library
# ------------------------------------------------------------------------------
function deployLibrary() {
    local adminServerHost artifact adminServerUrl
    adminServerHost="$1"
    artifact="$2"
    adminServerUrl="t3://$adminServerHost:$ADMIN_SERVER_PORT"

    echo
    echo "deploying '$artifact' artifact to '$adminServerUrl' as a library..."
    echo "   admin URL:    $adminServerUrl"
    echo "   user:         $ADMIN_SERVER_USER"
    echo "   password:     $ADMIN_SERVER_PASSWORD"
    echo "   cluster name: $CLUSTER_NAME"
    echo "   artifact:     $artifact"

    source "$ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh"
    java weblogic.Deployer -verbose \
                           -adminurl "$adminServerUrl" \
                           -username "$ADMIN_SERVER_USER" \
                           -password "$ADMIN_SERVER_PASSWORD" \
                           -usenonexclusivelock \
                           -targets "$CLUSTER_NAME" \
                           -library \
                           -deploy "$artifact"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
        echo "ERROR: the deployment of the $artifact has been failed, return code: $returnValue."
        exit 1
    fi
    echo "$artifact has been deployed successfully as a library"
}

# ------------------------------------------------------------------------------
# read value from property file
# ------------------------------------------------------------------------------
function getValue() {
    local propertiesFile key value
    propertiesFile=$1
    key=$2
    value=$(awk '{print $1}' "$propertiesFile" | grep "$key" | cut -d "=" -f2)
    echo "$value"
}

# ------------------------------------------------------------------------------
# restart all the managed servers in the domain
#
# usage:
#    $1: path to the 'boot.properties' file
# ------------------------------------------------------------------------------
function restartManagedServers() {
    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$1"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")

    local adminServerHost
    adminServerHost="$HOSTNAME"

    echo
    echo "*************************************************************************"
    echo "**  restarting all the managed servers..."
    echo "**     boot.properties:   $propertiesFile"
    echo "**     admin server host: $adminServerHost"
    echo "**     admin server port: $ADMIN_SERVER_PORT"
    echo "**     user:              $adminServerUsername"
    echo "**     password:          $adminServerPassword"
    echo "*************************************************************************"

    wlst.sh \
        -skipWLSModuleScanning \
        "$ORACLE_HOME/restart-managed-servers.py" \
            "$ADMIN_SERVER_NAME" \
            "$adminServerHost" \
            "$ADMIN_SERVER_PORT" \
            "$adminServerUsername" \
            "$adminServerPassword"
}

# ------------------------------------------------------------------------------
# restart the admin server
# it can be run only from the admin server host machine
# ------------------------------------------------------------------------------
function restartAdminServer() {
    local adminServerHost adminServerPort adminServerName domainName domainHome adminServerUrl
    adminServerHost="$1"
    adminServerPort="$2"
    adminServerName="$3"
    domainName="$4"
    domainHome="$ORACLE_HOME/user_projects/domains/$domainName"
    adminServerUrl="t3://$adminServerHost:$adminServerPort"

    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$5"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")

    echo
    echo "*************************************************************************"
    echo "**  stopping the admin server..."
    echo "**     user:              $adminServerUsername"
    echo "**     password:          $adminServerPassword"
    echo "**     admin server url:  $adminServerUrl"
    echo "**     domain home:       $domainHome"
    echo "*************************************************************************"
    "$domainHome/bin/stopWebLogic.sh" "$adminServerUsername" "$adminServerPassword" "$adminServerUrl"

    echo
    echo "*************************************************************************"
    echo "**  starting the admin server..."
    echo "**     domain name:       $domainName"
    echo "**     admin server name: $adminServerName"
    echo "**     admin server host: $adminServerHost"
    echo "**     admin server port: $adminServerPort"
    echo "**     boot.properties:   $propertiesFile"
    echo "*************************************************************************"
    local logHome
    logHome="$ORACLE_HOME/user_projects/domains/$domainName/servers/$adminServerName/logs"
    "$ORACLE_HOME/user_projects/domains/$domainName/bin/startWebLogic.sh" > "$logHome/$adminServerName.out" 2>&1 &
    waitForAdminServer "$adminServerHost" "$adminServerPort" "$adminServerName" "$propertiesFile"
}

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
function waitForAdminServer() {
    local adminServerHost adminServerPort adminServerName
    adminServerHost="$1"
    adminServerPort="$2"
    adminServerName="$3"

    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$4"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")

    echo "checking whether the $adminServerName is up and running..."
    echo "$adminServerName is not running yet, waiting..."

    local command
    command="wget --timeout=1 --tries=1 -qO- --user $adminServerUsername --password $adminServerPassword http://$adminServerHost:$adminServerPort/management/tenant-monitoring/servers/$adminServerName"
    while [[ $($command) != *"RUNNING"* ]]; do
        sleep 2
    done
    echo "$adminServerName is up and running"
}
