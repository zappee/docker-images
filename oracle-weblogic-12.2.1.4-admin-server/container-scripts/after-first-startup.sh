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
# Copyright (c) 2020 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showVariables {
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   oracle home: $ORACLE_HOME"
    echo
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables

# your code starts here
