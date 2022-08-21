terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "datadog" {}

# An example of a JSON document you might pull/generate from an internal API
variable "json_results" {
  default = <<EOJ
{
  "https://example.org": {
    "test_frequency_in_sec": 120,
    "locations": ["aws:us-east-1"]
  },
  "https://google.com": {
    "test_frequency_in_sec": 60,
    "locations": ["aws:us-east-2"]
  },
  "https://amazon.com": {
    "test_frequency_in_sec": 180,
    "locations": [
      "aws:us-east-1",
      "aws:us-east-2"
    ]
  }
}
EOJ
}

module "datadog_sythetics_test" {
  source   = "../.."
  for_each =  jsondecode(var.json_results)

  name      = "Simple uptime monitor for ${each.key}"
  subtype   = "multi"
  locations = each.value["locations"]
  tags      = ["terraform:true"]

  options_list = {
    tick_every = each.value["test_frequency_in_sec"]

    retry = {
      count    = 2
      interval = 300
    }

    monitor_options = {
      renotify_interval = 120
    }
  }

  api_steps = [
    {
      name = "Test first"

      assertions = [
        {
          type     = "statusCode"
          operator = "is"
          target   = "200"
        }
      ]

      request_definition = {
        method = "GET"
        url    = each.key
      }
    }
  ]
}