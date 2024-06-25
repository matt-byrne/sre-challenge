#############
# Providers #
#############

terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }

  backend "azurerm" {
    resource_group_name  = "akqa-sre-challenge"
    storage_account_name = "akqasrechallengetfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id

  skip_provider_registration = true

  features {}
}

provider "newrelic" {
  region = var.newrelic_region
}

########
# Data #
########

data "newrelic_account" "acc" {}

#######################
# Modules & Resources #
#######################

# < Your code here >