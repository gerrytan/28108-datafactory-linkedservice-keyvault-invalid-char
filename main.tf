terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  # export ARM_SUBSCRIPTION_ID env variable to avoid hardcoding the subscription_id here
}

variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                = "${var.prefix}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_data_factory" "df" {
  name                = "${var.prefix}-df"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_data_factory_linked_service_key_vault" "lskv" {
  name            = "${var.prefix}-kv-thisisaverylongname-thisisaverylongname-thisisaverylongname-thisisaverylongname-thisisaverylongname-thisisaverylongname-thisisaverylongname"
  data_factory_id = azurerm_data_factory.df.id
  key_vault_id    = azurerm_key_vault.kv.id
}
