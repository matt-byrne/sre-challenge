###########
# Backend #
###########

terraform {
  backend "azurerm" {
    resource_group_name  = "akqa-sre-challenge"
    storage_account_name = "akqasrechallengetfstate"
    container_name       = "60803635"
    key                  = "terraform.tfstate"
  }
}
