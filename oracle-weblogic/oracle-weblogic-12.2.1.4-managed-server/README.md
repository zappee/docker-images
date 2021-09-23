# Oracle WebLogic Managed Server Docker Image

## 1) Image description
This is a _Oracle WebLogic Managed Server_ Docker image, built at the top of the [Oracle WebLogic 12.2.1.4](../oracle-weblogic-12.2.1.4) image.
Developers can use this image as the main building block of a WebLogic environment.
If you would like to jump into the deep water you can skip this document and continue with the [hello-weblogic-world](../hello-weblogic-world) which is a step-by-step guide explains how to dockerize an existing application running on WebLogic server using the  Remal's images.

## 2) Image overview
* The WebLogic Managed server will start automatically with the container.


* If the NodeManager is stopped or killed then the docker container will stop too because the main process that keeps alive the container is the NodeManager process.


* Multiply WebLogic Managed servers can be started parallelly. You can find examples under the [oracle-weblogic-12.2.1.4](../oracle-weblogic-12.2.1.4) project.


* The WebLogic Managed servers will join automatically to the WebLogic cluster without any additional configuration after they start.


* FIPS 140-2 is enabled in the managed server image. If you see in log the `<Changing the default Random Number Generator in RSA CryptoJ from ECDRBG128 to HMACDRBG. To disable this change, specify -Dweblogic.security.allowCryptoJDefaultPRNG=true.>` entry, then it means that the `FIPS 140-2` is enabled properly.


* The [Remal JMS-Message-Sender](https://github.com/zappee/jms-message-sender) command line tool to can be used to send text messages to JMS and SAF queues.


* Use the [Remal SQL-Runner](https://github.com/zappee/sql-runner) command line tool to execute SQL commands like `SELECT`, `INSERT`, `UPDATE` or `CREATE`.


* The `common-utils.sh` bash script contains reusable functions that can be used to
    * deploy an artifact (WAR, EAR) as an application
    * deploy an artifact (WAR, JAR) as a shared library
    * get value from a `*.properties` file
    * create a new database schema
    * execute SQL commands
    * run Liquibase and update your database


* Use the WebLogic lifecycle bash scripts to automate the application deployment.
    * `before-first-startup.sh`: executed once, before the first startup of the WebLogic Managed server
    * `before-startup.sh`: executed before each startup of the WebLogic Managed server

## 3) Build
1) Pull all the following images from the docker repository or build them locally:
    * [Remal Oracle Java 8](../../java/oracle-java-8) Docker image
    * [Remal Oracle WebLogic](../oracle-weblogic-12.2.1.4) Docker image

2) Build this image using:
    ```
    $ cd oracle-weblogic-12.2.1.4-managed-server
    $ ./build.sh
    ```

## 4) How to use this image
You can find multiply docker-compose sample files under the [oracle-weblogic-12.2.1.4](../oracle-weblogic-12.2.1.4) project.

## 5) WebLogic server lifecycle methods
The [WebLogic Admin Server](../oracle-weblogic-12.2.1.4-admin-server) and the WebLogic Managed Server Docker images help technicians to build scalable Oracle WebLogic environments and deploy/run application easily on WebLogic server.

The application deployment can be automated easily using the four built-in admin server lifecycle methods.
These lifecycle methods are actually bash scripts, and they can execute any Unix commands that you need in order to prepare the environment properly and deploy the application or applications.

The available WebLogic server lifecycle scripts in this Docker image:
1. `before-first-startup.sh`: executed once, before the first startup of the WebLogic Managed server
1. `before-startup.sh`: executed before each startup of the WebLogic Managed server

## 6) Block the server startup and wait for an event before continue
Often the Managed Server startup must be blocked and wait for the startup of the Admin server.

To handle this case or any similar situations, you can use the following script:
* `wait-for-admin-server.sh`

This example demonstrates the usage of the blocking scripts: [hello-weblogic-world](../hello-weblogic-world/docker-compose.yml)

## 7) Remal SQL-Runner command line tool
Please visit the [oracle-weblogic-12.2.1.4-admin-server](../oracle-weblogic-12.2.1.4-admin-server) project for more info.

## 8) Remal JMS-Message-Sender command line tool
Please visit the [oracle-weblogic-12.2.1.4-admin-server](../oracle-weblogic-12.2.1.4-admin-server) project for more info.

## 9) The `common-utils` bash library
Please visit the [oracle-weblogic-12.2.1.4-admin-server](../oracle-weblogic-12.2.1.4-admin-server) project for more info.

## 10) Environment variables used by the build
The WebLogic Managed server in the docker image is installed during the first startup of the docker container based on environment variables.
These variables have default values, but they can be changed before starting the build process.
In this section, you can find information about the variables and their default values.

Variables used in the `Dockerfile`:

| variables                   | default value         | description |
|-----------------------------|-----------------------|-------------|
| ADMIN_SERVER_HOST           | weblogic-admin-server | The hostname of the docker container where the WebLogic Admin server runs. |
| ADMIN_SERVER_NAME           | ADMIN_SERVER          | An alphanumeric name for this server instance. |
| ADMIN_SERVER_PORT           | 7001                  | The TCP port that this server uses to listen for regular (non-SSL) incoming connections. See `container_name` and `hostname` in the `docker-compose.yml` file. |
| CLASSPATH                   | $CLASSPATH:$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/app-config:$ORACLE_HOME/wlserver/server/lib/jcmFIPS.jar:$ORACLE_HOME/wlserver/server/lib/sslj.jar | The WebLogic managed server classpath. |
| CLUSTER_NAME                | DEV_CLUSTER           | The name of the WebLogic cluster. |
| DOMAIN_NAME                 | DEV_DOMAIN            | The name of the WebLogic cluster. |
| MANAGED_SERVER_JAVA_OPTIONS | -Dweblogic.rjvm.enableprotocolswitch=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4001 -XX:+UnlockCommercialFeatures -XX:+ResourceManagement -Djava.security.properties==$JAVA_HOME/jre/lib/security/java.security -Dweblogic.security.allowCryptoJDefaultJCEVerification=true | The JVM option used by the WebLogic managed server. |
| MANAGED_SERVER_NAME         | MANAGED_SERVER        | The name of the WebLogic Managed Server. It must be unique in the WebLogic domain. |
| MANAGED_SERVER_PORT         | 8001                  | The TCP port that this server uses to listen for regular (non-SSL) incoming connections.|
| NODE_MANAGER_PORT           | 5556                  | The Node Manager listen port.  |
| ORACLE_HOME                 | /home/oracle        | The home directory of the `oracle` user.  |
| PRODUCTION_MODE             | true                  | Boolean value, set it true if the production mode is used. |


## 11) How to dockerize an existing application
The [hello-weblogic-world](../hello-weblogic-world) is a project that shows the steps to dockerize an existing application running in WebLogic used the Remal Docker images and shows how to build an Admin and a Managed server images that contain a deployed application.

## 12) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
