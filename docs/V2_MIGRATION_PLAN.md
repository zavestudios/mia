# Autonomous Agent v2 Migration Plan

## Phase 1: Rename And Reclassify

- Rename local/repository identity from `mia` to `autonomous-agent`.
- Reclassify from `tenant` to `platform-service` in `REPO_TAXONOMY`.
- Treat `Mia` as a possible instance/persona name.
- Archive Mia v1 docs and runbooks.
- Remove WhatsApp from the active build/config surface.

## Phase 2: Decommission Mia v1 Runtime

- Remove old `mia` GitOps desired state through a GitOps PR.
- Retain an audit note explaining why v1 was retired.
- Do not migrate WhatsApp credentials or phone-number allowlists.
- Decide whether old PVC data should be archived, inspected, or deleted.

**Requires cluster access:**

- inspect live `mia` resources
- confirm PVC/secret cleanup requirements
- verify ArgoCD/cluster convergence after GitOps removal

## Phase 3: Define V2 Instance Contract

- Define the minimal instance configuration shape.
- Define allowed trigger types: manual, schedule, event, standing instruction.
- Define tool permission boundaries.
- Define approval policy for low, medium, and high-risk actions.
- Define memory scope and retention behavior.

## Phase 4: Choose Remote Access Surface

Evaluate OpenClaw-supported channels and platform access options before choosing
a replacement.

Requirements:

- no dedicated phone line/device
- durable enough for long-term use
- supports practical remote/mobile interaction
- compatible with platform auth and auditability

Candidate starting point:

- OpenClaw dashboard/API behind Cloudflare Access

Do not assume another messaging platform is required.

## Phase 5: Integrate llm-platform

- Add gateway-backed model access.
- Keep direct provider mode only as a temporary fallback if needed.
- Move shared provider credentials, routing profiles, quota, and tracing to
  `llm-platform`.

## Phase 6: Add One Concrete Autonomous Use Case

Choose one narrow use case before adding broad autonomy.

Candidates:

- scheduled weekly review prompt
- platform monitoring summary
- stale issue/workflow detection
- recurring friction report draft
- goal status review with human approval

The first use case should produce reviewable outputs and avoid unattended
mutation.

## Phase 7: Evaluate Delegation

- Use `oracle` for durable asynchronous jobs only when needed.
- Use `engineering-agent` for software-change execution when policy permits.
- Keep both boundaries explicit.

