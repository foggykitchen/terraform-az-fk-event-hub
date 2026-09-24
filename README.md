# terraform-az-fk-event-hub

This repository contains a reusable Terraform / OpenTofu module and focused examples for deploying Azure Event Hubs namespaces and Event Hubs.

It is part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/) and is the Azure counterpart to `terraform-oci-fk-streaming`.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Purpose

The module provides a clean, composable ingestion and buffering boundary for Azure event-driven systems:

- Creates one Event Hubs Namespace as the pool-equivalent resource
- Creates zero or more Event Hubs within that namespace
- Gives each Event Hub an independent partition count and retention period
- Supports creating the namespace first and attaching Event Hubs later

This is not a general messaging platform abstraction. It is a small, explicit infrastructure module for Azure Event Hubs.

---

## What the module does

The module creates:

- Azure Event Hubs Namespace (`azurerm_eventhub_namespace`)
- Zero or more Azure Event Hubs (`azurerm_eventhub`)

The module intentionally does not create:

- Publisher or consumer resources such as Function Apps, Event Grid subscriptions, Logic Apps, or applications
- VNets, networking, or Private Endpoints
- IAM/RBAC role assignments required for publishers or consumers to send or receive events
- Consumer Groups beyond Azure's built-in `$Default` group
- Event Hubs Capture destinations or Storage Accounts
- Service Bus resources

Publishers, consumers, identity, networking, and long-term capture storage belong in focused modules or composition layers. Additional Consumer Groups are also consumer-specific lifecycle state, so they remain outside this ingestion/buffering module.

---

## Provider Notes

The contract was verified against AzureRM `4.81.0`, the latest 4.x version selected on 2026-09-24 by the FoggyKitchen constraint `>= 3.100.0, < 5.0.0`. AzureRM 5.x exists, but current FoggyKitchen Azure modules deliberately retain the shared `< 5.0.0` compatibility boundary.

AzureRM's `azurerm_eventhub` resource names its retention argument `message_retention` and measures it in **days**. The module therefore exposes `message_retention_in_days` instead of copying OCI Streaming's hours-based input name.

Current Azure tier limits are enforced by the module:

| Tier | Capacity unit | Maximum partitions per Event Hub | Maximum message retention |
|------|---------------|----------------------------------|---------------------------|
| Basic | Throughput unit (TU) | 32 | 1 day |
| Standard | Throughput unit (TU) | 32 | 7 days |
| Premium | Processing unit (PU) | 100 | 90 days |

Basic and Standard support up to 40 throughput units; Premium supports up to 16 processing units. Namespace-wide partition and Event Hub count quotas still apply. Partition counts cannot be decreased, and changing them after creation is restricted outside Premium/Dedicated tiers.

---

## Repository Structure

```bash
terraform-az-fk-event-hub/
├── examples/
│   ├── 01_single_event_hub/
│   ├── 02_multiple_event_hubs/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── SUPPORT.md
├── LICENSE
└── README.md
```

---

## Example Usage

```hcl
module "event_hub" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-event-hub.git?ref=v0.1.0"

  name                = "fk-event-hub-demo"
  resource_group_name = "fk-events-rg"
  location            = "westeurope"
  sku                 = "Standard"
  capacity            = 1

  event_hubs = {
    ingestion = {
      partition_count           = 4
      message_retention_in_days = 1
    }
    audit = {
      name                      = "audit-events"
      partition_count           = 2
      message_retention_in_days = 7
    }
  }
}
```

Set `event_hubs = {}` or omit it to create only the namespace and attach Event Hubs later.

---

## Module Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | `string` | yes | Event Hubs Namespace name |
| `resource_group_name` | `string` | yes | Resource group where the namespace is created |
| `location` | `string` | yes | Azure region |
| `sku` | `string` | no | Namespace tier: `Basic`, `Standard`, or `Premium` |
| `capacity` | `number` | no | Namespace throughput units for Basic/Standard or processing units for Premium |
| `event_hubs` | `map(object({ name = optional(string), partition_count = optional(number, 2), message_retention_in_days = optional(number, 1) }))` | no | Event Hubs keyed by logical name |
| `tags` | `map(string)` | no | Namespace tags |

---

## Module Outputs

| Output | Description |
|--------|-------------|
| `namespace_id` | Event Hubs Namespace resource ID |
| `namespace_name` | Event Hubs Namespace name |
| `event_hub_ids` | Map of Event Hub logical names to resource IDs |
| `event_hubs` | Map of Event Hub logical names to resolved metadata |

---

## Examples

See [examples/README.md](examples/README.md) for the progressive examples:

- One namespace with one Event Hub
- One namespace with multiple Event Hubs for a simple pipeline

Both examples use the Standard tier with one throughput unit. Standard is the general-purpose choice for application pipelines because it supports multiple consumer groups, Kafka, Capture, and up to seven days of retention without Premium's dedicated processing-unit cost model.

---

## Composition Requirements

Callers are responsible for composing the surrounding system:

- Grant publisher identities an appropriate send role such as `Azure Event Hubs Data Sender`.
- Grant consumer identities an appropriate receive role such as `Azure Event Hubs Data Receiver`.
- Create non-default Consumer Groups with the consuming workload or a separate consumer-focused module.
- Add Private Endpoints, network rules, and Private DNS through dedicated networking modules when private access is required.

The module outputs resource IDs for explicit composition without embedding publisher, consumer, identity, or networking ownership.

---

## Design Philosophy

- Explicit over implicit
- Small modules over monoliths
- Event Hubs separated from publishers, consumers, identity, and networking
- Optimized for learning, reuse, and composition

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
