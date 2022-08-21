terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}

provider "datadog" {}

module "datadog_sythetics_test" {
  source = "../.."

  name      = "test-tf-module"
  subtype   = "multi"
  locations = ["aws:eu-central-1"]
  tags      = ["terraform:true"]

  options_list = {
    tick_every = 60

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
        url    = "https://example.org"
      }
    }
  ]
}