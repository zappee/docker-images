# Remal Docker Image: Oracle WebLogic Administration Server

## 1) Image description
This is a _Oracle WebLogic Administration Server_ Docker image, built at the top of the [Oracle WebLogic 12.2.1.4](../oracle-weblogic-12.2.1.4) image.
Developers can use this image as the main building block of a WebLogic environment.
If you would like to jump into the deep water you can skip this document and continue with the [hello-weblogic-world](../hello-weblogic-world) which is a step-by-step guide explains how to dockerize an existing application running on WebLogic server using the Remal's images.

## 2) Image overview

* The WebLogic Admin server will start automatically with the container.


* A `tail` command keeps alive the container that shows the server log files.


* Multiply WebLogic Admin servers can be started parallely on the same host machine using one or multiply `docker-compose.yml`. You can find examples under the [oracle-weblogic-12.2.1.4](../oracle-weblogic-12.2.1.4) project.


* The current installation contains a WebLogic Cluster.


* The WebLogic Managed servers will join automatically to the cluster without any additional configuration after the start.


* The [Remal JMS-Message-Sender](https://github.com/zappee/jms-message-sender) command line tool to can be used to send text messages to JMS and SAF queues.


* Use the [Remal SQL-Runner](https://github.com/zappee/sql-runner) command line tool to execute SQL commands like `SELECT`, `INSERT`, `UPDATE` or `CREATE`.


* The `common-utils.sh` bash script contains reusable functions that can be used to
    * deploy an artifact (WAR, EAR) as an application
    * deploy an artifact (WAR, JAR) as a shared library
    * get value from a `*.properties` file
    * create a new database schema
    * execute SQL commands
    * run Liquibase and update your database
    * restart WebLogic admin and managed server


* Use the server lifecycle bash scripts to automate your application deployment. There are scripts that are executed before/after the server first start, before/after each server start and before/after the completely WebLogic domain start.


* The `WEB_CONSOLE_COLOR` variable can be used to customize the color of the WebLogic web console. This feature is useful when multiple WebLogic domains are started.


* Block the WebLogic server startup and wait for an event before continue with the `wait-for-*.sh` bash scripts.

## 3) Build
1) Pull all the following images from the docker repository or build them locally:
    * [Remal Oracle Java 8](../../java/oracle-java-8) Docker image
    * [Remal Oracle WebLogic](../oracle-weblogic-12.2.1.4) Docker image

2) Build this image using:
    ```
    $ cd oracle-weblogic-admin-server
    $ ./build.sh
    ```

## 4) How to use this image
You can find multiply docker-compose sample files under the [oracle-weblogic-12.2.1.4](../oracle-weblogic-12.2.1.4) project.

## 5) WebLogic server lifecycle methods
The WebLogic Admin Server and the [WebLogic Managed Server](../oracle-weblogic-12.2.1.4-managed-server) Docker images help technicians to build scalable Oracle WebLogic environments and deploy/run applications easily on WebLogic server.

The application deployment can be automated easily using the four built-in admin server lifecycle methods.
These lifecycle methods are actually bash scripts, and they can execute any Unix commands that you need in order to prepare the environment properly and deploy the application or applications.

The six server lifecycle scripts, and their execution order is the following:
1. `before-server-first-startup.sh`: executed once, before the first startup of the WebLogic Admin server
2. `before-server-startup.sh`: executed before each startup of the WebLogic Admin server
3. `after-server-first-startup.sh`: executed once, after the first startup of the WebLogic Admin server
4. `after-server-startup.sh`: executed after each startup of the WebLogic Admin server
5. `after-domain-first-startup.sh`: executed once, after the startup of the complete WebLogic Domain
6. `after-domain-startup.sh`: executed after the startup of the complete WebLogic Domain

## 6) Block the server startup and wait for an event before continue
In some special use cases, you need to block the startup of the WebLogic server (and the execution of the server lifecycle bash scripts) and wait for an event or the startup of another server.

The following use case is a good example that demonstrates when you need to block the WebLogic server startup:
* In the production environment we always use external database server (not the Oracle Database Docker Image).
  However, during the application development, each developer works on a separate Docker environment running everything on `localhost`.
  In the development environment usually the Oracle Database Docker Image is used with the Remal WebLogic Docker images, like in this sample [docker-compose.yml](../oracle-weblogic-12.2.1.4/docker-compose-with-database.yml).
  
  Unfortunately, the database server startup takes longer than the WebLogic server startup, so you may need to block the WebLogic startup until the database server is up and able to serve requests.
  Otherwise, e.g. the connection pool WLST deployment from the `after-domain-first-startup.sh` script will fail because the deployment will be executed before the database server able to serve requests.


You can block the WebLogic admin server startup with the `wait-for-database-server.sh` script and wait until the database server in the Docker container will be up and ready to serve requests.
You can also block the manager server startup and wait for the admin server using the `wait-for-admin-server.sh` script that is available in the managed server container.
Using the `wait-*.sh` scripts, you can solve all problems that are related to the parallel container startup.

Example:
```
version: '3'
services:
    weblogic-admin-server:
    image: docker/remal/oracle-weblogic-admin-12.2.1.4:2.0.0
    container_name: weblogic-admin-server
    hostname: weblogic-admin-server
    ports:
        - "7001:7001" # weblogic listening port
        - "4001:4001" # debug port
    depends_on:
        - "oracle-db"
    command: ["/home/oracle/wait-for-database-server.sh"]
    environment:
        - MANAGED_SERVER_HOSTNAMES=weblogic-managed-server-1, weblogic-managed-server-2

    weblogic-managed-server-1:
        image: docker/remal/oracle-weblogic-managed-12.2.1.4:2.0.0
        container_name: weblogic-managed-server-1
        hostname: weblogic-managed-server-1
        ports:
            - "8001:8001" # weblogic listening port
            - "5001:4001" # debug port
        depends_on:
            - "weblogic-admin-server"
        command: ["/home/oracle/wait-for-admin-server.sh"]
        environment:
            - ADMIN_SERVER_HOST=weblogic-admin-server
```

This example demonstrates the usage of the blocking scripts: [hello-weblogic-world](../hello-weblogic-world/docker-compose.yml)

## 7) Remal SQL-Runner command line tool
The `Remal SQL-Runner` is a small command-line tool written in Java and can be used on all platforms where Java is available.
The tool can be used to execute any SQL commands. It is suitable for executing SQL `SELECT`, `UPDATE`, `DELETE`, and `CREATE`.
You can use this tool to create a new database schema during the application deployment in the Docker environment and insert initial data into the databases.

This tool can be use from any WebLogic lifecycle script easily to prepare the database before the application deployment.

The tool is available in the image from the `/home/oracle/bin/sql-runner` directory.

For more info about the tool, please visit the tool's [homepage](https://github.com/zappee/sql-runner).

## 8) Remal JMS-Message-Sender command line tool
The Remal JMS-Message-Sender is a flexible command-line Java tool that can be used to send text messages to JMS Queue.
This is a command line tool can be run from bash or windows scripts and command line as well.

You can use this tool in the Docker environment to
* send test messages to any JMS queue
* test SAF connection
* simulate response messages coming from an external system while executing integration tests in docker
* etc.

The tool is available in the image, from the `/home/oracle/bin/jms-message-sender` directory.

For more info about the tool, please visit the tool's [homepage](https://github.com/zappee/jms-message-sender).

## 9) The `common-utils` bash library
The `common-utils` is a collection of bash functions that you can use from the server lifecycle scripts, mentioned in the previous chapters.
The functions simplify the usage of some often used commands like
* create a new Oracle database schema
* keep up to date your database schema with the [Liquibase](https://www.liquibase.org)
* execution of any SQL command
* execution of an external SQL/DDL file
* JAR, WAR, or EAR deployment to WebLogic server as a library or an application
* read values from a standard `*.properties` file
* restart WebLogic admin and managed server

In order to you can use bash functions, you need to include the `common-utils.sh` library to your bash script with the `source ./common-utils.sh` command.

The library locates under the `/home/oracle` directory.

### 9.1) Create an Oracle database schema
* Command: `createDbSchema <username> <password>`
* Parameters:
    * `username`: the new database user
    * `password`: password for the new database user
* Used environment variables:
    * `DB_HOST`: name of the database server
    * `DB_PORT`: number of the port where the server listens for requests
    * `DB_NAME`: name of the particular database on the server, also known as the SID in Oracle terminology
    * `DB_USER`: the connecting database user
    * `DB_PASSWORD`: password for the connecting user
* Example:
    ~~~
    $ DB_HOST=localhost
    $ DB_PORT=1521
    $ DB_NAME=ORCLPDB1.localdomain
    $ DB_USER=SYS as SYSDBA
    $ DB_PASSWORD=Oradoc_db1
    
    createDbSchema authorization password
    ~~~

### 9.2) SQL command executor
* Command: `sqlCommandExecutor <username> <password> <sql>`
* Parameters:
    * `username`: the schema user
    * `password`: password for the schema user
    * `sql`: the SQL command to be executed
* Used environment variables:
    * `DB_HOST`: name of the database server
    * `DB_PORT`: number of the port where the server listens for requests
    * `DB_NAME`: name of the particular database on the server, also known as the SID in Oracle terminology
* Example:
    ~~~
    $ DB_HOST=localhost
    $ DB_PORT=1521
    $ DB_NAME=ORCLPDB1.localdomain
    
    sqlCommandExecutor authorization password "INSERT INTO USER (username, email) VALUES ('Arnold Somogyi', 'arnold.somogyi@gmail.com')"
    ~~~

### 9.3) SQL script file executor
* Command: `sqlScriptFileExecutor <username> <password> <sql-script-file>`
* Parameters:
    * `username`: the schema user
    * `password`: password for the schema user
    * `sql-script-file`: path of the sql script file
* Used environment variables:
    * `DB_HOST`: name of the database server
    * `DB_PORT`: number of the port where the server listens for requests
    * `DB_NAME`: name of the particular database on the server, also known as the SID in Oracle terminology
* Example:
    ~~~
    $ DB_HOST=localhost
    $ DB_PORT=1521
    $ DB_NAME=ORCLPDB1.localdomain
    
    sqlCommandExecutor authorization password ../sql/init-db.sql
    ~~~

### 9.4) Liquibase executor
* Command: `executeLiquibase <directory>>`
* Parameters:
   * `directory`: the directory where the `pom.xml` that contains the Liquibase execution locates
* Example:
    ~~~
    executeLiquibase  $ORACLE_HOME/liquibase/liquibase-app
    ~~~

### 9.5) Application deployment with or without deployment plan
* Command: `deployApplication <artifact> <target1> <target2>`
* Parameters:
   * `artifact`: the file that will be deployed to the WebLogic cluster as an application
   * `target1`: deploying to one target
   * `target2`: optional parameter, deploying to more targets
* Used environment variables:
    * `ADMIN_SERVER_PORT`: the port of the T3 protocol
    * `ADMIN_SERVER_USER`: the user who has the proper access to the WebLogic server
    * `ADMIN_SERVER_PASSWORD`: the password for the connecting user
    * `CLUSTER_NAME`: the name of the WebLogic cluster
    * the hostname is always `localhost` because this function is called from the WebLogic Admin Server Docker container where the Admin Server runs
* Example:
    ~~~
    $ ADMIN_SERVER_PORT=7001
    $ ADMIN_SERVER_USER=weblogic
    $ ADMIN_SERVER_PASSWORD=weblogic12
    $ CLUSTER_NAME=DEV_CLUSTER
    
    deployApplication $ORACLE_HOME/bin/app/hello-0.1.0-SNAPSHOT.war $ADMIN_SERVER_NAME $CLUSTER_NAME
    ~~~

### 9.6) Shared library deployment
* Command: `deployLibrary <artifact>`
* Parameters:
   * `artifact`: the file that will be deployed to the WebLogic cluster as a library
* Used environment variables:
    * `ADMIN_SERVER_PORT`: the port of the T3 protocol
    * `ADMIN_SERVER_USER`: the user who has the proper access to the WebLogic server
    * `ADMIN_SERVER_PASSWORD`: the password for the connecting user
    * `CLUSTER_NAME`: the name of the WebLogic cluster
    * the hostname is always `localhost` because this function is called from the WebLogic Admin Server Docker container where the Admin Server runs
* Example:
    ~~~
    $ ADMIN_SERVER_PORT=7001
    $ ADMIN_SERVER_USER=weblogic
    $ ADMIN_SERVER_PASSWORD=weblogic12
    $ CLUSTER_NAME=DEV_CLUSTER
    
    deployLibrary $ORACLE_HOME/bin/app/hello-common-0.1.0-SNAPSHOT.jar
    ~~~

### 8.7) Read value from properties file
* Command: `getValue <properties-file> <key>`
* Parameters:
    * `properties-file`: the *.properties file
    * `key`: the key in the file
* Example:
    ~~~
    PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
    USERNAME=$(getValue $PROPERTIES_FILE "username")
    PASSWORD=$(getValue $PROPERTIES_FILE "password")
    ~~~

## 10) Environment variables used by the build
The WebLogic Admin server in the docker image is installed during the first startup of the docker container based on environment variables.
These variables have default values, but they can be changed before starting the image build process.
In this section, you can find information about the variables and their default values.

Variables used in the `Dockerfile`:

| variables                 | default value | description |
|---------------------------|---------------|-------------|
| ADMIN_SERVER_JAVA_OPTIONS | -Dweblogic.rjvm.enableprotocolswitch=true -Dweblogic.data.canTransferAnyFile=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4001 -XX:+UnlockCommercialFeatures -XX:+ResourceManagement | The WebLogic admin server classpath. |
| ADMIN_SERVER_NAME         | ADMIN_SERVER  | An alphanumeric name for this server instance. |
| ADMIN_SERVER_PORT         | 7001          | The TCP port that this server uses to listen for regular (non-SSL) incoming connections. |
| CLUSTER_NAME              | DEV_CLUSTER   | The name of the WebLogic cluster. |
| DOMAIN_NAME               | DEV_DOMAIN    | The name of the WebLogic cluster. |
| ORACLE_HOME               | /home/oracle  | The home directory of the `oracle` user. |
| PRODUCTION_MODE           | true          | Boolean value, set it true if the production mode is used. |

## 11) How to dockerize an existing application
The [hello-weblogic-world](../hello-weblogic-world) is a project that shows the steps to dockerize an existing application running in WebLogic used the Remal Docker images and shows how to build an Admin and a Managed server images that contain a deployed application.

## 12) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
