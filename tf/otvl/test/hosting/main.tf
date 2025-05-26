provider "openstack" {
}

terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

module "network" {
  source           = "../../modules/hosting/network"
  ext_net_name     = var.ext_net_name
  loc_net_name     = var.loc_net_name
  vlts_sg_name     = var.vlts_sg_name
  vlts_port        = var.vlts_port
  vlts_ssh_exposed = var.vlts_ssh_exposed
}
