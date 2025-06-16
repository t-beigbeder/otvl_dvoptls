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
variable "hosting_sg_id" {
  description = "The hosting sg id"
  type        = string
}
variable "hosting_ssh_exposed" {
  description = "do the computing hosts expose SSH"
  type        = bool
}
variable "hosting_cs_dvo" {
  description = "do the computing hosts launch code-server for devops admin"
  type        = bool
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
variable "lops_repo" {
  description = "Git repo devopstools local operations"
  type        = string
}
variable "install_env" {
  description = "Environment to install"
  type        = string
}
variable "vlts_hostname" {
  description = "The hostname or IP address of vlts"
  type        = string
}
variable "vlts_port" {
  description = "The HTTPS port of vlts"
  type        = number
}
variable "instances_attrs" {
  description = "Attributes for instance to create"
  type = list(object({
    name          = string
    groups        = string
    otvl_meta     = string
    ip_v4         = string
    image_name    = string
    flavor_name   = string
    is_nfs_server = optional(bool, false)
    nfs_disk_size = optional(number, 0)
  }))
}
