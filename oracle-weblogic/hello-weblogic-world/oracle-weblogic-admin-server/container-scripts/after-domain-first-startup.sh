#!/bin/bash
# ******************************************************************************
#  This bash script is executed once, after the startup of the WebLogic
#  Domain. While this script is executing, the admin server and the managed
#  servers are up and running.
#
#  Commands with WLST online-mode or database operations can be executed by
#  this script.
#
#  Be warned that the commands added to this file will be executed only once,
#  after the first server startup.
#
#  Execution order of the bash scripts:
#     1) before-server-first-startup.sh
#     2) before-server-startup.sh
#     3) after-server-first-startup.sh
#     4) after-server-startup.sh
#     5) after-domain-first-startup.sh
#     6) after-domain-startup.sh
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showContext {
    echo "executing the ${BASH_SOURCE[0]} script with"
    echo "   admin server host:     $ADMIN_SERVER_HOST"
    echo "   admin server port:     $ADMIN_SERVER_PORT"
    echo "   admin server user:     $ADMIN_SERVER_USER"
    echo "   admin server password: $ADMIN_SERVER_PASSWORD"
    echo "   domain name:           $DOMAIN_NAME"
    echo "   cluster name:          $CLUSTER_NAME"
    echo "   oracle home:           $ORACLE_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
source "$ORACLE_HOME/common-utils.sh"
PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
ADMIN_SERVER_USER=$(getValue $PROPERTIES_FILE "username")
ADMIN_SERVER_PASSWORD=$(getValue $PROPERTIES_FILE "password")
ADMIN_SERVER_HOST=localhost

showContext
"$ORACLE_HOME/deploy-fips-checker.sh"
"$ORACLE_HOME/deploy-hello-weblogic-world.sh"
