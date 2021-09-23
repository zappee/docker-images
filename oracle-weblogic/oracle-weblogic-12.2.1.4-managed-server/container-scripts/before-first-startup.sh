#!/bin/bash
# ******************************************************************************
# This is a lifecycle-bash script, executed once, BEFORE the first startup of
# the WebLogic managed server.
#
# While this script is running, the managed server is not running yet. It is
# possible to block the execution of this script file and wait for the database
# server with the 'wait-for-database-server.sh' script.
#
# WLST offline-mode commands or database operations can be executed by this
# bash script.
#
# Be warned that the commands in this file will be executed only once before
# the first server startup.
#
# Execution order of the lifecycle bash scripts:
#     1) before-first-startup.sh
#     2) before-startup.sh
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
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables

# your code starts here
