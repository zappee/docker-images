#!/bin/bash
# ******************************************************************************
#  Installation script of the hello-weblogic-world application.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showContext {
    echo
    echo ".==================================================================."
    echo "||    ( )              STARTING THE SHOW WITH              ( )    ||"
    echo "||                                                                ||"
    echo "||    ( )            HELLO-WEBLOGIC-WORLD 0.1.0            ( )    ||"
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
    echo "executing the ${BASH_SOURCE[0]} script with"
    echo "   oracle home                   : $ORACLE_HOME"
    echo "   WebLogic domain name          : $DOMAIN_NAME"
    echo "   WebLogic cluster name         : $CLUSTER_NAME"
    echo "   WebLogic admin server port    : $ADMIN_SERVER_PORT"
    echo "   WebLogic admin server user    : $ADMIN_SERVER_USER"
    echo "   WebLogic admin server password: $ADMIN_SERVER_PASSWORD"
    echo "   database host                 : $DB_HOST"
    echo "   database port                 : $DB_PORT"
    echo "   database name                 : $DB_NAME"
    echo "   database sysdba user          : $DB_USER"
    echo "   database sysdba password      : $DB_PASSWORD"
    echo "   HELLO schema user             : $DB_SCHEMA_USER_HELLO"
    echo "   HELLO schema password         : $DB_SCHEMA_PASSWORD"
}

# ------------------------------------------------------------------------------
# use WLST to create WebLogic resources
# ------------------------------------------------------------------------------
function createWebLogicResources {
    wlst.sh \
        -skipWLSModuleScanning \
        -loadProperties "$PROPERTIES_FILE" \
        "$ORACLE_HOME/deploy-hello-weblogic-world.py" "localhost" "$ADMIN_SERVER_PORT" "$CLUSTER_NAME" "$DB_HOST" "$DB_PORT" "$DB_NAME" "$DB_SCHEMA_USER_HELLO" "$DB_SCHEMA_PASSWORD"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
source "$ORACLE_HOME/common-utils.sh"

PROPERTIES_FILE="$ORACLE_HOME/user_projects/domains/$DOMAIN_NAME/security/boot.properties"
ADMIN_SERVER_USER=$(getValue "$PROPERTIES_FILE" "username")
ADMIN_SERVER_PASSWORD=$(getValue "$PROPERTIES_FILE" "password")

showContext

if [ "$CREATE_DATABASE" = "true" ]; then
    echo "creating the database schemas..."
    createDbSchema "$DB_SCHEMA_USER_HELLO" "$DB_SCHEMA_PASSWORD"
    executeLiquibase "$ORACLE_HOME/liquibase/liquibase-hello-weblogic-world"
    sqlCommandExecutor "$DB_SCHEMA_USER_HELLO" "$DB_SCHEMA_PASSWORD" "INSERT INTO CONTACT (ID, NAME, EMAIL) VALUES (CONTACT_SEQ.nextval, 'Arnold Somogyi', 'arnold.somogyi@gmail.com')"
fi

createWebLogicResources
deployApplication "$HOSTNAME" "$ORACLE_HOME/bin/hello-weblogic-world/hello-weblogic-world-0.1.0.war"
