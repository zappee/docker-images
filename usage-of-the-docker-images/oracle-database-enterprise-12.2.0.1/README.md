# Oracle Database Enterprise 12.2.0.1 Docker Compose file

Before use this, you must pull the Oracle Database image from Docker Hub. 
In order to you can pull the image you must accept the Oracle Terms and Conditions on Docker Hub.
After that use the following command: `docker pull store/oracle/database-enterprise:12.2.0.1`

* Oracle Database listening port: `1521`
* SYSDBA connection parameters
    * Database: `ORCLPDB1.localdomain`
    * User: `SYS as SYSDBA`
    * Password: `Oradoc_db1`
* JDBC URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain`
* Deploy the image: `docker-compuse up`