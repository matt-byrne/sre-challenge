########
# Data #
########

data "newrelic_account" "acc" {
  # Configuration for data source
}

#######################
# Modules & Resources #
#######################

module "newrelic" {
  source = "./modules/newrelic"

  website_url               = var.website_url
  newrelic_account_id       = var.newrelic_account_id
  newrelic_api_key          = var.newrelic_api_key
  newrelic_region           = var.newrelic_region
  newrelic_synthetic_region = var.newrelic_synthetic_region
  email_recipients          = var.email_recipients
}
