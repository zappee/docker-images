#!/bin/bash 
# ******************************************************************************
# This script returns only if the database server is up and running.
#
# Since : April, 2022
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# waiting for server to startup
# ------------------------------------------------------------------------------
waitForDatabaseServer() {
    echo "checking whether database server is up and running..."

    local command
    command="java -jar ${ORACLE_HOME}/bin/sql-runner/sql-runner-0.3.1-with-dependencies.jar -q -U \"${DB_USER}\" -P \"${DB_PASSWORD}\" -j jdbc:oracle:thin:@${DB_HOST}:${DB_PORT}/${DB_NAME} -s \"select 1 from dual\""
    echo "command to execute: $command"
    echo "the database server is not running yet, waiting..."

    while ! eval "$command"; do
        sleep 2
    done
    echo "database server is up and running"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
waitForDatabaseServer
exec "$ORACLE_HOME/startup.sh"
