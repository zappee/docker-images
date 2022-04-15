#!/bin/bash
# ******************************************************************************
# ** This bash script is executed after each startup of the WebLogic
# ** Domain. While this script is executing, the admin server and the managed
# ** servers are up and running.
# **
# ** Commands with WLST online-mode or database operations can be executed by
# ** this script.
# **
# ** Execution order of the bash scripts:
# **    1) before-server-first-startup.sh
# **    2) before-server-startup.sh
# **    3) after-server-first-startup.sh
# **    4) after-server-startup.sh
# **    5) after-domain-first-startup.sh
# **    6) after-domain-startup.sh
# **
# ** Since : April, 2022
# ** Author: Arnold Somogyi <arnold.somogyi@gmail.com>
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
