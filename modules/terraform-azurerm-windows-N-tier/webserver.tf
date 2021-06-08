// Remember to also add monitor diagnostic alerts to a log analytics workspace if applicable

resource "azurerm_resource_group" "web" {
  count    = var.web ? 1 : 0
  name     = "${var.prefix}-${var.rg_name}-web"
  location = var.location
}

resource "azurerm_network_interface" "web" {
  count               = var.web ? 1 : 0
  name                = "${var.prefix}-${var.web_instance_config.vm_name}-nic-int-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.web.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

// remove this resource to have only private IP
resource "azurerm_public_ip" "web" {
  count               = var.web ? 1 : 0
  name                = "${var.prefix}-${var.web_instance_config.vm_name}-nic-ext-web"
  resource_group_name = azurerm_resource_group.web.name
  location            = var.location
  allocation_method   = "Dynamic"
}

// See notes here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine
resource "azurerm_windows_virtual_machine" "web" {
  name                = "${var.prefix}-${var.web_instance_config.vm_name}-web"
  resource_group_name = azurerm_resource_group.web.name
  location            = azurerm_resource_group.web.location
  size                = var.web_instance_config.machine_size
  admin_username      = var.web_instance_config.admin_username
  admin_password      = var.web_instance_config.admin_password
  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.web_instance_config.os_disk_storage_account_type
  }

  // source_image_id can replace this if business packer base images are to be used
  source_image_reference {
    publisher = var.web_instance_config.os_publisher
    offer     = var.web_instance_config.os_offer
    sku       = var.web_instance_config.os_sku
    version   = var.web_instance_config.os_version
  }
}
