variable "project_name" {
  type    = string
  default = "scw-terraform"
}

variable "zone" {
  type    = string
  default = "fr-par-1"
}

variable "instance-type" {
  type    = string
  default = "PLAY2-NANO"
}

variable "image" {
  type    = string
  default = "ubuntu_jammy"
}

variable "pvn" {
  type    = string
  default = "pvn-k8s-terra"
}

variable "vol_size" {
  type    = number
  default = 15
}

variable "master" {
  type    = string
  default = "controlplane"
}

variable "worker01" {
  type    = string
  default = "worker01"
}