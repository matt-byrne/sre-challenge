#############
# Providers #
#############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id
  features {}
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = var.newrelic_region
}
