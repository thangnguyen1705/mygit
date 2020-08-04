#bin/bash
echo " ####Install chrony"
echo " #### nhap du an "
read projects
echo "##Nhap IP timeserver:"
read IP
cat >>/etc/ansible/playbook/setup-chrony-new.yml<<EOF
- hosts: $projects
  become: true
  roles:
    - role: ericsysmin.chrony
      chrony_config_server:
        - $IP
EOF
ansible-playbook --user ansible --key-file=/home/ansible/.ssh/id_rsa /etc/ansible/playbook/setup-chrony-new.yml
rm -rf /etc/ansible/playbook/setup-chrony-new.yml
