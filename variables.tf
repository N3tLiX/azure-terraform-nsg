variable "name" {
  description = "(Required) Specifies the name of the network security group. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "associate_subnet_id" {
  description = "(Optional) The ID of the Subnet. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "rules" {
  type = list(object({
    name        = string
    description = string
    protocol    = string
    access      = string
    priority    = string
    direction   = string

    source = object({
      port_range                     = string
      port_ranges                    = list(string)
      address_prefix                 = string
      address_prefixes               = list(string)
      application_security_group_ids = list(string)
    })

    destination = object({
      port_range                     = string
      port_ranges                    = list(string)
      address_prefix                 = string
      address_prefixes               = list(string)
      application_security_group_ids = list(string)
    })
  }))
}

variable "tags" {
  description = "(Optional) Specifies the tags of the network security group"
  default     = {}
}
