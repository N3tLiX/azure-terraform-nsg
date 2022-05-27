# azure-terraform-nsg

## Create a simple Network Security Group (NSG) in Azure

This Terraform module deploys a Network Security Group (NSG) in Azure.

The module creates or expose a security group.
You could use https://github.com/n3tlix/azure-terraform-network to assign the network security group to the subnets.

## Usage in Terraform 0.13
```hcl
module "nsg" {
  source              = "azure-terraform-nsg"
  name                = "nsg-example"
  resource_group_name = "rg-example-nsg"
  location            = "westeurope"
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
```

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

### Native (Mac/Linux)

#### Prerequisites

- [Terraform **(~> 0.14.9")**](https://www.terraform.io/downloads.html)

## Authors

Originally created by [Patrick Hayo](http://github.com/adminph-de)

## License

[MIT](LICENSE)