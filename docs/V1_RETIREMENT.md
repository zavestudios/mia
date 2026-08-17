# Mia v1 Retirement

## Decision

Mia v1 is retired.

The v1 runtime depended on a WhatsApp gateway identity hosted by a temporary
phone/account. Access to that phone is no longer available, and the architecture
was already brittle because it required maintaining a dedicated external
device/account for the primary interaction channel.

V2 starts from a clean `autonomous-agent` platform-service boundary rather than
migrating the WhatsApp-based runtime.

## Retired Surface

Do not migrate:

- WhatsApp plugin installation as a required image dependency
- WhatsApp pairing credentials
- phone-number allowlist build arguments
- `WHATSAPP_ALLOW_FROM` and `WHATSAPP_GROUP_ALLOW_FROM` CI secrets
- WhatsApp PVC credential persistence assumptions
- WhatsApp startup/recovery runbooks
- the `mia` repository name as the platform capability identity

## Preserved Artifacts

The old v1 docs are archived under:

```text
docs/archive/mia-v1/
```

They are retained for historical context and lessons learned, not as active
operational instructions.

## Runtime Cleanup

GitOps should remove the old `mia` desired state after the v2 replacement path
is represented in Git.

Live cluster cleanup is not performed from this repository.

**Requires cluster access:**

- verify whether `mia` resources still exist
- verify whether any `mia` PVCs or secrets need archival before deletion
- confirm decommissioning left no orphan resources

