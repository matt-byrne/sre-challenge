#############
# Variables #
#############

variable "azure_subscription_id" {
  description = "The Azure subscription ID."
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID."
}

variable "azure_client_id" {
  description = "The Azure client ID."
}

variable newrelic_region {
  description = "The New Relic region."
  default     = "US"
}