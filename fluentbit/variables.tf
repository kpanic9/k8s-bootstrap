variable "customer" {
  type = string
}

variable "environment" {
  type = string
}

variable "namespace" {
  description = "Namespace name to deploy fluentbit collector"
  type        = string
}

variable "fluentbit_multiline_regex" {
  description = "Regex that will match the beginning of a multiline log message"
  default     = "(?<log>^{\"log\":\"*.\\d{4}-\\d{1,2}-\\d{1,2}\\s\\d{2}:\\d{2}:\\d{2}.*)"
}