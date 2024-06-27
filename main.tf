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
################################################################
# CREATING SYNTHETIC MONITORS
# Not possible at this time to create the STEP monitor to fill in the contact us option using TERRAFORM, monitor have been created manually
# This is not possible because I currently don't have all the new relic information
################################################################
# Creating Synthetic Monitor for the ssl expiry
resource "newrelic_synthetics_cert_check_monitor" "cert-check-monitor-N" {
  name = "cert-check-monitor-N"
  domain = "https://witty-water-008de0c00.5.azurestaticapps.net/#home"
  certificate_expiration = "10"
  period = "EVERY_6_HOURS"
  status = "ENABLED"
  locations_public = ["US_EAST_2"]
}

# Creating Simple Browser Monitor
resource "newrelic_synthetics_monitor" "ReactApp-PingTest-N" {
  name = "ReactApp-PingTest-N"
  type = "SIMPLE"
  period = "EVERY_6_HOURS"
  status = "ENABLED"
  uri = "https://witty-water-008de0c00.5.azurestaticapps.net/#home"
  verify_ssl = "true"
  locations_public = ["US_EAST_2"]
}
####### Monitors created
################################################################

################################################################
# Section 2: Creating Dashboard to view the Synthetics checks
################################################################

resource "newrelic_one_dashboard_json" "React-App-Synthetics-N" {
  json = file("dashboard.json")
}

################################################################
# Section 3: Creating Alerts for all 3 monitors
################################################################
# Create New Alert Policy
resource "newrelic_alert_policy" "ReactApp_Policy-N" {
  name = "ReactApp Signals Final"
}

# Create Alert for SSL Certificate
resource "newrelic_nrql_alert_condition" "cert-expiring-N" {
  account_id = 4493573
  policy_id = newrelic_alert_policy.ReactApp_Policy-N.id
  type = "baseline"
  name = "cert-expiring"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE monitorName = (${newrelic_synthetics_cert_check_monitor.cert-check-monitor-N.name}) FACET monitorName"
  }

  critical {
    operator = "above"
    threshold = 30
    threshold_duration = 18000
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 18000
  aggregation_method = "event_flow"
  aggregation_delay = 120
  baseline_direction = "upper_and_lower"
}

# Create Alert for Ping Test Failure
resource "newrelic_nrql_alert_condition" "ping-test-failure-N" {
  account_id = 4493573
  policy_id = newrelic_alert_policy.ReactApp_Policy-N.id
  type = "baseline"
  name = "ping-test-failure-N"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE monitorName = (${newrelic_synthetics_monitor.ReactApp-PingTest-N.name}) FACET monitorName"   
  }

  critical {
    operator = "above"
    threshold = 30
    threshold_duration = 18000
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 18000
  aggregation_method = "event_flow"
  aggregation_delay = 120
  baseline_direction = "upper_and_lower"
}

# Create Alert for Form Submission Failure
# here using the name of the monitor directly as it was not declared in Terraform due to lack of knowlegde with NewRelic Naming conventions
resource "newrelic_nrql_alert_condition" "form_submission_failure" {
  account_id = 4493573
  policy_id = newrelic_alert_policy.ReactApp_Policy-N.id
  type = "baseline"
  name = "form_submission_failure"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck WHERE monitorName = 'ReactApp-submitform' FACET monitorName"
  }

  critical {
    operator = "above"
    threshold = 30
    threshold_duration = 18000
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 18000
  aggregation_method = "event_flow"
  aggregation_delay = 120
  baseline_direction = "upper_and_lower"
}

########################################
# Section 4: Get notified via Email when Alert Triggers
########################################
#Configure Email Destinations
resource "newrelic_notification_destination" "email-destination-N" {
  name = "alert-email-N"
  type = "EMAIL"

  property {
    key = "email"
    value = "akqasrechallenge47806911@gmail.com"
  }
}

#Configure Teams Channel with Subject
resource "newrelic_notification_channel" "alert-email-N" {
  name = "alert-email-N"
  type = "EMAIL"
  destination_id = newrelic_notification_destination.email-destination-N.id
  product = "IINT"

  property {
    key = "subject"
    value = "New Subject"
  }
}


resource "newrelic_workflow" "React-workflow-N" {
  name = "React-workflow-N"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "filter-example"
    type = "FILTER"

  predicate {
     attribute = "accumulations.sources"
     operator = "EXACTLY_MATCHES"
     values = ["newrelic"]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.alert-email-N.id
  }
}