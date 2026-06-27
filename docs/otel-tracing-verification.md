# OTEL Tracing Verification

Purpose: verify that Mia emits OpenTelemetry signals through the shared Alloy receiver and that traces are visible in Tempo/Grafana.

This is the focused closure path for `zavestudios/mia#30`.

## Scope

- Confirm the running deployment has the expected OTEL environment.
- Confirm the OpenClaw runtime config enables diagnostics OTEL export.
- Generate one real Mia request.
- Confirm Tempo/Grafana shows a trace for `mia-gateway`.

## Procedure

1. Confirm deployment wiring.

**Requires cluster access:**

```bash
kubectl -n mia get deploy mia -o jsonpath='{range .spec.template.spec.containers[?(@.name=="mia")].env[*]}{.name}={.value}{"\n"}{end}' \
  | rg 'OTEL_EXPORTER_OTLP_ENDPOINT|OTEL_EXPORTER_OTLP_PROTOCOL|OTEL_SERVICE_NAME'

kubectl -n alloy get svc alloy-receiver -o wide
kubectl -n alloy logs deploy/alloy-receiver --since=15m
```

Pass signals:
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://alloy-receiver.alloy.svc.cluster.local:4318`
- `OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf`
- `OTEL_SERVICE_NAME=mia-gateway`
- `alloy-receiver` Service exists in namespace `alloy`
- receiver logs do not show repeated OTLP receive or Tempo export failures

2. Confirm OpenClaw diagnostics config.

**Requires cluster access:**

```bash
kubectl -n mia exec deploy/mia -- node -e '
const fs = require("fs");
const cfg = JSON.parse(fs.readFileSync("/home/node/.openclaw/openclaw.json", "utf8"));
console.log(JSON.stringify({
  pluginAllowed: cfg.plugins?.allow?.includes("diagnostics-otel"),
  pluginEnabled: cfg.plugins?.entries?.["diagnostics-otel"]?.enabled,
  diagnostics: cfg.diagnostics
}, null, 2));
'
```

Pass signals:
- `pluginAllowed` is `true`
- `pluginEnabled` is `true`
- `diagnostics.enabled` is `true`
- `diagnostics.otel.enabled` is `true`
- `diagnostics.otel.traces` is `true`

3. Generate a real request through Mia.

Use the normal operator access path from [interaction-smoke-test.md](interaction-smoke-test.md), then send a request that produces a successful assistant response.

**Requires cluster access:**

```bash
kubectl -n mia exec deploy/mia -- openclaw gateway health --json
kubectl -n mia exec deploy/mia -- openclaw status --json
```

Pass signals:
- gateway health returns `"ok": true`
- the request completes successfully from the operator UI or configured channel

4. Verify trace visibility.

Open Grafana and use the Tempo data source to search for:

- service name: `mia-gateway`
- time range: last 15 minutes
- operation/span names associated with the request generated in step 3

Pass signals:
- at least one trace is visible for `mia-gateway`
- trace timestamp matches the request window
- trace details show Mia/OpenClaw request handling rather than only collector internals

## Fail Criteria

- OTEL environment variables are absent from the running `mia` container.
- `alloy-receiver` Service is absent or not accepting OTLP/HTTP.
- OpenClaw effective config does not enable diagnostics OTEL.
- No `mia-gateway` traces appear in Tempo after a successful real request.
- Alloy logs show repeated export failures to Tempo.

## Evidence To Capture

Record these in the issue comment when closing `zavestudios/mia#30`:

- deployed Mia image digest
- timestamp and timezone for the generated request
- `OTEL_SERVICE_NAME` observed in the running deployment
- Grafana/Tempo query used
- whether traces, metrics, and logs appeared as expected
- any remaining gap between Mia's declared tracing capability and the operator workflow
