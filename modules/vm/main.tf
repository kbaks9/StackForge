resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group


  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.nic-pip[0].id : null
  }
}

resource "azurerm_public_ip" "nic-pip" {
  count               = var.create_public_ip ? 1 : 0
  name                = "public-ip-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  disable_password_authentication = var.ssh_public_key != null
  dynamic "admin_ssh_key" {
    # If an SSH key is not null (which means it exists): create one admin_ssh_key block
    # Otherwise: create zero admin_ssh_key blocks
    for_each = var.ssh_public_key != null ? [var.ssh_public_key] : []
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
