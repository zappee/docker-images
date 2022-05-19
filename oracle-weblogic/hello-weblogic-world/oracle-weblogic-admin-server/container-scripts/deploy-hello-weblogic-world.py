# ******************************************************************************
# WLST script for creating WebLogic resources for the application.
#
# Since : Jun, 202
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************


# ------------------------------------------------------------------------------
# connect to the admin server
# ------------------------------------------------------------------------------
def connect_to_server(_admin_server_host, _admin_server_port, _admin_server_user, _admin_server_password):
    _url = 't3://' + _admin_server_host + ':' + _admin_server_port
    connect(_admin_server_user, _admin_server_password, _url)


# ------------------------------------------------------------------------------
# start a new edit session
# ------------------------------------------------------------------------------
def lock_and_edit():
    _wait_time_in_millis = 60000
    _timeout_in_millis = 90000
    edit()
    startEdit(_wait_time_in_millis, _timeout_in_millis, 'True')


# ------------------------------------------------------------------------------
# save changes to disk
# ------------------------------------------------------------------------------
def save_changes():
    save()
    activate()
    disconnect()


# ------------------------------------------------------------------------------
# create a new data-source
# ------------------------------------------------------------------------------
def create_data_source(_ds_name, _ds_jndi, _ds_url, _ds_driver, _ds_user, _ds_pwd, _ds_target, _ds_target_type):
    print('creating a new data-source...')
    print('   datasource name: %s' % _ds_name)
    print('   JNDI name:       %s' % _ds_jndi)
    print('   JDBC URL:        %s' % _ds_url)
    print('   JDBC Driver:     %s' % _ds_driver)
    print('   Username:        %s' % _ds_user)
    print('   Password:        %s' % _ds_pwd)
    print('   Target:          %s' % _ds_target)
    print('   Target type:     %s' % _ds_target_type)

    cd('/')
    cmo.createJDBCSystemResource(_ds_name)

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name)
    cmo.setName(_ds_name)

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCDataSourceParams/' + _ds_name)
    set('JNDINames', jarray.array([String(_ds_jndi)], String))

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name)
    cmo.setDatasourceType('GENERIC')

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCDriverParams/' + _ds_name)
    cmo.setUrl(_ds_url)
    cmo.setDriverName(_ds_driver)
    set('Password', _ds_pwd)

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCDriverParams/' + _ds_name
       + '/Properties/' + _ds_name)
    cmo.createProperty('user')

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCDriverParams/' + _ds_name
       + '/Properties/' + _ds_name + '/Properties/user')
    cmo.setValue(_ds_user)

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCConnectionPoolParams/' + _ds_name)
    cmo.setTestTableName('SQL SELECT 1 FROM DUAL')

    cd('/JDBCSystemResources/' + _ds_name + '/JDBCResource/' + _ds_name + '/JDBCDataSourceParams/' + _ds_name)
    cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

    cd('/JDBCSystemResources/' + _ds_name)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _ds_target + ',Type=' + _ds_target_type)], ObjectName))


# ------------------------------------------------------------------------------
# create a new jms-server
# ------------------------------------------------------------------------------
def create_jms_server(_jms_server, _jms_target, _jms_target_type):
    print('creating a new jms-server...')
    print('   JMS server name: %s' % _jms_server)
    print('   Target:          %s' % _jms_target)
    print('   Target type:     %s' % _jms_target_type)

    cd('/')
    cmo.createJMSServer(_jms_server)
    cd('/JMSServers/' + _jms_server)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jms_target + ',Type=' + _jms_target_type)], ObjectName))


# ------------------------------------------------------------------------------
# create a new jms-module
# ------------------------------------------------------------------------------
def create_jms_module(_jms_server, _jms_module, _jms_module_sub_deployment, _jms_target, _jms_target_type):
    print('creating a new jms-module...')
    print('   JMS server name:                %s' % _jms_server)
    print('   JMS module name:                %s' % _jms_module)
    print('   JMS module sub-deployment name: %s' % _jms_module_sub_deployment)
    print('   Target:                         %s' % _jms_target)
    print('   Target type:                    %s' % _jms_target_type)

    cd('/')
    cmo.createJMSSystemResource(_jms_module)
    cd('/JMSSystemResources/' + _jms_module)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jms_target + ',Type=' + _jms_target_type)], ObjectName))

    cmo.createSubDeployment(_jms_module_sub_deployment)
    cd('/JMSSystemResources/' + _jms_module + '/SubDeployments/' + _jms_module_sub_deployment)
    set('Targets', jarray.array([ObjectName('com.bea:Name=' + _jms_server + ',Type=JMSServer')], ObjectName))


# ------------------------------------------------------------------------------
# create a new jms-connection-factory
# ------------------------------------------------------------------------------
def create_connection_factory(_jms_module, _jms_module_sub_deployment, _jms_cf, _jms_cf_jndi):
    print('creating a new connection-factory...')
    print('   JMS module name:                %s' % _jms_module)
    print('   JMS module sub-deployment name: %s' % _jms_module_sub_deployment)
    print('   Connection factory name:        %s' % _jms_cf)
    print('   Connection factory JNDI name:   %s' % _jms_cf_jndi)

    cd('/JMSSystemResources/' + _jms_module + '/JMSResource/' + _jms_module)
    cmo.createConnectionFactory(_jms_cf)
    cd('/JMSSystemResources/' + _jms_module + '/JMSResource/' + _jms_module + '/ConnectionFactories/' + _jms_cf)
    cmo.setJNDIName('jms/' + _jms_cf_jndi)
    cmo.setSubDeploymentName(_jms_module_sub_deployment)


# ------------------------------------------------------------------------------
# create a new distributed-jms-queue
# ------------------------------------------------------------------------------
def create_distributed_jms_queue(_jms_module, _jms_module_sub_deployment, _jms_queue_name, _jms_queue_jndi):
    print('creating a new distributed-jms-queue...')
    print('   JMS module name:                %s' % _jms_module)
    print('   JMS module sub-deployment name: %s' % _jms_module_sub_deployment)
    print('   JMS queue name:                 %s' % _jms_queue_name)
    print('   JMS queue JNDI name:            %s' % _jms_queue_jndi)

    cd('/JMSSystemResources/' + _jms_module + '/JMSResource/' + _jms_module)
    cmo.createUniformDistributedQueue(_jms_queue_name)

    cd('/JMSSystemResources/' + _jms_module + '/JMSResource/' + _jms_module + '/UniformDistributedQueues/'
       + _jms_queue_name)
    cmo.setJNDIName(_jms_queue_jndi)
    cmo.setSubDeploymentName(_jms_module_sub_deployment)


# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
admin_server_host = sys.argv[1]
admin_server_port = sys.argv[2]
cluster_name = sys.argv[3]
db_host = sys.argv[4]
db_port = sys.argv[5]
db_name = sys.argv[6]
ds_user = sys.argv[7]
ds_pwd = sys.argv[8]

print("executing the ${BASH_SOURCE[0]} script with")
print('   admin server host:     %s' % admin_server_host)
print('   admin server port:     %s' % admin_server_port)
print('   admin server user:     %s' % username)
print('   admin server password: %s' % password)
print('   cluster name:          %s' % cluster_name)

connect_to_server(admin_server_host, admin_server_port, username, password)
lock_and_edit()

dsURL = 'jdbc:oracle:thin:@//' + db_host + ':' + db_port + '/' + db_name
create_data_source('hello-ds',
                   'jdbc/HELLO_DS',
                   dsURL,
                   'oracle.jdbc.xa.client.OracleXADataSource',
                   ds_user,
                   ds_pwd,
                   cluster_name,
                   'Cluster')

jms_server_name = 'dev-jms-server'
jms_module_name = 'dev-jms-module'
jms_module_sub_deployment = 'dev-jms-module-subdeployment'
create_jms_server(jms_server_name, cluster_name, 'Cluster')
create_jms_module(jms_server_name, jms_module_name, jms_module_sub_deployment, cluster_name, 'Cluster')
create_connection_factory(jms_module_name, jms_module_sub_deployment, 'jms-connection-factory', 'qcf')
create_distributed_jms_queue(jms_module_name, jms_module_sub_deployment, 'hello-incoming-queue', 'jms/incoming')
create_distributed_jms_queue(jms_module_name, jms_module_sub_deployment, 'hello-outgoing-queue', 'jms/outgoing')

save_changes()
