# OpenClaw Token Optimization Notes (Mia)

This is an actionable summary of the external optimization deck, adapted to Mia's current deployment model.

## High-ROI Controls

1. Keep a cheaper default model for routine tasks.
2. Route heartbeat to local Ollama where possible.
3. Keep session bootstrap context lean.
4. Add rate/budget guardrails in prompt files.
5. Track weekly cost/token metrics and iterate.

## Config Guidance (Current OpenClaw Version)

- Do not put provider API keys in `openclaw.json`.
- Use Kubernetes Secrets (`SealedSecret` -> Secret -> env vars).
- For heartbeat settings, use `agents.defaults.heartbeat` (not top-level `heartbeat` in newer versions).

## Model Routing Pattern

- Default: lower-cost model for general work.
- Escalate to higher-cost model only for complex reasoning/review/security decisions.
- Keep aliases simple and explicit in config.

## Heartbeat Strategy

- Primary agent model can remain cloud-hosted.
- Heartbeat can target `ollama/llama3.2:3b` to reduce paid API usage.
- Ensure Ollama model is pulled once and persisted on PVC.

## Session Context Hygiene

- Load only essential files on session start.
- Retrieve historical context on demand.
- Keep static references small and stable.

## Practical Guardrails

Add clear operating constraints in workspace prompt files (`SOUL.md`/`TOOLS.md`):

- delay between expensive calls
- cap search bursts
- stop/retry policy on rate-limit responses
- daily/monthly budget warning thresholds

## Validation Checklist

Use these checks after any optimization change:

```bash
kubectl -n mia exec deploy/mia -- openclaw status --json
kubectl -n mia logs deploy/mia --tail=200 | egrep -i 'agent model|heartbeat|error'
kubectl -n mia get pods
```

Success means:
- intended model routing is active
- heartbeat path is healthy
- pod stability and probes remain clean
