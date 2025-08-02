terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_compute_keypair_v2" "this" {
  name       = var.ssh_key_name
  public_key = var.ssh_pub
}

resource "openstack_networking_port_v2" "ext" {
  count = length(var.instances_attrs)
  network_id = var.ext_net_id
  security_group_ids = [
    var.external_sg_id
  ]
  admin_state_up = "true"
}

resource "openstack_networking_port_v2" "loc" {
  count = length(var.instances_attrs)
  network_id = var.loc_net_id
  fixed_ip {
    subnet_id  = var.loc_subnet_id
    ip_address = var.instances_attrs[count.index].ip_v4
  }
  admin_state_up = "true"
}

resource "openstack_compute_instance_v2" "instances" {
  count = length(var.instances_attrs)
  name        = var.instances_attrs[count.index].name
  image_name  = var.instances_attrs[count.index].image_name
  flavor_name = var.instances_attrs[count.index].flavor_name
  key_pair    = openstack_compute_keypair_v2.this.name
  user_data   = var.instances_attrs[count.index].user_data
  security_groups = []
  network {
    port = openstack_networking_port_v2.ext[count.index].id
  }
  network {
    port = openstack_networking_port_v2.loc[count.index].id
  }
  metadata = {
    "groups"    = var.instances_attrs[count.index].groups
    "otvl_meta" = var.instances_attrs[count.index].otvl_meta
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}

locals {
  syncs_instances_indexes = [for ii, ia in var.instances_attrs: ii if ia.is_sync_server]
}

resource "openstack_blockstorage_volume_v3" "volumes" {
  count = length(local.syncs_instances_indexes)
  name = var.instances_attrs[local.syncs_instances_indexes[count.index]].name
  size = var.instances_attrs[local.syncs_instances_indexes[count.index]].sync_disk_size
  lifecycle {
    prevent_destroy = true
  }
}

resource "openstack_compute_volume_attach_v2" "volatts" {
  count = length(local.syncs_instances_indexes)
  instance_id = openstack_compute_instance_v2.instances[local.syncs_instances_indexes[count.index]].id
  volume_id = openstack_blockstorage_volume_v3.volumes[count.index].id
}