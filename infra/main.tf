# Bootstrap in tf-review creates this resource group and the identities' roles on it.
data "azurerm_resource_group" "target" {
  name = "rg-tf-review-demo-prod"
}

# A virtual network costs nothing, so the demo stays free while it's deployed.
resource "azurerm_virtual_network" "main" {
  name                = "vnet-tf-review-demo-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.42.0.0/16"]

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}

# Seeded case C1: SSH open to the internet.
resource "azurerm_network_security_group" "seed" {
  name                = "nsg-seed-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}

resource "azurerm_network_security_rule" "seed" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.target.name
  network_security_group_name = azurerm_network_security_group.seed.name
}
