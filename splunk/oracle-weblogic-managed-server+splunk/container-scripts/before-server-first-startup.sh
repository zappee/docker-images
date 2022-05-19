#!/bin/bash
# ******************************************************************************
#  This bash script is executed once, before the first startup of the WebLogic
#  admin server. While this script is executing, the admin server is not
#  running yet. If the 'wait-for-database-server.sh' option is used then the
#  database server will be up and running while executing this.
#
#  Commands with WLST offline-mode commands or database operations can be
#  executed by this script.
#
#  Be warned that the commands added to this file will be executed only once
#  before the first server startup.
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
function showVariables {
    echo
    echo "executing the ${BASH_SOURCE[0]} script with"
    echo "   oracle home:         $ORACLE_HOME"
    echo "   domain name:         $DOMAIN_NAME"
    echo "   managed server name: $MANAGED_SERVER_NAME"
    echo "   splunk home:         $SPLUNK_HOME"
 }

# ------------------------------------------------------------------------------
# configure the Splunk Universal Forwarder to send log entries to the Splunk
# server
# ------------------------------------------------------------------------------
function configureSplunkForwarder() {
    echo "configuring Splunk Universal Forwarder...";
    local logHome
    logHome="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs"

    mkdir -p "$logHome"
    touch "$logHome/$MANAGED_SERVER_NAME.out"
    touch "$logHome/$MANAGED_SERVER_NAME.log"

    "$SPLUNK_HOME/bin/splunk" \
        add monitor "$logHome/$MANAGED_SERVER_NAME.out" \
         -index main \
         -sourcetype "$MANAGED_SERVER_NAME" \
         -auth "$SPLUNK_USERNAME:$SPLUNK_PASSWORD"

    "$SPLUNK_HOME/bin/splunk" \
        add monitor "$logHome/$MANAGED_SERVER_NAME.log" \
        -index main \
        -sourcetype "$MANAGED_SERVER_NAME" \
        -auth "$SPLUNK_USERNAME:$SPLUNK_PASSWORD"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables
configureSplunkForwarder
