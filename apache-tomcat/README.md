# Apache Tomcat Docker Image

## 1) Image description
The image is based on `tomcat:10.0` image.
The difference between the official Tomcat image available from [here](https://hub.docker.com/_/tomcat) and this image is that this has a configured administration user.

## 2) Build
~~~
$ cd apache-tomcat
$ ./build.sh
~~~

## 3) Usage
* Start: `docker-compose up`
* Managing console URL: [http://localhost](http://localhost)
* Credentials: `admin`/`admin`

## 4) License
Copyright (c) 2020-2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
