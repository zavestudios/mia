# First Interaction Runbook (Sandbox)

This runbook provides a reproducible first end-to-end interaction path for `mia`.

It intentionally avoids external chat channel setup for day-1 validation.

## Scope

- Validate that gateway runtime is reachable.
- Validate that an agent turn can be executed and returns output.
- Capture the minimum commands/operators need for repeatability.

## Prerequisites

- `mia` pod is `Running` in namespace `mia`.
- You can exec into the container via `kubectl`.
- A model provider API key is available for local-agent mode:
  - `ANTHROPIC_API_KEY` (or provider key configured for your OpenClaw model path).

## 1) Gateway baseline check

**Run manually by human:**

```bash
kubectl -n mia exec deploy/mia -- openclaw gateway health --json
kubectl -n mia exec deploy/mia -- openclaw status --json
```

Expected:
- command exits `0`
- JSON output with gateway health/status fields

## 2) First interaction (local agent turn)

This path validates request -> agent processing -> response output without requiring WhatsApp/Telegram/Discord credentials.

**Run manually by human:**

```bash
kubectl -n mia exec deploy/mia -- sh -lc '\
  export ANTHROPIC_API_KEY=\"<YOUR_KEY>\" && \
  openclaw agent --local --to +15555550123 --message \"Reply with: mia interaction smoke ok\" --json'
```

Expected:
- command exits `0`
- JSON output includes agent response payload

## 3) Operator verification signals

**Run manually by human:**

```bash
kubectl -n mia logs deploy/mia --tail=200
```

Look for:
- gateway start/listening lines
- agent-turn execution logs
- no crash loop / OOM / permission errors

## 4) Optional dashboard check

**Run manually by human:**

```bash
kubectl -n mia exec deploy/mia -- openclaw dashboard --no-open
```

Expected:
- command prints dashboard URL with current token context.

## Pass Criteria

- Gateway health/status commands succeed.
- Local agent turn returns a response payload.
- Runtime logs show stable process (no repeated crash/restart errors).
