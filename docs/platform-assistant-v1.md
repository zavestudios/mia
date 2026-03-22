# Mia Platform Assistant v1

## Purpose

Mia v1 extends the existing OpenClaw-based tenant into a doctrine-aware platform assistant for ZaveStudios.

Mia may:

- read GitHub and GitLab issues and discussions
- classify friction and platform work items
- compute measurement snapshots from governed repositories
- assemble audit evidence bundles
- draft human-readable reports and proposed next actions

Mia may not:

- define canonical governance or policy
- redefine contract or lifecycle semantics
- mutate GitOps state directly
- perform autonomous high-risk write actions in v1

Canonical authority remains in `platform-docs/_platform/`.

## Why This Exists

This capability operationalizes documented platform workflows without moving authority out of `platform-docs`.

Primary doctrine inputs:

- `REPO_TAXONOMY.md`
- `CONTROL_PLANE_MODEL.md`
- `GITOPS_MODEL.md`
- `MEASUREMENT_MODEL.md`
- `FRICTION_FEEDBACK.md`
- `AUDIT_PROGRAM.md`

## Scope

### Included in v1

- manual-trigger issue and discussion triage
- friction triage aligned to `FRICTION_FEEDBACK.md`
- measurement snapshots for metrics derivable from repository and issue-system state
- audit evidence bundle generation
- Markdown report drafting
- approval bundles for any proposed write action

### Explicitly Excluded in v1

- autonomous polling and scheduled write actions
- automatic issue closure or reassignment
- GitOps mutation
- cluster mutation
- dashboard implementation
- provider-specific logic embedded into assistant workflows

## Repository Scope

This initiative is primarily single-repo in `mia`.

Read sources include:

- `platform-docs/_platform/`
- `gitops/`
- governed repositories defined by `platform-docs/_platform/REPO_TAXONOMY.md`

Cross-repo changes are only required when enabling runtime credentials or network access for external APIs.

## Existing Mia Backlog Impact

Open `mia` issues affect rollout sequencing:

- `#6` should be treated as a conformance prerequisite for broader reuse of Mia as a reference workload.
- `#17` is aligned with the long-term extraction of reusable tenant patterns.
- runtime hardening issues (`#11`, `#13`, `#14`, `#15`, `#16`) argue for manual-trigger, low-risk assistant behavior in v1.

These issues do not block design, but they do block any plan that assumes mature autonomous runtime operations.

## Architecture Boundary

Mia remains a governed `tenant` workload.

- `platform-docs` owns doctrine and governance.
- `gitops` owns desired state and lifecycle registration.
- `llm-platform` will eventually own shared model access.
- `mia` owns doctrine-aware execution of assistant workflows.

Mia must consume doctrine. It must not become doctrine.

## Capability Modules

### 1. `policy_reader`

Purpose:

- load only the canonical documents relevant to the current task
- map a task to the authoritative docs it depends on

Responsibilities:

- scope resolution from `REPO_TAXONOMY.md`
- doctrine lookup for friction, measurement, audit, and control-plane questions

### 2. `issue_triage`

Purpose:

- read GitHub and GitLab issues or discussions
- classify the work item
- recommend safe next actions

Responsibilities:

- issue normalization across providers
- label recommendation
- priority and impact suggestion
- duplicate and needs-info detection
- comment draft generation

### 3. `friction_triage`

Purpose:

- apply the documented friction triage flow from `FRICTION_FEEDBACK.md`

Responsibilities:

- classify into `automation`, `docs`, `bug`, `capability`, or `user-error`
- assess `impact: high|medium|low`
- recommend `quick-fix`, `roadmap-item`, `known-limitation`, or `wont-fix`
- draft DX PM response text

### 4. `measurement`

Purpose:

- compute platform metrics that can be derived from governed repositories and issue systems

Initial metric coverage:

- workloads with `zave.yaml`
- workloads with `docker-compose`
- workloads with `.env.example`
- workloads with README local development section
- workloads registered in GitOps
- capability adoption counts
- POC governance conformance
- friction submission and resolution metrics

### 5. `audit_support`

Purpose:

- gather evidence for the audits defined in `AUDIT_PROGRAM.md`

Responsibilities:

- identify audit trigger and in-scope repos
- cite canonical authorities consulted
- generate findings, exceptions, and debt lists
- mark manual human steps explicitly

### 6. `reporting`

Purpose:

- render Markdown summaries from structured outputs

Responsibilities:

- friction reports
- formation progress reports
- audit summaries
- proposed issue and discussion comments

## Trigger Surface

V1 is manual-trigger only.

Supported command shapes:

- `triage issue github <owner>/<repo>#<number>`
- `triage issue gitlab <project>#<number>`
- `triage discussion <url>`
- `triage friction <url>`
- `measure formation`
- `measure repo-conformance`
- `measure friction <month|quarter>`
- `draft friction-report <quarter>`
- `draft audit <trigger>`
- `show evidence <metric|audit>`

Not supported in v1:

- background polling
- webhook-driven autonomous actions
- recurring unattended writes

## Output Contract

All Mia assistant tasks should produce:

1. a short human-readable summary
2. a machine-readable JSON result
3. an approval bundle when any write action is proposed

Report-oriented tasks may additionally produce Markdown artifacts.

### `IssueTriageResult`

```json
{
  "type": "IssueTriageResult",
  "source": "github",
  "entity": "zavestudios/mia#17",
  "classification": "bug|feature|question|friction|ops|duplicate|needs-info|wont-fix",
  "impact": "high|medium|low",
  "priority": "high|medium|low",
  "recommended_labels": [],
  "recommended_actions": [],
  "comment_template": "none|clarify|needs-repro|roadmap|known-limitation|wont-fix",
  "evidence": [],
  "confidence": 0.0,
  "requires_human_approval": true
}
```

### `FrictionTriageResult`

```json
{
  "type": "FrictionTriageResult",
  "entity": "platform-docs discussion 123",
  "category": "automation|docs|bug|capability|user-error",
  "impact": "high|medium|low",
  "resolution_category": "quick-fix|roadmap-item|known-limitation|wont-fix",
  "recommended_labels": [],
  "recommended_response": "",
  "roadmap_candidate": true,
  "evidence": [],
  "confidence": 0.0,
  "requires_human_approval": true
}
```

### `MetricSnapshot`

```json
{
  "type": "MetricSnapshot",
  "metric_set": "formation|friction|conformance|capability-adoption",
  "captured_at": "2026-03-22T00:00:00Z",
  "scope": [],
  "values": {},
  "unknowns": [],
  "sources": [],
  "notes": []
}
```

### `AuditEvidenceBundle`

```json
{
  "type": "AuditEvidenceBundle",
  "audit_name": "Contract and Conformance Audit",
  "trigger": "tenant onboarding",
  "in_scope_repos": [],
  "authorities": [],
  "findings": [],
  "formation_exceptions": [],
  "manual_human_steps": []
}
```

### `ApprovalBundle`

```json
{
  "type": "ApprovalBundle",
  "proposed_writes": [],
  "reasoning_summary": "",
  "evidence": [],
  "risk_level": "low|medium|high",
  "approved": false
}
```

## Decision Pipeline

Assistant execution should follow this order:

1. resolve scope from `REPO_TAXONOMY.md`
2. load only task-relevant doctrine files
3. run deterministic checks and rules first
4. use small-model JSON classification only when rules are insufficient
5. emit structured result
6. emit approval bundle if any write is proposed

This keeps cost low and prevents policy invention.

## LLM Access Abstraction

Mia should not embed long-term provider-routing logic.

The assistant should support two model-access modes:

- `direct`
- `gateway`

Suggested config contract:

- `LLM_MODE=direct|gateway`
- `LLM_BASE_URL=<internal shared gateway URL when gateway mode is enabled>`
- internal model profiles such as `cheap`, `default`, and `premium`

This keeps Mia compatible with the future `llm-platform` shared gateway without blocking v1.

## Write Permission Matrix

### Default v1 mode

- read-only

### Allowed only with explicit approval

- add labels
- post templated comments
- create draft issue or report artifacts

### Not allowed in v1

- automatic issue closure
- automatic reassignment
- GitOps mutation
- pull request merge
- doctrine mutation as part of assistant execution
- cluster actions

## Metrics Coverage

### Metrics Mia can compute in v1

- contract adoption scans
- DX standardization artifact presence
- GitOps registration presence
- capability adoption counts
- POC documentation conformance
- friction volume, resolution rate, and high-impact handling

### Metrics Mia should mark as partial or externally sourced

- valid-contract rate when CI validation evidence is unavailable
- deployments via GitOps
- DORA lead time
- change failure rate
- MTTR
- CSAT
- NPS
- platform toil percentage

These require CI, runtime, incident, survey, or manual-input sources not guaranteed to exist inside Mia.

## Risk Controls

- manual-trigger only
- rules-first classification
- batch limits for issue processing
- content-hash skipping for unchanged entities
- doctrine citations included in outputs
- approval required for all proposed writes

## Success Criteria

V1 succeeds when:

- Mia can triage a single issue or discussion into the documented friction flow.
- Mia can compute a Formation measurement snapshot from governed repositories.
- Mia can produce an audit evidence bundle with explicit authorities and findings.
- Mia does not introduce a competing authority surface.
- All write actions remain gated by approval bundles.

## Next Implementation Slice

The first implementation slice should add:

- assistant configuration surface
- schema definitions for the output contract
- doctrine-to-task mapping
- one end-to-end issue triage path
- one end-to-end formation measurement path
- one end-to-end audit evidence path

## Manual Human Steps

If future runtime integration requires external credentials or cluster wiring:

- secrets and env injection changes belong in `gitops`
- any `kubectl` validation must be labeled `Run manually by human`
