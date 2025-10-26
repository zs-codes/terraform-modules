variable "location" {
  type    = string
  default = "West Europe"
}

variable "resource_group_name" {
  type    = string
  default = "rg-demo"
}

variable "virtual_network_name" {
  type    = string
  default = "vnet-demo"
}

variable "subnet_name" {
  type    = string
  default = "subnet-demo"
}

variable "public_ip_name" {
  type    = string
  default = "public-ip-demo"
}

variable "network_interface_name" {
  type    = string
  default = "nic-demo"
}

variable "virtual_machine_name" {
  type    = string
  default = "vm-demo"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "adminuser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Local path to the SSH public key file for VM authentication"
}
