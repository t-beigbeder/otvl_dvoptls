terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

data "openstack_networking_network_v2" "ext_net" {
  name = var.ext_net_name
}

data "openstack_networking_network_v2" "loc_net" {
  name = var.loc_net_name
}

data "openstack_networking_subnet_v2" "loc_net_sn" {
  network_id = data.openstack_networking_network_v2.loc_net.id
  name       = var.loc_net_name
}

resource "openstack_networking_secgroup_v2" "ext" {
  name = var.vlts_sg_name
}

resource "openstack_networking_secgroup_rule_v2" "ext_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.vlts_port
  port_range_max    = var.vlts_port
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_ssh" {
  count             = var.vlts_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_ssh6" {
  count             = var.vlts_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}
