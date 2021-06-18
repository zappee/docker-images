#!/bin/bash
# ******************************************************************************
# This is a bash script to customize the WebLogic console.
#
# Since : February, 2021
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020 Remal Software and Arnold Somogyi All rights reserved
# BSD (2-clause) licensed
# ******************************************************************************

# ------------------------------------------------------------------------------
# prints all parameters used by this script
# ------------------------------------------------------------------------------
function showVariables {
    echo "variables for $BASH_SOURCE:"
    echo "   oracle home:       $ORACLE_HOME"
    echo "   web console color: $WEB_CONSOLE_COLOR"
}

# ------------------------------------------------------------------------------
# main program starts here
# ------------------------------------------------------------------------------
showVariables

if [ -n "$WEB_CONSOLE_COLOR" ]; then
    echo "customizing the WebLogic console..."
    yes | cp $ORACLE_HOME/content.css $ORACLE_HOME/wlserver/server/lib/consoleapp/webapp/css/
    sed -i "s/#D2E5F9/$WEB_CONSOLE_COLOR/g" $ORACLE_HOME/wlserver/server/lib/consoleapp/webapp/css/content.css
    echo "web console color has been updated"
else
    echo "skipping web console color customization because the WEB_CONSOLE_COLOR variable is not defined..."
fi
