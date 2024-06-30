# New Relic Monitoring and Alerting Module

## Overview

This Terraform module is designed to configure and manage a comprehensive monitoring and alerting setup using New Relic. It encompasses creating alert policies, configuring notification channels, setting up various monitors, and building dashboards to visualize the collected data. Below is an overview of the main components and their functions.

## Components

### 1. Alert Policies and Notification Channels

- **Alert Policies**: This module creates alert policies to manage and trigger alerts based on specific conditions.
  - `newrelic_alert_policy` defines the policy name and the criteria for triggering alerts.

- **Notification Destinations**: Configures where notifications should be sent.
  - `newrelic_notification_destination` sets up email notifications for alerting.

- **Notification Channels**: Links the notification destination with a channel that has a specific subject for alert notifications.
  - `newrelic_notification_channel` sets up the email alerts with a custom subject.

- **Workflows**: Defines the workflow for handling alerts, specifying which alerts to notify and how to handle muting rules.
  - `newrelic_workflow` links the alert policy with the notification channel.

### 2. Monitors

- **Ping Monitor**: A simple monitor to check the availability and response time of the website.
  - `newrelic_synthetics_monitor` with type `SIMPLE` monitors the specified URL at regular intervals.

- **Browser Monitor**: Simulates user interactions with a website to monitor its performance and functionality.
  - `newrelic_synthetics_monitor` with type `BROWSER` checks the website's performance and verifies SSL certificates.

- **SSL Certificate Monitor**: Script-based monitor to check the SSL certificate's validity and expiration date.
  - `newrelic_synthetics_script_monitor` uses a custom script to fetch and validate the SSL certificate.

- **Form Submission Monitor**: Automates form submission and checks if the process completes successfully.
  - `newrelic_synthetics_script_monitor` uses a script to simulate filling and submitting a form on the website.

### 3. Dashboard

- **Dashboard Configuration**: Creates a comprehensive dashboard to visualize data from the monitors.
  - `newrelic_one_dashboard` organizes various widgets to display metrics such as average duration, connection times, error codes, and performance timings.

### 4. Providers and Variables

- **Providers**: Specifies the New Relic provider and necessary credentials.
  - `provider "newrelic"` configures the New Relic provider with account ID, API key, and region.

- **Variables**: Defines the variables used throughout the module.
  - Variables like `newrelic_account_id`, `newrelic_api_key`, `website_url`, `email_recipients`, `newrelic_region`, and `newrelic_synthetic_region` are defined to customize the module.

