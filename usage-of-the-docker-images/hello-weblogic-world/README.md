# Oracle WebLogic 12.2.1.4 Docker Compose files

__Single WebLogic domain with two managed servers__
* Start: `docker-compuse up`
* WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
* WebLogic credentials: `weblogic`/`weblogic12`

__Multiply WebLogic domains with managed servers__
* Start: `docker-compose -f docker-compose-multiserver.yml  up`
* WebLogic-1 console URL: [http://localhost:7101/console](http://localhost:7101/console)
* WebLogic-2 console URL: [http://localhost:7201/console](http://localhost:7201/console)
* WebLogic credentials: `weblogic`/`weblogic12`

__Single WebLogic domain with two managed servers + Oracle Database Server__
* Start: `docker-compose -f docker-compose-with-database.yml up`
* WebLogic console URL: [http://localhost:7001/console](http://localhost:7001/console)
* WebLogic credentials: `weblogic`/`weblogic12`
* Oracle Database listening port: `1521`
* Oracle Database SYSDBA connection parameters
    * Database: `ORCLPDB1.localdomain`
    * User: `SYS as SYSDBA`
    * Password: `Oradoc_db1`
* Oracle Database JDBC URL: `jdbc:oracle:thin:@localhost:1521/ORCLPDB1.localdomain`
