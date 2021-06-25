# Release info

All notable changes to this project will be documented in this file.

## [weblogic-managed-12.2.1.4:1.0.0] - 25/Feb/2021
#### Modified
* use `unix-machine` instead of general `machine` while creating a WebLogic machine
* fix FiPS installation issue
  
  How to check it: `grep -i 'rsa crypto'`
  
  Result: `Changing the default Random Number Generator in RSA CryptoJ from ECDRBG128 to HMACDRBG.`
#### Added
* remove dangling image after the build
* add `before-startup.sh` script: executed before each startup of the WebLogic admin server
#### Removed
* the `upload` directory for sharing files between the host and Docker container was moved to the `java-8` image because this directory is needed for each image
