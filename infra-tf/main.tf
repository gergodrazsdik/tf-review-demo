# Test only: a project planned with Terraform.
data "azurerm_resource_group" "target" {
  name = "rg-tf-review-demo-prod"
}

resource "azurerm_virtual_network" "tf_test" {
  name                = "vnet-tftest-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  address_space       = ["10.47.0.0/16"]
}
