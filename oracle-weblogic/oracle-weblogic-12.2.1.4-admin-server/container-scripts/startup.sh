#!/bin/bash
# ******************************************************************************
# This startup script is executed automatically by Docker when a container
# starts.
#
# Since : April, 2022
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all variables used by this script
# ------------------------------------------------------------------------------
function showContext {
    echo
    echo "executing the ${BASH_SOURCE[0]} script with"
    echo "   admin server name:        $ADMIN_SERVER_NAME"
    echo "   admin server port:        $ADMIN_SERVER_PORT"
    echo "   server ready signal port: $READY_SIGNAL_PORT"
    echo "   cluster name:             $CLUSTER_NAME"
    echo "   oracle home:              $ORACLE_HOME"
    echo "   domain name:              $DOMAIN_NAME"
    echo "   production mode:          $PRODUCTION_MODE"
    echo "   web console color:        $WEB_CONSOLE_COLOR"
    echo "   managed server hostnames: $MANAGED_SERVER_HOSTNAMES"
    echo "   managed server port:      $MANAGED_SERVER_PORT"
    echo
}

# ------------------------------------------------------------------------------
# execute tasks before the server's first startup
# ------------------------------------------------------------------------------
function executeStep1Tasks() {
    local markerFile fileToExecute
    markerFile="$ORACLE_HOME/.before-first-server-startup.marker"
    fileToExecute="$ORACLE_HOME/before-server-first-startup.sh"

    if [ -f "$markerFile" ]; then
        echo "skipping the execution of the before server's first startup tasks..."
    else
        echo "executing some tasks before the server's first startup..."
        createAdminServer
        configureNodeManager

        if [ -f "$fileToExecute" ]; then
            echo "---------------------------------------------------------------------"
            echo "--                             STEP  1                             --"
            echo "--                   BEFORE SERVER FIRST STARTUP                   --"
            echo "---------------------------------------------------------------------"
            "$fileToExecute"
            touch "$markerFile"
            echo "--------------------------- end of STEP 1 ---------------------------"
            echo
        else
            echo "the '$fileToExecute' file does not exist"
        fi
    fi
}

# ------------------------------------------------------------------------------
# execute tasks before each server startup
# ------------------------------------------------------------------------------
function executeStep2Tasks() {
    local fileToExecute
    fileToExecute=$ORACLE_HOME/before-server-startup.sh

    customizeWebLogicConsole

    if [ -f "$fileToExecute" ]; then
        echo "-------------------------------------------------------------------------"
        echo "--                               STEP  2                               --"
        echo "--                        BEFORE SERVER STARTUP                        --"
        echo "-------------------------------------------------------------------------"
        "$fileToExecute"
        echo "----------------------------- end of STEP 2 -----------------------------"
        echo
    else
        echo "the '$fileToExecute' file does not exist"
    fi
}

# ------------------------------------------------------------------------------
# execute tasks after the server's first startup
# ------------------------------------------------------------------------------
function executeStep3Tasks() {
    local markerFile fileToExecute
    markerFile="$ORACLE_HOME/.after-first-server-startup.marker"
    fileToExecute="$ORACLE_HOME/after-server-first-startup.sh"

    waitForAdminServer

    if [ -f "$markerFile" ]; then
         echo "skipping the execution of the after server's first startup tasks..."
     else
         echo "executing some tasks after the server's first startup..."

        # create managed servers
        local hosts index
        IFS=', '
        read -r -a hosts <<< "$MANAGED_SERVER_HOSTNAMES"
        for index in "${!hosts[@]}"; do
            createManagedServer "${hosts[index]^^}" "${hosts[index]}" "$MANAGED_SERVER_PORT" "$NODE_MANAGER_PORT"
        done

        enrollNodeManager
        generateServerTemplate

        if [ -f "$fileToExecute" ]; then
            echo "-------------------------------------------------------------------------"
            echo "--                               STEP  3                               --"
            echo "--                     AFTER  SERVER FIRST STARTUP                     --"
            echo "-------------------------------------------------------------------------"
            "$fileToExecute"
            touch "$markerFile"
            echo "----------------------------- end of STEP 3 -----------------------------"
            echo
        fi
    fi

    executeStep4Tasks
}

# ------------------------------------------------------------------------------
# execute tasks after the server startup
# ------------------------------------------------------------------------------
function executeStep4Tasks() {
    local fileToExecute
    fileToExecute="$ORACLE_HOME/after-server-startup.sh"
    if [ -f "$fileToExecute" ]; then
        echo "-------------------------------------------------------------------------"
        echo "--                               STEP  4                               --"
        echo "--                        AFTER  SERVER STARTUP                        --"
        echo "-------------------------------------------------------------------------"
        "$fileToExecute"
        echo "----------------------------- end of STEP 4 -----------------------------"
        echo
    else
        echo "the '$fileToExecute' file does not exist"
    fi

    setServerUpState
}

# ------------------------------------------------------------------------------
# execute tasks after the domain's first startup
# ------------------------------------------------------------------------------
function executeStep5Tasks() {
    local markerFile fileToExecute
    markerFile="$ORACLE_HOME/.after-domain-first-startup.marker"
    fileToExecute="$ORACLE_HOME/after-domain-first-startup.sh"

    waitForDomain
    showRunningLabel

    if [ -f "$markerFile" ]; then
       echo "skipping the execution of the after domain's first startup tasks..."
    else
        echo "executing some tasks after the domain's first startup..."
        if [ -f "$fileToExecute" ]; then
            echo "-------------------------------------------------------------------------"
            echo "--                               STEP  5                               --"
            echo "--                     AFTER  DOMAIN FIRST STARTUP                     --"
            echo "-------------------------------------------------------------------------"
            "$fileToExecute"
            touch "$markerFile"
            echo "----------------------------- end of STEP 5 -----------------------------"
            echo
        else
            echo "the '$fileToExecute' file does not exist"
        fi
    fi

    executeStep6Tasks
}

# ------------------------------------------------------------------------------
# execute tasks after each server startup
# ------------------------------------------------------------------------------
function executeStep6Tasks() {
    local fileToExecute
    fileToExecute="$ORACLE_HOME/after-domain-startup.sh"
    if [ -f "$fileToExecute" ]; then
        echo "-------------------------------------------------------------------------"
        echo "--                               STEP  6                               --"
        echo "--                        AFTER  DOMAIN STARTUP                        --"
        echo "-------------------------------------------------------------------------"
        "$fileToExecute"
        echo "----------------------------- end of STEP 6 -----------------------------"
        echo
    else
        echo "the '$fileToExecute' file does not exist"
    fi
}

# ------------------------------------------------------------------------------
# show a nice label
# ------------------------------------------------------------------------------
function showRunningLabel {
    echo
    echo "    888888ba                               oo             "
    echo "    88    \`8b                                             "
    echo "    88     88 .d8888b. 88d8b.d8b. .d8888b. dP 88d888b.    "
    echo "    88     88 88'  \`88 88'\`88'\`88 88'  \`88 88 88'  \`88    "
    echo "    88    .8P 88.  .88 88  88  88 88.  .88 88 88    88    "
    echo "    8888888P  \`88888P' dP  dP  dP \`88888P8 dP dP    dP    "
    echo
    echo "                     oo                                   "
    echo
    echo "                     dP .d8888b.                          "
    echo "                     88 Y8ooooo.                          "
    echo "                     88       88                          "
    echo "                     dP \`88888P'                          "
    echo
    echo "                                      oo                  "
    echo
    echo " 88d888b. dP    dP 88d888b. 88d888b. dP 88d888b. .d8888b. "
    echo " 88'  \`88 88    88 88'  \`88 88'  \`88 88 88'  \`88 88'  \`88 "
    echo " 88       88.  .88 88    88 88    88 88 88    88 88.  .88 "
    echo " dP       \`88888P' dP    dP dP    dP dP dP    dP \`8888P88 "
    echo "                                                      .88 "
    echo "                                                  d8888P  "
    echo
}

# ------------------------------------------------------------------------------
# create an admin server
# ------------------------------------------------------------------------------
function createAdminServer {
    echo "creating a new WebLogic admin server..."

    local propertiesFile
    propertiesFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties"
    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/create-admin-server.py" \
            "$ORACLE_HOME" \
            "$ADMIN_SERVER_NAME" \
            "$ADMIN_SERVER_PORT" \
            "$DOMAIN_NAME" \
            "$CLUSTER_NAME" \
            "$PRODUCTION_MODE" \
            "$MANAGED_SERVER_PORT" \
            "$NODE_MANAGER_PORT"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
        echo "WebLogic Admin server creation failed with $returnValue"
        exit 1
    fi

    echo "updating the original WL startup script..."
    mv -f "$ORACLE_HOME/startWebLogic.sh" "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/"
}

# ------------------------------------------------------------------------------
# create a managed server with WLST
# ------------------------------------------------------------------------------
function createManagedServer() {
    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")

    local adminServerHost
    adminServerHost="$HOSTNAME"

    local managedServerName managedServerHost managedServerPort nodeManagerPort
    managedServerName=$1
    managedServerHost=$2
    managedServerPort=$3
    nodeManagerPort=$4

    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/create-managed-server.py" \
            "$adminServerHost" \
            "$ADMIN_SERVER_PORT" \
            "$adminServerUsername" \
            "$adminServerPassword" \
            "$managedServerName" \
            "$managedServerHost" \
            "$managedServerPort" \
            "$CLUSTER_NAME" \
            "$nodeManagerPort"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
      echo "Managed server creation failed with $returnValue."
      exit 1
    fi
}

# ------------------------------------------------------------------------------
# configure the node manager
# ------------------------------------------------------------------------------
function configureNodeManager() {
    local configFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/nodemanager/nodemanager.properties"
    echo "updating the node manager config file, path: $configFile..."
    sed -i "s/SecureListener=true/SecureListener=false/g" "$configFile"
    sed -i "s/ListenAddress=localhost/ListenAddress=$HOSTNAME/g" "$configFile"
}

# ------------------------------------------------------------------------------
# enroll the node manager
# ------------------------------------------------------------------------------
function enrollNodeManager() {
    echo "enrolling the node manager..."
    local propertiesFile adminServerUsername adminServerPassword adminServerHost
    propertiesFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")
    adminServerHost="$HOSTNAME"

    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/enroll-node-manager.py" \
            "$adminServerHost" \
            "$ADMIN_SERVER_PORT" \
            "$adminServerUsername" \
            "$adminServerPassword" \
            "$ORACLE_HOME" \
            "$DOMAIN_NAME"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
      echo "Enrolling then node manager failed with $returnValue."
      exit 1
    fi
}

# ------------------------------------------------------------------------------
# customize the WebLogic console
# ------------------------------------------------------------------------------
function customizeWebLogicConsole() {
    if [ -n "$WEB_CONSOLE_COLOR" ]; then
        echo "customizing the WebLogic console's color..."
        \cp -rf "$ORACLE_HOME/content.css" "$ORACLE_HOME/wlserver/server/lib/consoleapp/webapp/css/"
        sed -i "s/#D2E5F9/$WEB_CONSOLE_COLOR/g" "$ORACLE_HOME/wlserver/server/lib/consoleapp/webapp/css/content.css"
    else
        echo "skipping the customization of the web console color, the 'WEB_CONSOLE_COLOR' variable is not set..."
    fi
}

# ------------------------------------------------------------------------------
# open a port to inform the listeners about the server up state
# it runs at the background in order to does not block the main script execution
# ------------------------------------------------------------------------------
function setServerUpState() {
    echo ">>> WebLogic $ADMIN_SERVER_NAME is up and ready to serve incoming requests <<<"
    nc --listen --keep-open --source-port "$READY_SIGNAL_PORT" &
}

# ------------------------------------------------------------------------------
# generate a WebLogic Domain Server Template during the first start,
# the template can be used to create a Managed Server on a remote host
# ------------------------------------------------------------------------------
function generateServerTemplate() {
    echo "generating a WebLogic domain server template JAR..."

    local templateHome templateJar toolHome
    templateHome="$ORACLE_HOME/wlserver/common/templates/domain/"
    templateJar="$DOMAIN_NAME-template.jar"
    toolHome="$ORACLE_HOME/oracle_common/common/bin/"

    mkdir -p "$templateHome"
	  cd "$toolHome" || { echo "Error while trying to change directory from $(pwd) to $toolHome."; exit 1; }
	  pack.sh \
	      -managed=true \
	      -domain="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME" \
	      -template="$templateHome/$templateJar" \
	      -template_name="$DOMAIN_NAME" \
	      -template_author="arnold.somogyi@gmail.com"
    cd - || { echo "Error while trying to return to the original directory."; exit 1; }

    # make the template jar available for other docker containers
    exposeTemplateJar "$templateHome/$templateJar" &
}

# ------------------------------------------------------------------------------
# make the template jar available for another docker containers via the
# docker network
#
# this runs in the background to avoid blocking the main script execution
# ------------------------------------------------------------------------------
function exposeTemplateJar() {
    local templateJar port
    templateJar="$1"
    port=1384

    echo "exposing the template JAR for another docker containers with..."
    echo "   template JAR: $templateJar"
    echo "   port:         $port"

    while :
    do
        { echo -ne "HTTP/1.0 200 OK\r\n\r\n"; cat "$templateJar" ; } | nc  -l "$port"
    done
}

# ------------------------------------------------------------------------------
# start the Node Manager
# ------------------------------------------------------------------------------
function startNodeManager() {
    echo "starting the node manager for $MANAGED_SERVER_NAME server..."
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/startNodeManager.sh" &

    while ! nc -z "$HOSTNAME" "$NODE_MANAGER_PORT"; do
      sleep 0.5
    done
    echo "node manager is up and ready to receive requests"
}

# ------------------------------------------------------------------------------
# start the WebLogic Admin server
# ------------------------------------------------------------------------------
function startAdminServer() {
    echo "starting the $ADMIN_SERVER_NAME server..."
    local logHome
    logHome="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs"
    mkdir -p "$logHome"
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/bin/startWebLogic.sh" > "$logHome/$ADMIN_SERVER_NAME.out" 2>&1 &
}

# ------------------------------------------------------------------------------
# waiting for server to be up and ready to serve requests
# ------------------------------------------------------------------------------
function waitForAdminServer() {
    echo "checking whether the $ADMIN_SERVER_NAME is up and running..."

    local propertiesFile adminServerUsername adminServerPassword command
    propertiesFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")
    command="wget --timeout=1 --tries=1 -qO- --user ${adminServerUsername} --password ${adminServerPassword} http://${HOSTNAME}:${ADMIN_SERVER_PORT}/management/tenant-monitoring/servers/${ADMIN_SERVER_NAME}"

    echo "$ADMIN_SERVER_NAME is not running yet, waiting..."
    while [[ $($command) != *"RUNNING"* ]]; do
        sleep 2
    done

    echo "$ADMIN_SERVER_NAME is up and running"
}

# ------------------------------------------------------------------------------
# waiting for domain startup to be finnished
# ------------------------------------------------------------------------------
function waitForDomain() {
    # parse $MANAGED_SERVER_HOSTNAMES string to an array
    local hosts
    IFS=', '
    read -r -a hosts <<< "$MANAGED_SERVER_HOSTNAMES"

    # managed servers + admin server
    local expectedRunning
    expectedRunning=$((${#hosts[@]}+1))

    echo "checking whether the $DOMAIN_NAME is up and running, expected $expectedRunning running servers..."

    # check the status of the servers
    echo "$DOMAIN_NAME is not up yet, waiting..."
    local actualRunning
    actualRunning=0
    while [[ "$actualRunning" -ne "$expectedRunning" ]]; do
        actualRunning=0
        # checking the admin server state
        if nc -z "$HOSTNAME" "$READY_SIGNAL_PORT" 1> /dev/null 2>&1; then
            actualRunning=$((actualRunning+1))
        fi

        # checking the managed servers state
        local index
        for index in "${!hosts[@]}"; do
            if nc -z "${hosts[$index]}" "$READY_SIGNAL_PORT" 1> /dev/null 2>&1; then
                actualRunning=$((actualRunning+1))
            fi
        done

        if [[ "$actualRunning" -ne "$expectedRunning" ]]; then
            sleep 1
       fi
    done

    echo ">>> WebLogic $DOMAIN_NAME is up and ready to serve incoming requests <<<"
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
source "$ORACLE_HOME/common-utils.sh"
showContext
executeStep1Tasks
executeStep2Tasks
executeStep3Tasks &
executeStep5Tasks &
startNodeManager
startAdminServer

# this command keeps alive the docker container
echo "a 'tail: cannot open...' error may appear but you can ignore it because 'tail -F' is used"
tail -F \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs/$ADMIN_SERVER_NAME.log" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs/$ADMIN_SERVER_NAME.nohup" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs/$ADMIN_SERVER_NAME.out" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs/datasource.log"
