# Apache Tomcat 10.0 with Java 11

__Single Apache-Tomcat server__
* Start: `docker-compose up`
* Managing console URL: [http://localhost](http://localhost)
* Credentials: `admin`/`admin`

__Multiply Apache-Tomcat servers__
* Start: `docker-compose -f docker-compose-multiserver.yml up`
* Managing console URL 1: [http://localhost:8001](http://localhost:8001)
* Managing console URL 2: [http://localhost:8002](http://localhost:8002)
* Credentials: `admin`/`admin`
