# ******************************************************************************
# WLST script for creating a new managed server in an existing WebLogic domain.
#
# Since : January, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************
import socket

# ------------------------------------------------------------------------------
# connect to the admin server
# ------------------------------------------------------------------------------
def connectToServer(_adminServerHost, _adminServerPort, _adminServerUser, _adminServerPassword):
    _url='t3://' + _adminServerHost + ':' + _adminServerPort
    connect(_adminServerUser, _adminServerPassword, _url)

# ------------------------------------------------------------------------------
# start a new edit session
# ------------------------------------------------------------------------------
def lockAndEdit():
    _waitTimeInMillis=60000
    _timeoutInMillis=90000
    edit()
    startEdit(_waitTimeInMillis, _timeoutInMillis, 'True')

# ------------------------------------------------------------------------------
# create a new machine
# ------------------------------------------------------------------------------
def createMachine(_machineName):
    print('creating a new machine with name \'' + _machineName + '\'...')
    cd('/')
    cmo.createUnixMachine(_machineName)

# ------------------------------------------------------------------------------
# create a new node manager and associate it to the machine
# ------------------------------------------------------------------------------
def createNodemanager(_machineName, _managedServerHost, _nodeManagerPort):
    print('creating a new node-manager for \'' + _machineName + '\'...')
    cd('/Machines/' + _machineName +'/NodeManager/' + _machineName)
    cmo.setNMType('Plain')
    cmo.setListenAddress(_managedServerHost)
    cmo.setListenPort(_nodeManagerPort)
    cmo.setDebugEnabled(false)

# ------------------------------------------------------------------------------
# create a managed server
# ------------------------------------------------------------------------------
def createManagedServer(_managedServerName, _managedServerPort, _clusterName, _machineName):
    print('creating a new managed server with name\'' + _managedServerName + '\'...')
    cd('/')
    cmo.createServer(_managedServerName)
    cd('/Servers/' + _managedServerName)
    cmo.setListenPort(_managedServerPort)

    print('redirecting stdout and stderr to server log...')
    cd('/Servers/' + _managedServerName + '/Log/' + _managedServerName)
    cmo.setRedirectStderrToServerLogEnabled(true)
    cmo.setRedirectStdoutToServerLogEnabled(true)
    cmo.setMemoryBufferSeverity('Debug')

    print('associate with \'' + _clusterName + '\' cluster...')
    cd('/Servers/' + _managedServerName)
    cmo.setCluster(getMBean('/Clusters/' + _clusterName))

    print('associate with node-manager...')
    cd('/Servers/' + _managedServerName)
    cmo.setMachine(getMBean('/Machines/' + _machineName))

# ------------------------------------------------------------------------------
# save changes to disk
# ------------------------------------------------------------------------------
def saveChanges():
    save()
    activate()
    disconnect()

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
adminServerHost = sys.argv[1]
adminServerPort = sys.argv[2]
adminServerUser = sys.argv[3]
adminServerPassword = sys.argv[4]
managedServerName = sys.argv[5]
managedServerPort = int(sys.argv[6])
clusterName = sys.argv[7]
machineName = managedServerName + '_MACHINE'
managedServerHost = socket.gethostname()
nodeManagerPort=5556

print('admin server host:     %s' % adminServerHost)
print('admin server password: %s' % adminServerPassword)
print('admin server port:     %s' % adminServerPort)
print('admin server user:     %s' % adminServerUser)
print('cluster name:          %s' % clusterName)
print('machine name:          %s' % machineName)
print('managed server host:   %s' % managedServerHost)
print('managed server name:   %s' % managedServerName)
print('managed server port:   %s' % managedServerPort)
print('node manager port:     %s' % nodeManagerPort)

connectToServer(adminServerHost, adminServerPort, adminServerUser, adminServerPassword)
lockAndEdit()
createMachine(machineName)
createNodemanager(machineName, managedServerHost, nodeManagerPort)
createManagedServer(managedServerName, managedServerPort, clusterName, machineName)
saveChanges()

print('managed server have been created successfully')
