#!/bin/bash
# ******************************************************************************
# This is a bash script executor. This shows information and then calls the
# 'before-startup.sh' script. For more info please check that script.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints information about this script
# ------------------------------------------------------------------------------
function showInfo() {
    echo "-------------------------------------------------------------------------"
    echo "--                               step  2                               --"
    echo "--                           BEFORE-STARTUP                            --"
    echo "-------------------------------------------------------------------------"
}

# ------------------------------------------------------------------------------
# external bash script executor
# ------------------------------------------------------------------------------
function externalScriptExecutor() {
    local _FILE_TO_EXECUTE=$ORACLE_HOME/before-startup.sh
    if [ -f "$_FILE_TO_EXECUTE" ]; then
        echo "executing the '$_FILE_TO_EXECUTE' file..."
        $_FILE_TO_EXECUTE
        echo "--------------------- end of step 2: BEFORE-STARTUP ---------------------"
        echo
    else
        echo "the '$_FILE_TO_EXECUTE' file does not exist, skipping it..."
    fi
    echo
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showInfo
$ORACLE_HOME/updateAdminConsoleColor.sh
externalScriptExecutor
