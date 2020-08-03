rsync -avp backup_202* thangnv@10.15.17.6:/data2/imgs/2790/images/
find /data/images  -type d -iname "backup*" -ctime +0 -exec echo {} \;