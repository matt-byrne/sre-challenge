## SIMPLE PING MONITOR
resource "newrelic_synthetics_monitor" "ping_monitor" {
  status           = "ENABLED"
  name             = "Ping Monitor"
  period           = "EVERY_15_MINUTES"
  uri              = var.website_url
  type             = "SIMPLE"
  locations_public = var.newrelic_synthetic_region
  verify_ssl       = true
  tag {
    key    = "monitor_type"
    values = ["ping_monitor"]
  }
}

## SIMPLE BROWSER MONITOR
resource "newrelic_synthetics_monitor" "browser_monitor" {
  status           = "ENABLED"
  name             = "Browser Test Monitor"
  period           = "EVERY_DAY"
  uri              = var.website_url
  type             = "BROWSER"
  locations_public = var.newrelic_synthetic_region

  enable_screenshot_on_failure_and_script = true
  validation_string                       = "AKQA"
  verify_ssl                              = true
  tag {
    key    = "monitor_type"
    values = ["browser_monitor"]
  }
}

resource "newrelic_synthetics_script_monitor" "form_submission_monitor" {
  status               = "ENABLED"
  name                 = "Form Submission Monitor"
  type                 = "SCRIPT_BROWSER"
  period               = "EVERY_6_HOURS"
  locations_public     = var.newrelic_synthetic_region
  runtime_type         = "CHROME_BROWSER"
  runtime_type_version = "100"
  script_language      = "JAVASCRIPT"

  script = file("${path.module}/monitor-scripts/form_submission_script.js")

  enable_screenshot_on_failure_and_script = true

  tag {
    key    = "monitor_type"
    values = ["form_submission_monitor"]
  }
}

resource "newrelic_synthetics_script_monitor" "ssl_certificate_monitor" {
  status               = "ENABLED"
  name                 = "SSL Certificate Monitor"
  type                 = "SCRIPT_API"
  period               = "EVERY_6_HOURS"
  locations_public     = var.newrelic_synthetic_region
  runtime_type         = "NODE_API"
  runtime_type_version = "16.10"

  script = file("${path.module}/monitor-scripts/ssl_certificate_script.js")

  tag {
    key    = "monitor_type"
    values = ["ssl_certificate_monitor"]
  }
}


