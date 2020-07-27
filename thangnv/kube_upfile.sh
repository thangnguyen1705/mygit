list=`find  -name "*.gz" -mtime +60 | sed  's/\.\///g'`
for file in $list;do
    aws s3 sync $path/$file s3://nexttech-backup/$HOSTNAME/$path/$file
done