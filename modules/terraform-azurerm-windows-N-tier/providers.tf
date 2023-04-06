terraform {
  required_version = ">= 1.4.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}
