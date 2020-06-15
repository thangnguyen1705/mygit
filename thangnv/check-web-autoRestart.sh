#bin/sh
n=(`curl -is http://47.244.169.77:8080/api/users/check | grep HTTP | awk '{print $2}'`)
if n==200

