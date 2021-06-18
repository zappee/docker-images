#!/bin/bash
# ******************************************************************************
# WLST script for updating the WebLogic console cookie name.
#
# Usage: updateConsoleCookieName.sh <ORACLE_HOME> <DOMAIN_NAME>
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
    echo "variables for $BASH_SOURCE:"
    echo "   oracle home: $ORACLE_HOME"
    echo "   domain name: $DOMAIN_NAME"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
function updateConsoleCookie() {
    local _MARKER_FILE=$ORACLE_HOME/.cookie-updated
    if [ -f "$_MARKER_FILE" ]; then
        echo "web console cookie name has been already updated"
    else
        wlst.sh -skipWLSModuleScanning $ORACLE_HOME/updateConsoleCookieName.py $ORACLE_HOME $DOMAIN_NAME
        touch $_MARKER_FILE
    fi
    echo
}
# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables
updateConsoleCookie
