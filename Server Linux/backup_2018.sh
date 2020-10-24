#!/bin/bash

##### FLAG
## Backup Type
DB_BAK_FLAG=1
CONF_BAK_FLAG=1
FILE_BAK_FLAG=0
CRON_BAK_FLAG=1
MONGO_BAK_FLAG=0
## Frequency of backup
DAILY_BAK=1

##### CONSTANT VAR
FILE_DIR_LIST="/data/www/"         # Put a list here, seperated by space
FILE_IGNORE_LIST="logs"  # Put a list to NOT backup here, seperated by space
#CRON_DIR="/var/spool/cron/crontabs"
CRON_DIR="/var/spool/cron"
CONF_DIR_LIST="/etc/ /usr/local/sbin" # Put a list of config dirs need backing up

################ MYSQL ###################
DB_USER="backup"
DB_PASS="NSXAjgKp123@sc"
DB_DATABASE=""                           # Put a list of databases need backing up, Default = ALL
#########################################
################# MONGO #################
DBHOST="10.0.0.230"
DBPORT="27017"
###########################################

BAK_DIR="/data/backups"
BAK_LOGS_DIR="$BAK_DIR/logs"
BAK_ALL_UNCOMPRESS="/data/backups/uncompress"
BAK_ALL_COMPRESSED="/data/backups/compressed"
BAK_LOGS_CREATE="$BAK_LOGS_DIR/create"
BAK_LOGS_DELETE="$BAK_LOGS_DIR/delete"

#get ip LAN centos 6
#IP_ADDRESS=`/sbin/ifconfig eth9 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

#get ip LAN centos 7
IP_ADDRESS=`/sbin/ifconfig ens160 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}'`

mkdir -p $BAK_ALL_UNCOMPRESS
mkdir -p $BAK_ALL_COMPRESSED

WEEK_DAY="Sun"  # Weekly backup will run on this day of a week ## Sun Mon Tue Wed Thu Fri Sat
MONTH_DAY="1"   # Monthly backup        ## From 1 to 28 because of February
QUARTERLY_DAY="01 04 07 10"
#####

##### Making necessarity directory
mkdir -p $BAK_DIR
mkdir -p $BAK_LOGS_DIR
#####

#####
DATE=`date +%u-%d-%m-%Y-%Hh%Mm`
Q=`date +%m`
mkdir -p $BAK_LOGS_CREATE
mkdir -p $BAK_LOGS_DELETE

echo "BEGIN: ${DATE}" >> $BAK_LOGS_CREATE/${DATE}.log
#####

function bak_file {
        FREQ=`echo $1 | awk '{print tolower($0)}'`
        modifier="BAK_${FREQ}_LIFETIME"
        ignore=""
        echo $FILE_IGNORE_LIST
        for FILE_IGNORE in $FILE_IGNORE_LIST
        do
                ignore="--exclude=$FILE_IGNORE $ignore"
        done

        # BAKUP AND REMOVE CODE
        echo "########## Backup code $FREQ ##########" >> $BAK_LOGS_CREATE/${DATE}.log
        D1=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "START: $D1" >> $BAK_LOGS_CREATE/${DATE}.log

        for FILE_DIR in $FILE_DIR_LIST
        do
                # BACKUP
                A=`echo "$FILE_DIR" | awk -F '/' -v OFS='/' '{print $NF}'`
        CODEFILE="${DATE}-$A.tar.gz"

        D3=`date +%u-%d-%m-%Y-%Hh%Mm`
                echo "START: $D3" >> $BAK_LOGS_CREATE/${DATE}.log
        tar -zcvf $BAK_ALL_UNCOMPRESS/$CODEFILE $FILE_DIR $ignore >> $BAK_LOGS_CREATE/${DATE}.log
        D4=`date +%u-%d-%m-%Y-%Hh%Mm`
                echo "END: $D4" >> $BAK_LOGS_CREATE/${DATE}.log
        done
        D2=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "END: $D2" >> $BAK_LOGS_CREATE/${DATE}.log
}


function bak_mysql {
        FREQ=`echo $1 | awk '{print tolower($0)}'`

        if [ "$DB_DATABASE" == "" ]
        then
                DBs=`mysql -u$DB_USER -p$DB_PASS -e "show databases" --skip-column-names --batch`
                echo $DBs
        else
                DBs=$DB_DATABASE
                echo $DBs
        fi

        for DB in $DBs
        do
                #mkdir -p $BAK_DB_DIR/mysql/$DB/$FREQ
                SQLFILE="${DATE}-$DB.sql"
                mysqldump -u$DB_USER -p$DB_PASS --quote-names --opt --lock-tables=false $DB > $BAK_ALL_UNCOMPRESS/$SQLFILE
                        gzip -9 $BAK_ALL_UNCOMPRESS/$SQLFILE
        done
}


function bak_cron {
        FREQ=`echo $1 | awk '{print tolower($0)}'`

        echo "########## Backup cron $FREQ ##########" >> $BAK_LOGS_CREATE/${DATE}.log
        D31=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "START: $D31" >> $BAK_LOGS_CREATE/${DATE}.log

        #mkdir -p $BAK_CRON_DIR/$FREQ
        tar -cvf $BAK_ALL_UNCOMPRESS/${DATE}_cron.tar $CRON_DIR >> $BAK_LOGS_CREATE/${DATE}.log
        gzip -9 $BAK_ALL_UNCOMPRESS/${DATE}_cron.tar >> $BAK_LOGS_CREATE/${DATE}.log

        D32=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "END: $D32" >> $BAK_LOGS_CREATE/${DATE}.log
}

function bak_conf {
        FREQ=`echo $1 | awk '{print tolower($0)}'`

        echo "########## Backup config $FREQ ##########" >> $BAK_LOGS_CREATE/${DATE}.log
        D41=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "START: $D41" >> $BAK_LOGS_CREATE/${DATE}.log

        #mkdir -p $BAK_CONF_DIR/$FREQ
        tar -cvf $BAK_ALL_UNCOMPRESS/${DATE}_config.tar $CONF_DIR_LIST >> $BAK_LOGS_CREATE/$DATE.log
        gzip -9 $BAK_ALL_UNCOMPRESS/${DATE}_config.tar >> $BAK_LOGS_CREATE/${DATE}.log

        D42=`date +%u-%d-%m-%Y-%Hh%Mm`
        echo "END: $D42" >> $BAK_LOGS_CREATE/${DATE}.log
}
function bak_mongo {
        FREQ=`echo $1 | awk '{print tolower($0)}'`
        #mkdir -p $BAK_DB_DIR/mysql/$DB/$FREQ
        MONGOFILE="${DATE}-mongo"
        MONGOTAR="${DATE}-mongo.tar.gz"
        mongodump --host=$HOST --port=$PORT --out $BAK_ALL_UNCOMPRESS/$MONGOFILE
        tar -zcvf $BAK_ALL_UNCOMPRESS/$MONGOTAR $BAK_ALL_UNCOMPRESS/$MONGOFILE
        rm -rf $BAK_ALL_UNCOMPRESS/$MONGOFILE
}

function bak_all {
        FREQ=$1
        if [ $CONF_BAK_FLAG -eq 1 ]
        then
                bak_conf $FREQ
        fi
        if [ $FILE_BAK_FLAG -eq 1 ]
        then
                bak_file $FREQ
        fi
        if [ $CRON_BAK_FLAG -eq 1 ]
        then
                bak_cron $FREQ
        fi
        if [ $DB_BAK_FLAG -eq 1 ]
        then
                bak_mysql $FREQ
        fi
        if [ $MONGO_BAK_FLAG -eq 1 ]
        then
                bak_mongo $FREQ
        fi
}



function daily_bak {
        bak_all "DAILY"
}

function bak_all_freq {
        if [ $DAILY_BAK -eq 1 ]
        then
                daily_bak
        fi
}

find $BAK_ALL_COMPRESSED -name "*.gz" -mtime 0 -print -exec rm -f {} \;

bak_all_freq

cd $BAK_ALL_UNCOMPRESS
tar -cvf $BAK_ALL_COMPRESSED/${DATE}_${IP_ADDRESS}.tar *
rm -rf $BAK_ALL_UNCOMPRESS/*
gzip -1 $BAK_ALL_COMPRESSED/${DATE}_${IP_ADDRESS}.tar


#find $BAK_ALL_COMPRESSED -name "*.gz" -mtime +0 -print -exec rm -f {} \;

DATE1=`date +%u-%d-%m-%Y-%Hh%Mm`
echo "ALL DONE: ${DATE1}" >> $BAK_LOGS_CREATE/${DATE}.log
chmod g+wsx -R /data/backups/
chown backup.backup -R /data/backups/