#!/bin/bash 
# ******************************************************************************
# Creates a new managed server during the first run and calls WebLogic
# lifecycle bash script.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# shows all the input parameters
# ------------------------------------------------------------------------------
function showVariables {
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   admin server host:   $ADMIN_SERVER_HOST"
    echo "   admin server port:   $ADMIN_SERVER_PORT"
    echo "   domain name:         $DOMAIN_NAME"
    echo "   cluster name:        $CLUSTER_NAME"
    echo "   hostname:            $HOSTNAME"
    echo "   managed server home: $MANAGED_SERVER_HOME"
    echo "   managed server name: $MANAGED_SERVER_NAME"
    echo "   managed server port: $MANAGED_SERVER_PORT"
    echo "   node manager port:   $NODE_MANAGER_PORT"
    echo "   oracle home:         $ORACLE_HOME"
    echo "   password:            $PASSWORD"
    echo "   username:            $USERNAME"
    echo "   verbose:             $VERBOSE"
    echo
}

# ------------------------------------------------------------------------------
# create an admin server
# ------------------------------------------------------------------------------
function createAdminServer {
    echo "creating a new WebLogic admin server..."
    wlst.sh -skipWLSModuleScanning -loadProperties $PROPERTIES_FILE $ORACLE_HOME/create-admin-server.py $ORACLE_HOME $ADMIN_SERVER_NAME $ADMIN_SERVER_PORT $DOMAIN_NAME $CLUSTER_NAME $PRODUCTION_MODE $NODE_MANAGER_PORT
    local _RETURN_VALUE=$?
    if [ $_RETURN_VALUE -ne 0 ]; then
        echo "Admin server creation failed. Return code: $_RETURN_VALUE."
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# create a managed server via WLST
# ------------------------------------------------------------------------------
createManagedServer() {
    echo "creating a new managed server..."
    wlst.sh -skipWLSModuleScanning -loadProperties $PROPERTIES_FILE $ORACLE_HOME/create-managed-server.py $ADMIN_SERVER_HOST $ADMIN_SERVER_PORT $USERNAME $PASSWORD $MANAGED_SERVER_NAME $MANAGED_SERVER_PORT $CLUSTER_NAME
    local _RETURN_VALUE=$?
    if [ $_RETURN_VALUE -ne 0 ]; then
      echo "Managed server creation failed. Return code: $_RETURN_VALUE."
      exit 1
    fi

    mkdir -p ${MANAGED_SERVER_HOME}/security
    mv $ORACLE_HOME/startWebLogic.sh $ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/
}

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
function waitForManagedServer() {
    echo "checking whether $MANAGED_SERVER_NAME is up and running..."
    local _COMMAND="wget --timeout=1 --tries=1 -qO- --user ${USERNAME} --password ${PASSWORD} http://${ADMIN_SERVER_HOST}:${ADMIN_SERVER_PORT}/management/tenant-monitoring/servers/${MANAGED_SERVER_NAME}"
    echo "command: $_COMMAND"
    local _JSON=$($_COMMAND)
    local _SHOW_MESSAGE=true

    while [[ ${_JSON} != *"RUNNING"* ]]
    do
        if [ $_SHOW_MESSAGE = "true" ]; then echo "$MANAGED_SERVER_NAME is not running yet, waiting..."; fi
        if [ $VERBOSE = "false" ]; then _SHOW_MESSAGE="false"; fi
        sleep 0.5
        _JSON=$($_COMMAND)
    done
    echo "$MANAGED_SERVER_NAME is up and running"
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

# ------------------------------------------------------------------------------
# execute commands if this is the first run
# ------------------------------------------------------------------------------
function executeFirstRun() {
    local _MARKER_FILE=$ORACLE_HOME/.server-created
    if [ -f "$_MARKER_FILE" ]; then
        echo "managed server has been already created"
    else
        createAdminServer
        createManagedServer
        executeBeforeFirstStartup
        touch $_MARKER_FILE
    fi
}


# ------------------------------------------------------------------------------
# run the before-first-startup.sh script
# ------------------------------------------------------------------------------
function executeBeforeFirstStartup() {
    local _EXTERNAL_SCRIPT=$ORACLE_HOME/before-startup.sh
    if [ -f "$_EXTERNAL_SCRIPT" ]; then
        echo "-------------------------------------------------------------------------"
        echo "--                               step  1                               --"
        echo "--                           MANAGED-SERVER                            --"
        echo "--                        BEFORE-FIRST-STARTUP                         --"
        echo "-------------------------------------------------------------------------"
        $_EXTERNAL_SCRIPT
        echo "------------------ end of step 1: BEFORE-FIRST-STARTUP ------------------"
        echo
    fi
}

# ------------------------------------------------------------------------------
# run the before-startup.sh script
# ------------------------------------------------------------------------------
function executeBeforeStartup() {
    local _EXTERNAL_SCRIPT=$ORACLE_HOME/before-first-startup.sh
    if [ -f "$_EXTERNAL_SCRIPT" ]; then
        echo "-------------------------------------------------------------------------"
        echo "--                               step 2                                --"
        echo "--                           MANAGED-SERVER                            --"
        echo "--                           BEFORE-STARTUP                            --"
        echo "-------------------------------------------------------------------------"
        $_EXTERNAL_SCRIPT
        echo "--------------------- end of step 2: BEFORE-STARTUP ---------------------"
        echo
    fi
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
MANAGED_SERVER_HOME=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME
PROPERTIES_FILE=$ORACLE_HOME/properties/boot.properties
PASSWORD=$(getValue $PROPERTIES_FILE "password")
USERNAME=$(getValue $PROPERTIES_FILE "username")
VERBOSE=false

showVariables
executeFirstRun
executeBeforeStartup

echo "starting the $MANAGED_SERVER_NAME managed server..."
cp $PROPERTIES_FILE $MANAGED_SERVER_HOME/security/boot.properties
$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/startManagedWebLogic.sh $MANAGED_SERVER_NAME t3://$ADMIN_SERVER_HOST:$ADMIN_SERVER_PORT &

waitForManagedServer

echo "starting the node manager..."
$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/startNodeManager.sh
