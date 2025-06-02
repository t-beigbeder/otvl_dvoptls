terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    sops = {
      source = "carlpett/sops"
    }
  }
}
locals {
  instances_user_data = [
    for index, ia in var.instances_attrs :
    base64encode(templatefile(
      "${path.module}/cloud-config.tftpl", {
        tf_loc_hostname  = ia.name
        tf_loc_ip_v4     = ia.ip_v4
        tf_dot_repo      = var.dot_repo
        tf_dot_branch    = var.dot_branch
        tf_lops_repo     = var.lops_repo
        tf_install_env   = var.install_env
        tf_vlts_hostname = var.vlts_hostname
        tf_vlts_port     = var.vlts_port
        tf_vlts_creds = trimspace(file(pathexpand("~/.config/otvl_vlts/${ia.name}")))
        tf_ssh_exposed   = var.hosting_ssh_exposed ? "1" : "0"
        tf_pki_cli_c = indent(6, file("${path.root}/pki_dir/test/cli.otvl.c.pem"))
        tf_pki_cli_k = indent(6, file("${path.root}/pki_dir/test/cli.otvl.k.pem"))
        tf_pki_fca_c = indent(6, file("${path.root}/pki_dir/test/fca.otvl.c.pem"))
      }))
  ]
}
locals {
  instances_attrs = [
    for index, ia in var.instances_attrs :
    merge(ia, { user_data : local.instances_user_data[index] })
  ]
}
module "instances" {
  source          = "../../../../modules/instances"
  ext_net_id      = var.ext_net_id
  loc_net_id      = var.loc_net_id
  loc_subnet_id   = var.loc_subnet_id
  external_sg_id  = var.hosting_sg_id
  ssh_key_name    = var.ssh_key_name
  ssh_pub         = var.ssh_pub
  instances_attrs = local.instances_attrs
}
