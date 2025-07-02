mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#### Optional (for autocompletion).
{
  echo 'source <(kubectl completion bash)'
  echo 'alias k=kubectl'
  echo 'complete -o default -F __start_kubectl k'
} >> ~/.bashrc

echo "Install network plugin : Calico"
## Install network plugin : Calico
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -o calico.yaml
kubectl apply -f calico.yaml > /dev/null
echo "Copy and paste the output below on each worker node"
cat /var/log/cloud-init-output.log | grep -A 1 'kubeadm join'
