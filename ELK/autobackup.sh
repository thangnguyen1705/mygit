#bin/bash
list=`cat list.txt`
domain=$1

#backup data
# for alias in $list
# do
#     echo "remove" ${alias}
#     rm -rf /data/${alias}.json
#     docker run --net=host -v /data:/tmp --rm -ti elasticdump/elasticsearch-dump \
#     --input=${domain}/$alias \
#     --output=/tmp/$alias.json \
#     --type=data
#     echo "create" $alias
# done
#restore data
# for alias in $list
# do
#     echo "restore" $alias
#     rm -rf /data/${alias}.json
#     docker run --net=host -v /data:/tmp --rm -ti elasticdump/elasticsearch-dump \
#     --input=/tmp/$alias.json \
#     --output=${domain}/$alias \
#     --type=data
# done
#delete and create index
for alias in $list
do
    echo "\n\nrestore $alias"
    curl -XDELETE ${domain}/$alias
    curl -XPUT "${domain}/$alias" -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0 }}}'
done