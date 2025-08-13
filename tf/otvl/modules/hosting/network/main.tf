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

resource "openstack_networking_secgroup_v2" "ext" {
  name = var.hosting_sg_name
}

resource "openstack_networking_secgroup_rule_v2" "ext_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_ssh" {
  count             = var.hosting_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "ext_ssh6" {
  count             = var.hosting_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "int_k3s_api_server" {
  count             = var.hosting_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_group_id   = openstack_networking_secgroup_v2.ext.id
  security_group_id = openstack_networking_secgroup_v2.ext.id
}

resource "openstack_networking_secgroup_rule_v2" "int_k3s_flannel_vxlan" {
  count             = var.hosting_ssh_exposed ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8472
  port_range_max    = 8472
  remote_group_id   = openstack_networking_secgroup_v2.ext.id
  security_group_id = openstack_networking_secgroup_v2.ext.id
}