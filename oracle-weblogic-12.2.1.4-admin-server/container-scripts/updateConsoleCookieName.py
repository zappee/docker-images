# ******************************************************************************
# WLST script for updating the WebLogic console cookie name.
#
# WebLogic Console: Domain > Configuration > General > Advanced Settings >
#          Console Cookie Name
#
# Since : January, 2021
# Author: Arnold Somogyi <arnold.somogyi@ext.ec.europa.eu>
#
# ******************************************************************************

# ------------------------------------------------------------------------------
# update console cookie name
# ------------------------------------------------------------------------------
def updateConsoleCookieName(_domainHome, _domainName):
    import random
    _cookieName = str(random.randint(10000, 99999)) + '_CONSOLESESSION'
    print("updating web console cookie name to '%s' for '%s', domain home: %s..." % (_cookieName, _domainName, _domainHome))

    try:
        readDomain(_domainHome)
        create(_domainName,'AdminConsole')
    finally:
        cd('/AdminConsole/' + _domainName)
        cmo.setCookieName(_cookieName)
        updateDomain()
        closeDomain()

    print("web console cookie name has been set")

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
oracleHome = sys.argv[1]
domainName = sys.argv[2]
domainHome = oracleHome + '/user_projects/domains/' + domainName
updateConsoleCookieName(domainHome, domainName)
