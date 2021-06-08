// Remember to also add monitor diagnostic alerts to a log analytics workspace if applicable

resource "azurerm_resource_group" "app" {
  count    = var.app ? 1 : 0
  name     = "${var.prefix}-${var.rg_name}-app"
  location = var.location
}

resource "azurerm_network_interface" "app" {
  count               = var.app ? 1 : 0
  name                = "${var.prefix}-${var.app_instance_config.vm_name}-nic-int-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app.id
  }
}

// remove this resource to have only private IP
resource "azurerm_public_ip" "app" {
  count               = var.app ? 1 : 0
  name                = "${var.prefix}-${var.app_instance_config.vm_name}-nic-ext-app"
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
  allocation_method   = "Dynamic"
}

// See notes here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine
resource "azurerm_windows_virtual_machine" "app" {
  name                = "${var.prefix}-${var.app_instance_config.vm_name}-app"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  size                = var.app_instance_config.machine_size
  admin_username      = var.app_instance_config.admin_username
  admin_password      = var.app_instance_config.admin_password
  network_interface_ids = [
    azurerm_network_interface.app.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.app_instance_config.os_disk_storage_account_type
  }

  // source_image_id can replace this if business packer base images are to be used
  source_image_reference {
    publisher = var.app_instance_config.os_publisher
    offer     = var.app_instance_config.os_offer
    sku       = var.app_instance_config.os_sku
    version   = var.app_instance_config.os_version
  }
}
