# ******************************************************************************
#  WLST script that updates the managed server configuration.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
import os


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
    startEdit(_wait_time_in_millis, _timeout_in_millis, 'False')


# ------------------------------------------------------------------------------
# update the server configuration i.e. username, password, classpath
# and JVM arguments
# ------------------------------------------------------------------------------
def update_server_config(_managed_server_name,
                         _managed_server_username,
                         _managed_server_password,
                         _managed_server_classpath,
                         _managed_server_arguments):

    print('setting java options and classpath for \'' + _managed_server_name + '\' started by Node Manager...')

    try:
        cd('/Servers/' + _managed_server_name + '/ServerStart/' + _managed_server_name)
        cmo.setClassPath(_managed_server_classpath)
        cmo.setArguments(_managed_server_arguments)

        print('setting username and password for \'' + _managed_server_name + '\', started by Node Manager...')
        cmo.setUsername(_managed_server_username)
        cmo.setPassword(_managed_server_password)
    except Exception, e:
        print('[ERROR] An unexpected error appeared while trying to configure the ' + _managed_server_name + '.')
        print('[ERROR] Probably the Admin server configuration that you use is wrong.')
        print('[ERROR] Please check the MANAGED_SERVER_HOSTNAMES environment variable in your *.yml file.')
        print e
        print('\n')


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
managed_server_username = sys.argv[6]
managed_server_password = sys.argv[7]
managed_server_classpath = os.environ['ACLASSPATH']
managed_server_arguments = os.environ['MANAGED_SERVER_JAVA_OPTIONS']

print('executing the update-managed-server-config.py script...')
print('   admin server host:        %s' % admin_server_host)
print('   admin server port:        %s' % admin_server_port)
print('   admin server user:        %s' % admin_server_user)
print('   admin server password:    %s' % admin_server_password)
print('   managed server name:      %s' % managed_server_name)
print('   managed server username:  %s' % managed_server_username)
print('   managed server password:  %s' % managed_server_password)
print('   managed server classpath: %s' % managed_server_classpath)
print('   managed server arguments: %s' % managed_server_arguments)

connect_to_server(admin_server_host, admin_server_port, admin_server_user, admin_server_password)
lock_and_edit()
update_server_config(managed_server_name,
                     managed_server_username,
                     managed_server_password,
                     managed_server_classpath,
                     managed_server_arguments)
save_changes()
print('the managed server configuration has been updated successfully')
