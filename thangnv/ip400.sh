#!bin/bash
month=`date | awk '{print $2}'`
grep -A1 "Multiple web server 400"  /var/ossec/logs/alerts/2020/$month/*log | grep IP | awk '{print $3}' >> /tmp/ip400.txt
cat /tmp/ip400.txt | sort | uniq > /tmp/ip401.txt
rm -rf /tmp/ip400.txt
cp -vp /tmp/ip401.txt /tmp/ip400.txt
chmod 777 /tmp/ip400.txt
rsync -avz /tmp/ip400.txt thangnv@10.0.8.215:/var/www/html/eld/ip.txt
#thangnvnasdasd