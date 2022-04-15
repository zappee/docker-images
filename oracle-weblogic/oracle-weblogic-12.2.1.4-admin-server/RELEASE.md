# Release info

All notable changes to this project will be documented in this file.

## [weblogic-admin-12.2.1.4:1.0.0] - 20/Feb/2021
#### Added
* Use the `weblogic-12.2.1.4:1.0.0` image as the base image.
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
* Extract the hardcoded _wait for database_ function to the `wait-for-database.sh` script. This can be used when we use an external database with the WebLogic Images so blocking the WebLogic server startup is necessary until the database server is up and ready to receive requests.
* Add `before-first-startup.sh` script that is executed once, before the first startup of the WebLogic admin server.
* Add `before-startup.sh` script that is executed before each startup of the WebLogic admin server.
* Add `after-first-startup.sh` script that is executed once, after the first startup of the WebLogic admin server.
* Add `after-startup.sh` script that is executed after each startup of the WebLogic admin server

## [weblogic-admin-12.2.1.4:1.1.0] - 15/April/2022
#### Modified
* Use the latest `weblogic-12.2.1.4:1.1.0` image.
* Improvements in bash scripts: better naming conventions for functions and variables, quoting properly, etc. 
* Improvements in python scripts.
* Simplify the container startup.
* Modify the WebLogic Admin server startup.
* Redirect the Unix standard error to standard out in order for the error messages can appear on the Docker log.
* Fixing issues in the `common-utils.sh` bash script.
* Rename the srver lifecycle scripts
  * `before-first-startup.sh` to `before-server-first-startup.sh`
  * `before-startup.sh` to `before-server-startup.sh`
  * `after-first-startup.sh` to `after-server-first-startup.sh`
  * `after-startup.sh` to `after-server-startup.sh`
#### Added
* Use `tail -F ...` command to shows the server log files on the docker log and keep alive the container.
* Add a new diagram that shows the server startup flow.
* Generate a WebLogic Domain Server Template JAR during the first startup that is used to create a Managed Server.
* Share the Domain Template JAR between containers via Docker network using Netcat.
* Add Node Manager for the Admin server.
* Add two new lifecycle methods: `after-domain-first-startup.sh`, `after-domain-startup.sh`.
* Set the Java options and classpath for the servers started by Node Manager.
* Set username and password for the servers started by Node Manager.
#### Removed
* Delete the following scripts: `execute-afters.sh`, `execute-before-first-startup.sh`, `execute-before-startup.sh`, `updateAdminConsoleColor.sh`, `updateConsoleCookieName.sh`, `wait-for-admin-server.sh`, `wait-fod-database-and-managed-server.sh`, `wait-for-managed-server.sh`.
#### Migration
* Use the new `after-domain-first-startup.sh` server lifecycle script to deploy applications instead of the old `after-first-startup.sh`.
  You just need to rename your bash file, and it will work properly.
* Add the `MANAGED_SERVER_HOSTNAMES` environment variable to your docker compose file.
* Remove the unused `MANAGED_SERVER_NAME` environment variable  from your docker compose file.
* Remove the `command` section from your docker compose file.
* Orrder your container startup order properly with  `depends_on` in your docker compose file.
