# Create Datadog synthetics browser site availability test
resource "datadog_synthetics_test" "main" {
  count = var.enabled ? 1 : 0

  # Simple Settings
  name            = var.name
  status          = var.status
  type            = var.type
  subtype         = var.type == "browser" ? null : var.subtype
  device_ids      = var.type == "browser" ? var.device_ids : null
  message         = var.message
  locations       = var.locations
  tags            = var.tags
  request_headers = var.request_headers
  request_query   = var.request_query
  set_cookie      = var.set_cookie

  # Dynamic blocks below
  dynamic "options_list" {
    for_each = var.options_list != null ? [var.options_list] : []

    content {
      tick_every = options_list.value["tick_every"]

      accept_self_signed           = try(options_list.value["accept_self_signed"], null)
      allow_insecure               = try(options_list.value["allow_insecure"], null)
      check_certificate_revocation = try(options_list.value["check_certificate_revocation"], null)

      dynamic "ci" {
        for_each = try([options_list.value["ci"]], [])

        content {
          execution_rule = try(ci.value["execution_rule"], null)
        }
      }

      follow_redirects     = try(options_list.value["follow_redirects"], null)
      min_failure_duration = try(options_list.value["min_failure_duration"], null)
      min_location_failed  = try(options_list.value["min_location_failed"], null)
      monitor_name         = try(options_list.value["monitor_name"], null)

      dynamic "monitor_options" {
        for_each = try([options_list.value["monitor_options"]], [])

        content {
          renotify_interval = try(monitor_options.value["renotify_interval"], null)
        }
      }

      monitor_priority = try(options_list.value["monitor_priority"], null)
      no_screenshot    = try(options_list.value["no_screenshot"], null)
      restricted_roles = try(options_list.value["restricted_roles"], null)

      dynamic "retry" {
        for_each = try([options_list.value["retry"]], [])

        content {
          count    = try(retry.value["count"], null)
          interval = try(retry.value["interval"], null)
        }
      }

      dynamic "rum_settings" {
        for_each = try([options_list.value["rum_settings"]], [])

        content {
          is_enabled = rum_settings.value["is_enabled"]

          application_id  = try(rum_settings.value["application_id"], null)
          client_token_id = try(rum_settings.value["client_token_id"], null)
        }
      }
    }
  }

  dynamic "api_step" {
    for_each = var.api_steps != null ? var.api_steps : []

    content {
      name = api_step.value["name"]

      allow_failure = try(api_step.value["allow_failure"], false)

      dynamic "assertion" {
        for_each = try(api_step.value["assertions"], [])

        content {
          operator = assertion.value["operator"]
          type     = assertion.value["type"]

          property = try(assertion.value["property"], null)
          target   = try(assertion.value["target"], null)

          dynamic "targetjsonpath" {
            for_each = try([assertion.value["targetjsonpath"]], [])

            content {
              jsonpath    = targetjsonpath.value["jsonpath"]
              operator    = targetjsonpath.value["operator"]
              targetvalue = targetjsonpath.value["targetvalue"]
            }
          }
        }
      }

      dynamic "extracted_value" {
        for_each = try(api_step.value["extracted_values"], [])

        content {
          name = extracted_value.value["name"]
          type = extracted_value.value["type"]

          dynamic "parser" {
            for_each = try([extracted_value.value["parser"]], [])

            content {
              type = parser.value["type"]

              value = try(parser.value["value"], null)
            }
          }
        }
      }

      is_critical = try(api_step.value["is_critical"], null)

      dynamic "request_basicauth" {
        for_each = try([api_step.value["request_basicauth"]], [])

        content {
          access_key    = try(request_basicauth.value["access_key"], null)
          domain        = try(request_basicauth.value["domain"], null)
          password      = try(request_basicauth.value["password"], null)
          region        = try(request_basicauth.value["region"], null)
          secret_key    = try(request_basicauth.value["secret_key"], null)
          service_name  = try(request_basicauth.value["service_name"], null)
          session_token = try(request_basicauth.value["session_token"], null)
          type          = try(request_basicauth.value["type"], null)
          username      = try(request_basicauth.value["username"], null)
          workstation   = try(request_basicauth.value["workstation"], null)
        }
      }

      dynamic "request_client_certificate" {
        for_each = try([api_step.value["request_client_certificate"]], [])

        content {
          dynamic "cert" {
            for_each = try([request_client_certificate.value["cert"]], [])

            content {
              content  = cert.value["content"]
              filename = try(cert.value["filename"], null)
            }
          }

          dynamic "key" {
            for_each = try([request_client_certificate.value["key"]], [])

            content {
              content  = key.value["content"]
              filename = try(key.value["filename"], null)
            }
          }
        }
      }

      dynamic "request_definition" {
        for_each = try([api_step.value["request_definition"]], [])

        content {
          allow_insecure          = try(request_definition.value["allow_insecure"], null)
          body                    = try(request_definition.value["body"], null)
          dns_server              = try(request_definition.value["dns_server"], null)
          dns_server_port         = try(request_definition.value["dns_server_port"], null)
          follow_redirects        = try(request_definition.value["follow_redirects"], null)
          host                    = try(request_definition.value["host"], null)
          message                 = try(request_definition.value["message"], null)
          method                  = try(request_definition.value["method"], null)
          no_saving_response_body = try(request_definition.value["no_saving_response_body"], null)
          number_of_packets       = try(request_definition.value["number_of_packets"], null)
          port                    = try(request_definition.value["port"], null)
          servername              = try(request_definition.value["servername"], null)
          service                 = try(request_definition.value["service"], null)
          should_track_hops       = try(request_definition.value["should_track_hops"], null)
          timeout                 = try(request_definition.value["timeout"], null)
          url                     = try(request_definition.value["url"], null)
        }
      }

      request_headers = try(api_step.value["request_headers"], null)

      dynamic "request_proxy" {
        for_each = try([api_step.value["request_proxy"]], [])

        content {
          url = request_proxy.value["url"]

          headers = try(request_proxy.value["headers"], null)
        }
      }

      request_query = try(api_step.value["request_query"], null)

      dynamic "retry" {
        for_each = try([api_step.value["retry"]], [])

        content {
          count    = try(retry.value["count"], null)
          interval = try(retry.value["interval"], null)
        }
      }

      subtype = try(api_step.value["subtype"], null)
    }
  }

  dynamic "assertion" {
    for_each = var.assertions != null ? var.assertions : []

    content {
      operator = assertion.value["operator"]
      type     = assertion.value["type"]

      property = try(assertion.value["property"], null)
      target   = try(assertion.value["target"], null)

      dynamic "targetjsonpath" {
        for_each = try([assertion.value["targetjsonpath"]], [])

        content {
          jsonpath    = targetjsonpath.value["jsonpath"]
          operator    = targetjsonpath.value["operator"]
          targetvalue = targetjsonpath.value["targetvalue"]
        }
      }
    }
  }

  dynamic "browser_step" {
    for_each = var.browser_steps != null ? var.browser_steps : []

    content {
      name = browser_step.value["name"]

      dynamic "params" {
        for_each = [browser_step.value["params"]]

        content {
          attribute  = try(params.value["attribute"], null)
          check      = try(params.value["check"], null)
          click_type = try(params.value["click_type"], null)
          code       = try(params.value["code"], null)
          delay      = try(params.value["delay"], null)
          element    = try(params.value["element"], null)

          dynamic "element_user_locator" {
            for_each = try([params.value["element_user_locator"]], [])

            content {
              dynamic "value" {
                for_each = [element_user_locator.value["value"]]

                content {
                  value = value.value["value"]

                  type = try(value.value["type"], null)
                }
              }

              fail_test_on_cannot_locate = try(element_user_locator.value["fail_test_on_cannot_locate"], null)
            }
          }

          email             = try(params.value["email"], null)
          file              = try(params.value["file"], null)
          files             = try(params.value["files"], null)
          modifiers         = try(params.value["modifiers"], null)
          playing_tab_id    = try(params.value["playing_tab_id"], null)
          request           = try(params.value["request"], null)
          subtest_public_id = try(params.value["subtest_public_id"], null)
          value             = try(params.value["value"], null)

          dynamic "variable" {
            for_each = try(params.value["variable"], [])

            content {
              example = try(variable.value["example"], null)
              name    = try(variable.value["name"], null)
            }
          }

          with_click = try(params.value["with_click"], null)
          x          = try(params.value["x"], null)
          y          = try(params.value["y"], null)
        }
      }

      type = browser_step.value["type"]

      allow_failure        = try(browser_step.value["allow_failure"], null)
      force_element_update = try(browser_step.value["force_element_update"], null)
      is_critical          = try(browser_step.value["is_critical"], null)
      timeout              = try(browser_step.value["timeout"], null)
    }
  }

  dynamic "browser_variable" {
    for_each = var.browser_variables != null ? var.browser_variables : []

    content {
      name = browser_variable.value["name"]
      type = browser_variable.value["type"]

      example = try(browser_variable.value["example"], null)
      id      = try(browser_variable.value["id"], null)
      pattern = try(browser_variable.value["pattern"], null)
    }
  }

  dynamic "config_variable" {
    for_each = var.config_variables != null ? var.config_variables : []

    content {
      name = config_variable.value["name"]
      type = config_variable.value["type"]

      example = try(config_variable.value["example"], null)
      id      = try(config_variable.value["id"], null)
      pattern = try(config_variable.value["pattern"], null)
    }
  }

  dynamic "request_basicauth" {
    for_each = var.request_basicauth != null ? [var.request_basicauth] : []

    content {
      access_key    = try(request_basicauth.value["access_key"], null)
      domain        = try(request_basicauth.value["domain"], null)
      password      = try(request_basicauth.value["password"], null)
      region        = try(request_basicauth.value["region"], null)
      secret_key    = try(request_basicauth.value["secret_key"], null)
      service_name  = try(request_basicauth.value["service_name"], null)
      session_token = try(request_basicauth.value["session_token"], null)
      type          = try(request_basicauth.value["type"], null)
      username      = try(request_basicauth.value["username"], null)
      workstation   = try(request_basicauth.value["workstation"], null)
    }
  }

  dynamic "request_client_certificate" {
    for_each = var.request_client_certificate != null ? [var.request_client_certificate] : []

    content {
      dynamic "cert" {
        for_each = try([request_client_certificate.value["cert"]], [])

        content {
          content  = cert.value["content"]
          filename = try(cert.value["filename"], null)
        }
      }

      dynamic "key" {
        for_each = try([request_client_certificate.value["key"]], [])

        content {
          content  = try(key.value["content"], null)
          filename = try(key.value["filename"], null)
        }
      }
    }
  }

  dynamic "request_definition" {
    for_each = var.request_definition != null ? [var.request_definition] : []

    content {
      body                    = try(request_definition.value["body"], null)
      dns_server              = try(request_definition.value["dns_server"], null)
      dns_server_port         = try(request_definition.value["dns_server_port"], null)
      host                    = try(request_definition.value["host"], null)
      message                 = try(request_definition.value["message"], null)
      method                  = try(request_definition.value["method"], null)
      no_saving_response_body = try(request_definition.value["no_saving_response_body"], null)
      number_of_packets       = try(request_definition.value["number_of_packets"], null)
      port                    = try(request_definition.value["port"], null)
      servername              = try(request_definition.value["servername"], null)
      service                 = try(request_definition.value["service"], null)
      should_track_hops       = try(request_definition.value["should_track_hops"], null)
      timeout                 = try(request_definition.value["timeout"], null)
      url                     = try(request_definition.value["url"], null)
    }
  }

  dynamic "request_proxy" {
    for_each = var.request_proxy != null ? [var.request_proxy] : []

    content {
      url = request_proxy.value["url"]

      headers = try(request_proxy.value["headers"], null)
    }
  }
}
