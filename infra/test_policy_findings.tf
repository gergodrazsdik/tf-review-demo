# Breaks the standards on purpose, to test the reviewer from a draft PR. Never merged.
resource "azurerm_virtual_network" "missing_tags" {
  name                = "vnet-missing-tags-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.43.0.0/16"]
}

resource "azurerm_virtual_network" "bad_name" {
  name                = "BadName_![x](https://example.com/a.png)"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.44.0.0/16"]

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}
