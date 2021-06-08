// Remember to also add monitor diagnostic alerts to a log analytics workspace if applicable

resource "azurerm_resource_group" "db" {
  count    = var.database ? 1 : 0
  name     = "${var.prefix}-${var.rg_name}-db"
  location = var.location
}

resource "azurerm_network_interface" "db" {
  count               = var.database ? 1 : 0
  name                = "${var.prefix}-${var.db_instance_config.vm_name}-nic-int-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.db[count.index].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.db[count.index].id
  }
}

// remove this resource to have only private IP
resource "azurerm_public_ip" "db" {
  count               = var.database ? 1 : 0
  name                = "${var.prefix}-${var.db_instance_config.vm_name}-nic-ext-db"
  resource_group_name = azurerm_resource_group.db[count.index].name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "db" {
  count                           = var.database ? 1 : 0
  name                            = "${var.prefix}-${var.db_instance_config.vm_name}-db"
  resource_group_name             = azurerm_resource_group.db[count.index].name
  location                        = var.location
  size                            = var.db_instance_config.machine_size
  admin_username                  = var.db_instance_config.admin_username
  admin_password                  = var.db_instance_config.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids = [
    azurerm_network_interface.db.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.db_instance_config.os_disk_storage_account_type
  }

  // source_image_id can replace this if business packer base images are to be used
  source_image_reference {
    publisher = var.db_instance_config.os_publisher
    offer     = var.db_instance_config.os_offer
    sku       = var.db_instance_config.os_sku
    version   = var.db_instance_config.os_version
  }
}
