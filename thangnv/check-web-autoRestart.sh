#!/bin/bash
cout=1
while [ $cout -lt 10 ]
do
       status=`curl -s -o /dev/null -w "%{http_code}" http://47.244.169.77:8080/api/users/check`
       echo `date` $status >> /tmp/crash_checks.log

       if [ "$status" -ne "200" ]
       then
              # Take any appropriate recovery action here.
              echo "webserver seems down, $cout th"
              let cout++
       else
              echo "web ok"
              break
       fi

       if [ $cout > 3 ]
       then
              echo " chay lenh"
              pkill -9 -f tomcat
              sh /opt/tomcat/bin/startup.sh
       fi
done
