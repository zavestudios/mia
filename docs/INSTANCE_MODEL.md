# Autonomous Agent Instance Model

## Concept

`autonomous-agent` is a platform-service template/runtime.

Named assistants are instances.

Example:

```text
autonomous-agent
  |
  +-- instance: mia
        persona: Mia
        scope: personal planning, platform monitoring, workflow coordination
```

The instance owns persona-specific configuration. The repository owns reusable
runtime mechanics and policy boundaries.

## Instance Configuration

An instance should define:

- instance name
- optional persona name
- purpose and scope
- standing instructions
- allowed tools
- denied tools
- approval policy
- schedule and event triggers
- memory scope
- retention policy
- escalation rules
- model profile requirements
- remote access surface

## Persona Guidance

A persona name is optional.

Use a persona when it improves human interaction, memory continuity, or
notification clarity. Do not use persona names as repository names or platform
capability boundaries.

## Initial Instance

`Mia` may return as an instance/persona after the v2 runtime boundary is stable.

Mia v1 should not be migrated directly because its primary WhatsApp gateway
identity depended on an unavailable phone/account and a fragile credential
pairing model.

