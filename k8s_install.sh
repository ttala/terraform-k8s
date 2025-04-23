#!/bin/bash

#Set master node name
master_node="controlplane"

set -e

# Update and install dependencies
apt update && apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "[1/6] Installing containerd..."
# Install containerd
apt install -y containerd

# Create containerd default config
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

# Set systemd as the cgroup driver for containerd
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd
systemctl enable containerd

echo "[2/6] Setting up sysctl params for Kubernetes..."
# Required for Kubernetes networking
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

echo "[3/6] Adding Kubernetes APT repository..."
# Add the Kubernetes APT repo
#mkdir -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt update

echo "[4/6] Installing kubelet, kubeadm, kubectl (v1.30)..."
# Install Kubernetes components
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "[5/6] Disabling swap..."
# Kubernetes requires swap to be off
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

systemctl enable kubelet
#systemctl start kubelet

echo "[6/6] Done! Kubernetes 1.31 and containerd are installed."
kubeadm version
kubectl version --client
containerd --version

echo "[7] Running kube init on master node only..."
# Configuration only for master node
if [ $HOSTNAME = $master_node ]; then
    kubeadm init --pod-network-cidr=192.168.0.0/16
    kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
    apt-get install -y bash-completion
    source <(kubectl completion bash) 
    echo "source <(kubectl completion bash)" >> ~/.bashrc
    source ~/.bashrc
    alias k=kubectl
    complete -o default -F __start_kubectl k
    #cat /var/log/cloud-init-output.log
fi
echo "[8] Finish ! "