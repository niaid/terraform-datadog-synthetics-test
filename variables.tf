# Required
variable "locations" {
  description = "Array of locations used to run the test. Refer to Datadog documentation for available locations"
  type        = list(string)
}

variable "name" {
  description = "Name of Datadog synthetics test"
  type        = string
}

# Optional
variable "api_steps" {
  description = "Steps for multistep api tests"
  type        = list(any)
  default     = null
}

variable "assertions" {
  description = "Assertions used for the test"
  type        = list(any)
  default     = null
}

variable "browser_steps" {
  description = "Steps for browser tests"
  type        = list(any)
  default     = null
}

variable "browser_variables" {
  description = "Variables used for a browser test steps"
  type        = list(any)
  default     = null
}

variable "config_variables" {
  description = "Variables used for the test configuration"
  type        = list(any)
  default     = null
}

variable "device_ids" {
  description = "Array with the different device IDs used to run the test. Valid values are laptop_large, tablet, mobile_small, chrome.laptop_large, chrome.tablet, chrome.mobile_small, firefox.laptop_large, firefox.tablet, firefox.mobile_small, edge.laptop_large, edge.tablet, edge.mobile_small"
  type        = list(string)
  default     = ["laptop_large"]
}

variable "enabled" {
  description = "Whether this test should be created"
  type        = bool
  default     = true
}

variable "message" {
  description = "A message to include with notifications for this synthetics test"
  type        = string
  default     = ""
}

variable "options_list" {
  description = "Options for your tests (pass in a map)"
  type        = any
  default     = null
}

variable "request_basicauth" {
  description = "The HTTP basic authentication credentials (pass in a map)"
  type        = any
  default     = null
}

variable "request_client_certificate" {
  description = "Client certificate to use when performing the test request (pass in a map)"
  type        = any
  default     = null
}

variable "request_definition" {
  description = "Required if `type = \"api\"`. The synthetics test request (pass in a map)"
  type        = any
  default     = null
}

variable "request_headers" {
  description = "Header name and value map"
  type        = any
  default     = null
}

variable "request_proxy" {
  description = "The proxy to perform the test (pass in a map)"
  type        = any
  default     = null
}

variable "request_query" {
  description = "Query arguments name and value map"
  type        = map(string)
  default     = null
}

variable "set_cookie" {
  description = "Cookies to be used for a browser test request, using the Set-Cookie syntax"
  type        = string
  default     = null
}

variable "status" {
  description = "Define whether you want to start (live) or pause (paused) a Synthetic test. Valid values are `live`, `paused`."
  type        = string
  default     = "live"
}

variable "subtype" {
  description = "The subtype of the Synthetic API test. Defaults to http. Valid values are http, ssl, tcp, dns, multi, icmp, udp, websocket, grpc"
  type        = string
  default     = "http"
}

variable "tags" {
  description = "A list of tags to associate with your synthetics test. This can help you categorize and filter tests in the manage synthetics page of the UI."
  type        = list(string)
  default     = []
}

variable "type" {
  description = "Synthetics test type. Valid values are `api`, `browser`."
  type        = string
  default     = "api"
}