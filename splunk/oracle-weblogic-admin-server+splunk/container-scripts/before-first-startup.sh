#!/bin/bash
# ******************************************************************************
# This is a lifecycle-bash script, executed once, BEFORE the first startup of
# the WebLogic admin server.
#
# While this script is running, the admin server is still stopped. It is
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
#     3) after-first-startup.sh
#     4) after-startup.sh
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
    echo "   oracle home:       $ORACLE_HOME"
    echo "   domain name:       $DOMAIN_NAME"
    echo "   admin server name: $ADMIN_SERVER_NAME"
    echo "   splunk home:       $SPLUNK_HOME"
 }

# ------------------------------------------------------------------------------
# configuring Splunk to send log entries to the Splunk server
# ------------------------------------------------------------------------------
function configureSplunk() {
    echo "configuring logfiles to be monitored by Splunk...";
    WL_LOG_HOME=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs

    mkdir -p $WL_LOG_HOME
    touch $WL_LOG_HOME/$ADMIN_SERVER_NAME.nohup;
    touch $WL_LOG_HOME/$ADMIN_SERVER_NAME.log;
    touch $WL_LOG_HOME/$DOMAIN_NAME.log;

    $SPLUNK_HOME/bin/splunk add monitor $WL_LOG_HOME/$ADMIN_SERVER_NAME.nohup -index main -sourcetype $ADMIN_SERVER_NAME -auth $SPLUNK_USERNAME:$SPLUNK_PASSWORD
    $SPLUNK_HOME/bin/splunk add monitor $WL_LOG_HOME/$ADMIN_SERVER_NAME.log -index main -sourcetype $ADMIN_SERVER_NAME -auth $SPLUNK_USERNAME:$SPLUNK_PASSWORD
    $SPLUNK_HOME/bin/splunk add monitor $WL_LOG_HOME/$DOMAIN_NAME.log -index main -sourcetype $ADMIN_SERVER_NAME -auth $SPLUNK_USERNAME:$SPLUNK_PASSWORD
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables
configureSplunk
