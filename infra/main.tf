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

# Seeded case C3: Owner at subscription scope.
data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "seed" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}
