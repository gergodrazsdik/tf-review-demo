# Only for the first run through the review service. Never merged: it breaks standards on purpose, to give each
# scanner and agent something to find.
resource "azurerm_storage_account" "service_test" {
  name                            = "badnameforservicetest"
  resource_group_name             = data.azurerm_resource_group.target.name
  location                        = data.azurerm_resource_group.target.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  min_tls_version                 = "TLS1_0"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_public_ip" "service_test" {
  name                = "pip-tf-review-demo-service-test"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}
