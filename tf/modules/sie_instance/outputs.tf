output "id" {
  value = openstack_compute_instance_v2.instance.id
}
output "ipv4" {
  value = openstack_compute_instance_v2.instance.network.fixed_ip_v4
}
