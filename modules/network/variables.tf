variable "resource_group" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type = string
}

variable "network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "vnet_address_space" {
  type        = string
  description = "Virtual network address space"
}

variable "subnet_web_name" {
  type        = string
  description = "Name of the web subnet"
}

variable "subnet_app_name" {
  type        = string
  description = "Name of the app subnet"
}

variable "subnet_data_name" {
  type        = string
  description = "Name of the data subnet"
}

variable "prefix_web" {
  type        = string
  description = "Web subnet address prefix"
}

variable "prefix_app" {
  type        = string
  description = "App subnet address prefix"
}

variable "prefix_data" {
  type        = string
  description = "Data subnet address prefix"
}

variable "security_group" {
  type        = string
  description = "The network security group to associate with the subnet"
}
