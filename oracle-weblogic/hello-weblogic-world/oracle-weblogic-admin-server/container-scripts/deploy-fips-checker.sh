#!/bin/bash
# ******************************************************************************
# Fips-Checker installation script.
#
# Since : July, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showVariables {
    echo
    echo ".==================================================================."
    echo "||    ( )              STARTING THE SHOW WITH              ( )    ||"
    echo "||                                                                ||"
    echo "||    ( )                 FIPS-CHECKER 1.0                 ( )    ||"
    echo "|'================================================================'|"
    echo "||                                                                ||"
    echo "||                                  .::::.                        ||"
    echo "||                                .::::::::.                      ||"
    echo "||                                :::::::::::                     ||"
    echo "||                                ':::::::::::..                  ||"
    echo "||                                 :::::::::::::::'               ||"
    echo "||                                  ':::::::::::.                 ||"
    echo "||                                    .::::::::::::::'            ||"
    echo "||                                  .:::::::::::...               ||"
    echo "||                                 ::::::::::::::''               ||"
    echo "||                     .:::.       '::::::::''::::                ||"
    echo "||                   .::::::::.      ':::::'  '::::               ||"
    echo "||                  .::::':::::::.    :::::    '::::.             ||"
    echo "||                .:::::' ':::::::::. :::::      ':::.            ||"
    echo "||              .:::::'     ':::::::::.:::::       '::.           ||"
    echo "||            .::::''         '::::::::::::::       '::.          ||"
    echo "||           .::''              '::::::::::::         :::...      ||"
    echo "||        ..::::                  ':::::::::'        .:' ''''     ||"
    echo "||     ..''''':'                    ':::::.'                      ||"
    echo "||                                                                ||"
    echo "|'================================================================'|"
    echo
    echo "variables for $BASH_SOURCE:"
    echo "   oracle home:                    $ORACLE_HOME"
    echo "   WebLogic domain name:           $DOMAIN_NAME"
    echo "   WebLogic cluster name:          $CLUSTER_NAME"
    echo "   WebLogic admin server port:     $ADMIN_SERVER_PORT"
    echo "   WebLogic admin server user:     $ADMIN_SERVER_USER"
    echo "   WebLogic admin server password: $ADMIN_SERVER_PASSWORD"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
source ./common-utils.sh
PROPERTIES_FILE=$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties
ADMIN_SERVER_USER=$(getValue $PROPERTIES_FILE "username")
ADMIN_SERVER_PASSWORD=$(getValue $PROPERTIES_FILE "password")

showVariables
deployApplication $ORACLE_HOME/bin/fips-checker/fips-checker-1.0.war $ADMIN_SERVER_NAME $CLUSTER_NAME
