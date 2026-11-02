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

# Test only, from here to the end of the file.
data "azurerm_subscription" "current" {}

resource "azurerm_network_security_group" "test" {
  name                = "nsg-test-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}

resource "azurerm_network_security_rule" "test" {
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
  network_security_group_name = azurerm_network_security_group.test.name
}

resource "azurerm_storage_account" "test" {
  name                            = "sttestprod"
  resource_group_name             = data.azurerm_resource_group.target.name
  location                        = data.azurerm_resource_group.target.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = true

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_role_assignment" "test" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_service_plan" "test" {
  name                = "asp-test-prod"
  resource_group_name = data.azurerm_resource_group.target.name
  location            = data.azurerm_resource_group.target.location
  os_type             = "Linux"
  sku_name            = "P1v3"

  tags = {
    owner       = "gergodrazsdik"
    environment = "prod"
    project     = "tf-review-demo"
  }
}
