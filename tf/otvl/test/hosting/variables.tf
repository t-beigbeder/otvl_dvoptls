# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ext_net_name" {
  description = "The name of the external network"
  type        = string
}
variable "loc_net_name" {
  description = "The name of the local network"
  type        = string
}
variable "hosting_sg_name" {
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
variable "install_env" {
  description = "Environment to install"
  type        = string
}
variable "vlts_hostname" {
  description = "The hostname or IP address of vlts"
  type        = string
}

variable "instances_attrs" {
  description = "Attributes for instances to create"
  type = list(object({
    name        = string
    groups      = string
    otvl_meta   = string
    ip_v4       = string
    image_name  = string
    flavor_name = string
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "vlts_port" {
  description = "The HTTPS port of vlts"
  type        = number
  default     = 9443
}
variable "hosting_ssh_exposed" {
  description = "do the computing hosts expose SSH"
  type        = bool
  default     = false
}
