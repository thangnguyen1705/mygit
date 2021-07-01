#/bin/bash
PORT=57017

check_port=`lsof -i -P -n | grep $PORT `

if [ -z "$check_port" ]; then
	STATUS=2
	TEXT_OUTPUT="Port $PORT is not ok"
else
	STATUS=0
	TEXT_OUTPUT="Port $PORT is ok"
fi
echo "${STATUS} check_port_mongo_dev_meta - ${TEXT_OUTPUT}"