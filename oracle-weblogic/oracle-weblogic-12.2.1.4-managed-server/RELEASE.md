# Release info

All notable changes to this project will be documented in this file.

## [weblogic-managed-12.2.1.4:1.0.0] - 25/Feb/2021
#### Modified
* Use `unix-machine` instead of general `machine` while creating a WebLogic machine.
* Fix FiPS installation issue.
  * Check whether fips is installed properly or not: `grep -i 'rsa crypto'`.
  * Expected result: `Changing the default Random Number Generator in RSA CryptoJ from ECDRBG128 to HMACDRBG.`
#### Added
* Remove dangling image after the build.
* Add the `before-first-startup.sh` WebLogic lifecycle script: it is executed once, before the first startup of the WebLogic managed server.
* Add the `before-startup.sh` WebLogic lifecycle script: it is executed before each startup of the WebLogic managed server.
#### Removed
* The `upload` directory for sharing files between the host and Docker container was moved to the `java-8` image because this directory is needed for each image.
#### Known issues
* ISSUE-100: A `java.net.ConnectException: Connection refused` exception appears when not the default 7001 admin port is used
  It seems that this is a WebLogic web console bug. I have raised a ticket on the official [Oracle Docker Image Git Repository](https://github.com/oracle/docker-images/issues/1860).  
  The workaround is the following:
  1. Check the IP address of the admin-server container with `docker inspect <container-name>`
  1. Open the WL console using the container private IP address, e.g.: http://172.19.0.2:7001/console
  1. In this case, the exception does not appear.

* ISSUE-101: During the first start of the WebLogic Managed Server Docker Image the Managed Server startup must be blocked until all the running WLST scripts started by the Admin Server finish properly.
  This can cause an issue that is related to opening and committing WLST edit sessions parallely.
  For example, if the Admin Server image starts a WLST edit session (executes WLST script using online-mode) and at the same time the Managed Server also starts a new WLST edit session then a session commit (either comes from Admin or Managed server) will close all opened WLST edit sessions despite not all of them finished yet.

## [weblogic-managed-12.2.1.4:2.0.0] - 13/Jun/2022
### Modified
* Use the latest `weblogic-12.2.1.4:2.0.0` image.
* Improvements in bash scripts: better naming conventions for functions and variables, quoting properly, etc.
* Improvements in python scripts.
* Simplify the container startup.
* Modify the WebLogic Managed server startup flow.
* Redirect the Unix standard error to standard out in order for the error messages can appear on the Docker log.
* Fixing issues in the `common-utils.sh` bash script.
* Rename the server lifecycle scripts
  * `before-first-startup.sh` to `before-server-first-startup.sh`
  * `before-startup.sh` to `before-server-startup.sh`
* Fix Node Manager misconfiguration.
* Start the Managed Server with Node Manager.
* Improvement in `common-utils.sh`: deploy application with or without `plan.xml` file.
#### Added
* Use `tail -F ...` command to shows the server log files on the docker
* The `tail` process keeps alive the container.
* Add a new diagram that shows the server startup flow.
* Use the WebLogic Domain Server Template JAR to install the Managed Server.
* Download the Server Template JAR directly from the Admin Docker container with `Netcat`.
* Set the Java options and classpath for the servers started by Node Manager.
* Set username and password for the servers started by Node Manager.
* Add a new feature to the `common-utils.sh` bash script that can be used to restart all managed servers
#### Removed
* Delete the following bash scripts: `startWeblogic.sh`, `create-admin-server.py`
* Delete the following scripts: `startWebLogic.sh`, `create-admin-server.py`, `create-managed-server.py`.
#### Migration
* Use the new `after-domain-first-startup.sh` server lifecycle script to deploy the applications instead of the `after-first-startup.sh`.
  You just need to rename your bash file, and it will work properly.
* Add the `MANAGED_SERVER_HOSTNAMES` environment variable to your docker compose file.
* Remove the unused `MANAGED_SERVER_NAME` environment variable from your docker compose file.
* Update the `command` section in your docker compose file.
* Ordering your container startup properly with the `depends_on` in your docker compose file.

## [weblogic-managed-12.2.1.4:2.0.1] - 30/Aug/2022
### Modified
* Use the latest `weblogic-12.2.1.4:2.0.1` image.
* Fix a path issue that appears while downloading the `domain-template.jar` from the `admin-server`.

  `/home/oracle/wlserver/common/templates/domain//DEV_DOMAIN-template.jar` -> `/home/oracle/wlserver/common/templates/domain/DEV_DOMAIN-template.jar`
* Fix a typo in the name of the server log: `MANAGED_SERVER_NAME.nohup` > `MANAGED_SERVER_NAME.out`
