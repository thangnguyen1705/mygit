#bin/bash

yum install open-vm-tools -y
systemctl enable vmtoolsd
systemctl start vmtoolsd
service vmtoolsd start
chkconfig vmtoolsd on