#!/bin/bash

### Usage:
###
###   file-backup.sh source

shopt -s dotglob

src=$1

today=`date +%Y-%m-%d`
now=`date +%H-%M`

source="/path/to/source/$src"    # The file (or dir) to back up
backup_path="/path/to/dest" # The base directory to keep backups in
dest="$backup_path/$today/$src"     # The location to back up to
use_tar="yes"                   # When yes, store backups as tar files instead of just copy
tar_compression="-j"            # Set to a valid tar compression flag, like '-j' or '-z'
tar_target_ext=".tbz"           # The filename extension to use when using tar*
excludes=""     # A colon-separated list of patterns to exclude from backup
expired=30                      # The number of days to retain backups

# * This is mostly to allow for you to select an appropriate extension for your
#   compression options.





# Convert $excludes into something our commands like
echo 'Processing excludes!'
exclude_str=""
for ex in $(echo $excludes | sed 's/:/\n/g'); do
    exclude_str="$exclude_str --exclude $ex"
done

# Do the backup
echo 'Backup engaged!'
mkdir -p $dest
if [ "$use_tar" == "yes" ]; then
    tar -c $tar_compression -f "$dest/$now$tar_target_ext" $exclude_str $source
else
    rsync -az $exclude_str $source/* $dest
fi

# Remove old folders
find "$backup_path" -type d -mtime +$expired | xargs rm -Rf

echo 'Done!'
