# Release info

All notable changes to this project will be documented in this file.

## [weblogic-12.2.1.4:1.0.0] - 11/Feb/2021
#### Added
* Remove dangling image after the image build.
* Add the _JMS-Message-Sender_ tool to the image.
* Add the _SQL-Runner_ tool to the image.
* Copy the Oracle JDBC driver under the `$ORACLE_HOME/bin/oracle/` directory.
* Install the Oracle JDBC Driver to the locale Maven repository.
* Remove WebLogic installation kit after the installation. This reduces the Docker image size by 1GB.