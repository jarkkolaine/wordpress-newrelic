FROM wordpress:4.3.1-apache

# Add custom script for running New Relic daemon
ADD run.sh /run.sh
RUN chmod +x /run.sh

# Modify the default entrypoint to call our new run script at its end
RUN sed -i "s/exec \"\$@\"/exec \"\/run.sh\"/" /entrypoint.sh

# Add a simple phpinfo() page for testing
ADD test.php /var/www/html/test.php

# Install New Relic daemon
RUN apt-get update && \
    apt-get -yq install wget && \
    wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

RUN apt-get update && \
    apt-get -yq install newrelic-php5 

# Setup environment variables for initializing New Relic
ENV NR_INSTALL_SILENT 1
ENV NR_INSTALL_KEY **ChangeMe**
ENV NR_APP_NAME "Default App Name"
