#!/bin/bash 
# ******************************************************************************
#  This startup script is executed automatically by Docker when a container
#  starts.
#
# Since : Jun, 2022
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
    echo "   oracle home:         $ORACLE_HOME"
    echo "   admin server host:   $ADMIN_SERVER_HOST"
    echo "   admin server port:   $ADMIN_SERVER_PORT"
    echo "   domain name:         $DOMAIN_NAME"
    echo "   cluster name:        $CLUSTER_NAME"
    echo "   hostname:            $HOSTNAME"
    echo "   managed server name: $MANAGED_SERVER_NAME"
    echo "   managed server port: $MANAGED_SERVER_PORT"
    echo "   node manager port:   $NODE_MANAGER_PORT"
    echo
}

# ------------------------------------------------------------------------------
# execute tasks before the first server startup
# ------------------------------------------------------------------------------
function executeStep1Tasks() {
    local markerFile fileToExecute
    markerFile="$ORACLE_HOME/.before-server-first-startup.marker"
    fileToExecute="$ORACLE_HOME/before-server-first-startup.sh"

    if [ -f "$markerFile" ]; then
        echo "this is not the first startup, skipping the execution of before the first server startup tasks..."
    else
        echo "this is the first startup, let's execute tasks before the first server startup..."

        createAdminServer
        configureNodeManager
        updateManagedServerConfig
        configureSplunkForwarder

        if [ -f "$fileToExecute" ]; then
            echo "---------------------------------------------------------------------"
            echo "--                             STEP  1                             --"
            echo "--                   BEFORE FIRST SERVER STARTUP                   --"
            echo "---------------------------------------------------------------------"
            "$fileToExecute"
            echo "--------------------------- end of STEP 1 ---------------------------"
            echo
            touch "$markerFile"
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
    fileToExecute="$ORACLE_HOME/before-server-startup.sh"

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
# create an admin server
# ------------------------------------------------------------------------------
function createAdminServer {
    local localTemplateHome remoteTemplateHome templateJar
    localTemplateHome="$ORACLE_HOME/wlserver/common/templates/domain/"
    remoteTemplateHome="$ORACLE_HOME/wlserver/common/templates/domain/"
    templateJar="$DOMAIN_NAME-template.jar"

    local remote_host remote_user remote_password
    remote_host="$ADMIN_SERVER_HOST"
    remote_user="root"
    remote_password="$ROOT_PASSWORD"

    echo "downloading the template JAR..."
    echo "   - remote host:     $remote_host"
    echo "   - remote user:     $remote_user"
    echo "   - remote password: $remote_password"
    echo "   - remote file:     $remoteTemplateHome/$templateJar"
    echo "   - local file:      $localTemplateHome/$templateJar"

    mkdir -p "$localTemplateHome"
    sshpass -p "$remote_password" scp -o StrictHostKeyChecking=no root@$remote_host:/$remoteTemplateHome/$templateJar $localTemplateHome/

    echo "unpacking the WebLogic domain server template JAR..."
    local toolHome
    toolHome="$ORACLE_HOME/oracle_common/common/bin/"

	  cd "$toolHome" || { echo "Error while trying to change directory from $(pwd) to $toolHome."; exit 1; }
    unpack.sh \
        -domain="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME" \
        -template="$localTemplateHome/$templateJar" \
        -overwrite_domain true
    cd - || { echo "Error while trying to return to the original directory."; exit 1; }
}

# ------------------------------------------------------------------------------
# configure the node manager
# ------------------------------------------------------------------------------
function configureNodeManager() {
    echo "enrolling the node manager..."
    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$ORACLE_HOME/properties/boot.properties"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")
    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/enroll-node-manager.py" \
            "$ADMIN_SERVER_HOST" \
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

    local configFile="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/nodemanager/nodemanager.properties"
    echo "updating the node manager config file, path: $configFile..."
    sed -i "s/SecureListener=true/SecureListener=false/g" "$configFile"
    sed -i "s/ListenAddress=localhost/ListenAddress=$HOSTNAME/g" "$configFile"
}

# ------------------------------------------------------------------------------
# update the managed server configuration i.e. username, password, classpath
# and JVM arguments
# ------------------------------------------------------------------------------
function updateManagedServerConfig() {
    echo "updating the managed server configuration i.e. username, password, classpath and JVM arguments..."
    local propertiesFile serverUsername serverPassword
    propertiesFile="$ORACLE_HOME/properties/boot.properties"
    serverUsername=$(getValue "$propertiesFile" "username")
    serverPassword=$(getValue "$propertiesFile" "password")

    # COMMENT 1:
    #    The CLASSPATH environment variable will be overwritten by the
    #    'wlst.sh' during the execution so this is the only way how we can
    #    preserve the original value of this variable while executing the
    #    'update-managed-server-config.py' python script.
    #
    # COMMENT 2:
    #    The classpath and the JVM arguments are passed to the
    #    'update-managed-server-config.py' python script via environment
    #    variables, not as a bash command line arguments i.e. username and
    #    password. Why? Because these values contain special characters
    #    i.e. '/', ':' and ','. These characters - especially the comma - split
    #    the parameter to multiply parts and the python script receives pieces.
    #    Pieces can be concatenated and handled properly on the python side but
    #    it requires more complex python code.
    export ACLASSPATH="$CLASSPATH"

    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/update-managed-server-config.py" \
            "$ADMIN_SERVER_HOST" \
            "$ADMIN_SERVER_PORT" \
            "$serverUsername" \
            "$serverPassword" \
            "${HOSTNAME^^}" \
            "$serverUsername" \
            "$serverPassword"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
      echo "Updating the managed server failed with $returnValue."
      exit 1
    fi
}

# ------------------------------------------------------------------------------
# configure the Splunk Universal Forwarder to send log entries to the Splunk
# server
# ------------------------------------------------------------------------------
function configureSplunkForwarder() {
    echo "configuring logfiles to be monitored by Splunk...";
    local logHome
    logHome="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs"

    mkdir -p "$logHome"
    touch "$logHome/$MANAGED_SERVER_NAME.out"
    touch "$logHome/$MANAGED_SERVER_NAME.log"

    "$SPLUNK_HOME/bin/splunk" \
        add monitor "$logHome/$MANAGED_SERVER_NAME.out" \
        -index main \
        -sourcetype "$MANAGED_SERVER_NAME" \
        -auth "$SPLUNK_USERNAME":"$SPLUNK_PASSWORD"

    "$SPLUNK_HOME/bin/splunk" \
        add monitor "$logHome/$MANAGED_SERVER_NAME.log" \
        -index main \
        -sourcetype "$MANAGED_SERVER_NAME" \
        -auth "$SPLUNK_USERNAME":"$SPLUNK_PASSWORD"
}

# ------------------------------------------------------------------------------
# start Splunk Universal Forwarder
# ------------------------------------------------------------------------------
function startSplunkForwarder() {
    echo "starting Splunk Universal Forwarder..."
    "$SPLUNK_HOME/bin/splunk" start --accept-license
    echo "Splunk Universal Forwarder is up and running"
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
# start the managed server
# ------------------------------------------------------------------------------
function startManagedServer() {
    echo "starting the $MANAGED_SERVER_NAME managed server..."
    local propertiesFile adminServerUsername adminServerPassword
    propertiesFile="$ORACLE_HOME/properties/boot.properties"
    adminServerUsername=$(getValue "$propertiesFile" "username")
    adminServerPassword=$(getValue "$propertiesFile" "password")

    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$propertiesFile" \
        "$ORACLE_HOME/start-managed-server.py" \
        "$ADMIN_SERVER_HOST" "$ADMIN_SERVER_PORT" "$adminServerUsername" "$adminServerPassword" "$MANAGED_SERVER_NAME"

    local returnValue
    returnValue=$?
    if [ $returnValue -ne 0 ]; then
        echo "An error appeared while starting the managed server. Error: $returnValue."
        exit 1
    fi

    setServerUpState
}

# ------------------------------------------------------------------------------
# open a port to inform the listeners about the server up state
# it runs at the background in order to does not block the main script execution
# ------------------------------------------------------------------------------
function setServerUpState() {
    echo ">>> WebLogic $MANAGED_SERVER_NAME server is up and ready to serve incoming requests <<<"
    nc --listen --keep-open --source-port "$READY_SIGNAL_PORT" &
}

# ------------------------------------------------------------------------------
# main app starts here
# ------------------------------------------------------------------------------
source "$ORACLE_HOME/common-utils.sh"
export MANAGED_SERVER_NAME=${HOSTNAME^^}

showContext
startSplunkForwarder
executeStep1Tasks
executeStep2Tasks
startNodeManager
startManagedServer

# this command keeps alive the docker container
tail -F \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs/$MANAGED_SERVER_NAME.log" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs/$MANAGED_SERVER_NAME.nohup" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs/$MANAGED_SERVER_NAME.out" \
    "$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$MANAGED_SERVER_NAME/logs/datasource.log"
