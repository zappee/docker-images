# ******************************************************************************
#  WLST script for enroll the NodeManager using nmEnroll() command.
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
# start a new edit session
# ------------------------------------------------------------------------------
def lock_and_edit():
    _wait_time_in_millis = 300000
    _timeout_in_millis = 90000
    edit()
    startEdit(_wait_time_in_millis, _timeout_in_millis, 'True')


# ------------------------------------------------------------------------------
# enroll the NodeManager
# ------------------------------------------------------------------------------
def enroll_node_manager(_oracle_home, _domain_name):
    nmEnroll(_oracle_home + '/user_projects/domains/' + _domain_name, _oracle_home + '/user_projects/domains/' + _domain_name + '/nodemanager')


# ------------------------------------------------------------------------------
# This command enrolls the computer on which WLST is running with the domain
# of the administration server to which WLST is connected. What "enrolling"
# means is the command downloads two files from the administration server to
# this computer: nm_password.properties and SerializedSystemIni.dat.
#
# The Node Manager "secret file," nm_password.properties, contains the
# encrypted username and password used by the adminstration server to
# authenticate itself to the Node Manager process. This file is placed in the
# domain directory under /config/nodemanager/.
#
# The file used for encryption and decryption, SerializedSystemIni.dat, is
# placed in the domain directory under /security/.
#
# In addition, the nmEnroll() command creates or updates the nodemanager.domains
# file found in the Node Manager home directory. It adds the current domain to
# the list of domains that this Node Manager is allowed to manage.
#
# The nmEnroll() command has two arguments:
#    1: The domain home directory on this computer
#    2: The Node Manager home directory on this computer
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
oracle_home = sys.argv[5]
domain_name = sys.argv[6]

print('executing the enroll-node-manager.py script...')
print('   admin server host:     %s' % admin_server_host)
print('   admin server port:     %s' % admin_server_port)
print('   admin server user:     %s' % admin_server_user)
print('   admin server password: %s' % admin_server_password)
print('   oracle home:           %s' % oracle_home)
print('   domain name:           %s' % domain_name)

connect_to_server(admin_server_host, admin_server_port, admin_server_user, admin_server_password)
lock_and_edit()
enroll_node_manager(oracle_home, domain_name)
save_changes()
print('the node manager has been enrolled successfully')
