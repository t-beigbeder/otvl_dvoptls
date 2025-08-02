# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ext_net_id" {
  description = "The external network id"
  type        = string
}
variable "loc_net_id" {
  description = "The local network id"
  type        = string
}
variable "loc_subnet_id" {
  description = "The local subnet id"
  type        = string
}
variable "external_sg_id" {
  description = "external sg id"
  type        = string
}
variable "ssh_key_name" {
  description = "The SSH key name to store the ssh_pub public key"
  type        = string
}
variable "ssh_pub" {
  description = "The SSH public key to authorize in created instances"
  type        = string
}
variable "instances_attrs" {
  description = "Attributes for instances to create"
  type = list(object({
    name          = string
    groups        = string
    otvl_meta     = string
    ip_v4         = string
    image_name    = string
    flavor_name   = string
    is_sync_server = optional(bool, false)
    sync_disk_size = optional(number, 0)
    user_data     = string
  }))
}
