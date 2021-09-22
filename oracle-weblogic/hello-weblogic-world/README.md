# Hello-WebLogic-World Docker image

## 1) Image description
This is a sample project that demonstrates the usage of the Remal's WebLogic [Admin](../oracle-weblogic-12.2.1.4-admin-server) and [Managed](../oracle-weblogic-12.2.1.4-managed-server) server images.
The project give a step-by-step guide how to build easily a dockerized WebLogic cluster with automated application deployment using the Remal Docker images.
The project shows best practices as well to cover the typical use cases.

## 2) Image overview
* WebLogic cluster Docker environment with Admin and Managed servers


* WebLogic resource deployment: `Conection Pool`, `Connection Factory` `Distributed JMS Queues`


* two `*.WAR` application deployment to the WebLogic cluster


* Database schema creation for the application


* Initialize the database and keep up to date the scheme with Liquibase


* Insert initial master data to the database during the automated deployment


* Sending test messages to the JMS queues to simulate the responses from an external system

## 3) Build
1) Pull all the following images from the docker repository or build them locally:
    * [Remal Oracle Java 8](../../java/oracle-java-8) Docker image
    * [Remal Oracle WebLogic](../oracle-weblogic-12.2.1.4) Docker image
    * [Remal Oracle WebLogic Admin Server](../oracle-weblogic-12.2.1.4-admin-server) Docker image
    * [Remal Oracle WebLogic Managed Server](../oracle-weblogic-12.2.1.4-managed-server) Docker image

2) Build this image using:
    ```
    $ cd hello-weblogic-world
    $ ./build.sh
    ```

## 4) Usage
### 4.1) Start the demo
* Command: `docker-compose up`

### 4.2) WeLogic server details
* WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
* WebLogic credentials: `weblogic`/`weblogic12`

### 4.3) Oracle database details
* Oracle Database listening port: `1521`
* SYSDBA connection parameters
    * Database: `ORCLPDB1.localdomain`
    * User: `SYS as SYSDBA`
    * Password: `Oradoc_db1`
* Application user details
  * User: `hello`
  * Password: `password`
* JDBC URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain`

### 4.4) Deployed applications
#### 4.4.1) FIPS checker
This is a web application that checks whether the FIPS mode is enabled or disabled on the server where the WAR is deployed.

The web application is deployed to the Admin server and the WebLogic cluster as well, and it shows that the FIPS is enabled or not there.
* Admin server URL (no FIPS): [http://localhost:7001/fips-checker-1.0](http://localhost:7001/fips-checker-1.0)
* Managed server 1 URL: [http://localhost:8001/fips-checker-1.0](http://localhost:8001/fips-checker-1.0)
* Managed server 2 URL: [http://localhost:8002/fips-checker-1.0](http://localhost:8002/fips-checker-1.0)

>More information available about the FIPS [here](https://www.wolfssl.com/license/fips) and [here](https://en.wikipedia.org/wiki/FIPS_140-2).
>
>This step-by-step instruction [here](https://docs.oracle.com/middleware/1213/wls/SECMG/fips.htm#SECMG768) describes how to enable FIPS mode on the Oracle WebLogic server.

#### 4.4.2) Hello WebLogic World Web application
This is a simple web application contains only one static HTML page.
The aim of this application is to demonstrate the multiply WAR deployment in the same WebLogic custer in Docker using the Remal's Docker images.
That deployment also demonstrates the deployment of a connection-pool and some JMS queues.

During the automated deployment the following resources will be created:
  * a new database schema
  * initialize the schema with some tables and initial data
  * [Liquibase](https://www.liquibase.org) execution
  * a new WebLogic database pool
  * a WebLogic JMS connection factory
  * some WebLogic distributed JMS queue

The web application is deployed to the WebLogic cluster so it is available from the wto managed servers:
* Managed server 1 URL: [http://localhost:8001/hello-weblogic-world-0.1.0](http://localhost:8001/hello-weblogic-world-0.1.0)
* Managed server 2 URL: [http://localhost:8002/hello-weblogic-world-0.1.0](http://localhost:8002/hello-weblogic-world-0.1.0)

Once the docker containers are up and running you can use the Remal [jms-message-sender](https://github.com/zappee/jms-message-sender) command line tool to send test text messages to the queue.
In the following example we log in to the WebLogic Admin server Docker container and we use the tool from there to send a test text message to the `Managed Server-1`.
```
$ docker exec -it admin-server /bin/bash

$cd /home/oracle/bin/jms-message-sender
$ java -jar jms-message-sender-0.2.0-with-dependencies.jar |
    --verbose |
    --host managed-server-1 |
    --port 8001 |
    --user weblogic |
    --password weblogic12 |
    --cf jms/jms/qcf |
    --queue jms/incoming |
    --message "hello developer"
```

Expected result:
```
getting initial context (t3://managed-server-1:8001, user: weblogic)...
looking up for 'jms/jms/qcf' queue connection factory...
creating a queue connection...
creating queue session...
looking up for 'jms/incoming' queue...
sending a text message to queue...
message: 'hello developer'
message has been sent successfully
closing the resources...
   closing queue-session...
   closing queue-connection...
   closing context...

Return code: 0
```

## 5) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
