# Interaction Smoke Test (Sandbox)

Purpose: provide one repeatable operator check after deploys.

## Scope

- Validate gateway health.
- Validate dashboard access path.
- Validate runtime stability signals.

## Procedure

0. Optional one-command runner.

**Run manually by human:**

```bash
./scripts/smoke-sandbox.sh
```

This executes the baseline checks below against namespace `mia` and deployment `mia`.

1. Verify pod baseline.

**Run manually by human:**

```bash
kubectl -n mia get pods -o wide
kubectl -n mia exec deploy/mia -- openclaw gateway health --json
kubectl -n mia exec deploy/mia -- openclaw status --json
```

Pass signals:
- `gateway health` returns `"ok": true`
- pod is `Running` and not crash-looping

2. Verify operator dashboard access from laptop via bastion tunnel.

**Run manually by human:**

```bash
# Bastion terminal
kubectl -n mia port-forward deploy/mia 18789:18789

# Laptop terminal
ssh -N -L 18789:127.0.0.1:18789 ubuntu@k3s-bastion-01
```

Then open:
- `http://127.0.0.1:18789/#token=<token-from-openclaw-dashboard-command>`

Pass signals:
- dashboard loads
- no repeated reconnect/error loop in UI

3. Verify recent runtime logs.

**Run manually by human:**

```bash
kubectl -n mia logs deploy/mia --tail=200
```

Pass signals:
- gateway startup/listening lines present
- no OOM, permission-denied, or continuous restart pattern

## Fail Criteria

- `gateway health` not ok
- pod restart count increasing repeatedly
- dashboard unreachable through port-forward + SSH tunnel

## Notes

- Current runtime binds gateway to loopback (`127.0.0.1`) inside container.
- Channel allowlist warnings are expected until channel sender policies are configured.
