variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "rg-iam-homelab"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Name of the domain controller VM."
  type        = string
  default     = "DC1"
}

variable "vm_size" {
  description = "Azure VM size SKU."
  type        = string
  default     = "Standard_DC2s_v3"
}

variable "admin_username" {
  description = "Local admin username for the VM."
  type        = string
  default     = "labadmin"
}

variable "admin_password" {
  description = "Local admin password. 12+ chars, upper/lower/digit/symbol."
  type        = string
  sensitive   = true
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "dc_private_ip" {
  description = "Static private IP for the domain controller."
  type        = string
  default     = "10.0.1.10"
}

variable "allowed_rdp_source" {
  description = "Public IP CIDR allowed to RDP. Use '*' for anywhere (not recommended)."
  type        = string
  default     = "*"
}