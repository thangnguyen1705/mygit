#bin/bash
echo " ####Remove User"
echo " ####Bo qua nhung thong tin khong co"
echo " #### nhap du an "
read projects
echo " ####nhap user:"
read user
cat >>/etc/ansible/playbook/setup-remove-user.yml<<EOF
- hosts: $projects
  sudo: true
  tasks:
    - script: /etc/ansible/roles/ansible.command/setup-remove-user.sh
      environment:
        user: $user
EOF
ansible-playbook --user ansible --key-file=/home/ansible/.ssh/id_rsa /etc/ansible/playbook/setup-remove-user.yml
rm -rf /etc/ansible/playbook/setup-remove-user.yml