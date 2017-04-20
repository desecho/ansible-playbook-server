#!/bin/bash

### MySQL Info ###
MYSQL_USER="root"
MYSQL_PASSWORD=""
MYSQL_HOST="localhost"

DIR="/var/backups"

MYSQL_DUMP="$(which mysqldump)"
MYSQL="$(which mysql)"
GZIP="$(which gzip)"
NOW=$(date +"%d-%m-%Y")

# DBS="$($MYSQL -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASSWORD -Bse 'show databases')"
DBS="$($MYSQL -u $MYSQL_USER -h $MYSQL_HOST -Bse 'show databases')"
DBS=${DBS//information_schema/}
DBS=${DBS//mysql/}
DBS=${DBS//performance_schema/}
DBS=${DBS//test/}
DBS=${DBS//sys/}
mkdir -p $DIR/$NOW
for db in $DBS
do
 FILE=$DIR/$NOW/$db.$NOW.sql.gz
 $MYSQL_DUMP -u $MYSQL_USER -h $MYSQL_HOST $db | $GZIP -9 > $FILE
 # $MYSQL_DUMP -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASSWORD $db | $GZIP -9 > $FILE
done
