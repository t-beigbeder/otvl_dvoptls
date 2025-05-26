terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

locals {
  user_data = base64encode(templatefile(
    "${path.module}/cloud-config.tftpl", {
      tf_loc_hostname  = var.instance_attr.name
      tf_loc_ip_v4     = var.instance_attr.ip_v4
      tf_dot_repo      = var.dot_repo
      tf_dot_branch    = var.dot_branch
      tf_rops_repo     = var.rops_repo
      tf_vlts_hostname = var.vlts_hostname
      tf_pki_cli_c     = indent(6, file("${path.root}/pki_dir/test/cli.otvl.c.pem"))
      tf_pki_cli_k     = indent(6, file("${path.root}/pki_dir/test/cli.otvl.k.pem"))
      tf_pki_fca_c     = indent(6, file("${path.root}/pki_dir/test/fca.otvl.c.pem"))
    }))
}
module "instances" {
  source         = "../../../../modules/instances"
  ext_net_id     = var.ext_net_id
  loc_net_id     = var.loc_net_id
  loc_subnet_id  = var.loc_subnet_id
  external_sg_id = var.hosting_sg_id
  ssh_key_name   = var.ssh_key_name
  ssh_pub        = var.ssh_pub
  instances_attrs = [merge(var.instance_attr, { user_data : local.user_data })]
}
