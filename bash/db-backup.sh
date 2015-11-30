#!/bin/bash
# Script to create a mysql backup and delete old backups
 
# Configuration - fill in the blanks
mysql_host=""
mysql_username=""
mysql_password=''
backup_path=/backup
expired=30           #how many days before the backup directory will be removed

mysql_database="$1"

if [ -z "$mysql_database" ]; then
    mysql_database="--all-databases"
fi
 
today=`date +%Y-%m-%d`
 
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
  "$mysql_database" > "$backup_path/`date +%H-%M`.sql"

# Remove old folders
find "$backup_path" -type d -mtime +$expired | xargs rm -Rf

