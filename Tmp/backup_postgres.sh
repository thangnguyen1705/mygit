#bash
time=`date "+%Y-%m-%d"`
echo $time
echo all_pg_$time.log
pg_dumpall > all_pg_$time.log
