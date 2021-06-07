#!/bin/bash
myservice=$(curl -s -XGET localhost:9200/_cluster/health?pretty | jq .status)
echo $myservice
if [[ $myservice = "\"green\"" ]]; then
     status=0
     statustxt="health_check_es_conversions is ok"
else
     status=2
     statustxt="health_check_es_conversions is not ok"
fi
echo "$status health_check_es_conversions - $statustxt"