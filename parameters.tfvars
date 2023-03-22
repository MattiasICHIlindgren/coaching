#Spoke1-dev values 
resource_group_name_dev = "Spoke1-Dev"
location_dev            = "West Europe"
VnetName_dev            = "VnetDev"
vnet_address_space_dev  = ["10.14.0.0/16"]
SubnetID_dev            = "Subnet1"
VMname_dev              = "Spoke1-DevVM"
VMsize_dev              = "Standard_B2s"
localAdmin_dev          = "adminuser1"
AdminPW_dev             = "H3lloWorld124!"


#Spoke2-test values 

resource_group_name_Test = "Spoke2-Test"
location_Test            = "West Europe"
VnetName_Test            = "VnetTest"
vnet_address_space_Test  = ["10.15.0.0/16"]
SubnetID_Test            = "Subnet1"
VMname_Test              = "Spoke2-TestVM"
VMsize_test              = "Standard_B2s"
localAdmin_test          = "adminuser2"
AdminPW_Test             = "H3lloWorld123!"



# hub values 
resource_group_name_hub = "Hub"
location_hub            = "West Europe"
VnetName_hub            = "VnetHub"
vnet_address_space_hub  = ["10.13.0.0/16"]


