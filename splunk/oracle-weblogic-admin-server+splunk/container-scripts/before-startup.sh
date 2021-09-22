#!/bin/bash
# ******************************************************************************
# This is a lifecycle-bash script, executed BEFORE each startup of the WebLogic
# admin server.
#
# While this script is running, the admin server is still stopped. It is
# possible to block the execution of this script file and wait for the database
# server with the 'wait-for-database-server.sh' script.
#
# WLST offline-mode commands or database operations can be executed by this
# bash script.
#
# Be warned that the commands in this file will be executed repetitively before
# each server startup.
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
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   oracle home: $ORACLE_HOME"
    echo "   splunk home: $SPLUNK_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables

echo "starting splunk..."
$SPLUNK_HOME/bin/splunk start
