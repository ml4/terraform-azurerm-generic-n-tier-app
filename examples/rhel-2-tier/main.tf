module "generic-n-tier-app_terraform-azurerm-rhel-N-tier" {
  source  = "app.terraform.io/ml4-hc/generic-n-tier-app/azurerm//modules/terraform-azurerm-rhel-N-tier"
  version = "1.0.13"
  prefix  = "ml4"
  rg_name = "rmg_test_net_rg"
  public_subnet_address_spaces = [
    {
      name          = "ml4-vnet-pub-asA"
      address_space = "10.0.0.0/24"
    },
    {
      name          = "ml4-vnet-pub-asB"
      address_space = "10.0.1.0/24"
    },
    {
      name          = "ml4-vnet-pub-asC"
      address_space = "10.0.2.0/24"
    }
  ]
  private_subnet_address_spaces = [
    {
      name          = "ml4-vnet-priv-asA"
      address_space = "10.0.3.0/24"
    },
    {
      name          = "ml4-vnet-priv-asB"
      address_space = "10.0.4.0/24"
    },
    {
      name          = "ml4-vnet-priv-asC"
      address_space = "10.0.5.0/24"
    }
  ]

  // az vm image list --offer RHEL --all --location westeurope -o table

  web = true
  web_instance_config = {
    vm_name                      = "rmg-test-web"
    machine_size                 = "Standard_D2_v4"
    os_publisher                 = "RedHat"
    os_offer                     = "RHEL"
    os_sku                       = "7_9"
    os_version                   = "7.9.2021051701"
    os_disk_storage_account_type = "Standard_LRS"
    admin_username               = "rhel"
    admin_password               = "KHvYv^mMqwQh"
  }

  app = false

  database = true
  db_instance_config = {
    vm_name                      = "rmg-test-web"
    machine_size                 = "Standard_D2_v4"
    os_publisher                 = "RedHat"
    os_offer                     = "RHEL"
    os_sku                       = "7_9"
    os_version                   = "7.9.2021051701"
    os_disk_storage_account_type = "Standard_LRS"
    admin_username               = "rhel"
    admin_password               = "KHvYv^mMqwQh"
  }
}
