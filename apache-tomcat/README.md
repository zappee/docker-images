# Apache Tomcat 10.0 Docker Image with Java 11

## 1) Image description
The image is based on the `tomcat:10.0` image.
The difference between the official Tomcat image available from [here](https://hub.docker.com/_/tomcat) and the Remal Tomcat Docker image is that there is a pre-configured administration user in the Remal image.

## 2) Build
~~~
$ cd apache-tomcat
$ ./build.sh
~~~

## 3) Usage

__Single Apache-Tomcat server__
* Start: `docker-compose up`
* Managing console URL: [http://localhost](http://localhost)
* Credentials: `admin`/`admin`

__Multiply Apache-Tomcat servers__
* Start: `docker-compose -f docker-compose-multiserver.yml up`
* Managing console URL 1: [http://localhost:8001](http://localhost:8001)
* Managing console URL 2: [http://localhost:8002](http://localhost:8002)
* Credentials: `admin`/`admin`

## 4) License
Copyright (c) 2020-2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
