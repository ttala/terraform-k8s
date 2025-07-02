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

Once your cluster is created, connect to the **control plane node** and run the following to finalize the setup and print the join token for worker nodes:

```bash
./k8s_setup.sh
source ~/.bashrc
```
---

### Notes : This setup is minimal and intended for testing or learning purposes.