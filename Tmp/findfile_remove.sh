time=30 #days
logfile="/tmp/backup-cpi.log"
folder="/data/backup/backup_cpi_clicks"
name=json.gz
date=`date "+%D %T"`

echo "########### $date ##############" >> $logfile
find $folder -name "*$name" -mtime +$time -exec echo -n -e {}"\0" \; | du -hc --files0-from=- >> $logfile
# delete the files!
find $folder -name "*$name" -mtime +$time -exec rm '{}' \;