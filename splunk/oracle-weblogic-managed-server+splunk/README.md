# Oracle WebLogic Managed Server + Splunk Forwarder Docker Image

## 1) Image description
This image is built at the top of the Remal [oracle-weblogic-12.2.1.4-managed-server](../oracle-weblogic/oracle-weblogic-12.2.1.4-managed-server) image, and additionally it contains a pre-configured Splunk Forwarder.
The forwarder is configured to send the WebLogic log entries to the Splunk server so logs can be watched from the Splunk web console too.

Details:
* Splunk forwarder installation


* Splunk Forwarder configuration
  * monitoring the `$WL_LOG_HOME/$MANAGED_SERVER_NAME.nohup` logfile
  * monitoring the `$WL_LOG_HOME/$MANAGED_SERVER_NAME.log` logfile

## 2) Build
Build it using:
~~~
$ cd splunk/oracle-weblogic-managed-server+splunk
$ ./build.sh
~~~

## 3) Usage
* Start the Splunk server:
    ~~~
    $ cd splunk/splunk-8.2
    $ docker-compose up
    ~~~


* Splunk web console URL: [http://localhost:8000](http://localhost:8000)


* Splunk credentials: `admin`/`password`

## 4) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
