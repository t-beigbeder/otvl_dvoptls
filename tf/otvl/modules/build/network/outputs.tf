output "ext_net_id" {
  value       = data.openstack_networking_network_v2.ext_net.id
  description = "The external network id"
}

output "build_sg_id" {
  value       = openstack_networking_secgroup_v2.ext.id
  description = "The build sg id"
}
