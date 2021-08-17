# Release info

All notable changes to this project will be documented in this file.

## [1.3] - not released yet
#### Added
* Swithc between internal and external database: `CREATE_DATABASE=true`
#### Known issues
* ISSUE-1: WebLogic domain must be restarted after the first start because the ECAS Authentication Provider deployment required this:
  ~~~
  <BEA-141239> <The non-dynamic attribute AuthenticationProviders on weblogic.management.security.RealmMBeanImpl@46f50669([DEV_DOMAIN]/SecurityConfiguration[DEV_DOMAIN]/Realms[myrealm]) has been changed. This may require redeploying or rebooting configured entities.>
  <BEA-141238> <A non-dynamic change has been made which affects the server ADMIN_SERVER. This server must be rebooted in order to consume this change.>
  <BEA-141239> <The non-dynamic attribute AuthenticationProviders on weblogic.management.security.RealmMBeanImpl@46f50669([DEV_DOMAIN]/SecurityConfiguration[DEV_DOMAIN]/Realms[myrealm]) has been changed. This may require redeploying or rebooting configured entities.> 
  ~~~

  * Solution: WLST offline mode must be use for ECAS Authenticator install before the server start.
  * Workaround: `docker-compose restart eutl-weblogic-admin-server eutl-weblogic-managed-server-1`
* ISSUE-3: remove the unused `oracle-weblogic-managed-server/properties/tms-ws/ecas-config-tms-ws.properties` file. After the remove the application the regression test must be executed.
