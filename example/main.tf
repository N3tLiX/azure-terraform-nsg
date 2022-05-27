terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-example-vnet"
  location = "westeurope"
}

data "azurerm_resource_group" "this" {
  name = azurerm_resource_group.this.name
}

module "nsg" {
  source              = "github.com/N3tLiX/modules//nsg"
  name                = "nsg-example"
  resource_group_name = data.azurerm_virtual_network.this.resource_group_name
  location            = data.azurerm_virtual_network.this.location
  associate_subnet_id = null
  rules = [
    {
      name        = "AllowRemoteAzureBastionSubnetInbound"
      description = "Allow SSH and RDP from AzureBastionSubnet Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 100
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = ["AzureBastionSubnet"]
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = "192.168.255.0/24"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "DenyRemoteAnyInbound"
      description = "Deny SSH and RDP from Any Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 1000
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = "192.168.255.0/24"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
  ]
}
