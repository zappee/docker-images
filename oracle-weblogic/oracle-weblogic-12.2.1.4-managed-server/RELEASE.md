# Release info

All notable changes to this project will be documented in this file.

## [weblogic-managed-12.2.1.4:1.0.0] - 25/Feb/2021
#### Modified
* use `unix-machine` instead of general `machine` while creating a WebLogic machine
* fix FiPS installation issue
  * check whether fips is installed properly or not: `grep -i 'rsa crypto'`
  * expected result: `Changing the default Random Number Generator in RSA CryptoJ from ECDRBG128 to HMACDRBG.`
#### Added
* remove dangling image after the build
* add the `before-first-startup.sh` WebLogic lifecycle script: it is executed once, before the first startup of the WebLogic managed server
* add the `before-startup.sh` WebLogic lifecycle script: it is executed before each startup of the WebLogic managed server
#### Removed
* the `upload` directory for sharing files between the host and Docker container was moved to the `java-8` image because this directory is needed for each image
