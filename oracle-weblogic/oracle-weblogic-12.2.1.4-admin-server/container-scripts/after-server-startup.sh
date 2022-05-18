#!/bin/bash
# ******************************************************************************
#  This bash script is executed after each startup of the WebLogic admin
#  server. While this script is executing the admin server is up and running.
#  But if the 'wait-for-database-server.sh' option is used then the database
#  server will operate as well.
#
#  Commands with WLST online-mode or database operations can be executed by
#  this script.
#
#  Be warned that the commands added to this file will be executed
#  repetitively after each server startup.
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
    echo "   oracle home: $ORACLE_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showContext

# your code starts here
