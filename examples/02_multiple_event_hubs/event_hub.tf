module "event_hub" {
  source = "../../"

  name                = "fk-eh-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Standard"
  capacity            = 1

  event_hubs = {
    ingestion = {
      partition_count           = 4
      message_retention_in_days = 1
    }
    processing = {
      partition_count           = 2
      message_retention_in_days = 3
    }
    audit = {
      name                      = "audit-events"
      partition_count           = 2
      message_retention_in_days = 7
    }
  }

  tags = var.tags
}
