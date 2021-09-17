# Oracle WebLogic Server 12.2.1.4.0 Docker Image

## 1) Image Description
The image is based on the Remal [`oracle-java-8`](../oracle-java-8) image and can only be used for extension.

The image contains
* a fresh installation of WebLogic Server 12.2.1.4.0
* JMS-Message-Sender command line tool, for more information please visit the [official page](https://github.com/zappee/jms-message-sender)
* SQL-Runner command line tool, for more information please visit the [official page](https://github.com/zappee/sql-runner)

## 2) Build
1. Download the _Developer installer of the Oracle WebLogic 12.2.1.4.0_ (`fmw_12.2.1.4.0_wls_Disk1_1of1.zip`) from [Oracle](https://download.oracle.com/otn/nt/middleware/12c/122140/fmw_12.2.1.4.0_wls_Disk1_1of1.zip).
1. Copy the downloaded file into the `bin` directory.
1. Build the image using:
    ~~~
    $ cd oracle-weblogic-12.2.1.4
    $ ./build.sh
    ~~~

## 3) Usage
__WebLogic image__

This WebLogic image can only be used as a base image of the [Oracle WebLogic Admin server](../oracle-weblogic-12.2.1.4-admin-server) and [Managed server](../oracle-weblogic-12.2.1.4-managed-server) images.
However, in some special cases, you may need to deploy this image and login into the container.
In this situation the following commands will help you.

* Run the image
  * `docker run --name weblogic-12.2.1.4 -d docker/images/oracle-weblogic/weblogic-12.2.1.4:1.0.0 tail -f /dev/null`


* Login into the running container
   * as an ordinary user: `docker exec -it weblogic-12.2.1.4 /bin/bash`
   * as root: `docker exec -it -u root -w /root weblogic-12.2.1.4 /bin/bash`

__Start a single WebLogic domain with two managed servers__
* Command: `docker-compuse up`
* WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
* WebLogic credentials: `weblogic`/`weblogic12`

__Start multiply WebLogic domains with managed servers__
* Command: `docker-compose -f docker-compose-multiserver.yml  up`
* WebLogic Domain-1 console URL: [http://localhost:7101/console](http://localhost:7101/console)
* WebLogic Domain-2 console URL: [http://localhost:7201/console](http://localhost:7201/console)
* WebLogic credentials: `weblogic`/`weblogic12`

This docker compose file demonstrates how to customize the WebLogic console via the `WEB_CONSOLE_COLOR` variable and how to use the WebLogic lifecycle methods mentioned [here](../oracle-weblogic-12.2.1.4-admin-server).

__Start a single WebLogic domain with two managed servers + Oracle Database Server__
* Command: `docker-compose -f docker-compose-with-database.yml up`
* WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
* WebLogic credentials: `weblogic`/`weblogic12`
* Oracle Database listening port: `1521`
* Oracle Database SYSDBA connection parameters
  * Database: `ORCLPDB1.localdomain`
  * User: `SYS as SYSDBA`
  * Password: `Oradoc_db1`
* Oracle Database JDBC URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain`

> _Info: Before you start working with the Remal WebLogic images, please have a look at the documentation of the [Oracle WebLogic Admin server](../oracle-weblogic-12.2.1.4-admin-server) and [Managed server](../oracle-weblogic-12.2.1.4-managed-server) images._
> _They contain useful information about the usege of the images._
> 
> _If you do not want to read a lot, check the [hello-weblogic-world](../hello-weblogic-world) project that is actually a step-by-step guide how to dockerize an existing WebLogic application using the Remal Docker image._

## 4) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

## Appendix 1) Oracle WLST tool
* Open a WLST console:
   1. Log in to the container: `docker exec -it WL /bin/bash`
   1. Set the environment variables: `. /home/oracle/wlserver/server/bin/setWLSEnv.sh`
   1. Start WLST: `java weblogic.WLST` 

* Connect to server
   * Online mode: `connect('weblogic', 'weblogic12', 't3://localhost:7001')`
   * Offline mode: `readDomain('/home/oracle/user_projects/domains/DEV_DOMAIN')`
