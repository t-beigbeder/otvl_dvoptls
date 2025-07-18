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
  source           = "../../modules/build/network"
  ext_net_name     = var.ext_net_name
  build_sg_name     = var.build_sg_name
}

module "compute" {
  source         = "../../modules/build/compute"
  ext_net_id     = module.network.ext_net_id
  build_sg_id     = module.network.build_sg_id
  ssh_key_name   = var.ssh_key_name
  ssh_pub        = var.ssh_pub
  dot_repo       = var.dot_repo
  dot_branch     = var.dot_branch
  instance_attrs = var.instance_attrs
}
