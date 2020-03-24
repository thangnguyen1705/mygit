#!/bin/bash

cat >>/etc/hosts<<EOF
192.168.11.33 kmaster.example.com kmaster
192.168.11.32 kworker.example.com kworker
EOF


yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

systemctl enable docker
systemctl start docker

setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

systemctl disable firewalld
systemctl stop firewalld

sed -i '/swap/d' /etc/fstab
swapoff -a

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubeadm kubelet kubectl

systemctl enable kubelet

systemctl start kubelet


