#!/bin/bash
cout=1
port=8104
while [ $cout -lt 4 ]
do
       status=`curl -m 5 -s -o /dev/null -w "%{http_code}" http://127.0.0.1:$port/api/users/check`
       echo `date` $status >> /tmp/crash_checks.log

       if [ "$status" -ne "200" ]
       then
              # Take any appropriate recovery action here.
              echo "webserver seems down, $cout th"
              let cout++
              sleep 2m
       else
              echo "web ok" >> /tmp/crash_checks.log
              break
       fi

       if [ $cout == 4 ]
       then
              id=`netstat -lnput |  grep $port | awk '{print $7}'| sed "s/\/java//g"`
              echo "restart tomcat pidid:" $id >> /tmp/crash_checks.log
              kill -9 $id
              #sh /opt/tomcat4/bin/startup.sh
       fi
done
