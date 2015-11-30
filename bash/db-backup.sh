#!/bin/bash
# Script to create a mysql backup and delete old backups
 
# Configuration
mysql_host=""
mysql_username=""
mysql_password=''
backup_path=/backup
compress=bzip2       # Set to "no" to disable, or set to a compression command like "bzip2"
expired=30           #how many days before the backup directory will be removed

mysql_database="$1"

if [ -z "$mysql_database" ]; then
    mysql_database="--all-databases"
fi
 
today=`date +%Y-%m-%d`
now=`date +%H-%M`
 
if [ "$mysql_database" == "--all-databases" ]; then
    backup_path="$backup_path/$today/000-full-db"
else
    backup_path="$backup_path/$today/$mysql_database"
fi

mkdir -p "$backup_path"

/usr/bin/mysqldump \
  -h "$mysql_host" \
  -u "$mysql_username" \
  --password="$mysql_password" \
  "$mysql_database" > "$backup_path/$now.sql"

if [ "$compress" != "no" ]; then
    $compress "$backup_path/$now.sql"
fi

# Remove old folders
find "$backup_path" -type d -mtime +$expired | xargs rm -Rf
