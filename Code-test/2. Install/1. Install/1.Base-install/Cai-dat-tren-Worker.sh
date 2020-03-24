#Run output nhận được từ Master
#ví dụ: 
kubeadm join 192.168.11.33:6443 --token twgk1g.kmpz0s2vm8pu6pbp     --discovery-token-ca-cert-hash sha256:7b82026d65d2c99f6c1e28149510cd9b6d5ba74369765ebf9219eecab41edc8b



############Phần này dành cho Vagrant để autu deploy
sshpass -p '12312312' ssh -t thaopt@192.168.11.33 'sudo kubeadm token create --print-join-command > /home/thaopt/joincluster.sh'
sshpass -p '12312312' scp thaopt@192.168.11.33:/home/thaopt/joincluster.sh /home/thaopt
sh /home/thaopt/joincluster.sh
