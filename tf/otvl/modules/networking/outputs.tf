output "ext_net_id" {
  value       = data.openstack_networking_network_v2.ext_net.id
  description = "The external network id"
}
