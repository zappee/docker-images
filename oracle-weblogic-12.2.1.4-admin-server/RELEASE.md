# Release info

All notable changes to this project will be documented in this file.

## [weblogic-admin-12.2.1.4:1.0.0] - 20/Feb/2021
#### Added
* Use the latest `weblogic-12.2.1.4:1.0.0` image.
* Set the console cookie name in order to avoid cookie collision when multiple WebLogic consoles are opened in the same web browser.
* WebLogic web console color customization: `WEB_CONSOLE_COLOR` environment variable can be used in the docker-compose file.
* use fix hostnames for containers instead of using randomly generated names: `container_name` vs. `hostname`.
* Create the admin server during the first startUP of the container.
* Turning off the `archiving WebLogic configuration file` flag to prevent losing the server state between the container stop and start.
* FIPS 140-2 is not installed on the admin server. It is only installed on the managed server, so applications can be deployed to the Admin server where there is no FIPS configured.
* The `upload` directory for sharing files between the host and Docker container was moved to the `java-8` image because this directory is common for each image.
* Move the `jms-message-sender` tool to the `oracle-weblogic` image.
* Move the `sql-runner` tool to the `oracle-weblogic` image.
* Move Oracle JDBC driver to the `oracle-weblogic` image.
* Add a function that removes dangling images after the build.
* Add an independent `wait-for-database` script instead of using a hardcoded solution. Sometimes we use an external database so blocking the WebLogic server startup until the database is up is not always necessary.
* Add `before-first-startup.sh` script. It is executed once, before the first startup of the WebLogic admin server.
* Add `before-startup.sh` script. It is executed before each startup of the WebLogic admin server.
* Add `after-first-startup.sh` script. It is executed once, after the first startup of the WebLogic admin server.
* Add `after-startup.sh` script. It is executed after each startup of the WebLogic admin server
