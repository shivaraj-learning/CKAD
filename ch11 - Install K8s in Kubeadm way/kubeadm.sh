##############1st step All Node####
#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
  stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo apt-get install -y  kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd


#########2nd step On Master##########

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo kubeadm init --pod-network-cidr=10.32.0.0/12

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


#########3rd step On worker########
kubeadm join 10.0.8.245:6443 --token oabqc8.w99dc0yw573fde4s --discovery-token-ca-cert-hash sha256:90db6fd77ee4cffc3967b6cca5d4b1efc6072ed2ec05fd7db6359a01b3d9c5b3
kubectl create secret generic dbsecrets --from-literal=connection=postgresql://postgres:Godrej123@database-1.c8mvgqt6jxua.us-east-1.rds.amazonaws.com