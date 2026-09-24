# Azure Event Hubs with Terraform/OpenTofu - Training Examples

This directory contains progressive free examples used with the **terraform-az-fk-event-hub** module.
The examples are designed as incremental building blocks for high-throughput ingestion and buffering architectures on Azure.

These examples are part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/) and are meant to be applied independently for learning and experimentation.

---

## Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Single Event Hub** | Standard namespace, one Event Hub, partitions, one-day retention |
| 02 | **Multiple Event Hubs** | Shared Standard namespace, logical-name map, independent partitions and retention |

---

## How to Use

Each example directory contains:

- Terraform/OpenTofu configuration split by resource concern (`.tf`)
- A focused `README.md` explaining the goal and service layout
- A `terraform.tfvars.example` file containing only non-secret values
- An independently created Resource Group and globally unique Event Hubs Namespace name

To run an example:

```bash
cd examples/01_single_event_hub
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

The current free learning path contains these focused examples:

```text
01
02
```

Each example owns an independent state and can be deployed separately. Larger event-driven compositions belong in FoggyKitchen landing zones or blueprints, not in free module examples.

---

## Design Principles

- One example = one architectural goal
- The Event Hubs module owns only the namespace and Event Hubs within it
- Examples require no secrets in `terraform.tfvars`
- Event Hubs are expressed as a map keyed by stable logical names
- Partition count and retention are explicit for each Event Hub
- Standard is used as the general-purpose learning tier
- Publishers, consumers, non-default Consumer Groups, networking, Private Endpoints, IAM/RBAC, Capture storage, Service Bus, and CI/CD remain outside this module

---

## Blueprint Candidates

Advanced Azure Event Hubs scenarios should be modeled as FoggyKitchen landing zones or blueprints:

- Burst-tolerant bulk ingestion pipelines feeding databases
- Event-driven data pipelines with Function or Container Apps consumers
- Private Event Hubs access through Private Endpoints and Private DNS
- Managed-identity publishers and consumers with least-privilege RBAC
- Event Hubs Capture to Azure Storage or Data Lake Storage
- Monitoring, autoscaling, schema governance, and disaster recovery

---

## Related Resources

- [FoggyKitchen Azure Event Hubs Module](../)
- [FoggyKitchen Azure Function Module](https://github.com/foggykitchen/terraform-az-fk-function)
- [FoggyKitchen Azure Event Grid Module](https://github.com/foggykitchen/terraform-az-fk-event-grid)
- [FoggyKitchen Azure Managed Identity Module](https://github.com/foggykitchen/terraform-az-fk-managed-identity)
- [FoggyKitchen Azure RBAC Module](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [FoggyKitchen Azure Private Endpoint Module](https://github.com/foggykitchen/terraform-az-fk-private-endpoint)

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
