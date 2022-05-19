#!/bin/bash
# ******************************************************************************
#  This bash script is executed before each startup of the WebLogic admin
#  server. While this script is executing the admin server is not up and
#  running. But if the 'wait-for-database-server.sh' option is used then the
#  database server will operate.
#
#  Commands with WLST offline-mode commands or database operations can be
#  executed by this script.
#
#  Be warned that the commands added to this file will be executed
#  repetitively before each server startup.
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
function showVariables {
    echo
    echo "executing the ${BASH_SOURCE[0]} script with"
    echo "   oracle home: $ORACLE_HOME"
    echo "   splunk home: $SPLUNK_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables

echo "starting splunk..."
"$SPLUNK_HOME/bin/splunk" start
