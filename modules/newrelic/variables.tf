variable "newrelic_account_id" {
  description = "The New Relic account ID."
  type        = number
}

variable "newrelic_api_key" {
  description = "The New Relic API key."
}

variable "website_url" {
  description = "The URL of the website to monitor."
}

variable "email_recipients" {
  description = "Comma-separated list of email recipients for alerts."
}

variable "newrelic_region" {
  description = "The New Relic region."
  type        = string
}

variable "newrelic_synthetic_region" {
  description = "The New Relic Synthetic region."
  type        = list(string)
  default     = ["AWS_US_WEST_1"]
}
