#!/bin/bash
# Change sender name: chfn -f "NAME" root
DATE=`date +%u-%d-%m-%Y`
find /data/dataweb/web-payout/reports/payoneer -type f -name "*.txt"  > /usr/local/sbin/vimo_all.txt
diff /usr/local/sbin/vimo_all.txt /usr/local/sbin/vimo_all_old.txt | grep "<" | sed 's/<\ //g' > /usr/local/sbin/vimo-new-file1.txt
mv /usr/local/sbin/vimo_all.txt /usr/local/sbin/vimo_all_old.txt
DANHSACH_FILE=$(cat /usr/local/sbin/vimo-new-file1.txt)
for NEWFILE in $DANHSACH_FILE
do
#        /bin/echo "Gui file hang ngay - ( $DATE )" | mail -s "Gui file ngay $DATE " -a $NEWFILE thongnv@vimo.vn tuannm@peacesoft.net giangvth@vimo.vn thangdt@vimo.vn hangltm@peacesoft.net hotro@vimo.vn thangnv@peacesoft.net
       /bin/echo "Gui file hang ngay - ( $DATE )" | mail -s "Gui file ngay $DATE " -a $NEWFILE thangnv@peacesoft.net
done
