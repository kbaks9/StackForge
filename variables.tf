variable "resource_group" {
  type        = string
  description = "Resource group"
}

variable "location" {
  type        = string
  description = "Resources are deployed in this region"
}

variable "subscription_id" {
  type        = string
  description = "The subscription identifier"
}

### Network

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

### NSG

variable "nsg_name" { type = string }
variable "nsg_web_name" { type = string }
variable "nsg_app_name" { type = string }
variable "nsg_data_name" { type = string }
variable "my_ip" { type = string }

### VM
