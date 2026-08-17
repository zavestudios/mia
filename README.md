# autonomous-agent

**Repository Category:** `platform-service`

Reusable autonomous assistant/orchestrator capability for ZaveStudios.

Status: v2 transition branch.

`autonomous-agent` provides the platform-owned runtime pattern for persistent,
goal-directed, event-directed, or scheduled agent instances. Named assistants,
including a future `Mia` persona, should be instance configuration rather than
the repository identity.

## Current Direction

V2 starts cleanly from the former `mia` workload.

The old Mia v1 runtime is retired instead of migrated because its WhatsApp
gateway depended on a brittle external phone/account. The v1 documentation is
preserved under [docs/archive/mia-v1](docs/archive/mia-v1).

## Boundaries

`autonomous-agent` may:

- host OpenClaw-based autonomous agent instances
- preserve long-lived context, goals, instructions, and workflow state
- coordinate tools and platform workflows when policy permits
- use `oracle` for durable asynchronous AI execution when needed
- delegate software-change execution to `engineering-agent`

`autonomous-agent` must not:

- become another interactive coding agent
- bypass `llm-platform` as the target shared model-access gateway
- own ZaveStudios-wide provider routing, credentials, quotas, profiles, policy,
  or tracing
- mutate GitOps, policy, doctrine, or shared infrastructure without an explicit
  approved workflow
- preserve WhatsApp as a required channel or runtime dependency

## Target Architecture

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

## Active Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Instance Model](docs/INSTANCE_MODEL.md)
- [V2 Migration Plan](docs/V2_MIGRATION_PLAN.md)
- [Mia v1 Retirement](docs/V1_RETIREMENT.md)

## Local Development

```bash
cp .env.example .env
docker-compose up --build
```

OpenClaw dashboard/API listens on `http://localhost:18789`.
