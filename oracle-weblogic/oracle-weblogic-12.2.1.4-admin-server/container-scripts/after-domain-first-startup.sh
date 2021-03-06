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
    echo "   oracle home: $ORACLE_HOME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showContext

# your code starts here
