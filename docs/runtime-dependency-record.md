# Runtime Dependency Record

Purpose: keep Mia's OpenClaw runtime and plugin compatibility history explicit so image build failures do not have to be reconstructed from PR memory.

## Current Source Of Truth

- Runtime image: `Dockerfile`
- OpenClaw config: `config/openclaw.json`
- Deployed image digest: `zavestudios/gitops/tenants/mia/deployment.yaml`
- Observability capability declaration: `zave.yaml`

## Current Runtime Baseline

As of PR #33, the Dockerfile pins:

```dockerfile
FROM ghcr.io/openclaw/openclaw:2026.5.22@sha256:dcfd148777401d1bbdc63eab5c2f280bbfa912dfb1818566f9d66bb96ffb3f95
```

The image build installs the external WhatsApp plugin with:

```dockerfile
RUN openclaw plugins install @openclaw/whatsapp@2026.5.22
```

That plugin reference is version-pinned to match the pinned OpenClaw runtime family.

## Compatibility History

| Date | Commit | Runtime / Plugin Change | Record |
| --- | --- | --- | --- |
| 2026-03-11 | `8354fb2` | Pinned OpenClaw `v2026.3.8` by digest | Early stable runtime pin |
| 2026-05-17 | `54f459c`, `260bc46` | Added `@openclaw/diagnostics-otel` install attempt | Initial OTEL source-side plugin work |
| 2026-05-17 | `73cd74b` | Upgraded OpenClaw to `2026.5.12` by digest | Compatibility upgrade for newer OpenClaw behavior |
| 2026-05-17 | `8246300` | Replaced diagnostics plugin install with `clawhub:@openclaw/whatsapp` | OpenClaw `2026.5.x` no longer carried WhatsApp in the lean runtime image |
| 2026-05-26 | `9ce5892` | Bumped OpenClaw to `2026.5.22` by digest | Follow-up runtime bump for WhatsApp plugin compatibility |
| 2026-06-27 | PR #33 | Pinned WhatsApp plugin to `@openclaw/whatsapp@2026.5.22` | Prevents mutable `clawhub` latest from selecting a plugin requiring a newer OpenClaw plugin API |

## Important Correction

PR #31 says the runtime image installs `@openclaw/diagnostics-otel`. That was true for the first commits in the PR, but the final merged Dockerfile does not install that plugin. The final merged state enables diagnostics OTEL in `config/openclaw.json` and installs the external WhatsApp plugin.

Mia's current governed observability capability is `tracing`, not `metrics`. The remaining proof for `zavestudios/mia#30` is runtime evidence that a real Mia request appears in Tempo as `mia-gateway`.

## Known Failure Class

Failure signature:

```text
Plugin "@openclaw/whatsapp" requires plugin API >=2026.6.10,
but this OpenClaw runtime exposes 2026.5.22.
```

Meaning:

- The Dockerfile still pins OpenClaw `2026.5.22`.
- The unpinned WhatsApp plugin resolver selected a newer plugin requiring OpenClaw plugin API `>=2026.6.10`.
- This is a mutable dependency failure, not evidence that the docs-only PR changed the image.

Applied fix:

- Pin the plugin install to `@openclaw/whatsapp@2026.5.22`, which declares `openclaw >=2026.5.22` and `pluginApi >=2026.5.22`.

Future fixes, if a newer plugin is required:

1. Upgrade the OpenClaw base image to a runtime exposing the required plugin API.
2. Pin the WhatsApp plugin to the same compatible version family.
3. Rebuild and promote the resulting image digest through GitOps.

## Operational Rule

When changing `Dockerfile` or `config/openclaw.json`, record the runtime version, plugin references, and expected plugin API compatibility in this file.

When only docs change, do not infer runtime compatibility from CI unless the container workflow intentionally ran for an image-affecting path.
