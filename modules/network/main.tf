resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_address_space]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"] 

  subnet {
    name             = var.subnet_web_name # subnet_web
    address_prefixes = [var.prefix_web]
    #security_group   = azurerm_network_security_group.example.id # module.nsg.example.id (maybe?)
  }

  subnet {
    name             = var.subnet_app_name # subnet_app
    address_prefixes = [var.prefix_app]
    #security_group   = azurerm_network_security_group.example.id # module.nsg.example.id (maybe?)
  }

  subnet {
    name             = var.subnet_data_name # subnet_data
    address_prefixes = [var.prefix_data]
    #security_group   = azurerm_network_security_group.example.id # module.nsg.example.id (maybe?)
  }

  tags = {
    environment = "Dev"
  }
}
