# ******************************************************************************
#  Dockerfile for Splunk 8.2.
#
#  Since : September, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
FROM splunk/splunk:8.2
LABEL authors="Arnold Somogyi <arnold.somogyi@gmail.com>"

ENV SPLUNK_HOME=/opt/splunk
COPY --chown=splunk:splunk properties/indexes.conf $SPLUNK_HOME/etc/system/local/
