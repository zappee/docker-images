# Remal Docker Image: Oracle WebLogic Server 12.2.1.4.0 Docker Image

## 1) Image description
The image is based on the Remal [`oracle-java-8`](../../java/oracle-java-8) image and can only be used for extension.

The image contains
* a fresh installation of the WebLogic Server 12.2.1.4.0
* Remal JMS-Message-Sender command line tool, for more information please visit the [official page](https://github.com/zappee/jms-message-sender)
* Remal SQL-Runner command line tool, for more information please visit the [official page](https://github.com/zappee/sql-runner)

## 2) Build
1. Download the _Developer installer of the Oracle WebLogic 12.2.1.4.0_ (`fmw_12.2.1.4.0_wls_Disk1_1of1.zip`) from [Oracle](https://download.oracle.com/otn/nt/middleware/12c/122140/fmw_12.2.1.4.0_wls_Disk1_1of1.zip).
2. Copy the downloaded file into the `bin` directory.
3. Build the image using:
    ~~~
    $ cd oracle-weblogic-12.2.1.4
    $ ./build.sh
    ~~~

## 3) Usage

This WebLogic image can only be used as a base image of the [Oracle WebLogic Admin server](../oracle-weblogic-12.2.1.4-admin-server) and [Managed server](../oracle-weblogic-12.2.1.4-managed-server) images.
However, in some special cases, you may need to deploy this image and login into the container.
In this situation the following commands will help.

* Run the image
  * `docker run --name weblogic-12.2.1.4 -d docker/remal/oracle-weblogic-12.2.1.4:2.0.0 tail -f /dev/null`


* Login into the running container
   * as an ordinary user: `docker exec -it weblogic-12.2.1.4 /bin/bash`
   * as root: `docker exec -it -u root -w /root weblogic-12.2.1.4 /bin/bash`


* Start a single WebLogic domain with two managed servers
  * Command: `docker-compose up`
  * WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
  * WebLogic credentials: `weblogic`/`weblogic12`


* Start multiply WebLogic domains with managed servers
  * Command: `docker-compose -f docker-compose-multiserver.yml up`
  * WebLogic Domain-1 console URL: [http://localhost:7101/console](http://localhost:7101/console)
  * WebLogic Domain-2 console URL: [http://localhost:7201/console](http://localhost:7201/console)
  * WebLogic credentials: `weblogic`/`weblogic12`


* Start a single WebLogic domain with two managed servers + Oracle Database Server
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
> _They contain useful information about the usage of the images._
> 
> _If you do not want to jump into the middle, check the [hello-weblogic-world](../hello-weblogic-world) project that is a step-by-step guide that demonstrates how to dockerize an existing WebLogic application using the Remal Docker images._

## 4) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2022 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

## Appendix 1) Oracle WLST tool
* Open a WLST console:
   1. Log in to the container: `docker exec -it WL /bin/bash`
   2. Set the environment variables: `. /home/oracle/wlserver/server/bin/setWLSEnv.sh`
   3. Start WLST: `java weblogic.WLST` 


* Connect to server
   * Online mode: `connect('weblogic', 'weblogic12', 't3://localhost:7001')`
   * Offline mode: `readDomain('/home/oracle/user_projects/domains/DEV_DOMAIN')`

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
