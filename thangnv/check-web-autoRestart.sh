#!/bin/bash
cout=1
while [ $cout -lt 4 ]
do
       status=`curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/api/users/check`
       echo `date` $status >> /tmp/crash_checks.log

       if [ "$status" -ne "200" ]
       then
              # Take any appropriate recovery action here.
              echo "webserver seems down, $cout th"
              let cout++
       else
              echo "web ok" >> /tmp/crash_checks.log
              break
       fi

       if [ $cout == 4 ]
       then
              echo " chay lenh" >> /tmp/crash_checks.log
              pkill -9 -f tomcat
              sh /opt/tomcat/bin/startup.sh
       fi
done
