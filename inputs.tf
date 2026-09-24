variable "name" {
  description = "Name of the Event Hubs Namespace."
  type        = string

  validation {
    condition     = trimspace(var.name) != ""
    error_message = "name must not be empty."
  }
}

variable "resource_group_name" {
  description = "Resource group where the Event Hubs Namespace is created."
  type        = string

  validation {
    condition     = trimspace(var.resource_group_name) != ""
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for the Event Hubs Namespace."
  type        = string

  validation {
    condition     = trimspace(var.location) != ""
    error_message = "location must not be empty."
  }
}

variable "sku" {
  description = "Event Hubs Namespace tier: Basic, Standard, or Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be Basic, Standard, or Premium."
  }
}

variable "capacity" {
  description = "Namespace capacity in throughput units for Basic/Standard or processing units for Premium."
  type        = number
  default     = 1

  validation {
    condition     = var.capacity >= 1 && floor(var.capacity) == var.capacity
    error_message = "capacity must be a positive whole number."
  }
}

variable "event_hubs" {
  description = "Event Hubs keyed by logical name. Each hub can override its Azure name, partition count, and message retention in days."
  type = map(object({
    name                      = optional(string)
    partition_count           = optional(number, 2)
    message_retention_in_days = optional(number, 1)
  }))
  default = {}

  validation {
    condition = alltrue([
      for hub in values(var.event_hubs) :
      hub.partition_count >= 1 &&
      hub.partition_count <= 100 &&
      floor(hub.partition_count) == hub.partition_count &&
      hub.message_retention_in_days >= 1 &&
      hub.message_retention_in_days <= 90 &&
      floor(hub.message_retention_in_days) == hub.message_retention_in_days &&
      (try(hub.name, null) == null || trimspace(hub.name) != "")
    ])
    error_message = "Each Event Hub must have a non-empty optional name, a whole-number partition_count from 1 to 100, and whole-number message_retention_in_days from 1 to 90. Tier-specific limits are enforced by resource preconditions."
  }
}

variable "tags" {
  description = "Tags assigned to the Event Hubs Namespace."
  type        = map(string)
  default     = {}
}
