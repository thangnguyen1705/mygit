#!/bin/bash
list=`find . -name "*.yaml" | sed  's/\.\///g'`
for file in $list;do
    kubectl apply -f $file
done