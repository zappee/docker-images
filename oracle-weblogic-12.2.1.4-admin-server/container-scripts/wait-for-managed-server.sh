#!/bin/bash 
# ******************************************************************************
# This script blocks the execution and waits for the managed servers to be up
# and running. Then the execution continues.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showVariables {
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   admin server port:                            $ADMIN_SERVER_PORT"
    echo "   user:                                         $USERNAME"
    echo "   password:                                     $PASSWORD"
    echo "   number of managed server in weblogic cluster: $NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER"
    echo
}

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
waitForManagedServer() {
    local _COMMAND='curl -s -u $USERNAME:$PASSWORD http://localhost:$ADMIN_SERVER_PORT/management/tenant-monitoring/clusters -H "Accept: application/json" | grep -o "RUNNING" | wc -l'
    echo "command: $_COMMAND"
    eval _NUMBER_OF_HEALTHY_SERVERS=\$\($_COMMAND\)

    while (( $_NUMBER_OF_HEALTHY_SERVERS < $NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER )); do
        sleep 0.5
        eval _NUMBER_OF_HEALTHY_SERVERS=\$\($_COMMAND\)
    done
    echo "all the managed servers are up and ready ($_NUMBER_OF_HEALTHY_SERVERS servers)"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
source $ORACLE_HOME/common-utils.sh

NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER=${1:-0}
VERBOSE=false
PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
USERNAME=$(getValue $PROPERTIES_FILE "username")
PASSWORD=$(getValue $PROPERTIES_FILE "password")
showVariables
waitForManagedServer &
exec $ORACLE_HOME/startup.sh
