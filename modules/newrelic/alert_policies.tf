# Create New Alert Policy
resource "newrelic_alert_policy" "Alert_Policy" {
  name = "Website Error Alerts"
}

# Configure Email Destinations
resource "newrelic_notification_destination" "email-destination" {
  account_id = var.newrelic_account_id
  name       = "email-destination"
  type       = "EMAIL"

  property {
    key   = "email"
    value = var.email_recipients
  }
}

# Configure Channel with Subject
resource "newrelic_notification_channel" "email-alerts" {
  account_id     = var.newrelic_account_id
  name           = "email-alerts"
  type           = "EMAIL"
  destination_id = newrelic_notification_destination.email-destination.id
  product        = "IINT"

  property {
    key   = "subject"
    value = "New Subject"
  }
}

# Configure Workflow
resource "newrelic_workflow" "Website-alert-workflow" {
  name                  = "Website-alert-workflow"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "filter-example"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.Alert_Policy.id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.email-alerts.id
  }
}
