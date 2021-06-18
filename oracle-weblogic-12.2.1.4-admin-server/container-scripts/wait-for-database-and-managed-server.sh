#!/bin/bash 
# ******************************************************************************
# This script returns only if the database server and the WebLogic managed
# servers are up and running.
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
    echo "   number of managed server in weblogic cluster: $NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER"
    echo
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER=${1:-0}
showVariables
$ORACLE_HOME/wait-for-database-server.sh skip
$ORACLE_HOME/wait-for-managed-server.sh $NUMBER_OF_MANAGED_SERVERS_IN_CLUSTER
