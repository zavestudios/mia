# Mia Platform and Career Assistant v1

## Purpose

Mia v1 extends the existing OpenClaw-based tenant into a doctrine-aware platform and career assistant for Xavier Lopez and ZaveStudios.

Mia may:

- maintain roadmap-oriented working memory through canonical planning artifacts
- support learning reviews, career planning, and weekly prioritization
- prepare structured findings for a future retrospective learning loop
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

This capability operationalizes documented platform workflows without moving authority out of `platform-docs`, while also turning active platform work into a usable career and learning operating system.

Primary doctrine inputs:

- `REPO_TAXONOMY.md`
- `CONTROL_PLANE_MODEL.md`
- `GITOPS_MODEL.md`
- `MEASUREMENT_MODEL.md`
- `FRICTION_FEEDBACK.md`
- `AUDIT_PROGRAM.md`

Adjacent future-model input:

- `platform-docs#71` (`LEARNING_LOOP_MODEL.md`, proposed)

## Scope

### Included in v1

- manual-trigger roadmap review and weekly planning
- conversational progress tracking against canonical local artifacts
- heartbeat-driven reminder and check-in prompts
- manual-trigger issue and discussion triage
- friction triage aligned to `FRICTION_FEEDBACK.md`
- measurement snapshots for metrics derivable from repository and issue-system state
- audit evidence bundle generation
- Markdown report drafting
- approval bundles for any proposed write action

### Explicitly Excluded in v1

- autonomous interpretation of repo activity as completed learning progress
- autonomous transcript ingestion and overnight proposal execution
- autonomous polling and scheduled write actions
- automatic issue closure or reassignment
- GitOps mutation
- cluster mutation
- dashboard implementation
- provider-specific logic embedded into assistant workflows

## Repository Scope

This implementation slice is primarily single-repo in `mia`.

Read sources include:

- local planning and tracking artifacts under `mia/docs/`
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

For career and learning use, Mia must also consume planning artifacts. It must not silently rewrite goals or mark progress complete without explicit user interaction or approval.

If Mia later participates in a retrospective learning loop, that loop must still respect the same control boundary: low-risk findings may be drafted automatically, but GitOps, policy, and other higher-risk changes must remain queued for human review.

## Capability Modules

### 1. `policy_reader`

Purpose:

- load only the canonical documents relevant to the current task
- map a task to the authoritative docs it depends on

Responsibilities:

- scope resolution from `REPO_TAXONOMY.md`
- doctrine lookup for friction, measurement, audit, and control-plane questions

### 1a. `roadmap_reader`

Purpose:

- load the canonical roadmap, tracker, and weekly review artifacts
- answer questions about current priorities, stale goals, and blocked work

Responsibilities:

- identify active priorities and current phase
- compare stated goals with recorded progress
- surface stale or conflicting commitments

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
- weekly reviews and progress summaries

### 7. `career_coach`

Purpose:

- translate platform work and learning goals into practical weekly execution

Responsibilities:

- recommend next actions
- identify overcommitment or drift
- suggest when a learning topic should move from exploration to execution
- connect repository work back to broader career goals

### 8. `learning_loop_adapter`

Purpose:

- define the interface between Mia's interactive workflows and a future retrospective refinement loop

Responsibilities:

- normalize candidate findings from sessions into reviewable proposals
- separate low-risk outputs from high-risk changes
- preserve evidence links back to roadmap, tracker, and source sessions
- avoid direct execution of queued infrastructure or policy mutations in v1

## Trigger Surface

V1 is manual-trigger plus heartbeat-prompt only.

Supported command shapes:

- `review roadmap`
- `review week`
- `show current priorities`
- `mark progress <item>`
- `log blocker <item>`
- `draft learning-loop finding`
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
- autonomous tracker updates based only on repo events

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

### `RoadmapReviewResult`

```json
{
  "type": "RoadmapReviewResult",
  "captured_at": "2026-04-30T00:00:00Z",
  "current_priorities": [],
  "completed_since_last_review": [],
  "slipped_items": [],
  "blockers": [],
  "recommended_next_actions": [],
  "sources": [],
  "requires_human_approval": true
}
```

### `LearningLoopFinding`

```json
{
  "type": "LearningLoopFinding",
  "captured_at": "2026-05-05T00:00:00Z",
  "source_kind": "session|issue|repo-work|manual-note",
  "pattern": "repeated-fix|missing-ci-check|manual-step-without-automation|control-plane-clarity-gap",
  "summary": "",
  "evidence": [],
  "target_surface": "mia-doc|mia-memory|repo-issue|platform-docs-issue|review-queue",
  "proposed_output": "memory-update|issue-draft|doc-update-draft|review-queue",
  "risk_level": "low|medium|high",
  "requires_human_approval": true
}
```

### Evidence Requirements For `LearningLoopFinding`

Every finding should include enough evidence to survive review without relying
on memory or chat archaeology.

Minimum evidence set:

- source reference
- concise problem statement
- repeated pattern or missed-check explanation
- proposed target surface
- why the proposal would reduce future troubleshooting time or improve predictability

Preferred evidence set:

- repeated occurrence count or multiple examples
- affected repos or control planes
- existing workaround or manual-step reference
- candidate durable fix category

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
2. load local roadmap/tracker artifacts when the task is career or planning related
3. load only task-relevant doctrine files
4. run deterministic checks and rules first
5. use small-model JSON classification only when rules are insufficient
6. emit structured result
7. emit approval bundle if any write is proposed

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
- draft roadmap or tracker updates for human review

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

## Career Tracking Rules

- the roadmap and tracker are the primary planning surface
- repo or issue activity is supporting evidence, not authoritative proof of progress
- completed progress should be confirmed explicitly by the human
- heartbeat prompts may request updates, but must not assume completion
- when priorities conflict, Mia should recommend narrowing scope rather than expanding it

## Future Learning Loop Alignment

The current interactive assistant should be compatible with the proposed
`LEARNING_LOOP_MODEL` direction from `platform-docs#71`.

That means:

- roadmap and tracker artifacts should remain easy to inspect and diff
- findings should be expressible as small structured proposals
- low-risk outputs may eventually be auto-drafted
- high-risk outputs should remain queued for review
- transcript-derived insights should supplement, not replace, explicit human progress confirmation

## Proposal Tiers

Future learning-loop proposals should be split by target surface and risk, not
just by convenience.

### Tier 1: Low-Risk Auto-Draft Candidates

Allowed as future auto-drafts, still reviewable:

- Mia memory updates
- draft issue creation in the appropriate repo
- draft tracker or roadmap updates for human review
- draft notes pointing to recurring manual steps or stale priorities

Conditions:

- the finding is backed by explicit evidence
- no GitOps, CI, policy, or governance mutation is implied
- the output is reversible and easy to inspect

### Tier 2: Review-Queue Only

Must always be queued for human review:

- `gitops` changes
- CI or workflow gate changes
- policy or doctrine additions
- lifecycle or contract-surface changes
- any recommendation that mutates shared infrastructure behavior

Conditions:

- findings may still be normalized and summarized automatically
- output should point to the owning repo and suggested issue surface
- no direct mutation should happen from Mia v1 or the first learning-loop phase

### Tier 3: Out Of Scope

Not appropriate for Mia's early learning-loop phases:

- direct cluster actions
- unattended GitOps mutation
- automatic pull request merge or closure
- automatic progress completion based only on transcript or repo inference

## Source Validity Rules

Not every artifact is equally trustworthy as a learning-loop input.

Primary valid sources:

- interactive assistant session transcripts
- approved manual notes
- issue discussions
- reviewable repository work artifacts

Secondary supporting sources:

- PR comments
- local tracker history
- linked runbooks and docs

Weak sources that should not stand alone:

- single unverified agent response
- inferred intent from one commit
- one-off exploratory shell output without corroboration

## Owning Surface Rules

Learning-loop outputs should land in the natural owning surface:

- personal planning or reminder refinement: `mia`
- doctrine, methodology, or governance gaps: `platform-docs`
- runtime desired state or lifecycle gaps: `gitops`
- workload-specific follow-up: owning workload repo issue

Mia may prepare the proposal, but should not redefine ownership.

## Risk Controls

- manual-trigger only
- rules-first classification
- batch limits for issue processing
- content-hash skipping for unchanged entities
- doctrine citations included in outputs
- approval required for all proposed writes

## Success Criteria

V1 succeeds when:

- Mia can review the roadmap and identify active priorities, slipped items, and blockers.
- Mia can support a weekly planning and review loop without inventing progress.
- Mia has a clear extension path toward retrospective learning-loop proposals without claiming autonomous execution today.
- Mia can triage a single issue or discussion into the documented friction flow.
- Mia can compute a Formation measurement snapshot from governed repositories.
- Mia can produce an audit evidence bundle with explicit authorities and findings.
- Mia does not introduce a competing authority surface.
- All write actions remain gated by approval bundles.

## Next Implementation Slice

The first implementation slice should add:

- assistant configuration surface
- roadmap, progress tracker, and weekly review artifacts
- schema definitions for the output contract
- doctrine-to-task and roadmap-to-task mapping
- one end-to-end issue triage path
- one end-to-end roadmap review path
- one end-to-end formation measurement path
- one end-to-end audit evidence path

## Phase 2 Direction

After v1 proves useful interactively, the next logical phase is to align Mia
with the proposed `LEARNING_LOOP_MODEL`:

- ingest session findings from an approved source
- detect repeat patterns and missed automation opportunities
- generate `LearningLoopFinding` proposals
- auto-draft only low-risk outputs
- queue infrastructure, CI, policy, and governance changes for review

## Manual Human Steps

If future runtime integration requires external credentials or cluster wiring:

- secrets and env injection changes belong in `gitops`
- any `kubectl` validation must be labeled `Run manually by human`
