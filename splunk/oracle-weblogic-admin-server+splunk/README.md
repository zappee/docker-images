# Oracle WebLogic Admin Server + Splunk Forwarder Docker Image

## 1) Image description
This image is built at the top of the Remal _docker/remal/oracle-weblogic-12.2.1.4_ image, and additionally it contains a pre-configured Splunk Forwarder.
The forwarder is configured to send the WebLogic log entries to the Splunk server so logs can be watched from the Splunk web console too.

Details:
* Splunk forwarder installation


* Splunk Forwarder configuration
  * monitoring the `$WL_LOG_HOME/$ADMIN_SERVER_NAME.nohup` logfile
  * monitoring the `$WL_LOG_HOME/$ADMIN_SERVER_NAME.log` logfile
  * monitoring the `$WL_LOG_HOME/$DOMAIN_NAME.log` logfile

## 2) Build
Build it using:
~~~
$ cd splunk/oracle-weblogic-admin-server+splunk
$ ./build.sh
~~~

## 3) Usage
* Start the Splunk server:
    ~~~
    $ cd splunk/splunk-8.2
    $ docker-compose up
    ~~~


* Splunk web console URL: [http://localhost:8000](http://localhost:8000)


* WebLogic credentials: `admin`/`password`

## 4) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
