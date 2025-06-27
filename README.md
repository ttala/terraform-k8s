# Kubernetes Cluster Provisioning on Scaleway

This script provisions a **Kubernetes cluster** on **Scaleway** using Terraform.  
It deploys a simple two-node setup:
- **1 control plane node**
- **1 worker node**

---

## Default Configuration

- **Node Type**: `PLAY2-NANO`
- **Operating System**: Ubuntu 22.04
- **Kubernetes Version**: `1.31`

---

## Prerequisites

Before running the script, ensure you're authenticated with Scaleway.  
Refer to the official Terraform provider docs for guidance:  
🔗 [Scaleway Terraform Provider – Authentication](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs#authentication)

---

## Deployment

Run the command below to create your cluster:
```bash
terraform init
terraform plan
terraform apply
```

Once your cluster is created, connect to the **control plane node** and run the following to finalize the setup:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#### Optional (for autocompletion).
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
alias k=kubectl
complete -o default -F __start_kubectl k

---

## Add workers node(s)

To join the worker node(s), extract the kubeadm join command from the control plane:
** cat /var/log/cloud-init-output.log | grep -A 1 'kubeadm join'

Copy and run the output command on each worker node.

---

### Notes : This setup is minimal and intended for testing or learning purposes.