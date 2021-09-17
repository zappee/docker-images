#!/bin/bash 
# ******************************************************************************
# This script returns only if the admin server is up and running.
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
    echo "   admin server host:   $ADMIN_SERVER_HOST"
    echo "   admin server name:   $ADMIN_SERVER_NAME"
    echo "   admin server port:   $ADMIN_SERVER_PORT"
    echo "   oracle home:         $ORACLE_HOME"
    echo "   password:            $PASSWORD"
    echo "   user:                $USERNAME"
    echo "   verbose:             $VERBOSE"
    echo
}

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
waitForAdminServer() {
    echo "checking whether $ADMIN_SERVER_NAME is up and running..."
    local _COMMAND="wget --timeout=1 --tries=1 -qO- --user ${USERNAME} --password ${PASSWORD} http://${ADMIN_SERVER_HOST}:${ADMIN_SERVER_PORT}/management/tenant-monitoring/servers/${ADMIN_SERVER_NAME}"
    echo "command: $_COMMAND"
    local _JSON=$($_COMMAND)
    local _SHOW_MESSAGE=true

    while [[ ${_JSON} != *"RUNNING"* ]]
    do
        if [ $_SHOW_MESSAGE = "true" ]; then echo "$ADMIN_SERVER_NAME is not running yet, waiting..."; fi
        if [ "$VERBOSE" = "false" ]; then _SHOW_MESSAGE="false"; fi
        sleep 0.5
        _JSON=$($_COMMAND)
    done
    echo "$ADMIN_SERVER_NAME is up and running"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
source $ORACLE_HOME/common-utils.sh

PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
USERNAME=$(getValue $PROPERTIES_FILE "username")
PASSWORD=$(getValue $PROPERTIES_FILE "password")
ADMIN_SERVER_HOST=localhost
VERBOSE=false
showVariables
waitForAdminServer
