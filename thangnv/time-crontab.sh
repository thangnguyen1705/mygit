#/bin/sh
IP=10.0.43
echo $IP
time=`crontab -l | grep $IP`
if [[ -z "$time" ]] ; then
echo "0 0 * * * ntpdate -u $IP.1" | tee -a /var/spool/cron/root
fi
