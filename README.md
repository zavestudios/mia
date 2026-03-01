# Mia — OpenClaw AI Assistant

**Repository Category:** `tenant` (see [REPO_TAXONOMY](https://github.com/zavestudios/platform-docs/blob/main/_platform/REPO_TAXONOMY.md))

OpenClaw AI assistant workload hosted in Kubernetes.

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

2. Copy environment template:
   ```bash
   cp .env.example .env
   ```

3. Add your API keys to `.env`:
   ```bash
   # Edit .env and add your Anthropic API key
   ANTHROPIC_API_KEY=sk-ant-your-key-here
   ```

4. Start services:
   ```bash
   docker-compose up
   ```

5. Access application:
   - App: http://localhost:8000
   - Database: localhost:5432

### Common Tasks

**Run tests:**
```bash
docker-compose --profile test run --rm test
```

**Access database:**
```bash
docker-compose exec db psql -U postgres -d mia_dev
```

**View logs:**
```bash
docker-compose logs -f app
```

**Rebuild after dependency changes:**
```bash
docker-compose up --build
```

**Stop services:**
```bash
docker-compose down
```

## Deployment

Deployment is automated via GitOps following the platform lifecycle model.

See [LIFECYCLE_MODEL.md](https://github.com/zavestudios/platform-docs/blob/main/_platform/LIFECYCLE_MODEL.md) for details.
