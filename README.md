# Mia — OpenClaw AI Gateway

**Repository Category:** `tenant` (see [REPO_TAXONOMY](https://github.com/zavestudios/platform-docs/blob/main/_platform/REPO_TAXONOMY.md))

Containerized deployment of [OpenClaw](https://docs.openclaw.ai/) - a self-hosted gateway connecting chat apps (WhatsApp, Telegram, Discord, iMessage) to AI coding agents.

## What is OpenClaw?

OpenClaw is a Node.js application that serves as a central gateway for:
- **Multi-platform messaging**: Connect WhatsApp, Telegram, Discord, iMessage simultaneously
- **AI agent routing**: Route conversations to coding agents like Pi
- **Web dashboard**: Control UI at port 18789
- **Self-hosted**: Runs on your infrastructure with full control

## Platform Contract

This workload is governed by the ZaveStudios platform contract model.

See `zave.yaml` for the canonical workload contract.

## Platform Authority

Canonical platform documentation:
- [platform-docs](https://github.com/zavestudios/platform-docs)
- [OPERATING_MODEL.md](https://github.com/zavestudios/platform-docs/blob/main/_platform/OPERATING_MODEL.md)
- [CONTRACT_SCHEMA.md](https://github.com/zavestudios/platform-docs/blob/main/_platform/CONTRACT_SCHEMA.md)

## Architecture

Details to be added as the application is developed.

## Local Development

### Prerequisites
- Docker and Docker Compose installed
- Git

### Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/zavestudios/mia.git
   cd mia
   ```

2. Copy environment template:
   ```bash
   cp .env.example .env
   ```

3. Start OpenClaw gateway:
   ```bash
   docker-compose up
   ```

4. Access OpenClaw:
   - **Web UI**: http://localhost:18789
   - **Gateway**: Running in container

5. Configure channels (optional):
   - Edit `config/openclaw.json` to enable WhatsApp, Telegram, etc.
   - Restart container to apply changes

### Common Tasks

**View OpenClaw logs:**
```bash
docker-compose logs -f mia
```

**Access container shell:**
```bash
docker-compose exec mia sh
```

**Rebuild after config changes:**
```bash
docker-compose up --build
```

**Stop services:**
```bash
docker-compose down
```

**Access OpenClaw CLI:**
```bash
docker-compose exec mia openclaw --help
```

## Deployment

Deployment is automated via GitOps following the platform lifecycle model.

See [LIFECYCLE_MODEL.md](https://github.com/zavestudios/platform-docs/blob/main/_platform/LIFECYCLE_MODEL.md) for details.

## First Interaction

Use the day-1 operator runbook at [docs/first-interaction.md](docs/first-interaction.md) to execute the first end-to-end interaction path in sandbox.
Use the repeatable post-deploy check at [docs/interaction-smoke-test.md](docs/interaction-smoke-test.md).
For a one-command operator check, run `./scripts/smoke-sandbox.sh`.

### Current Status

- CI/CD pipeline wiring is complete for this repository.
- GitOps desired-state wiring for `mia` is merged in the `gitops` repository.
- First sandbox runtime verification is intentionally deferred and can be completed later via cluster-state review.

### First-Time Sandbox Deploy Checklist

`mia` is a cross-repo deploy: `mia` (tenant workload/image) + `gitops` (runtime desired state).

1. Build and publish initial image from `mia`:
   - Merge `mia` changes to `main`.
   - Wait for `.github/workflows/build.yml` to complete successfully.
   - Record the pushed image digest from workflow logs (`ghcr.io/zavestudios/mia@sha256:...`).

2. Register image digest in `gitops`:
   - Update `gitops/tenants/mia/deployment.yaml` image to the new digest.
   - Ensure `gitops/clusters/sandbox/kustomization.yaml` includes `../../tenants`.
   - Ensure `gitops/tenants/kustomization.yaml` exists and includes `mia`.
   - Open and merge a `gitops` PR.

3. Apply/verify GitOps state:
   - If Flux/entrypoint is not yet active, apply it manually.
   - **Run manually by human**:
     ```bash
     kubectl kustomize clusters/sandbox
     kubectl apply -k clusters/sandbox
     ```

4. Validate runtime health:
   - **Run manually by human**:
     ```bash
     kubectl -n mia get pods,svc,ingress
     kubectl -n mia describe deploy mia
     ```
   - Confirm ingress host `mia-sandbox.zavestudios.com` routes to service `mia`.

5. Prerequisites to verify once:
   - Namespace `mia` has pull secret `ghcr-secret` for `ghcr.io/zavestudios/mia`.
   - DNS for `mia-sandbox.zavestudios.com` points to sandbox ingress.
   - TLS issuance is available for `mia-tls` via cert-manager.
