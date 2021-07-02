#!/bin/bash
# ******************************************************************************
# This is a lifecycle-bash script, executed once, AFTER the first startup of
# the WebLogic admin server.
#
# While this script is running, the admin server is up and running. It is
# possible to block the execution of this script file and wait for the database
# server with the 'wait-for-database-server.sh' script.
#
# The execution of the 'after-*.sh' scripts can be blocked and wait for the
# managed servers using the 'wait-for-managed-server.sh' script.
#
# WLST online-mode commands or database operations can be executed by this
# bash script.
#
# Be warned that the commands in this file will be executed only once after
# the first server startup.
#
# Execution order of the lifecycle bash scripts:
#     1) before-first-startup.sh
#     2) before-startup.sh
#     3) after-first-startup.sh
#     4) after-startup.sh
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
    echo "variables for $BASH_SOURCE:"
    echo "   WebLogic admin server host:     $ADMIN_SERVER_HOST"
    echo "   WebLogic admin server port:     $ADMIN_SERVER_PORT"
    echo "   WebLogic admin server user:     $ADMIN_SERVER_USER"
    echo "   WebLogic admin server password: $ADMIN_SERVER_PASSWORD"
    echo "   WebLogic domain name:           $DOMAIN_NAME"
    echo "   WebLogic cluster name:          $CLUSTER_NAME"
    echo "   oracle home:                    $ORACLE_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
source ./common-utils.sh
PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
ADMIN_SERVER_USER=$(getValue $PROPERTIES_FILE "username")
ADMIN_SERVER_PASSWORD=$(getValue $PROPERTIES_FILE "password")
ADMIN_SERVER_HOST=localhost

showVariables
$ORACLE_HOME/deploy-fips-checker.sh
