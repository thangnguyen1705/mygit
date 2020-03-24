kubeadm init --apiserver-advertise-address=192.168.11.33 --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml

# Create Token cho Worker node - Output của lệnh này sẽ chạy trên Worker
kubeadm token create --print-join-command
