provider "azurerm" {
  features {}
  # Configuration options
}

# Added public IP to allow SSH connection for provisioners
resource "azurerm_public_ip" "main" {
  for_each = var.component
  name                = "${each.key}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  for_each = var.component
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  

  ip_configuration {
    name                          = "workstation"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/workstation"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "workstation" {
  for_each = var.component
  network_interface_id      = azurerm_network_interface.main[each.key].id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "workstation" {
  name                = "workstation"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                =  "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.main["workstation"].id,
  ]

  admin_username = "devops"
  admin_password = "Devops@12345"
  disable_password_authentication = false
  vtpm_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshopImage"
  provisioner "file" {
    source      = "./install.sh"
    destination = "/home/devops/install.sh"

    connection {
        type     = "ssh"
        user     = "devops"
        password = "Devops@12345"
        host     = azurerm_linux_virtual_machine.workstation.public_ip_address
    }
    }
}

resource "null_resource" "ws_name" {
    depends_on = [ azurerm_linux_virtual_machine.workstation ]

    provisioner "remote-exec" {
          connection {
        type     = "ssh"
        user     = "devops"
        password = "Devops@12345"
        host     = azurerm_linux_virtual_machine.workstation.public_ip_address
    }
    inline = [
      "chmod +x /home/devops/install.sh",
      "bash /home/devops/install.sh",
    ]

   }
}

# resource "azurerm_linux_virtual_machine" "jenkins" {
#   name                = "jenkins"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   size                =  "Standard_B2s"
#   network_interface_ids = [
#     azurerm_network_interface.main["jenkins"].id,
#   ]

#   admin_username = "devops"
#   admin_password = "Devops@12345"
#   disable_password_authentication = false
#   vtpm_enabled = true
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshopImage"
#   provisioner "file" {
#     source      = "./jenkins.sh"
#     destination = "/home/devops/jenkins.sh"

#     connection {
#         type     = "ssh"
#         user     = "devops"
#         password = "Devops@12345"
#         host     = azurerm_linux_virtual_machine.jenkins.public_ip_address
#     }
#     }
# }

# resource "null_resource" "jenkins_name" {
#     depends_on = [ azurerm_linux_virtual_machine.jenkins ]

#     provisioner "remote-exec" {
#           connection {
#         type     = "ssh"
#         user     = "devops"
#         password = "Devops@12345"
#         host     = azurerm_linux_virtual_machine.jenkins.public_ip_address
#     }
#     inline = [
#       "chmod +x /home/devops/jenkins.sh",
#       "bash /home/devops/jenkins.sh",
#     ]

#    }
# }