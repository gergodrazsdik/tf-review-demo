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

# Test only: a paid resource, to see a real priced comment.
resource "azurerm_service_plan" "cost_test" {
  name                = "asp-cost-test-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}
