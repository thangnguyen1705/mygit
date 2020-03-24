#!/bin/bash
DATE=$(date '+%Y.%m.%d' --date="-90 day")
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/filebeat-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/palo-threat-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/palo-traffic-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/.watcher-history-10-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/.monitoring-kibana-7-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/.monitoring-es-7-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/wazuh-alerts-3.x-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/wazuh-monitoring-3.x-$DATE
curl -XDELETE -u elastic1:Next123Tech.LMS localhost:9200/apm-%{[@metadata][version]}-%{[processor][event]}-2020.02.15
echo > /data/docker/containers/35bd3a5061ae8c718baead8d6793761abac9f8dbcb25ba7d9892250e4b36a717/35bd3a5061ae8c718baead8d6793761abac9f8dbcb25ba7d9892250e4b36a717-json.log
