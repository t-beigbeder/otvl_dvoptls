provider "openstack" {
}

terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1.1"
    }
  }
}

module "network" {
  source              = "../../modules/hosting/network"
  ext_net_name        = var.ext_net_name
  loc_net_name        = var.loc_net_name
  hosting_sg_name     = var.hosting_sg_name
  hosting_ssh_exposed = var.hosting_ssh_exposed
}

module "compute" {
  source              = "../../modules/hosting/compute"
  ext_net_id          = module.network.ext_net_id
  loc_net_id          = module.network.loc_net_id
  loc_subnet_id       = module.network.loc_subnet_id
  loc_net_cidr        = var.loc_net_cidr
  hosting_sg_id       = module.network.hosting_sg_id
  hosting_ssh_exposed = var.hosting_ssh_exposed
  hosting_cs_dvo      = var.hosting_cs_dvo
  vlts_hostname       = var.vlts_hostname
  vlts_port           = var.vlts_port
  ssh_key_name        = var.ssh_key_name
  ssh_pub             = var.ssh_pub
  dot_repo            = var.dot_repo
  dot_branch          = var.dot_branch
  lops_repo           = var.lops_repo
  install_env         = var.install_env
  instances_attrs     = var.instances_attrs
}
