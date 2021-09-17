# Oracle WebLogic Admin Server Docker Image

## 1) Image Description
This is a _Oracle WebLogic Administration Server_ Docker image, built at the top of the [Oracle WebLogic 12.2.1.4](/oracle-weblogic-12.2.1.4) image.
Developers can use this image as the main building block of a WebLogic environment.
If you would like to jump into the deep water you can skip this document and continue with the [hello-weblogic-world](../hello-weblogic-world) which is a step-by-step guide explains how to dockerize an existing application running on WebLogic server using the  Remal's images.

## 2) Image overview

* The WebLogic Admin server will start automatically with the container.


* If the WebLogic admin server is stopped or killed then the docker container will stop too because the main process that keeps alive the container is the WebLogic process itself.


* Multiply WebLogic Admin servers can be started parallelly on the same host machine using one or multiply `docker-compose.yml`. You can find examples under the [oracle-weblogic-12.2.1.4](../oracle-weblogic-12.2.1.4) project. 


* The current installation contains a WebLogic Cluster.


* The WebLogic Managed servers will join automatically to the cluster without any additional configuration after they start.


* The [Remal JMS-Message-Sender](https://github.com/zappee/jms-message-sender) command line tool to can be used to send text messages to JMS and SAF queues.


* Use the [Remal SQL-Runner](https://github.com/zappee/sql-runner) command line tool to execute SQL commands like `SELECT`, `INSERT`, `UPDATE` or `CREATE`.


* The `common-utils.sh` bash script contains reusable functions that can be used to
    * deploy an artifact (WAR, EAR) as an application
    * deploy an artifact (WAR, JAR) as a shared library
    * get value from a `*.properties` file
    * create a new database schema
    * execute SQL commands
    * run Liquibase and update your database


* Use the WebLogic lifecycle bash scripts to automate the application deployment. There are four lifecycle methods that you can use:
    * `before-first-startup.sh`: executed once, before the first startup of the WebLogic Admin server
    * `before-startup.sh`: executed before each startup of the WebLogic Admin server
    * `after-first-startup.sh`: executed once, after the first startup of the WebLogic Admin server
    * `after-startup.sh`: executed after each startup of the WebLogic Admin server


* The `WEB_CONSOLE_COLOR` variable can be used to customize the color of the WebLogic web console. This feature is useful when multiple WebLogic domains are started.


* Block the WebLogic server execution and wait for an event before continue with the `wait-for-*.sh` bash scripts.

## 2) Build
1) Pull all the following images from the docker repository or build them locally:
    * Remal Oracle Java 8 image
    * Remal Oracle WebLogic image

2) Before building this image the followings needs to be checked and set properly:
    * in `Dockerfile`: base image name and version (`FROM`)
    * in the `build.sh` script: the name and the version of the image you are building

3) Build it using:
    ```
    $ cd oracle-weblogic-admin-server
    $ ./build.sh
    ```

## 3) How to use this image
You can find multiply `docker-compose.yml` sample files under the [usage-of-the-docker-images](/usage-of-the-docker-images) directory.

* Run the image
   * normal mode: `docker run -d -p 7001:7001 --name weblogic-admin-server weblogic-admin-server-12.2.1.4:1.0.0`
   * without starting the admin server: `docker run -d --name weblogic-admin-server weblogic-admin-server-12.2.1.4:1.0.0 tail -f /dev/null`

* Login into the running container
   * as an ordinary user: `docker exec -it weblogic-admin-server /bin/bash`
   * as root: `docker exec -it -u root -w /root weblogic-admin-server /bin/bash`

* Displays and follow log output
   *  `docker logs -f weblogic-admin-server`

## 4) Automated application deployment
The WebLogic Admin Server and the [WebLogic Managed Server](/oracle-weblogic-12.2.1.4-managed-server) Docker images help technicians to build scalable Oracle WebLogic environments and run application easily on WebLogic server.
This image set can be used at all environment levels: `PRODUCTION`, `ACCEPTANCE`, `TEST`, and `DEVELOPMENT`.

The application deployment can be automated easily using the four built-in admin server lifecycle methods.
These lifecycle methods are actually bash scripts, and they can execute any Unix commands that you need to prepare the environment and deploy the application or applications.

The mentioned four lifecycle scripts, and their execution order is the following:
1. `before-first-startup.sh`
1. `before-startup.sh`
1. `after-first-startup.sh`
1. `after-startup.sh`

## 5) Block the server startup
In some special use cases, you need to block the startup of the WebLogic server (and the execution of the lifecycle bash scripts) and wait for another server or signal.

The following use case is a good example that demonstrates when you need to block the WebLogic server startup.
In the production environment always external database servers are used (not the Oracle Database Docker Image).
But during the application development, each developer works on a separate environment with their own servers running on the `localhost`.
That means an Oracle Database Docker Image is used often together with this WebLogic Docker image in the same `docker-compose.yml` file.
Unfortunately, the database server startup time takes longer than the WebLogic server startup, so you may need to block the WebLogic startup until the database server is up and able to serve requests.
Otherwise, the connection pool deployment with the WLST tool from e.g., the `after-first-startup.sh` bash script will fail because the WebLogic Admin server starts before the database server.
As it is known, one of the main important pre-requirement to create a WebLogic connection pool is that the database must be up during the creation time of the connection pool.

Another situation that required to block the execution of the `after-*.sh` lifecycle bash scripts is that when you would like to create a WebLogic resource and deploy it to the managed server or servers.
For example, to create file persistent stores with WLST from the `after-first-startup.sh` script and deploy them to the managed servers must require that the managed servers must be running at the creation time of the File Persistent Store.

To handle the cases or any similar situations described above, you can use the following scripts:
* `wait-for-admin-server.sh`: this script returns only if the admin server is up and running
* `wait-for-database-server.sh`: this script returns only if the database server is up and running
* `wait-for-managed-server.sh`: this script waits until the managed server or servers up and running
* `wait-for-database-and-managed-server.sh`: this script is a combination of two scripts

## 6) SQL Runner command line tool
The `SQL-Runner` is a small command-line tool written in Java and can be used on all platforms where Java is available.
The tool can be used to execute any SQL commands, especially it is suitable for executing SQL `SELECT`, `UPDATE`, `DELETE`, and `CREATE` commands.
You can use this tool for example to create a new database schema during the application deployment and insert initial data into databases.

This can be run from any WebLogic lifecycle script easily to prepare the database before the application deployment.
You can find sample code in `chapter 10`.

The tool is available from the image, the installation directory is  `/home/oracle/bin`.

For more info about the tool, please read [this](https://github.com/zappee/sql-runner).

## 7) JMS Message Sender command line tool
The JMS Message Sender is a flexible command-line Java tool that can be used to send text messages to any kind of JMS Queue.
This is a command line tool can be run from bash or windows scripts and command line as well.

You can use this command line tool in the Docker environment to
* send test messages to any JMS queue
* test SAF connection
* simulate external system while executing integration tests
* etc.

The tool is available from the image, the installation directory is  `/home/oracle/bin`.

For more info about the tool, please read [this](https://github.com/zappee/jms-message-sender).

## 8) common-utils.sh library
The `common-utils` is a collection of bash functions that you can use from any of the four WebLogic lifecycle methods, mentioned in the previous chapters.
The functions simplify the usage of some often used commands like
* create a new Oracle database schema when you use Oracle Database Docker image
* keep up to date your database schema with the [Liquibase](https://www.liquibase.org)
* execution of any SQL command
* execution of external SQL/DDL file
* JAR, WAR, or EAR deployment to WebLogic server as a library or application
* read values from standard `*.properties` files

In order to you can use the collection of these bash functions, you need to include the `common-utils.sh` library to your bash script with the `source ./common-utils.sh` command.

The library can be found within in the `/home/oracle` directory.

### 8.1) Create Oracle database schema
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

### 8.2) SQL command executor
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
    
    sqlCommandExecutor authorization password "select * from user"
    ~~~

### 8.3) SQL script file executor
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

### 8.4) Liquibase executor
* Command: `executeLiquibase <directory>>`
* Parameters:
   * `directory`: the directory where the `pom.xml` that contains the Liquibase execution locates
* Example:
    ~~~
    executeLiquibase  $ORACLE_HOME/liquibase/liquibase-app
    ~~~

### 8.5) Application deployment
* Command: `deployApplication <artifact> <target1> <target2>`
* Parameters:
   * `artifact`: the file that will be deployed to the WebLogic cluster as an application
   * `target1`: deploying to one target
   * `target2`: optional parameter, deploying to more targets
* Used environment variables:
    * `ADMIN_SERVER_PORT`: the port of the T3 protocol
    * `ADMIN_SERVER_USER`: the user who has the proper access to the WebLogic server
    * `ADMIN_SERVER_PASSWORD`: the password for the connecting user
    * `CLUSTER_NAME`: the name of the WebLogic cluser
    * the hostname is always `localhost` because this function is called from the WebLogic Admin Server Docker container where the Admin Server runs
* Example:
    ~~~
    $ ADMIN_SERVER_PORT=7001
    $ ADMIN_SERVER_USER=weblogic
    $ ADMIN_SERVER_PASSWORD=weblogic12
    $ CLUSTER_NAME=DEV_CLUSTER
    
    deployApplication $ORACLE_HOME/bin/app/hello-0.1.0-SNAPSHOT.war $ADMIN_SERVER_NAME $CLUSTER_NAME
    ~~~

### 8.6) Shared library deployment
* Command: `deployLibrary <artifact>`
* Parameters:
   * `artifact`: the file that will be deployed to the WebLogic cluster as a library
* Used environment variables:
    * `ADMIN_SERVER_PORT`: the port of the T3 protocol
    * `ADMIN_SERVER_USER`: the user who has the proper access to the WebLogic server
    * `ADMIN_SERVER_PASSWORD`: the password for the connecting user
    * `CLUSTER_NAME`: the name of the WebLogic cluser
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

## 9) Environment variables used by the build
The Docker image is built based on the environment variables.
These variables have default values, but they can be changed before starting the build process.
In this section, you can find information about the variables and their default values.

Variables used from the `Dockerfile`:

| variables                 | default value | description |
|---------------------------|---------------|-------------|
| ADMIN_SERVER_JAVA_OPTIONS | -Dweblogic.rjvm.enableprotocolswitch=true -Dweblogic.data.canTransferAnyFile=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4001 -XX:+UnlockCommercialFeatures -XX:+ResourceManagement | The WebLogic admin server classpath. |
| ADMIN_SERVER_NAME         | ADMIN_SERVER  | An alphanumeric name for this server instance. |
| ADMIN_SERVER_PORT         | 7001          | The TCP port that this server uses to listen for regular (non-SSL) incoming connections. |
| CLUSTER_NAME              | DEV_CLUSTER   | The name of the WebLogic cluster. |
| DOMAIN_NAME               | DEV_DOMAIN    | The name of the WebLogic cluster. |
| ORACLE_HOME               | /home/oracle  | The home directory of the `oracle` user. |
| PRODUCTION_MODE           | true          | Boolean value, set it true if the production mode is used. |

Another variables:

| variables   | default value                                      | description |
|-------------|----------------------------------------------------|-------------|
| username    | weblogic                                           | The WebLogic console user, defined in the `boot.properties`. |
| password    | weblogic12                                         | The password for the console user, defined in the `boot.properties`. |
| domain home | `/home/oracle/user_projects/domains/<DOMAIN-NAME>` | The WebLogic domain home directory. |
| server log  |`<DOMAIN-HOME>/servers/<ADMIN-SERVER-NAME>/logs`    | The directory where the admin server's logfiles locates. |

## 10) Example how to build WebLogic Images with  automated deployment 
The [oracle-weblogic-demo-application](../hello-weblogic-world) is a project that shows how to dockerize an existing application and build Admin and Managed server images that contain a deployed WAR file with a dockerized database.

## 11) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
