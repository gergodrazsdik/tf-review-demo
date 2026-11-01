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

  # C8: a tag value changes to another valid value, so this must not be reported.
  tags = {
    owner       = "platform-team"
    environment = "prod"
    project     = "tf-review-demo"
  }
}

# Test only: each resource below is one seeded case.

# C5: missing tags.
resource "azurerm_virtual_network" "c5_missing_tags" {
  name                = "vnet-c5-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.43.0.0/16"]
}

# C6: a name that breaks ADR-001.
resource "azurerm_virtual_network" "c6_bad_name" {
  name                = "MyBadNetwork"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.44.0.0/16"]

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}

# C9: an environment value ADR-002 doesn't allow, which the Rego doesn't catch.
resource "azurerm_virtual_network" "c9_bad_environment" {
  name                = "vnet-c9-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.45.0.0/16"]

  tags = {
    owner       = "gergodrazsdik"
    environment = "production"
    project     = "tf-review-demo"
  }
}

# C10: a subnet has no tags attribute, so it must not be reported.
resource "azurerm_subnet" "c10_subnet" {
  name                 = "snet-c10-prod"
  resource_group_name  = data.azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.42.1.0/24"]
}
