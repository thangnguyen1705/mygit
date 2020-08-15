#bin/bash
mv /etc/ansible/hosts /etc/ansible/hosts_old
echo " ####Update time"
echo " ####Bo qua nhung thong tin khong co"
echo " #### Nhap dai ip"
read IP
grep -r $IP /etc/ansible/hosts_old > /etc/ansible/hosts
cat >>/etc/ansible/playbook/update-crontab-time.yaml<<EOF
- hosts: all
  sudo: true
  tasks:
    - script: /etc/ansible/roles/ansible.command/update-crontab-time.sh
      environment:
        IP: $IP
EOF
ansible-playbook --user ansible --key-file=/home/ansible/.ssh/id_rsa /etc/ansible/playbook/update-crontab-time.yaml
rm -rf /etc/ansible/playbook/update-crontab-time.yaml
rm -rf /etc/ansible/hosts
mv /etc/ansible/hosts_old /etc/ansible/hosts