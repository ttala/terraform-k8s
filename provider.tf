terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = ">= 2.42.0"
    }
  }
  #required_version = ">= 0.13"
}

provider "scaleway" {
  region = "nl-ams"
}
