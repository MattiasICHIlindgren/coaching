resource "azurerm_resource_group" "Dev" {
  name     = var.resource_group_name_dev
  location = var.location_dev
}

resource "azurerm_resource_group" "Test" {
  name     = var.resource_group_name_Test
  location = var.location_Test
}

resource "azurerm_resource_group" "Hub" {
  name     = var.resource_group_name_hub
  location = var.location_hub
}



resource "azurerm_subnet" "Subnet1_dev" { 
    name = "DevSubnet1"
    resource_group_name = azurerm_resource_group.Dev.name
    virtual_network_name = azurerm_virtual_network.VnetName_dev.name
    address_prefixes = ["10.14.1.0/24"]
  
}

resource "azurerm_subnet" "Subnet2_dev" { 
    name = "DevSubnet2"
    resource_group_name = azurerm_resource_group.Dev.name
    virtual_network_name = azurerm_virtual_network.VnetName_dev.name
    address_prefixes = ["10.14.2.0/24"]
  
}

resource "azurerm_subnet" "Subnet3_dev" { 
    name = "DevSubnet3"
    resource_group_name = azurerm_resource_group.Dev.name
    virtual_network_name = azurerm_virtual_network.VnetName_dev.name
    address_prefixes = ["10.14.3.0/24"]
  
}

# # three subnets for Spoke2 in Test 
resource "azurerm_subnet" "Subnet1_test" {
  name                 = "TestSubnet1"
  resource_group_name  = azurerm_resource_group.Test.name
  virtual_network_name = azurerm_virtual_network.VnetName_Test.name
  address_prefixes     = ["10.15.1.0/24"]

}

resource "azurerm_subnet" "Subnet2_test" {
  name                 = "TestSubnet2"
  resource_group_name  = azurerm_resource_group.Test.name
  virtual_network_name = azurerm_virtual_network.VnetName_Test.name
  address_prefixes     = ["10.15.2.0/24"]

}

resource "azurerm_subnet" "Subnet3_test" {
  name                 = "TestSubnet3"
  resource_group_name  = azurerm_resource_group.Test.name
  virtual_network_name = azurerm_virtual_network.VnetName_Test.name
  address_prefixes     = ["10.15.3.0/24"]

}


#
resource "azurerm_subnet" "AzureFirewallSubnet" { 
    name = "AzureFirewallSubnet"
    resource_group_name = azurerm_resource_group.Hub.name
    virtual_network_name = azurerm_virtual_network.VnetName_hub.name
    address_prefixes = ["10.13.1.0/24"]
  
}

resource "azurerm_subnet" "HubSubnet2" { 
    name = "HubSubnet2"
    resource_group_name = azurerm_resource_group.Hub.name
    virtual_network_name = azurerm_virtual_network.VnetName_hub.name
    address_prefixes = ["10.13.2.0/24"]
  
}

resource "azurerm_subnet" "HubSubnet3" { 
    name = "HubSubnet3"
    resource_group_name = azurerm_resource_group.Hub.name
    virtual_network_name = azurerm_virtual_network.VnetName_hub.name
    address_prefixes = ["10.13.3.0/24"]
  
}


# NEtwork interface for Spoke2-Test
resource "azurerm_network_interface" "NetInterFace_dev" {
  name                = "${var.VMname_dev}-nic"
  location            = var.location_dev
  resource_group_name = var.resource_group_name_dev

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet1_dev.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NEtwork interface for Spoke2-Test
resource "azurerm_network_interface" "NetInterFace_Test" {
  name                = "${var.VMname_Test}-nic"
  location            = var.location_Test
  resource_group_name = var.resource_group_name_Test

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet1_test.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Vm for for spoke1
resource "azurerm_windows_virtual_machine" "devvm" {
  name                = var.VMname_dev
  resource_group_name = var.resource_group_name_dev
  location            = var.location_dev
  size                = var.VMsize_dev
  admin_username      = var.localAdmin_dev
  admin_password      = var.AdminPW_dev
  network_interface_ids = [
    azurerm_network_interface.NetInterFace_dev.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# Vm for for spoke2
resource "azurerm_windows_virtual_machine" "testvm" {
  name                = var.VMname_Test
  resource_group_name = var.resource_group_name_Test
  location            = var.location_Test
  size                = var.VMsize_test
  admin_username      = var.localAdmin_test
  admin_password      = var.AdminPW_Test
  network_interface_ids = [
    azurerm_network_interface.NetInterFace_Test.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "NSGdev1" {
  name                = "NSG1_InOutdev"
  location            = var.location_dev
  resource_group_name = var.resource_group_name_dev

  security_rule {
    name                       = "Spoke2self_In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.14.0.0/16"
    destination_address_prefix = "10.14.0.0/16"

  }
    security_rule {
    name                       = "Spoke2self_out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.14.0.0/16"
    destination_address_prefix = "10.14.0.0/16"
 }
}


resource "azurerm_network_security_group" "NSGTest1" {
  name                = "NSG1_InOutTest"
  location            = var.location_Test
  resource_group_name = var.resource_group_name_Test

  security_rule {
    name                       = "Spoke2self_In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.15.0.0/16"
    destination_address_prefix = "10.15.0.0/16"
  }
   
  security_rule {
    name                       = "Spoke2self_out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.15.0.0/16"
    destination_address_prefix = "10.15.0.0/16"
  }

  }

resource "azurerm_network_security_group" "NSGdev2" {
  name                = "NSG2_dev"
  location            = var.location_dev
  resource_group_name = var.resource_group_name_dev

  security_rule {
    name                       = "NSG2dev"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.13.0.0/16"
  }
}


resource "azurerm_network_security_group" "NSGTest2" {
  name                = "NSG2_Test"
  location            = var.location_Test
  resource_group_name = var.resource_group_name_Test

  security_rule {
    name                       = "NSG2Test"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.13.0.0/16"
  }
} 

resource "azurerm_virtual_network" "VnetName_Test" {
  name                = var.VnetName_Test
  location            = azurerm_resource_group.Test.location
  resource_group_name = azurerm_resource_group.Test.name
  address_space       = var.vnet_address_space_Test

}

resource "azurerm_virtual_network" "VnetName_dev" {
  name                = var.VnetName_dev
  resource_group_name = azurerm_resource_group.Dev.name
  address_space       = var.vnet_address_space_dev
  location            = azurerm_resource_group.Dev.location
}

resource "azurerm_virtual_network" "VnetName_hub" {
  name                = var.VnetName_hub
  resource_group_name = azurerm_resource_group.Hub.name
  address_space       = var.vnet_address_space_hub
  location            = azurerm_resource_group.Hub.location
}

resource "azurerm_virtual_network_peering" "Spoke1_ToHub" {
  name                      = "Spoke1ToHub"
  resource_group_name       = azurerm_resource_group.Dev.name
  virtual_network_name      = azurerm_virtual_network.VnetName_dev.name
  remote_virtual_network_id = azurerm_virtual_network.VnetName_hub.id
   allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "Hub_ToSpoke1" {
  name                      = "HubToSpoke1"
  resource_group_name       = azurerm_resource_group.Hub.name
  virtual_network_name      = azurerm_virtual_network.VnetName_hub.name
  remote_virtual_network_id = azurerm_virtual_network.VnetName_dev.id
   allow_virtual_network_access = true
  allow_forwarded_traffic      = true
} 

resource "azurerm_virtual_network_peering" "Spoke2_ToHub" {
  name                      = "Spoke2ToHub"
  resource_group_name       = azurerm_resource_group.Test.name
  virtual_network_name      = azurerm_virtual_network.VnetName_Test.name
  remote_virtual_network_id = azurerm_virtual_network.VnetName_hub.id
   allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "Hub_ToSpoke2" {
  name                      = "HubToSpoke2"
  resource_group_name       = azurerm_resource_group.Hub.name
  virtual_network_name      = azurerm_virtual_network.VnetName_hub.name
  remote_virtual_network_id = azurerm_virtual_network.VnetName_Test.id
   allow_virtual_network_access = true
  allow_forwarded_traffic      = true
} 



resource "azurerm_route_table" "Spoke1_2_Hub" {
  name                          = "Spoke1TOhub"
  location                      = azurerm_resource_group.Dev.location
  resource_group_name           = azurerm_resource_group.Dev.name
  disable_bgp_route_propagation = false

  route {
    name           = "DefualtRoute"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address  = "10.14.1.4"
  }
} 

resource "azurerm_route_table" "Spoke2_TO_Hub" {
  name                          = "Spoke2TOhub"
  location                      = azurerm_resource_group.Test.location
  resource_group_name           = azurerm_resource_group.Test.name
  disable_bgp_route_propagation = false

  route {
    name                   = "DefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.15.1.4"
  }
}

resource "azurerm_subnet_route_table_association" "RouteAssociation1" {
  subnet_id      = azurerm_subnet.Subnet1_dev.id
  route_table_id = azurerm_route_table.Spoke1_2_Hub.id
}

resource "azurerm_subnet_route_table_association" "RouteAssociation2" {
  subnet_id      = azurerm_subnet.Subnet1_test.id
  route_table_id = azurerm_route_table.Spoke2_TO_Hub.id
}

resource "azurerm_public_ip" "PublicIP" {
  name                = "PublicIP"
  location            = azurerm_resource_group.Hub.location
  resource_group_name = azurerm_resource_group.Hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "Firewall_Hub" {
  name                = "firewall_hub"
  location            = azurerm_resource_group.Hub.location
  resource_group_name = azurerm_resource_group.Hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration_hub"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.PublicIP.id
  }
}

resource "azurerm_firewall_nat_rule_collection" "WAFruleCollection" {
  name                = "WAFrule"
  azure_firewall_name = azurerm_firewall.Firewall_Hub.name
  resource_group_name = azurerm_resource_group.Hub.name
  priority            = 400
  action              = "Dnat"

  rule {
    name = "Spoke1-Spoke2"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "3389",
    ]

    destination_addresses = [
      azurerm_public_ip.PublicIP.ip_address
    ]

    translated_port = 3389

    translated_address = "10.15.1.4"

    protocols = [
      "TCP",
      "UDP",
    ]
  }


 rule {
    name = "Spoke2-Spoke1"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "3389",
    ]

    destination_addresses = [
      azurerm_public_ip.PublicIP.ip_address
    ]

    translated_port = 3389

    translated_address = "10.14.1.4"

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}

