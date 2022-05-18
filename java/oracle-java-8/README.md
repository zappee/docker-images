# Remal Docker Image: Oracle Java 8 Docker Image

## 1) Image description
This image is based on the `oraclelinux:7-slim` image and can only be used as a base image of another images.
This image is used as a base image of the Remal WebLogic images.

The following tools have been installed in this image:
* Apache Maven
* GNU Wget
* Git client
* IP utils, ex. ping
* JDK™ 8u331 (`JAVA_HOME=/usr/java/jdk-8`)
* Midnight Commander
* Netcat
* Network configuration tool: ip
* Nmap
* Telnet client
* Unzip
* cURL
* gzip and tar
* tree
* vi editor

Available Unix aliases:
* `ll`: `ls -all`

## 2) Build
Download the Java™ SE Development Kit 8, Update 331 (JDK 8u331), `jdk-8u331-linux-x64.tar.gz` from the Oracle website and copy that file under the `bin/` directory.

Then build the image using:
~~~
$ cd oracle-java-8
$ ./build.sh
~~~

## 3) Usage
* Run the image
    * `docker run --name java-8 -d docker/remal/oracle-java-8:2.0.0 tail -f /dev/null`


* Login into the running container
    * as an ordinary user: `docker exec -it java-8 /bin/bash`
    * as root: `docker exec -it -u root -w /root java-8 /bin/bash`

## 4) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2020-2022 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed

<a href="https://trackgit.com"><img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/kv444g8vf7bti919dcgk" alt="trackgit-views" /></a>
