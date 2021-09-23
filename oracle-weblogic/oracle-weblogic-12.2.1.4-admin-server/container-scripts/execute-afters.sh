#!/bin/bash
# ******************************************************************************
# This is a bash script executor. For more info please check the
# 'after-first-startup.sh' and 'after-startup.sh' scripts.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints information about a bash script
# ------------------------------------------------------------------------------
function showAfterFirstStartupInfo() {
    echo "-------------------------------------------------------------------------"
    echo "--                               step  3                               --"
    echo "--                            ADMIN-SERVER                             --"
    echo "--                         AFTER-FIRST-STARTUP                         --"
    echo "-------------------------------------------------------------------------"
}

# ------------------------------------------------------------------------------
# checks the precondition and if they are appropriate then executes the
# after-first-startup.sh script
# ------------------------------------------------------------------------------
function executeAfterFirstStartup() {
    local _MARKER_FILE=$ORACLE_HOME/.after-first-startup
    local _FILE_TO_EXECUTE=$ORACLE_HOME/after-first-startup.sh

    if [ -f "$_FILE_TO_EXECUTE" ]; then
        if [ -f "$_MARKER_FILE" ]; then
            echo "the '$_FILE_TO_EXECUTE' file was executed before, skipping it..."
        else
            showAfterFirstStartupInfo
            echo "executing the '$_FILE_TO_EXECUTE' file..."
            $_FILE_TO_EXECUTE
            touch $_MARKER_FILE
            echo "------------------ end of step 3:  AFTER-FIRST-STARTUP ------------------"
            echo
        fi
    else
        echo "the '$_FILE_TO_EXECUTE' file does not exist, skipping it..."
    fi
}

# ------------------------------------------------------------------------------
# prints information about a bash script
# ------------------------------------------------------------------------------
function showAfterStartupInfo() {
    echo "-------------------------------------------------------------------------"
    echo "--                               step  4                               --"
    echo "--                            ADMIN-SERVER                             --"
    echo "--                            AFTER-STARTUP                            --"
    echo "-------------------------------------------------------------------------"
}

# ------------------------------------------------------------------------------
# checks the precondition and if they are appropriate then executes the
# after-startup.sh script
# ------------------------------------------------------------------------------
function executeAfterStartup() {
    local _FILE_TO_EXECUTE=$ORACLE_HOME/after-startup.sh
    showAfterStartupInfo

    if [ -f "$_FILE_TO_EXECUTE" ]; then
        echo "executing the '$_FILE_TO_EXECUTE' file..."
        $_FILE_TO_EXECUTE
        echo "--------------------- end of step 4:  AFTER-STARTUP ---------------------"
        echo
    else
        echo "the '$_FILE_TO_EXECUTE' file does not exist, skipping it..."
    fi
    echo
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
$ORACLE_HOME/wait-for-admin-server.sh
executeAfterFirstStartup
executeAfterStartup
