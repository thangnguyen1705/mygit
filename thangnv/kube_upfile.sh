#!/bin/bash
sed -i 's/nscore:nscore2020@128.199.70.237/mongo:4yrc6iG}74WaOGgh@mongodb.mongodb/g' *

list=`find . -name "*.yaml" | sed  's/\.\///g'`
for file in $list;do
    kubectl apply -f $file
done