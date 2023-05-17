#Create public IP for LB
resource "azurerm_public_ip" "anne_terraform_lbip" {
   name                         = "anne_publiciplb"
   location                     = azurerm_resource_group.anne_terraform_rg.location
   resource_group_name          = azurerm_resource_group.anne_terraform_rg.name
   allocation_method            = "Static"
 }

#Create LB
resource "azurerm_lb" "anne_terraform_lb" {
   name                = "anne_loadBalancer"
   location            = azurerm_resource_group.anne_terraform_rg.location
   resource_group_name = azurerm_resource_group.anne_terraform_rg.name

   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.anne_terraform_lbip.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "anne_terraform_bp" {
   loadbalancer_id     = azurerm_lb.anne_terraform_lb.id
   name                = "BackEndAddressPool"
 }
