#!/bin/bash

# Depends on unzip
# Creates/deletes /tmp/mysqltuner

mkdir /tmp/mysqltuner
cd /tmp/mysqltuner
curl https://nodeload.github.com/rackerhacker/MySQLTuner-perl/zipball/master > mysqltuner.zip
unzip -j ./mysqltuner.zip > /dev/null
perl ./mysqltuner.pl
rm -rf /tmp/mysqltuner