 resource "azurerm_virtual_network" "anne_terraform_network" {
   name                = "anne_vnet"
   address_space       = ["10.20.0.0/16"]
   location            = azurerm_resource_group.anne_terraform_rg.location
   resource_group_name = azurerm_resource_group.anne_terraform_rg.name
 }

 resource "azurerm_subnet" "anne_terraform_subnet" {
   name                 = "anne_subnet"
   resource_group_name  = azurerm_resource_group.anne_terraform_rg.name
   virtual_network_name = azurerm_virtual_network.anne_terraform_network.name
   address_prefixes     = ["10.20.10.0/24"]
 }

#Create Private Network Interfaces
resource "azurerm_network_interface" "anne_terraform_ni" {
  name                = "anneni${count.index + 1}"
  location            = azurerm_resource_group.anne_terraform_rg.location
  resource_group_name = azurerm_resource_group.anne_terraform_rg.name
  count               = 2

  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.anne_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"

  }
}
