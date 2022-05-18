# Oracle Database Enterprise 12.2.0.1 Docker Compose file

## 1) Image description
This image is the official image released by Oracle Corporation.

## 2) Preparation for the usage
Before use this image, you must pull the Oracle Database image from Docker Hub. 
In order to you can pull the image you must accept the Oracle Terms and Conditions on Docker Hub.

Use the following command to deploy the image to your local computer:
~~~
docker pull store/oracle/database-enterprise:12.2.0.1
~~~

## 3) Usage
__Start the database server__
* Command: `docker-compose up`
* Oracle Database listening port: `1521`
* SYSDBA connection parameters
    * Database: `ORCLPDB1.localdomain`
    * User: `SYS as SYSDBA`
    * Password: `Oradoc_db1`
* JDBC URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain`

## 4) License
Copyright (c) 2020-2022 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
