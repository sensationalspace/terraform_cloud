provider "azurerm" {
  features {}
}

resource "azurerm_management_group" "sysarc2" {
  display_name = "haba managemet group"
}


resource "azurerm_consumption_budget_management_group" "sysarc2" {
  name                = "sysarc2"
  management_group_id = azurerm_management_group.valf2.id

  amount     = 500
  time_grain = "Monthly"

  time_period {
    start_date = "2024-04-01T00:00:00Z"
    end_date   = "2026-04-01T00:00:00Z"
  }

  filter {
    tag {
      name = "sysarc2"
      values = [
        "sysarc2",
      ]
    }
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails = [
      "steveadebola@gmail.com",
      "cheslynlendore@gmail.com",
    ]
  }

  notification {
    enabled        = false
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = [
      "steveadebola@gmail.com",
      "cheslynlendore@gmail.com",
    ]
  }
}
