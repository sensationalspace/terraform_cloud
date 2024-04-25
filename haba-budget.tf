resource "azurerm_management_group" "haba_budget" {
  display_name = "haba managemet group"
}


resource "azurerm_consumption_budget_management_group" "haba_budget" {
  name                = "haba_budget"
  management_group_id = azurerm_management_group.haba_budget.id

  amount     = 50
  time_grain = "Monthly"

  time_period {
    start_date = "2024-04-01T00:00:00Z"
    end_date   = "2026-04-01T00:00:00Z"
  }

  filter {
    tag {
      name = "haba_budget"
      values = [
        "haba_budget",
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
