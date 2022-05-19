# Splunk 8.2 Docker Image

## 1) Image description
The image is based on the official _splunk:8.2_ image.
In this image the disk usage by the Splunk Indexer is limited to 200 MB.

* Figure 1: Splunk web console - hosts
![Splunk web console - hosts](screenshots/splunk-screenshot-01.png)

* Figure 2: Splunk web console - incoming log entries
  ![Splunk web console - hosts](screenshots/splunk-screenshot-02.png)

## 2) Build
Build it using:
~~~
$ cd splunk-8.2
$ ./build.sh
~~~

## 3) Usage
* Start the Splunk server: `docker-compose up`
* Splunk web console URL: [http://localhost:8000](http://localhost:8000)
* WebLogic credentials: `admin`/`password`
* Login into the running container
   * as an ordinary user: `docker exec -it splunk /bin/bash`
   * as splunk user: `docker exec -it -u splunk splunk /bin/bash`

## 5) Troubleshooting
### 5.1) Receiver
* _Enable receiver port_

  Go to the receiver and then browse to the `Settings` > `Forwarding and receiving` > under `Receive data` select `Configure receiving`.
  The port specified here should be the same port the forwarders are configured to send data. So if your receiver is set to receive forwarded data to port `8889`, then you should have this listed when you do the `splunk list forward-server` command:
  ```
  splunkserver:8889
  ```

* Look for your receiving port to be open on the indexer: `netstat -an | grep 9997`

  This should return an active TCP listener on `9997`.

* Review if you have properly configured receiving and forwarding.
  
  You should run a search to find the forwarder connection on the indexer:
  ```
  index=_internal source=*metrics.log tcpin_connections
  ```

  You should see an event very similar to below with your forwarder IP address:
  ```
  group=tcpin_connections, 172.18.0.4:36908:9997, connectionType=cooked,
  sourcePort=36908, sourceHost=172.18.0.4, sourceIp=172.18.0.4,
  destPort=9997, kb=21.343, _tcp_Bps=704.969, _tcp_KBps=0.688,
  _tcp_avg_thruput=0.828, _tcp_Kprocessed=11173.916, _tcp_eps=0.774,
  _process_time_ms=0, evt_misc_kBps=0.000, evt_raw_kBps=0.581,
  evt_fields_kBps=0.065, evt_fn_kBps=0.000, evt_fv_kBps=0.032,
  evt_fn_str_kBps=0.000, evt_fn_meta_dyn_kBps=0.000, evt_fn_meta_predef_kBps=0.000,
  evt_fn_meta_str_kBps=0.000, evt_fv_num_kBps=0.000, evt_fv_str_kBps=0.032,
  evt_fv_predef_kBps=0.000, evt_fv_offlen_kBps=0.000, evt_fv_fp_kBps=0.000,
  build=ddff1c41e5cf, version=8.2.1, os=Linux, arch=x86_64, hostname=8f51662e6215,
  guid=F8BB7917-C8BC-4B16-A7B1-F3D451ACC6D8, fwdType=uf, ssl=false,
  lastIndexer=172.18.0.2:9997, ack=false
  ```

### 5.2) Forwarder
* See if the forward-server is active on the forwarder.
  If it's inactive, it usually means you have not enabled the receiver to receive forwarded data.
  ```
  cd "$SPLUNK_HOME/bin/"
  ./splunk list forward-server
  ```

* Look for your receiving port to be connected to from the forwarder: `netstat -an | grep 9997`

  This should return an active TCP connection TO port `9997` on your indexer

### 5.3) Feed Splunk with fake data for test
Login to the managed-server and execute this from bash:
```
for i in {1..500}; do echo "$i: something good is happening now :)" >> $ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/servers/$ADMIN_SERVER_NAME/logs/$ADMIN_SERVER_NAME.log; done
```

## 5) License
Before the build, you must download the `Oracle JDK` install kit from the Oracle website and accept the license indicated on that page.

Copyright (c) 2021 Remal Software, Arnold Somogyi. All rights reserved.

BSD (2-clause) licensed
