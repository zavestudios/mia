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
- [PLATFORM_OPERATING_MODEL.md](https://github.com/zavestudios/platform-docs/blob/main/_platform/PLATFORM_OPERATING_MODEL.md)
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

2. Start OpenClaw gateway:
   ```bash
   docker-compose up
   ```

3. Access OpenClaw:
   - **Web UI**: http://localhost:18789
   - **Gateway**: Running in container

4. Configure channels (optional):
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
