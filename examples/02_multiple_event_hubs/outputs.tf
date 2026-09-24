output "namespace_id" {
  description = "Event Hubs Namespace resource ID."
  value       = module.event_hub.namespace_id
}

output "namespace_name" {
  description = "Event Hubs Namespace name."
  value       = module.event_hub.namespace_name
}

output "event_hubs" {
  description = "Map of Event Hub logical names to resolved metadata."
  value       = module.event_hub.event_hubs
}
