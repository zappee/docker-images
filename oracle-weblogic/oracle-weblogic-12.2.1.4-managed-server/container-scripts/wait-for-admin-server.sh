#!/bin/bash 
# ******************************************************************************
#  This script returns only if the admin server is up and running.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# waiting for server to be up and ready to serve requests
# ------------------------------------------------------------------------------
waitForAdminServer() {
    echo "checking whether the $ADMIN_SERVER_NAME is up and running..."

    while ! nc -z "$ADMIN_SERVER_HOST" "$ADMIN_SERVER_READY_SIGNAL_PORT"; do
      sleep 0.5
    done

    echo "$ADMIN_SERVER_NAME is up and running"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
waitForAdminServer
exec "$ORACLE_HOME/startup.sh"
