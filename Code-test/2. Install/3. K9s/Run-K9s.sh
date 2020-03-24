#Install K9s on CentOS
sudo yum install epel-release -y

sudo yum install snapd -y

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap #logout or reboot to ensure snap’s paths are updated correctly.

sudo snap install k9s

# Run k9s
k9s --kubeconfig ~/.kube/config