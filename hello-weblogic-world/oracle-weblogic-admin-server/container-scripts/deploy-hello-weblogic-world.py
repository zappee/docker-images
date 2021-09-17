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
# create a new jms-server
# ------------------------------------------------------------------------------
def createJmsServer(_jmsServerName, _jmsTargetName, _jmsTargetType):
    print('creating a new jms-server...')
    print('   JMS server name: %s' % _jmsServerName)
    print('   Target:          %s' % _jmsTargetName)
    print('   Target type:     %s' % _jmsTargetType)

    cd('/')
    cmo.createJMSServer(_jmsServerName)
    cd('/JMSServers/' + _jmsServerName)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jmsTargetName + ',Type=' + _jmsTargetType)], ObjectName))

# ------------------------------------------------------------------------------
# create a new jms-module
# ------------------------------------------------------------------------------
def createJmsModule(_jmsServerName, _jmsModuleName, _jmsModuleSubDeploymentName, _jmsTargetName, _jmsTargetType):
    print('creating a new jms-module...')
    print('   JMS server name:                %s' % _jmsServerName)
    print('   JMS module name:                %s' % _jmsModuleName)
    print('   JMS module sub-deployment name: %s' % _jmsModuleSubDeploymentName)
    print('   Target:                         %s' % _jmsTargetName)
    print('   Target type:                    %s' % _jmsTargetType)

    cd('/')
    cmo.createJMSSystemResource(_jmsModuleName)
    cd('/JMSSystemResources/' + _jmsModuleName)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jmsTargetName + ',Type=' + _jmsTargetType)], ObjectName))

    cmo.createSubDeployment(_jmsModuleSubDeploymentName)
    cd('/JMSSystemResources/' + _jmsModuleName + '/SubDeployments/' + _jmsModuleSubDeploymentName)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jmsServerName + ',Type=JMSServer')], ObjectName))

# ------------------------------------------------------------------------------
# create a new jms-connection-factory
# ------------------------------------------------------------------------------
def createConnectionFactory(_jmsModuleName, _jmsModuleSubDeploymentName, _jmsconnectionFactoryName, _jmsconnectionFactoryJndiName):
    print('creating a new connection-factory...')
    print('   JMS module name:                %s' % _jmsModuleName)
    print('   JMS module sub-deployment name: %s' % _jmsModuleSubDeploymentName)
    print('   Connection factory name:        %s' % _jmsconnectionFactoryName)
    print('   Connection factory JNDI name:   %s' % _jmsconnectionFactoryJndiName)

    cd('/JMSSystemResources/' + _jmsModuleName + '/JMSResource/' + _jmsModuleName)
    cmo.createConnectionFactory(_jmsconnectionFactoryName)
    cd('/JMSSystemResources/' + _jmsModuleName + '/JMSResource/' + _jmsModuleName + '/ConnectionFactories/' + _jmsconnectionFactoryName)
    cmo.setJNDIName('jms/' + _jmsconnectionFactoryJndiName)
    cmo.setSubDeploymentName(_jmsModuleSubDeploymentName)


# ------------------------------------------------------------------------------
# create a new distributed-jms-queue
# ------------------------------------------------------------------------------
def createDistributedJmsQueue(_jmsModuleName, _jmsModuleSubDeploymentName, _jmsQueueName, _jmsQueueJndiName):
    print('creating a new distributed-jms-queue...')
    print('   JMS module name:                %s' % _jmsModuleName)
    print('   JMS module sub-deployment name: %s' % _jmsModuleSubDeploymentName)
    print('   JMS queue name:                 %s' % _jmsQueueName)
    print('   JMS queue JNDI name:            %s' % _jmsQueueJndiName)

    cd('/JMSSystemResources/' + _jmsModuleName + '/JMSResource/' + _jmsModuleName)
    cmo.createUniformDistributedQueue(_jmsQueueName)

    cd('/JMSSystemResources/' + _jmsModuleName + '/JMSResource/' + _jmsModuleName + '/UniformDistributedQueues/' + _jmsQueueName)
    cmo.setJNDIName(_jmsQueueJndiName)
    cmo.setSubDeploymentName(_jmsModuleSubDeploymentName)

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

print('admin server host:     %s' % adminServerHost)
print('admin server port:     %s' % adminServerPort)
print('admin server user:     %s' % username)
print('admin server password: %s' % password)
print('cluster name:          %s' % clusterName)

connectToServer(adminServerHost, adminServerPort, username, password)
lockAndEdit()

dsURL = 'jdbc:oracle:thin:@//' + dbHost + ':' + dbPort + '/' + dbName
createDataSource('hello-ds', 'jdbc/HELLO_DS', dsURL, 'oracle.jdbc.xa.client.OracleXADataSource', dsUsername, dsPassword, clusterName, 'Cluster')

jmsServerName = 'dev-jms-server'
jmsModuleName = 'dev-jms-module'
jmsModuleSubDeploymentName = 'dev-jms-module-subdeployment'
createJmsServer(jmsServerName, clusterName, 'Cluster')
createJmsModule(jmsServerName, jmsModuleName, jmsModuleSubDeploymentName, clusterName, 'Cluster')
createConnectionFactory(jmsModuleName, jmsModuleSubDeploymentName, 'jms-connection-factory', 'qcf')
createDistributedJmsQueue(jmsModuleName, jmsModuleSubDeploymentName, 'hello-incoming-queue', 'jms/incoming')
createDistributedJmsQueue(jmsModuleName, jmsModuleSubDeploymentName, 'hello-outgoing-queue', 'jms/outgoing')

saveChanges()
