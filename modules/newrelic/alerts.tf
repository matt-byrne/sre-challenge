## 4XX / 5XX ERRORS ALERT
resource "newrelic_nrql_alert_condition" "errors_reported" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.Alert_Policy.id
  type                         = "static"
  name                         = "4XX / 5XX Errors Reported"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT count(*) AS 'Error response codes' FROM SyntheticRequest WHERE monitorName = 'Ping Monitor' AND responseCode > 399 FACET responseCode"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

## SSL ALERT
resource "newrelic_nrql_alert_condition" "ssl_certificate_expiration" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.Alert_Policy.id
  type                         = "static"
  name                         = "SSL Certificate Expiration"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT latest(daysToExpiry) FROM SyntheticCheck WHERE monitorName = 'SSL Certificate Monitor' AND result != 'SUCCESS'"
  }

  critical {
    operator              = "below"
    threshold             = 30
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}


## FORM SUBMISSION ALERT
resource "newrelic_nrql_alert_condition" "form_submission_failure" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.Alert_Policy.id
  type                         = "static"
  name                         = "Form Submission Failure"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT latest(formSubmissionSuccess) FROM SyntheticCheck WHERE monitorName = 'Form Submission Monitor' AND result != 'SUCCESS'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}
