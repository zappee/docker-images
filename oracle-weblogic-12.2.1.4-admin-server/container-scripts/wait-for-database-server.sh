#!/bin/bash 
# ******************************************************************************
# This script returns only if the database server is up and running.
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
    echo "   SQL to be executed:    $SQL"
    echo "   database name:         $DB_NAME"
    echo "   database server host:  $DB_HOST"
    echo "   database server host:  $DB_PORT"
    echo "   database user:         $DB_USER"
    echo "   oracle home:           $ORACLE_HOME"
    echo "   password for the user: $DB_PASSWORD"
    echo "   verbose:               $VERBOSE"
    echo
}

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
waitForDatabaseServer() {
    echo "checking whether database server is up and running..."
    local _COMMAND='java -jar ${ORACLE_HOME}/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar -q -U "${DB_USER}" -P ${DB_PASSWORD} -j jdbc:oracle:thin:@${DB_HOST}:${DB_PORT}/${DB_NAME} -s "select 1 from dual"'
    echo "command: $_COMMAND"
    local _SHOW_MESSAGE=true

    eval "$_COMMAND"
    while [ $? -ne 0 ]
    do
        if [ $_SHOW_MESSAGE = "true" ]; then echo "the database server is not running yet, waiting..."; fi
        if [ "$VERBOSE" = "false" ]; then _SHOW_MESSAGE="false"; fi
        sleep 0.5
        eval $_COMMAND
    done
    echo "database server is up and running"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
VERBOSE=false
showVariables
waitForDatabaseServer
exec $ORACLE_HOME/startup.sh
