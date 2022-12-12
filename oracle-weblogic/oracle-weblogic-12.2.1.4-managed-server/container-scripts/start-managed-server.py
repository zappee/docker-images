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
# start the server
# ------------------------------------------------------------------------------
def start_managed_server(_managed_server_name):
    start(managed_server_name, 'Server')


# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
admin_server_host = sys.argv[1]
admin_server_port = sys.argv[2]
admin_server_user = sys.argv[3]
admin_server_password = sys.argv[4]
managed_server_name = sys.argv[5]


print('executing the start-managed-server.py script...')
print('   admin server host:     %s' % admin_server_host)
print('   admin server port:     %s' % admin_server_port)
print('   admin server user:     %s' % admin_server_user)
print('   admin server password: %s' % admin_server_password)
print('   managed server name    %s' % managed_server_name)

connect_to_server(admin_server_host, admin_server_port, admin_server_user, admin_server_password)
start_managed_server(managed_server_name)
print('managed server has been started successfully')
