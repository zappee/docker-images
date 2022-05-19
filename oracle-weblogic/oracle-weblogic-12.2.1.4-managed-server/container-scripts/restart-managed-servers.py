# ******************************************************************************
#  WLST script for starting the managed server using WLST.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************


# ------------------------------------------------------------------------------
# connect to the admin server
# ------------------------------------------------------------------------------
def connect_to_server(_admin_server_host, _admin_server_port, _admin_server_user, _admin_server_password):
    _url = 't3://' + _admin_server_host + ':' + _admin_server_port
    connect(_admin_server_user, _admin_server_password, _url)


# ------------------------------------------------------------------------------
# stop/start the managed servers in the domain
# ------------------------------------------------------------------------------
def control_managed_servers(_admin_server_name, _command):
    if _command == 'stop':
        print('shutting down the managed servers...')
    else:
        print('starting the managed servers...')

    domainRuntime()

    _tasks = []
    for _server in cmo.getServerLifeCycleRuntimes():
        _server_state = _server.getState()
        _server_name = _server.getName()
        if _server_name != _admin_server_name:
            print('status: ' + _server_name + ' is ' + _server_state)

            if _command == 'stop':
                # shut down
                if _server_state == 'RUNNING':
                    print('shutting down the \'' + _server_name + '\'...')
                    _tasks.append(_server.forceShutdown())
            else:
                # start
                if _server_state == 'SHUTDOWN':
                    print('starting the \'' + _server_name + '\'...')
                    _tasks.append(_server.start())

    # wait for tasks to complete
    while len(_tasks) > 0:
        for _task in _tasks:
            if _task.getStatus() != 'TASK IN PROGRESS':
                _tasks.remove(_task)
        java.lang.Thread.sleep(1000)


# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
admin_server_name = sys.argv[1]
admin_server_host = sys.argv[2]
admin_server_port = sys.argv[3]
admin_server_user = sys.argv[4]
admin_server_password = sys.argv[5]

print('executing the restart-managed-servers.py script...')
print('   admin server name:     %s' % admin_server_name)
print('   admin server host:     %s' % admin_server_host)
print('   admin server port:     %s' % admin_server_port)
print('   admin server user:     %s' % admin_server_user)
print('   admin server password: %s' % admin_server_password)

connect_to_server(admin_server_host, admin_server_port, admin_server_user, admin_server_password)
control_managed_servers(admin_server_name, 'stop')
control_managed_servers(admin_server_name, 'start')
print('all managed servers have been restarted successfully')
