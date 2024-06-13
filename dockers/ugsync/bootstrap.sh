#!/bin/bash
set -xe

./setup.sh
# wait for ranger-admin start up first
sleep 120
cp /opt/ranger_usersync/conf/ranger-ugsync-site.xml /tmp/ranger-ugsync-site.xml
xmlstarlet ed  -u "//property[name='ranger.usersync.enabled']/value"  -v true /tmp/ranger-ugsync-site.xml > /opt/ranger_usersync/conf/ranger-ugsync-site.xml

cp /opt/ranger_usersync/conf/ranger-ugsync-site.xml /tmp/ranger-ugsync-site.xml
xmlstarlet ed  -u "//property[name='ranger.usersync.group.searchenabled']/value"  -v true /tmp/ranger-ugsync-site.xml > /opt/ranger_usersync/conf/ranger-ugsync-site.xml

./ranger-usersync-services.sh start

# tail -f logfile
tail -f $(grep 'logdir' ./install.properties  | sed -e 's#.*=\(\)#\1#')/usersync-usersync-ldap-.log
