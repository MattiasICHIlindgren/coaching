#--Test--

# RG
variable "resource_group_name_Test" {
  type        = string
  description = "The resource group for the Test SPoke2"
}

#Location
variable "location_Test" {
  type        = string

  description = "The location of the deployment"
}

#Vnet values
variable "VnetName_Test" {
  type        = string
  description = "The name of the VNet Test"
}


variable "vnet_address_space_Test" {
  type        = list(any)
  description = "The address space of the VNet Test" 
}

# SubnetID 
variable "SubnetID_Test" {
    type = string
    description = "The subnet ID the network card attaches to "
}

#VM values 
variable "VMname_Test" {
    type = string
    description = "Name of the Spoke2-Test VM"
}

variable "VMsize_test" {
    type = string
    description = "The size of the VM for Spoke2-Test"
}

variable "localAdmin_test" {
    type = string
    description = "The local admin account"
}

variable "AdminPW_Test" {
    type = string
    sensitive = true
    description = "The local admin password"
} 


#--Hub-- 


#variables for hub
variable "resource_group_name_hub" {
  type        = string
  description = "The resource group for the hub"
}

variable "location_hub" {
  type        = string
  default     = "West Europe"
  description = "The location of the deployment"
}

variable "VnetName_hub" {
  type        = string
  description = "The name of the VNet Hub"
}

variable "vnet_address_space_hub" {
  type        = list(any)
  description = "The address space of the VNet"
}


#--Dev-- 

variable "resource_group_name_dev" {
  type        = string
  description = "The resource group for the Dev"
}

variable "location_dev" {
  type        = string

  description = "The location of the deployment"
}

variable "VnetName_dev" {
  type        = string
  description = "The name of the VNet Dev"
}

variable "vnet_address_space_dev" {
  type        = list(any)
  description = "The address space of the VNet" 
} 

variable "SubnetID_dev" {
    type = string
    description = "The subnet ID the network card attaches to "
}

#VM values 
variable "VMname_dev" {
    type = string
    description = "Name of the Spoke2-Test VM"
}

variable "VMsize_dev" {
    type = string
    description = "The size of the VM for Spoke2-Test"
}

variable "localAdmin_dev" {
    type = string
    description = "The local admin account"
}

variable "AdminPW_dev" {
    type = string
    sensitive = true
    description = "The local admin password"
}


