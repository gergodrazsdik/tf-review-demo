# What a repo made from this template changes: the workload names the resource group, every resource (ADR-001)
# and the project tag, and the owner is whoever answers for it (ADR-002). Bootstrap's repos map names the same
# resource group.
locals {
  workload    = "tf-review-demo"
  environment = "prod"
  owner       = "gergodrazsdik"

  tags = {
    owner       = local.owner
    environment = local.environment
    project     = local.workload
  }
}

# Bootstrap in tf-review creates this resource group and the identities' roles on it.
data "azurerm_resource_group" "target" {
  name = "rg-${local.workload}-${local.environment}"
}

# A virtual network costs nothing, so the demo stays free while it's deployed.
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.workload}-${local.environment}"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.42.0.0/16"]

  tags = local.tags
}

# A subnet for a web front end, with HTTPS open to the internet and nothing else. Subnets and NSGs cost nothing.
resource "azurerm_subnet" "app" {
  name                 = "snet-app-${local.workload}-${local.environment}"
  resource_group_name  = data.azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.42.1.0/24"]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-${local.workload}-${local.environment}"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location

  tags = local.tags
}

resource "azurerm_network_security_rule" "https_in" {
  name                        = "allow-https-in"
  resource_group_name         = data.azurerm_resource_group.target.name
  network_security_group_name = azurerm_network_security_group.app.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.42.1.0/24"
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}


# Seeded case C10: subnets don't support tags, so this must not be reported.
resource "azurerm_subnet" "seed" {
  name                 = "snet-seed-prod"
  resource_group_name  = data.azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.42.2.0/24"]
}
