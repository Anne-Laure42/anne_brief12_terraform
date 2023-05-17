#Create managed disk for VMS
resource "azurerm_managed_disk" "anne_terraform_disk" {
   count                = 2
   name                 = "datadisk_existing_${count.index}"
   location             = azurerm_resource_group.anne_terraform_rg.location
   resource_group_name  = azurerm_resource_group.anne_terraform_rg.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "20"
 }

 resource "azurerm_availability_set" "anne_terraform_avset" {
   name                         = "anne_avset"
   location                     = azurerm_resource_group.anne_terraform_rg.location
   resource_group_name          = azurerm_resource_group.anne_terraform_rg.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

 resource "azurerm_virtual_machine" "anne_terraform_vm" {
   count                 = 2
   name                  = "anne_vm${count.index}"
   location              = azurerm_resource_group.anne_terraform_rg.location
   availability_set_id   = azurerm_availability_set.anne_terraform_avset.id
   resource_group_name   = azurerm_resource_group.anne_terraform_rg.name
   network_interface_ids = [element(azurerm_network_interface.anne_terraform_ni.*.id, count.index)]
   vm_size               = "Standard_DS1_v2"

#Delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination = true

#Delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = true


#Cretae image for VMS
   storage_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "16.04-LTS"
     version   = "latest"
   }

#Cretae OS disk for VMS
   storage_os_disk {
     name              = "myosdisk${count.index}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   storage_data_disk {
     name            = element(azurerm_managed_disk.anne_terraform_disk.*.name, count.index)
     managed_disk_id = element(azurerm_managed_disk.anne_terraform_disk.*.id, count.index)
     create_option   = "Attach"
     lun             = 1
     disk_size_gb    = element(azurerm_managed_disk.anne_terraform_disk.*.disk_size_gb, count.index)
   }


#Configuration for admin connection
   os_profile {
     computer_name  = "hostname"
     admin_username = "testadmin"
     admin_password = "Password1234!"
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }

   tags = {
     environment = "staging"
   }
 }
