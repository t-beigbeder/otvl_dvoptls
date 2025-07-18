# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ext_net_name" {
  description = "The name of the external network"
  type        = string
}
variable "build_sg_name" {
  description = "The security group name for external access"
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
variable "dot_repo" {
  description = "Git repo devopstools"
  type        = string
}
variable "dot_branch" {
  description = "Git branch devopstools"
  type        = string
}
variable "instance_attrs" {
  description = "Attributes for instance to create"
  type = object({
    name        = string
    groups      = string
    otvl_meta   = string
    image_name  = string
    flavor_name = string
  })
}
