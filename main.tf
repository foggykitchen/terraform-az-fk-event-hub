resource "azurerm_eventhub_namespace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  capacity            = var.capacity
  tags                = var.tags

  lifecycle {
    precondition {
      condition     = var.sku == "Premium" ? var.capacity <= 16 : var.capacity <= 40
      error_message = "capacity must be between 1 and 40 for Basic/Standard, or between 1 and 16 for Premium."
    }
  }
}

resource "azurerm_eventhub" "this" {
  for_each = var.event_hubs

  name              = coalesce(try(each.value.name, null), each.key)
  namespace_id      = azurerm_eventhub_namespace.this.id
  partition_count   = each.value.partition_count
  message_retention = each.value.message_retention_in_days

  lifecycle {
    precondition {
      condition     = each.value.partition_count <= (var.sku == "Premium" ? 100 : 32)
      error_message = "partition_count must not exceed 32 for Basic/Standard or 100 for Premium."
    }

    precondition {
      condition = each.value.message_retention_in_days <= (
        var.sku == "Basic" ? 1 : var.sku == "Standard" ? 7 : 90
      )
      error_message = "message_retention_in_days must not exceed 1 for Basic, 7 for Standard, or 90 for Premium."
    }
  }
}
