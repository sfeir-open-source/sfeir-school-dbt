<!-- .slide: class="transition" -->

# Semantic Layer

## Understanding Semantic Layer


##==##


# Why Semantic Layer ?

Available only version >= 1.6

**The Problem**: Metrics (revenue, active users) are inconsistently recalculated across every BI & dashboard tool.

=> Establish a true "Single Source of Truth".

Centralize business logic directly within your dbt project.

**Define once, use everywhere !**

```bash
$ pip install dbt-metricflow
```

Now also the single source of truth for **LLMs & AI Agents** as your conversational AI returns the exact same figures as your official dashboards.


##==##


# What is Semantic Layer ?

The dbt **Semantic Layer** is the ecosystem that exposes your business metrics to any tool.

At its core runs **MetricFlow** the engine that dynamically generates optimized SQL on the fly.

MetricFlow = the engine.

Semantic Layer = the full ecosystem.


##==##


# Core Building Blocks

- **Semantic Model**: An abstraction layer built on top of an existing dbt physical model (table/view).
- **Entities**: Join keys (Primary/Foreign) that allow MetricFlow to link models automatically.
- **Dimensions**: Axes of analysis to slice and dice data (Time: created_at, Categorical: status).
- **Measures**: Base mathematical aggregations (Sum, Count, Min/Max) tied to physical columns.
- **Metrics**: The final business indicators exposed to end-users (Simple, Derived, Ratio).
- **Saved Queries**: Pre-defined combinations of metrics + dimensions that can be materialized as views or tables directly in your warehouse — ready for scheduling or bulk export.
