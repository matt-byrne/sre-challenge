locals {
  ping_monitor_name    = "Ping Monitor"
  browser_monitor_name = "Browser Test Monitor"
  time_range           = "SINCE 1 day AGO LIMIT 30 TIMESERIES AUTO"
}

resource "newrelic_one_dashboard" "observability" {
  name        = "New Relic Terraform Example"
  permissions = "public_read_only"

  # Ensure the dashboard is created after the monitors
  depends_on = [
    newrelic_synthetics_monitor.ping_monitor,
    newrelic_synthetics_monitor.browser_monitor
  ]

  page {
    name = "Synthetic Checks"

    widget_line {
      title  = "Average Duration for Ping Monitor"
      row    = 1
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(duration) FROM SyntheticCheck WHERE monitorName = '${local.ping_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_line {
      title  = "Connection times for Ping Monitor"
      row    = 1
      column = 5
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(durationConnect) as 'Connect', average(durationDNS) AS 'DNS', average(durationSSL) as 'SSL' FROM SyntheticRequest WHERE monitorName = '${local.ping_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_line {
      title  = "Error Response Codes for Ping Monitor"
      row    = 1
      column = 9
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT count(*) AS 'Error response codes' FROM SyntheticRequest WHERE monitorName = '${local.ping_monitor_name}' AND responseCode > 399 FACET responseCode ${local.time_range}
NRQL
      }
    }

    widget_stacked_bar {
      title  = "Performance timings for Browser Monitor"
      row    = 2
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(durationBlocked + durationConnect + durationDNS + durationWait) as 'First Byte', average(firstPaint) as 'First Paint', average(firstContentfulPaint) as 'First Contentful Paint', average(onPageLoad) as 'Page Load' FROM SyntheticRequest WHERE monitorName = '${local.browser_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_area {
      title  = "Total requests by domain"
      row    = 2
      column = 5
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT count(*) FROM SyntheticRequest FACET domain WHERE monitorName = '${local.browser_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_area {
      title  = "Duration by domain"
      row    = 2
      column = 9
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(duration) FROM SyntheticRequest FACET domain WHERE monitorName = '${local.browser_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_stacked_bar {
      title  = "Response Body Size by Content Category"
      row    = 3
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(responseBodySize) FROM SyntheticRequest FACET contentCategory WHERE monitorName = '${local.browser_monitor_name}' ${local.time_range}
NRQL
      }
    }

    widget_area {
      title  = "Resources load time"
      row    = 3
      column = 5
      width  = 4
      height = 3

      nrql_query {
        query = <<NRQL
SELECT average(duration) FROM SyntheticRequest WHERE (entityGuid = 'NDQ5NTA4NHxTWU5USHxNT05JVE9SfDQ0ODE3YmY5LWEzYzUtNDI3MC04YTJiLWNjNTJmZmM3NjQ0OQ') FACET `contentCategory` ${local.time_range}
NRQL
      }
    }
  }
}
