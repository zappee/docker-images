# ******************************************************************************
#  WLST script for creating a new administration server in the WebLogic domain.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
import socket


# ------------------------------------------------------------------------------
# generate the cluster address based on the hostnames and port
# e.g. "managed1.company.com:8001,managed2.company.com:8001"
# ------------------------------------------------------------------------------
def build_cluster_address(_managed_server_hostnames, _managed_server_port):
    _hosts = [x.strip() for x in _managed_server_hostnames.split(',')]
    _result = ''
    _separator = ''

    for _host in _hosts:
        _result += _separator + _host + ':' + str(_managed_server_port)
        _separator = ','

    return _result


# ------------------------------------------------------------------------------
# reading the domain from template in offline mode
# ------------------------------------------------------------------------------
def read_domain_template(_oracle_home):
    print('reading the domain from the template...')
    readTemplate(_oracle_home + '/wlserver/common/templates/wls/wls.jar')


# ------------------------------------------------------------------------------
# create a new machine with node manager
# ------------------------------------------------------------------------------
def create_machine(_machine_name, _host, _node_manager_port):
    print('creating a new machine with name of \'' + _machine_name + '\'...')
    cd('/')
    create(_machine_name, 'UnixMachine')

    print('creating a new node-manager for \'' + _machine_name + '\'...')
    cd('/Machines/' + _machine_name)
    create(_machine_name, 'NodeManager')
    cd('NodeManager/' + _machine_name)
    set('NMType', 'Plain')
    set('ListenAddress', _host)
    set('ListenPort', _node_manager_port)
    set('DebugEnabled', 'false')


# ------------------------------------------------------------------------------
# create a new admin server
# ------------------------------------------------------------------------------
def create_admin_server(_domain_name, _admin_server_name, _admin_server_host, _admin_server_port, _machine_name):
    print('creating a new domain with name of \'' + _domain_name + '\'...')
    cd('/')
    set('Name', _domain_name)
    setOption('DomainName', _domain_name)
    create(_domain_name, 'Log')
    cd('/Log/' + _domain_name)
    set('FileName', 'logs/' + _domain_name + '.log')

    # configure the administration server
    print('configuring the \'' + _admin_server_name + '\' server...')
    cd('/Servers/AdminServer')
    #set('ListenAddress', _admin_server_host)
    set('ListenPort', _admin_server_port)
    set('Name', _admin_server_name)

    # username and password come from the boot.properties file
    cd('/Security/' + _domain_name + '/User/weblogic/')
    cmo.setName(username)
    cmo.setPassword(password)

    print('turning off the \'archiving weblogic configuration file\' flag...')
    cd('/')
    cmo.setConfigBackupEnabled(false)


# ------------------------------------------------------------------------------
# create a new cluster
# ------------------------------------------------------------------------------
def create_cluster(_cluster_name, _cluster_address):
    print('creating a new cluster with name of \'' + _cluster_name + '\'...')
    cd('/')
    create(_cluster_name, 'Cluster')
    cd('/Clusters/' + _cluster_name)
    cmo.setClusterAddress(_cluster_address)


# ------------------------------------------------------------------------------
# update the WebLogic console cookie name
# ------------------------------------------------------------------------------
def update_console_cookie_name(_domain_name):
    import random
    cookie_name = str(random.randint(10000, 99999)) + '_CONSOLESESSION'
    print("setting up the web console cookie for domain '%s' to '%s'..." % (_domain_name, cookie_name))
    cd('/')
    create(_domain_name, 'AdminConsole')
    cd('/AdminConsole/' + _domain_name)
    cmo.setCookieName(cookie_name)


# ------------------------------------------------------------------------------
# save the domain to disk
# ------------------------------------------------------------------------------
def save_domain(_domain_home, _production_mode_enabled):
    print('saving the domain...')
    setOption('OverwriteDomain', 'true')
    writeDomain(_domain_home)
    closeTemplate()

    print('updating the domain...')
    readDomain(_domain_home)
    cd('/')
    if _production_mode_enabled == "true":
        cmo.setProductionModeEnabled(true)
    else:
        cmo.setProductionModeEnabled(false)
    updateDomain()
    closeDomain()


# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
oracle_home = sys.argv[1]
admin_server_name = sys.argv[2]
admin_server_port = int(sys.argv[3])
domain_name = sys.argv[4]
cluster_name = sys.argv[5]
production_mode = sys.argv[6]
managed_server_port = int(sys.argv[7])
node_manager_port = int(sys.argv[8])
managed_server_hostnames = os.environ['MANAGED_SERVER_HOSTNAMES']
domain_home = '/home/oracle/user_projects/domains/%s' % domain_name
admin_server_host = socket.gethostname()
cluster_address = build_cluster_address(managed_server_hostnames, managed_server_port)
machine_name = admin_server_name + '_MACHINE'

print('executing the create-admin-server.py script...')
print('   oracle home:          %s' % oracle_home)
print('   admin server name:    %s' % admin_server_name)
print('   admin server host:    %s' % admin_server_host)
print('   admin server port:    %s' % admin_server_port)
print('   cluster name:         %s' % cluster_name)
print('   domain home:          %s' % domain_home)
print('   domain name:          %s' % domain_name)
print('   production mode:      %s' % production_mode)
print('   cluster address:      %s' % cluster_address)
print('   machine name:         %s' % machine_name)
print('   node manager port     %s' % node_manager_port)

read_domain_template(oracle_home)
create_machine(machine_name, admin_server_host, node_manager_port)
create_admin_server(domain_name, admin_server_name, admin_server_host, admin_server_port, machine_name)
create_cluster(cluster_name, cluster_address)
update_console_cookie_name(domain_name)
save_domain(domain_home, production_mode)
print('the \'' + admin_server_name + '\' server has been created successfully\n')
