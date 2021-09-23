#!/bin/bash
# ******************************************************************************
# This is a bash script executor. This shows information and then calls the
# 'before-first-startup.sh' script. For more info please check that script.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints information about this script
# ------------------------------------------------------------------------------
function showInfo() {
    echo "-------------------------------------------------------------------------"
    echo "--                               step  1                               --"
    echo "--                            ADMIN-SERVER                             --"
    echo "--                         BEFORE-FIRST-STARTUP                        --"
    echo "-------------------------------------------------------------------------"
}

# ------------------------------------------------------------------------------
# external bash script executor
# ------------------------------------------------------------------------------
function externalScriptExecutor() {
  local _MARKER_FILE=$ORACLE_HOME/.before-first-startup
  local _FILE_TO_EXECUTE=$ORACLE_HOME/before-first-startup.sh

  if [ -f "$_FILE_TO_EXECUTE" ]; then
      if [ -f "$_MARKER_FILE" ]; then
          echo "the '$_FILE_TO_EXECUTE' file was executed before, skipping it..."
      else
          echo "executing the '$_FILE_TO_EXECUTE' file..."
          $_FILE_TO_EXECUTE
          touch $_MARKER_FILE
          echo "------------------ end of step 1: BEFORE-FIRST-STARTUP ------------------"
          echo
      fi
  else
      echo "the '$_FILE_TO_EXECUTE' file does not exist, skipping it..."
  fi
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showInfo
$ORACLE_HOME/updateConsoleCookieName.sh
externalScriptExecutor
