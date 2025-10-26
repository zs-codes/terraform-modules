# Create a resource group
resource "azurerm_resource_group" "myrg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "myvnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Create a subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "myIp" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "myNIC" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myIp.id
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "myVM" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.myNIC.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
