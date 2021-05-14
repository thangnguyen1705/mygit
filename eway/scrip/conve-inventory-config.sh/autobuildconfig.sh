echo > config
list=`awk '{print $1}' host`
for file in $list;do
    echo "$file"
    export IP=$(cat host | grep "$file ansible" | sed 's/'$file'//' | sed 's/\ ansible_host=//' | sed 's/eway-//')
    echo $IP
    echo "Host $file" >> config
    echo "  HostName $IP" >> config
    echo "  User root" >> config
    echo "" >> config
done