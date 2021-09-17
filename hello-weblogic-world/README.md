# Hello-WebLogic-World Docker image

## 1) Image Description
This is a sample project that demonstrates the usage of the Remal's WebLogic [Admin](../oracle-weblogic-12.2.1.4-admin-server) and [Managed](../oracle-weblogic-12.2.1.4-managed-server) server images.
The project give a step-by-step guide how to dockerize an existing application running on WebLogic server using the Remal Docker images.
The project shows best practices as well to cover the typical use cases.

## 2) Image overview

__The sample docker-compose file starts the following containers:__
* WebLogic Admin server
* Two WebLogic Managed servers
* Oracle Database Server instance

The WebLogic web console URL is [http://localhost:7001/console](http://localhost:7001/console) and the username password that you can use to log-in is `weblogic`/`weblogic12`.

__During the first startup (`docker-compose up`) two web applications will be deployed automatically:__
* [FIPS checker](https://github.com/zappee/fips-checker)
* Hello web-application

# 2) Applications deployed in this image
## 2.1) FIPS checker
This is a web application that checks whether the FIPS mode is enabled or disabled on the server where the WAR is deployed.
More information available about the FIPS [here](https://www.wolfssl.com/license/fips) and [here](https://en.wikipedia.org/wiki/FIPS_140-2).
The step-by-step instruction that describes how to enable FIPS mode on the Oracle WebLogic server is available [here](https://docs.oracle.com/middleware/1213/wls/SECMG/fips.htm#SECMG768).
  
The web application is deployed to the Admin server and the WebLogic cluster (the two managed servers) and it shows that the FIPS is enabled on which server.
* Admin server: FIPS is not enabled, URL: [http://localhost:7001/fips-checker-1.0](http://localhost:7001/fips-checker-1.0)
* Managed server 1: FIPS is enabled here, URL: [http://localhost:8001/fips-checker-1.0](http://localhost:8001/fips-checker-1.0)
* Managed server 2: FIPS is enabled here, URL: [http://localhost:8002/fips-checker-1.0](http://localhost:8002/fips-checker-1.0)

## 2.2) Hello web-application
This is a simple web application contains only one static index HTML page.
The aim of the deployment of this WAR is to demonstrate the dockerization process of a complex WAR file with a database connection, and a JMS queue.

During the automated deployment the following resources will be created:
* a new database schema
* initialize the schema with some tables and initial data
* [Liquibase](https://www.liquibase.org) execution
* a new WebLogic database pool
* a new WebLogic JMS connection factory
* a new WebLogic distributed JMS queue

Once the docker containers are up and running you can use the [jms message sender](https://github.com/zappee/jms-message-sender) to test the queue.
The following comand sends a test message to the queue that was created during the deployment:

`aaaaa`

