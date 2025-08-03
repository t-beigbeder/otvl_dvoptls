# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ext_net_name" {
  description = "The name of the external network"
  type        = string
}
variable "vlts_sg_name" {
  description = "The security group name for external access"
  type        = string
}
variable "vlts_port" {
  description = "The HTTPS port of vlts"
  type        = number
}
variable "vlts_ssh_exposed" {
  description = "does the vlts server expose SSH"
  type        = bool
}
