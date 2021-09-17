# Release info

All notable changes to this project will be documented in this file.

## [weblogic-admin-12.2.1.4:1.0.0] - 20/Feb/2021
#### Added
* Use the latest `weblogic-12.2.1.4:1.0.0` image as the base image.
* Customize the console cookie name in order to avoid cookie collision when multiple WebLogic consoles are opened in the same web browser.
* WebLogic web console color customization: `WEB_CONSOLE_COLOR` environment variable can be used in the docker-compose file.
* Use fix hostnames for containers instead of using randomly generated names: `container_name` vs. `hostname`.
* Create the admin server during the first startup of the container.
* Turning off the `archiving WebLogic configuration file` flag to prevent losing the server state between the container stop and start.
* FIPS 140-2 is not installed in the admin server. It is only installed on the managed server, so applications deployed to the Admin server will not use FIPS.
* The `upload` directory for sharing files between the host and Docker container was moved to the `java-8` image because this directory is common for each image.
* Move the Remal `jms-message-sender` tool to the parent `oracle-weblogic` image.
* Move the Remal `sql-runner` tool to the parent `oracle-weblogic` image.
* Move Oracle JDBC driver to the parent `oracle-weblogic` image.
* Add a function that removes dangling images after the image build.
* Extract the hardcoded _wait for database_ function to the `wait-for-database.sh` script. This can be used when an external database is used so blocking the WebLogic server startup is necessary until the database server is up and ready to receive requests.
* Add `before-first-startup.sh` script that is executed once, before the first startup of the WebLogic admin server.
* Add `before-startup.sh` script that is executed before each startup of the WebLogic admin server.
* Add `after-first-startup.sh` script that is executed once, after the first startup of the WebLogic admin server.
* Add `after-startup.sh` script that is executed after each startup of the WebLogic admin server
