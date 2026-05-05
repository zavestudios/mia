# Weekly Review Template

## Purpose

Use this template with Mia for a consistent weekly review.

The goal is to surface drift early, reduce hidden blockers, and keep the next
week narrow enough to execute.

## Prompt Shape

Suggested manual trigger:

```text
review week
```

## Review Questions

1. What were the top priorities this week?
2. What actually got completed?
3. What slipped?
4. What is blocked?
5. Which goals still matter next week?
6. Which goals should be dropped, deferred, or narrowed?
7. What are the top three priorities for the next week?

## Output Expectations

Mia should produce:

- a short summary
- completed items
- slipped items
- blockers
- recommended next actions
- proposed tracker updates for review

## Anti-Patterns

- too many priorities
- treating repo activity as automatic completion
- carrying stale goals forward without re-justifying them
- adding new work without removing old commitments

## Example Review Outcome

```text
Summary:
- Mia repositioning progressed.
- OpenShift learning remains active but is no longer the main capability proving surface.

Slipped:
- live RabbitMQ runtime validation did not complete because cluster readiness remained unstable.

Blockers:
- Mia still lacks dedicated action identity and scoped credentials.

Next actions:
- finish Mia v1 planning artifacts
- standardize weekly review cadence
- decide when to add scoped write actions after identity work
```
