#!/bin/bash
# ******************************************************************************
# This startup script is executed automatically by Docker when a container
# starts.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showVariables {
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   admin server name: $ADMIN_SERVER_NAME"
    echo "   admin server port: $ADMIN_SERVER_PORT"
    echo "   cluster name:      $CLUSTER_NAME"
    echo "   oracle home:       $ORACLE_HOME"
    echo "   production mode:   $PRODUCTION_MODE"
    echo
}

# ------------------------------------------------------------------------------
# create an admin server
# ------------------------------------------------------------------------------
function createAdminServer {
    echo "creating a new WebLogic admin server..."
    local _PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
    wlst.sh -skipWLSModuleScanning -loadProperties $_PROPERTIES_FILE $ORACLE_HOME/create-admin-server.py $ORACLE_HOME $ADMIN_SERVER_NAME $ADMIN_SERVER_PORT $DOMAIN_NAME $CLUSTER_NAME $PRODUCTION_MODE
    local _RETURN_VALUE=$?
    if [ $_RETURN_VALUE -ne 0 ]; then
        echo "Admin server creation failed. Return code: $_RETURN_VALUE."
        exit 1
    fi
    mv -f $ORACLE_HOME/startWebLogic.sh $ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/
}

# ------------------------------------------------------------------------------
# checks whether the marker file exists and creates a new weblogic domain if it
# is still does not exist
# ------------------------------------------------------------------------------
function checkAndExecute() {
    local _MARKER_FILE=$ORACLE_HOME/.server-created

    # if this is the first run then the manage server will be created
    if [ -f "$_MARKER_FILE" ]; then
        echo "admin server has been already updated"
        echo "the '$ORACLE_HOME/before-first-startup.sh' file was executed before, skipping it..."
    else
        createAdminServer
        $ORACLE_HOME/execute-before-first-startup.sh
        touch $_MARKER_FILE
    fi
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
showVariables
checkAndExecute
$ORACLE_HOME/execute-before-startup.sh
$ORACLE_HOME/execute-afters.sh &
echo "starting the admin server..."
$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/startWebLogic.sh
