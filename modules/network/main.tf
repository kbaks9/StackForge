resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_address_space]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "web" {
  name                 = var.subnet_web_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.prefix_web]
}

resource "azurerm_subnet" "app" {
  name                 = var.subnet_app_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.prefix_app]
}

resource "azurerm_subnet" "data" {
  name                 = var.subnet_data_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.prefix_data]
}
