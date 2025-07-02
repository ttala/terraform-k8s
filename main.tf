resource "scaleway_instance_ip" "master_ip" {
  zone = var.zone
}

resource scaleway_vpc_private_network pnet {
    name = var.pvn
}

resource "scaleway_instance_server" "master-node" {
  name   = var.master
  type   = var.instance-type
  ip_id  = scaleway_instance_ip.master_ip.id
  image  = var.image
  zone   = var.zone

  root_volume {
    volume_type = "sbs_volume"
    sbs_iops = 5000
    size_in_gb = 20
  }

  private_network {
    pn_id = scaleway_vpc_private_network.pnet.id
  }
  user_data = {
    foo        = "kube"
    cloud-init = templatefile("${path.module}/k8s_install.sh", {
    hostname = var.master
  })
  }

}

resource "null_resource" "provision" {
  depends_on = [scaleway_instance_server.master-node]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = scaleway_instance_server.master-node.public_ip
  }

  provisioner "file" {
    source      = "k8s_setup.sh"
    destination = "/root/k8s_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/k8s_setup.sh"
    ]
  }
}


resource "scaleway_instance_ip" "worker_ip" {
  zone = var.zone
}

resource "scaleway_instance_server" "worker-node" {
  name   = var.worker01
  type   = var.instance-type
  ip_id  = scaleway_instance_ip.worker_ip.id
  image  = var.image
  zone   = var.zone

  root_volume {
    volume_type = "sbs_volume"
    sbs_iops = 5000
    size_in_gb = 20
  }

  private_network {
    pn_id = scaleway_vpc_private_network.pnet.id
  }
  user_data = {
    foo        = "kube"
    cloud-init = file("${path.module}/k8s_install.sh")
  }

}

