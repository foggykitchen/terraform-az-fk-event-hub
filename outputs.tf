output "namespace_id" {
  description = "Event Hubs Namespace resource ID."
  value       = azurerm_eventhub_namespace.this.id
}

output "namespace_name" {
  description = "Event Hubs Namespace name."
  value       = azurerm_eventhub_namespace.this.name
}

output "event_hub_ids" {
  description = "Map of Event Hub logical names to resource IDs."
  value = {
    for key, hub in azurerm_eventhub.this :
    key => hub.id
  }
}

output "event_hubs" {
  description = "Map of Event Hub logical names to resolved metadata."
  value = {
    for key, hub in azurerm_eventhub.this :
    key => {
      id                        = hub.id
      name                      = hub.name
      namespace_id              = hub.namespace_id
      partition_count           = hub.partition_count
      partition_ids             = hub.partition_ids
      message_retention_in_days = hub.message_retention
    }
  }
}
