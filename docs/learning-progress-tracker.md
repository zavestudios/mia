# Learning Progress Tracker

## Purpose

This file records current priorities, completed work, blockers, and next
actions. It is the canonical evidence surface for Mia's weekly review flow.

Update style:
- keep entries short
- prefer dated notes
- record explicit blockers and decisions
- avoid using repository activity as the only proof of progress

## Current Week

**Week of:** 2026-04-28

### Top Priorities

1. Reposition Mia into a useful platform and career assistant.
2. Clarify how OpenShift learning fits the new team reality.
3. Separate RabbitMQ capability evaluation from OpenShift-specific learning.

### In Progress

- Mia assistant scope is being refocused around roadmap, tracking, and weekly review.
- RabbitMQ/OpenShift work is being reframed so capability decisions are not overfit to OpenShift.
- Mia is being aligned with the proposed retrospective learning-loop direction from `platform-docs#71`.

### Completed

- 2026-04-29: documented RabbitMQ OpenShift findings in `gitops` and linked the POC artifact.
- 2026-04-30: removed hardcoded RabbitMQ credentials from local OpenShift validation scripts.

### Blockers

- Mia does not yet have dedicated GitHub/GitLab identity or scoped runtime credentials for action-taking.
- Current Mia implementation surface is config-and-docs driven, not a custom backend with durable automation state.

### Next Actions

- define Mia v1 as a platform and career assistant with bounded behavior
- use the roadmap and tracker as canonical planning artifacts
- decide which review cadence should be standard: daily prompt, weekly review, or both
- incorporate `platform-docs#71` into Mia's future-phase design without over-claiming current autonomy
- define proposal tiers, evidence requirements, and owning-surface rules for future learning-loop outputs

## Decision Log

- 2026-04-30: OpenShift remains worth learning for breadth, but no longer drives RabbitMQ platform evaluation by default.
- 2026-04-30: V1 should prioritize useful planning and tracking over autonomous repo polling.
- 2026-05-05: the Command Center learning-loop item should shape Mia's Phase 2 direction, but not collapse V1 into unattended automation.
- 2026-05-05: future learning-loop outputs need explicit proposal tiers and owning-surface rules before implementation.

## Evidence Links

- `docs/platform-assistant-v1.md`
- `docs/learning-roadmap-v1.md`
- `docs/weekly-review-template.md`
- `zavestudios/gitops#139`
- `zavestudios/mia#21`
- `zavestudios/platform-docs#71`
