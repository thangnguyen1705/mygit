#bin/bash
echo " ####Remove User"
echo " ####Bo qua nhung thong tin khong co"
echo " #### nhap du an "
read projects
echo " ####nhap gateway:"
read gateway
cat >>/etc/ansible/playbook/setup-route.yml<<EOF
- hosts: $projects
  sudo: true
  tasks:
    - name: update all route
      script: /etc/ansible/roles/ansible.command/update-all-route.sh
      environment:
        user: $gateway
EOF
ansible-playbook --user ansible --key-file=/home/ansible/.ssh/id_rsa /etc/ansible/playbook/setup-route.yml
rm -rf /etc/ansible/playbook/setup-route.yml