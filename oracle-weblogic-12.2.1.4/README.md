# Oracle WebLogic Server 12.2.1.4.0 Docker Image

## 1) Image Description
The image is based on [`oracle-java-8`](../oracle-java-8) and can only be used for extension.

The image contains
* a fresh installation of WebLogic Server 12.2.1.4.0
* JMS-Message-Sender command line tool, for more information please visit the [official page](https://github.com/zappee/jms-message-sender)
* SQL-Runner command line tool, for more information please visit the [official page](https://github.com/zappee/sql-runner)

## 2) Build
1. Download the _Developer installer of the Oracle WebLogic 12.2.1.4.0_ (`fmw_12.2.1.4.0_wls_Disk1_1of1.zip`) from [Oracle](https://download.oracle.com/otn/nt/middleware/12c/122140/fmw_12.2.1.4.0_wls_Disk1_1of1.zip).
1. Copy all downloaded files into the `bin` directory.
1. Build the image using:
    ~~~
    $ cd oracle-weblogic-12.2.1.4
    $ ./build.sh
    ~~~

## 3) How to use the image
This image can only be used as a base image of the _Oracle WebLogic Admin and Managed server_ images.
However, in some special cases, you may need to deploy this image and login into the container.
In thi situation the following commands will help you.

* Run the image
  * `docker run --name weblogic-12.2.1.4 -d docker/images/oracle-weblogic/weblogic-12.2.1.4:1.0.0 tail -f /dev/null`

* Login into the running container
   * as an ordinary user: `docker exec -it weblogic-12.2.1.4 /bin/bash`
   * as root: `docker exec -it -u root -w /root weblogic-12.2.1.4 /bin/bash`

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