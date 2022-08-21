# Terraform Module for Setting up Datadog Synthetics Test(s)

This module is used to create, manage, and update [Datadog's Synethentics Test](https://docs.datadoghq.com/synthetics/).  The primary use-case for this module as envisioned by its authors is the ability to just pass in structured data (JSON, YAML, HCL maps, etc.) to create tests, instead of requiring Terraform.  This is useful if want users who dont know Terraform, third-party remote systems via an API, etc. to return information that you can then turn into tests.

The module is fairly unopinionated, but does set a few defaults (like the `type` and `status`) to reduce the boilerplate, but these can be changed as needed.

## Structure

Because the [Datadog synthetics resource](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test) makes heavy use of Terraform blocks, this module follows the following heauristic for passing in data:

- If a block can be used multiple times, the input variable will be (essentially) a **list of maps**, and the input variable/field will have an `s` at the end to signal this
- If only a single block can be created, the input variable/field will be a **map**.

For example, the `options_list` block can only be set once, so the input variable would look like:

```hcl
options_list = {
  tick_every = 60
}
```

Whereas you can create multiple `api_step` blocks, and within this, you can create multiple `assertion` blocks, but only one `request_definition` so the input looks like:

```hcl
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
```

## Examples

The following is a simple example for setting up a basic uptime monitor:

```hcl
module "datadog_sythetics_test" {
  source = "."

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
```

While writing your test(s) like this is perfectly valid, it's not really where this module shines.  Imagine instead you wanted to create this test (or any test) for 500 URLs, with slightly different settings for each?  If you imagine that you can pull these URLs from a third-party API in your organization, which returns something like:

```json
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
```

You could then do:

```hcl
data "http" "get_urls_to_monitor" {
  url = "https://some-company.com/api/v1/urls"

  request_headers = {
    content-type = "application/json"
    access_key   = "somekindofaccesskey"
  }
}

module "datadog_sythetics_test" {
  source   = "."
  for_each =  jsondecode(data.http.get_urls_to_monitor.response_body)

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
```

Or, if you wanted another team or group which doesn't know Terraform/HCL, but can write, copy and paste, etc. some YAML configuration, these tests could be written in YAML, stored in a repo, remote API, etc. and then you could `yamldecode` this data into HCL, which you could pass into the module directly, as seen above, or transform it using Terraform locals (`for` blocks, functions, etc.) to get your desired tests.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [datadog_synthetics_test.main](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_steps"></a> [api\_steps](#input\_api\_steps) | Steps for multistep api tests | `list(any)` | `null` | no |
| <a name="input_assertions"></a> [assertions](#input\_assertions) | Assertions used for the test | `list(any)` | `null` | no |
| <a name="input_browser_steps"></a> [browser\_steps](#input\_browser\_steps) | Steps for browser tests | `list(any)` | `null` | no |
| <a name="input_browser_variables"></a> [browser\_variables](#input\_browser\_variables) | Variables used for a browser test steps | `list(any)` | `null` | no |
| <a name="input_config_variables"></a> [config\_variables](#input\_config\_variables) | Variables used for the test configuration | `list(any)` | `null` | no |
| <a name="input_device_ids"></a> [device\_ids](#input\_device\_ids) | Array with the different device IDs used to run the test. Valid values are laptop\_large, tablet, mobile\_small, chrome.laptop\_large, chrome.tablet, chrome.mobile\_small, firefox.laptop\_large, firefox.tablet, firefox.mobile\_small, edge.laptop\_large, edge.tablet, edge.mobile\_small | `list(string)` | <pre>[<br>  "laptop_large"<br>]</pre> | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether this test should be created | `bool` | `true` | no |
| <a name="input_locations"></a> [locations](#input\_locations) | Array of locations used to run the test. Refer to Datadog documentation for available locations | `list(string)` | n/a | yes |
| <a name="input_message"></a> [message](#input\_message) | A message to include with notifications for this synthetics test | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Datadog synthetics test | `string` | n/a | yes |
| <a name="input_options_list"></a> [options\_list](#input\_options\_list) | Options for your tests (pass in a map) | `any` | `null` | no |
| <a name="input_request_basicauth"></a> [request\_basicauth](#input\_request\_basicauth) | The HTTP basic authentication credentials (pass in a map) | `any` | `null` | no |
| <a name="input_request_client_certificate"></a> [request\_client\_certificate](#input\_request\_client\_certificate) | Client certificate to use when performing the test request (pass in a map) | `any` | `null` | no |
| <a name="input_request_definition"></a> [request\_definition](#input\_request\_definition) | Required if `type = "api"`. The synthetics test request (pass in a map) | `any` | `null` | no |
| <a name="input_request_headers"></a> [request\_headers](#input\_request\_headers) | Header name and value map | `any` | `null` | no |
| <a name="input_request_proxy"></a> [request\_proxy](#input\_request\_proxy) | The proxy to perform the test (pass in a map) | `any` | `null` | no |
| <a name="input_request_query"></a> [request\_query](#input\_request\_query) | Query arguments name and value map | `map(string)` | `null` | no |
| <a name="input_set_cookie"></a> [set\_cookie](#input\_set\_cookie) | Cookies to be used for a browser test request, using the Set-Cookie syntax | `string` | `null` | no |
| <a name="input_status"></a> [status](#input\_status) | Define whether you want to start (live) or pause (paused) a Synthetic test. Valid values are `live`, `paused`. | `string` | `"live"` | no |
| <a name="input_subtype"></a> [subtype](#input\_subtype) | The subtype of the Synthetic API test. Defaults to http. Valid values are http, ssl, tcp, dns, multi, icmp, udp, websocket, grpc | `string` | `"http"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags to associate with your synthetics test. This can help you categorize and filter tests in the manage synthetics page of the UI. | `list(string)` | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | Synthetics test type. Valid values are `api`, `browser`. | `string` | `"api"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_test"></a> [test](#output\_test) | n/a |
