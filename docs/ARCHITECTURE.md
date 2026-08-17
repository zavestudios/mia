# Autonomous Agent Architecture v2

## Purpose

`autonomous-agent` is the ZaveStudios platform-service capability for
persistent autonomous assistant/orchestrator instances.

It is capability-oriented, not persona-oriented. A persona such as `Mia` may be
deployed as an instance of this capability, but the repository remains named for
the reusable architecture.

## Operating Model

`autonomous-agent` is persistent and goal/event-directed.

It differs from `engineering-agent` by operating model:

- `engineering-agent`: operator-directed software engineering execution
- `autonomous-agent`: goal, schedule, event, and standing-instruction driven
  autonomous coordination

Both systems may have durable state. Persistence is not the boundary.

## Target Flow

```text
Billy
  |
  v
autonomous-agent instance / OpenClaw
  |-- tools and workflows
  |-- scheduled or event-driven activity
  |-- Oracle for durable asynchronous work when appropriate
  |-- engineering-agent for software-change execution when policy permits
  |
  v
llm-platform
  |
  v
providers/models
```

## Runtime

The current implementation target is OpenClaw.

OpenClaw is an implementation choice, not the capability identity. If OpenClaw
is replaced later, `autonomous-agent` remains the owning platform-service
boundary.

## Model Access

Target model access is:

```text
autonomous-agent -> llm-platform -> providers/models
```

The runtime may temporarily support direct provider mode during migration, but
shared provider credentials, routing policy, profiles, quota, tracing, and
observability belong in `llm-platform`.

## Persistence

The v2 design must preserve useful long-lived context:

- cross-session memory
- long-running goals
- standing instructions
- preferences
- project/workload relationships
- workflow state

The old Mia v1 runtime used PVC-backed OpenClaw state and tenant-scoped Ollama
model cache. V2 should keep persistence explicit, but should not preserve the
WhatsApp credential model or assume the old PVC layout is the desired future
state.

## Boundaries

`autonomous-agent` must not:

- become another coding agent
- merge protected branches
- mutate GitOps or platform doctrine without an approved workflow
- bypass `llm-platform` as the target model-access boundary
- subsume `oracle`
- subsume `engineering-agent`
- require WhatsApp or a dedicated phone/device

`oracle` remains responsible for durable asynchronous AI job execution.
`autonomous-agent` may call `oracle` when autonomous work needs retries,
leasing, restart recovery, or long-running execution.

`engineering-agent` remains responsible for interactive software-engineering
execution. If autonomous work requires code changes, the preferred architecture
is delegation to `engineering-agent`, not duplicating that execution inside
OpenClaw.

