terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_network_security_rule" "this" {
  for_each = { for rule in var.rules : rule.name => rule }

  name                                       = each.key
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  network_security_group_name                = azurerm_network_security_group.this.name
  description                                = each.value.description
  protocol                                   = each.value.protocol
  access                                     = each.value.access
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  source_port_range                          = each.value.source.port_range != null ? each.value.source.port_range : null
  source_port_ranges                         = each.value.source.port_ranges != null ? each.value.source.port_ranges : null
  source_address_prefix                      = each.value.source.address_prefix != null ? each.value.source.address_prefix : null
  source_address_prefixes                    = each.value.source.address_prefixes != null ? each.value.source.address_prefixes : null
  source_application_security_group_ids      = each.value.source.application_security_group_ids != null ? each.value.source.application_security_group_ids : null
  destination_port_range                     = each.value.destination.port_range != null ? each.value.destination.port_range : null
  destination_port_ranges                    = each.value.destination.port_ranges != null ? each.value.destination.port_ranges : null
  destination_address_prefix                 = each.value.destination.address_prefix != null ? each.value.destination.address_prefix : null
  destination_address_prefixes               = each.value.destination.address_prefixes != null ? each.value.destination.address_prefixes : null
  destination_application_security_group_ids = each.value.destination.application_security_group_ids != null ? each.value.destination.application_security_group_ids : null
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = var.associate_subnet_id
  network_security_group_id = azurerm_network_security_group.this.id
}
