# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ext_net_name" {
  description = "The name of the external network"
  type        = string
}
variable "hosting_sg_name" {
  description = "The security group name for external access"
  type        = string
}
variable "hosting_ssh_exposed" {
  description = "do the computing hosts expose SSH"
  type        = bool
}
