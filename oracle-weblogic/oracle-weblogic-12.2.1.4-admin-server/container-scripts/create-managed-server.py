# ******************************************************************************
#  WLST script for creating a new managed server in an existing WebLogic
#  domain.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
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
# create a new machine with node manager
# ------------------------------------------------------------------------------
def create_machine(_machine_name, _host, _node_manager_port):
    print('creating a new machine with name \'' + _machine_name + '\'...')
    cd('/')
    cmo.createUnixMachine(_machine_name)

    print('creating a new node-manager for \'' + _machine_name + '\'...')
    cd('/Machines/' + _machine_name + '/NodeManager/' + _machine_name)
    cmo.setNMType('Plain')
    cmo.setListenAddress(_host)
    cmo.setListenPort(_node_manager_port)
    cmo.setDebugEnabled(false)


# ------------------------------------------------------------------------------
# create a managed server
# ------------------------------------------------------------------------------
def create_managed_server(_managed_server_name,
                          _managed_server_host,
                          _managed_server_port,
                          _cluster_name,
                          _machine_name):

    print('creating a new managed server with name \'' + _managed_server_name + '\'...')
    cd('/')
    cmo.createServer(_managed_server_name)
    cd('/Servers/' + _managed_server_name)
    cmo.setListenAddress(_managed_server_host)
    cmo.setListenPort(_managed_server_port)

    print('redirecting stdout and stderr to server log...')
    cd('/Servers/' + _managed_server_name + '/Log/' + _managed_server_name)
    cmo.setRedirectStderrToServerLogEnabled(true)
    cmo.setRedirectStdoutToServerLogEnabled(true)
    cmo.setMemoryBufferSeverity('Debug')

    print('associate with the \'' + _cluster_name + '\' cluster...')
    cd('/Servers/' + _managed_server_name)
    cmo.setCluster(getMBean('/Clusters/' + _cluster_name))

    print('associating the server with the \'' + _machine_name + '\' machine...')
    cd('/Servers/' + _managed_server_name)
    cmo.setMachine(getMBean('/Machines/' + _machine_name))


# ------------------------------------------------------------------------------
# updating the logging configuration of a given server
# ------------------------------------------------------------------------------
def update_server_log_config(_server_name):
    # the value is considered as days
    log_file_count = 10

    # server log configuration
    print('updating the log configuration for \'' + _server_name + '\'...')
    cd('/Servers/' + _server_name)
    cd('Log/' + _server_name)
    cmo.setFileName('logs/' + _server_name + '.log')
    cmo.setRotationType('bySize') # byTime, bySize
    cmo.setRotationTime('23:59')
    cmo.setFileMinSize(10000)
    cmo.setNumberOfFilesLimited(true)
    cmo.setFileCount(log_file_count)
    cmo.setRotateLogOnStartup(false)
    cmo.setDateFormatPattern('yyyy.MM.dd hh:mm:ss,SSS')

    # web server access log configuration
    print('updating the web server access log configuration for \'' + _server_name + '\'...')
    cd('/Servers/' + _server_name)
    cd('WebServer/' + _server_name)
    cd('WebServerLog/' + _server_name)
    cmo.setFileName('logs/access.log')
    cmo.setRotationType('bySize') # byTime, bySize
    cmo.setRotationTime('23:59')
    cmo.setFileMinSize(10000)
    cmo.setNumberOfFilesLimited(true)
    cmo.setFileCount(log_file_count)
    cmo.setRotateLogOnStartup(false)
    cmo.setDateFormatPattern('yyyy.MM.dd hh:mm:ss,SSS')


# ------------------------------------------------------------------------------
# save changes to disk
# ------------------------------------------------------------------------------
def save_changes():
    save()
    activate()
    disconnect()


# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
admin_server_host = sys.argv[1]
admin_server_port = sys.argv[2]
admin_server_user = sys.argv[3]
admin_server_password = sys.argv[4]
managed_server_name = sys.argv[5]
managed_server_host = sys.argv[6]
managed_server_port = int(sys.argv[7])
cluster_name = sys.argv[8]
node_manager_port = int(sys.argv[9])
machine_name = managed_server_name + '_MACHINE'

print('executing the create-managed-server.py script...')
print('   admin server host:     %s' % admin_server_host)
print('   admin server port:     %s' % admin_server_port)
print('   admin server user:     %s' % admin_server_user)
print('   admin server password: %s' % admin_server_password)
print('   managed server name:   %s' % managed_server_name)
print('   managed server host:   %s' % managed_server_host)
print('   managed server port:   %s' % managed_server_port)
print('   cluster name:          %s' % cluster_name)
print('   node manager port:     %s' % node_manager_port)
print('   machine name:          %s' % machine_name)

connect_to_server(admin_server_host, admin_server_port, admin_server_user, admin_server_password)
lock_and_edit()
create_machine(machine_name, managed_server_host, node_manager_port)
create_managed_server(managed_server_name, managed_server_host, managed_server_port, cluster_name, machine_name)
update_server_log_config(managed_server_name)
save_changes()
print('machine, node manager and the managed server have been created successfully')
