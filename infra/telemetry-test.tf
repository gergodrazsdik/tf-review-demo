# Only to run a review on the new image and find its metrics in App Insights. Never merged.
resource "azurerm_public_ip" "telemetry_test" {
  name                = "pip-tf-review-demo-telemetry-test"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
