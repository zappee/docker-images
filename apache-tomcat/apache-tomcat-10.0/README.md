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
* Command: `docker-compose up`
* Managing console URL: [http://localhost:8080](http://localhost:8080)
* Credentials: `admin`/`admin`

__Multiply Apache-Tomcat servers__
* Command: `docker-compose -f docker-compose-multiserver.yml up`
* Managing console URL 1: [http://localhost:8081](http://localhost:8081)
* Managing console URL 2: [http://localhost:8082](http://localhost:8082)
* Credentials: `admin`/`admin`

## 4) License
Copyright (c) 2020-2022 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
