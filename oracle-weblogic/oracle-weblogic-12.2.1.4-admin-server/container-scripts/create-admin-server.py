# ******************************************************************************
# WLST script for creating a new administration server in the WebLogic domain.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# create a new admin server
# ------------------------------------------------------------------------------
def createAdminServer(_oracleHome, _domainName, _adminServerName, _adminServerPort):
    print('creating a new domain...')
    readTemplate(_oracleHome + '/wlserver/common/templates/wls/wls.jar')
    set('Name', _domainName)
    setOption('DomainName', _domainName)
    create(_domainName,'Log')
    cd('/Log/%s' % _domainName);
    set('FileName', 'logs/' + _domainName + '.log')

    # configure the administration server
    print('configuring the administration server...')
    cd('/Servers/AdminServer')
    set('ListenPort', _adminServerPort)
    set('Name', _adminServerName)

    # username and password come from the boot.properties file
    cd('/Security/' + _domainName + '/User/weblogic/')
    cmo.setName(username)
    cmo.setPassword(password)

    print('turning off the \'archiving weblogic configuration file\' flag...')
    cd('/')
    cmo.setConfigBackupEnabled(false)

# ------------------------------------------------------------------------------
# create a new cluster
# ------------------------------------------------------------------------------
def createCluster(_clusterName):
    print('creating a new cluster...')
    cd('/')
    create(_clusterName, 'Cluster')

# ------------------------------------------------------------------------------
# save domain to disk
# ------------------------------------------------------------------------------
def saveDomain(_domainHome, _productionModeEnabled):
    print('saving the domain...')
    setOption('OverwriteDomain', 'true')
    writeDomain(_domainHome)
    closeTemplate()

    print('updating the domain...')
    readDomain(_domainHome)
    cd('/')
    if _productionModeEnabled == "true":
        cmo.setProductionModeEnabled(true)
    else:
        cmo.setProductionModeEnabled(false)
    updateDomain()
    closeDomain()

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
oracleHome = sys.argv[1]
adminServerName = sys.argv[2]
adminServerPort = int(sys.argv[3])
domainName = sys.argv[4]
clusterName = sys.argv[5]
productionMode = sys.argv[6]
domainHome = '/home/oracle/user_projects/domains/%s' % domainName

print('oracle home:       %s' % oracleHome)
print('admin server name: %s' % adminServerName)
print('admin server port: %s' % adminServerPort)
print('cluster name:      %s' % clusterName)
print('domain home:       %s' % domainHome)
print('domain name:       %s' % domainName)
print('production mode:   %s' % productionMode)

createAdminServer(oracleHome, domainName, adminServerName, adminServerPort)
createCluster(clusterName)
saveDomain(domainHome, productionMode)

print('admin server has been created successfully')
