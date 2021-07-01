#/bin/bash
CONTAINER_ID=$(docker ps | grep "4500/udp" | grep "agent" | awk '{print $1}')
OFFSET_FILE=/tmp/offset_charon_network
LOG_FILE=/var/log/charon.log
NO_LOG_ERROR=$(docker exec -ti ${CONTAINER_ID} logtail2 -f ${LOG_FILE} -o ${OFFSET_FILE} | grep "unable" | wc -l)
STATUS_FILE=/var/opt/charon_status
STATUS_FILE_RESULT=0
if [ -f "${STATUS_FILE}" ];then
	STATUS_FILE_RESULT=$(cat ${STATUS_FILE})
else
	echo -n 0 > ${STATUS_FILE}
fi
if [ ${NO_LOG_ERROR} -gt 0 ]
then
	STATUS=2
	TEXT_OUTPUT="PROBLEM: rancher network has problem, please restart rancher network agent"
	echo -n 1 > ${STATUS_FILE}
fi
if [ ${NO_LOG_ERROR} -eq 0 ] && [ ${STATUS_FILE_RESULT} -eq 0 ]
then
	STATUS=0
	TEXT_OUTPUT="OK: rancher network works!"
fi
echo "${STATUS} rancher_network_agent - ${TEXT_OUTPUT}"