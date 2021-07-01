#bash
time=`date "+%Y-%m-%d"`
pg_dumpall > /var/lib/postgresql/backup/all_pg_$time.sql
find /var/lib/postgresql/backup/ -name "*sql" -mtime +14 -exec rm '{}' \;