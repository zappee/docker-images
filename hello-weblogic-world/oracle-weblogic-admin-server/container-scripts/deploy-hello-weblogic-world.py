# ******************************************************************************
# WLST script for creating WebLogic resources for the application.
#
# Since : August, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

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
# save changes to disk
# ------------------------------------------------------------------------------
def saveChanges():
    save()
    activate()
    disconnect()

# ------------------------------------------------------------------------------
# create a new data-source
# ------------------------------------------------------------------------------
def createDataSource(_dsName, _dsJNDIName, _dsURL, _dsDriver, _dsUsername, _dsPassword, _dsTargetName, _dsTargetType):
    print('creating a new data-source...')
    print('   DS name:     %s' % _dsName)
    print('   JNDI name:   %s' % _dsJNDIName)
    print('   DS URL:      %s' % _dsURL)
    print('   JDBC Driver: %s' % _dsDriver)
    print('   Username:    %s' % _dsUsername)
    print('   Password:    %s' % _dsPassword)
    print('   Target:      %s' % _dsTargetName)
    print('   Target type: %s' % _dsTargetType)

    cd('/')
    cmo.createJDBCSystemResource(_dsName)

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName)
    cmo.setName(_dsName)

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCDataSourceParams/' + _dsName)
    set('JNDINames', jarray.array([String(_dsJNDIName)], String))

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName)
    cmo.setDatasourceType('GENERIC')

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCDriverParams/' + _dsName)
    cmo.setUrl(_dsURL)
    cmo.setDriverName(_dsDriver)
    set('Password', _dsPassword)

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCDriverParams/' + _dsName + '/Properties/' + _dsName)
    cmo.createProperty('user')
    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCDriverParams/' + _dsName + '/Properties/' + _dsName + '/Properties/user')
    cmo.setValue(_dsUsername)

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCConnectionPoolParams/' + _dsName)
    cmo.setTestTableName('SQL SELECT 1 FROM DUAL')

    cd('/JDBCSystemResources/' + _dsName + '/JDBCResource/' + _dsName + '/JDBCDataSourceParams/' + _dsName)
    cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

    cd('/JDBCSystemResources/' + _dsName)
    set('Targets',jarray.array([ObjectName('com.bea:Name=' + _dsTargetName + ',Type=' + _dsTargetType)], ObjectName))

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
adminServerHost = sys.argv[1]
adminServerPort = sys.argv[2]
clusterName = sys.argv[3]
dbHost = sys.argv[4]
dbPort = sys.argv[5]
dbName = sys.argv[6]
dsUsername = sys.argv[7]
dsPassword = sys.argv[8]

dsName = 'hello-ds'
dsJNDIName = 'jdbc/HELLO_DS'
dsURL = 'jdbc:oracle:thin:@//' + dbHost + ':' + dbPort + '/' + dbName
dsDriver = 'oracle.jdbc.xa.client.OracleXADataSource'

print('admin server host:     %s' % adminServerHost)
print('admin server port:     %s' % adminServerPort)
print('admin server user:     %s' % username)
print('admin server password: %s' % password)
print('cluster name:          %s' % clusterName)

connectToServer(adminServerHost, adminServerPort, username, password)
lockAndEdit()
createDataSource(dsName, dsJNDIName, dsURL, dsDriver, dsUsername, dsPassword, clusterName, 'Cluster')
saveChanges()
