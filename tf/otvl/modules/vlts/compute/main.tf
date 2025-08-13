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
      tf_loc_hostname  = var.instance_attrs.name,
      tf_dot_repo      = var.dot_repo
      tf_dot_branch    = var.dot_branch
      tf_install_env   = ""
      tf_prik          = ""
      tf_vlts_hostname = ""
      tf_vlts_port     = var.vlts_port
      tf_pki_srv_c = indent(6, file("${path.root}/pki_dir/test/srv.otvl.c.pem"))
      tf_pki_srv_k = indent(6, file("${path.root}/pki_dir/test/srv.otvl.k.pem"))
      tf_pki_slf_c = indent(6, file("${path.root}/pki_dir/test/slf.otvl.c.pem"))
      tf_pki_slf_k = indent(6, file("${path.root}/pki_dir/test/slf.otvl.k.pem"))
      tf_pki_fca_c = indent(6, file("${path.root}/pki_dir/test/fca.otvl.c.pem"))
    }))
}
module "instances" {
  source         = "../../../../modules/instances"
  ext_net_id     = var.ext_net_id
  external_sg_id = var.vlts_sg_id
  ssh_key_name   = var.ssh_key_name
  ssh_pub        = var.ssh_pub
  instances_attrs = [merge(var.instance_attrs, { user_data : local.user_data })]
}
