# Project learning absorption receipt · 2026-08-31

> This is an operations evidence receipt for the project-owned learning review requested on 2026-08-31. It is not a product Decision, a Base proposal registration, a Base implementation, or a release/human-validation claim.

```yaml
receipt_id: SX-LRN-20260831-01
source_project: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
project_main_baseline: a165a31ddf3ba20d2ba0411f42cc9f5899b4753b
project_main_baseline_subject: "docs: reconcile PR 263 and workspace hygiene (#264)"
base_comparison_revision: 1f0ef9d8bdb1869c9ba25b33efdcb34cf2ccba83
survey_window: 2026-08-01 through 2026-08-31 KST
surveyed_history: 640 reachable origin/main commits; 51 first-parent merge milestones
current_project_workspace: GITHUB_ONLY
notion_current_use: RETIRED_NO_ACTIVE_USE
BASE_REPOSITORY_MUTATION: NOT_PERFORMED
```

## Scope, sources, and limits

The review sampled the full first-parent milestone history and read the current owner/consumer paths for each material lesson. It also read relevant merged PR receipts and current tests. The project remains GitHub-only; historical Notion and unrecorded chat sessions were not used as current authority. The review does not claim that it read unavailable external/private conversations, and it does not convert earlier test results into a pass for this receipt's baseline.

| Source group | Readback | Use in this receipt |
| --- | --- | --- |
| Current project authority | `AGENTS.md`, `ACTIVE_CONTEXT.md`, `CURRENT_CONFIRMED_DECISIONS.md`, v4.8 adapter | Current scope, protection, evidence ceiling, and owner routing |
| Project history | 640 commits / 51 first-parent milestones, `2026-08-01` to `2026-08-31` | Locate the original failures, corrections, and merged outcomes |
| Current consumers | Candidate pointer/launcher tests, GUT workflow, execution-contract regression | Verify that a lesson is enforced or classify it as only historical |
| Historical merged PR evidence | #97 and #264 | Verify fresh-import and workspace-hygiene causality respectively |
| Base comparison | Base main `1f0ef9d…`, BCP-025 and BCP-046 | Remove duplicated Base knowledge and locate the one narrow review candidate |

## Classification and project absorption

### 1. Exact candidate evidence follows player-facing source bytes

```yaml
classification: EXISTING_PROJECT_REFLECTION_AND_BASE_DUPLICATE
project_owner: evidence/acceptance/post_sx_dec_060_candidate.json
project_consumers:
  - tests/python/test_current_poc_candidate_pointer.py
  - tests/python/test_execution_contract_freshness.py
status: already_absorbed_and_regression_guarded
```

The project preserves each prior candidate as immutable historical evidence and fail-closes current selection after Candidate 006's exact source revision was superseded by player-facing SX-DEC-067 bytes. Player-facing byte changes invalidate prior candidate status, while tooling-only changes are separately named. This is enforced by the explicit JSON pointer, launcher, and regression tests. It is not a new Base candidate: Base's current exact-SHA, source-identity, and evidence-transfer contracts already own the general rule.

### 2. Fresh Godot import is a preparation gate, not a runtime result

```yaml
classification: EXISTING_PROJECT_REFLECTION_AND_BASE_DUPLICATE
project_owner: .github/workflows/gut-9-7-1-tests.yml
project_consumers:
  - tests/python/test_gut_phase_b_workflow_contract.py
  - docs/GODOT_LIVE_EDITOR_ADOPTION.md
historical_evidence: PR #97 · merge 42d6a1739fb4c645174627367251a260905beef7
status: already_absorbed_and_regression_guarded
```

PR #97 showed that clean import time belonged inside the test budget rather than being misreported as a product test failure. Current workflow order keeps `--headless --import --path .` before the GUT runner, and the project records that fresh cache materialization is separate from normal runtime evidence. This is not a new Base candidate: Base BCP-025 already covers fresh derived/cache generation separate from runtime boot.

### 3. Windows temporary worktree depth and partial cleanup receipts

```yaml
classification: BASE_REVIEW_CANDIDATE_OBSERVATION
project_owner: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md#8A
project_context_owner: 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md#2026-08-31-workspace-artifact-hygiene
project_consumer: tests/python/test_execution_contract_freshness.py
project_absorption: MERGED_MAIN_VERIFIED · PR #264 · a165a31ddf3ba20d2ba0411f42cc9f5899b4753b
BASE_BCP_TARGET: BCP-2026-046-work-godot-process-lifecycle
base_candidate_status: OBSERVATION_ONLY · NOT_REGISTERED · NOT_IMPLEMENTED
```

The project has already absorbed the local rule: create Godot-only temporary worktrees as a **short direct child of the configured Windows temporary root**, audit the exact target before removal, and preserve a partial-cleanup receipt rather than claiming a failed removal recovered storage. The current regression test protects this policy. The general process-ownership and residual-check boundary exists in Base BCP-046, but its current text does not state the Windows path-depth prevention and filesystem-residual receipt together.

This receipt records the actual bounded observation that motivated the project rule:

```yaml
cleanup_observation_date: 2026-08-31 KST
cleanup_residual_path: .worktrees/codex-wayside-hazards-salvage-20260830
cleanup_residual_bytes_observed: 137790617
cleanup_residual_status: PARTIAL
cleanup_residual_reason: Windows path-depth failure in generated .godot shader-cache descendants; broad deletion was not used to bypass the safety boundary.
recovery_rule: re-verify the exact target, consumer/reference, Git state, and active processes before any later removal attempt.
```

The Base-reviewable portion is deliberately narrow: a temporary Godot worktree on Windows should have a path-depth budget, and a failed cleanup must produce an auditable residual receipt. It does not recommend deleting an unknown directory, widening process-kill authority, changing project cache policy, or treating cleanup as runtime verification.

### 4. Product validation policy and finite-delivery content

```yaml
classification: PROJECT_ONLY
project_owners:
  - docs/decisions/SX_DEC_065_MACHINE_PRIMARY_FINAL_USER_REVIEW_VALIDATION_POLICY.md
  - docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
  - docs/decisions/SX_DEC_067_WAYSIDE_HAZARDS_SALVAGE_AND_ROUTE_BOOK_02.md
status: retained_in_project_only_owners
```

Machine-primary acceptance, final-user-review scope, LIFO delivery semantics, cardinal station service, curated Route Book stages, wayside hazards, and miniature rail asset construction remain project-specific. They are not sent to Base as general rules. In particular, the user-selected exclusion of five-person comprehension and player-experience studies is a project validation policy, not a Base requirement.

### 5. User decision and approval preference learning

```yaml
approval_preference_id: SX-APR-20260831-01
classification: PROJECT_OPERATIONAL_PREFERENCE
status: USER_APPROVED_AND_REGRESSION_GUARDED
learning_mode: USER_APPROVAL_PREFERENCE_LEARNING
decision_trace_required: CURRENT_STATE → RECOMMENDED_ACTION → REASON → EXPECTED_EFFECT
base_promotion_boundary: PROJECT_LEARNING_ONLY_UNTIL_BASE_ELIGIBILITY_AND_REGISTRY_OWNERSHIP_CLEAR
```

The user requires a recommendation or approval request to explain the decision in a way that can be judged before implementation. This is a reporting and learning preference, not a new game mechanic, visual canon, runtime acceptance state, or permission to bypass a Base proposal lifecycle.

| Required approval explanation | What must be shown | Why it prevents an avoidable mistake |
| --- | --- | --- |
| `CURRENT_STATE` | The exact current owner, consumer, evidence state, and unresolved constraint | Prevents a recommendation from being based on stale chat context or a candidate being presented as current runtime truth. |
| `RECOMMENDED_ACTION` | The smallest concrete action, its excluded scope, and whether it is project-only, a Base candidate, or an approved Base implementation | Prevents an observation, proposal, and active implementation from being silently conflated. |
| `REASON` | The decision rationale and at least the materially distinct alternatives that were rejected or deferred | Prevents preference-only choices from being reported as inevitable technical facts. |
| `EXPECTED_EFFECT` | The player, maintainer, verification, storage, recovery, or future-work effect that is expected, plus its evidence ceiling | Prevents a cleanup, document change, or static test from being overstated as runtime, human, device, or release proof. |

Every future Base-promotion submission proposed from this project must additionally include the following fields before the user is asked to judge it:

```yaml
PROMOTION_RATIONALE: why the lesson should leave the project boundary
WORK_STRUCTURE: the actual preflight → action → readback → rollback flow
VISUAL_OR_ASSET_RELEVANCE: required consumer-backed image state, or an explicit no-image rationale
FAILURE_CAUSAL_ANALYSIS: the concrete failure mechanism, recurrence conditions, and unsafe shortcuts
EXPECTED_EFFECT: measurable prevention, maintenance, recovery, or evidence-quality benefit
```

For a workflow-only proposal with no player-facing or runtime texture consumer, `VISUAL_OR_ASSET_RELEVANCE` must state `TEXT_NATIVE_FLOW_NO_IMAGE_GENERATION`. The proposal may use a text-native flow diagram, table, or state machine to make the operational relationship inspectable, but it must not generate decorative raster images merely to make the proposal look complete.

This learning does not promote the user's project-specific decision criteria to Base by itself. A later Base submission must separately prove the Base promotion requirements: strong shared contract or repeated cross-project value, preserved project identity, narrow stable interface, clear rights/security/cost boundaries, real consumer and regression evidence, and unoccupied Proposal Registry ownership.

## Reuse handoff evaluation

| Required field | Result |
| --- | --- |
| `selected_modules` | Existing project candidate-freshness guard; existing fresh-import workflow; existing workspace-hygiene rule/test |
| `reuse_mode` | `REUSE_EXISTING_PROJECT_IMPLEMENTATION`; one `BASE_PROMOTION_CANDIDATE` observation only |
| `project_paths_changed` | this receipt, its focused regression test, and the current Active Context resume link; the hygiene operating rule was already merged in PR #264 |
| `verification_evidence` | Historical PR #97/#264 readback; current owner/consumer readback; focused RED→GREEN regression; project contract/Python suite run for this receipt |
| `evidence_ceiling` | No new Godot runtime, human, player-experience, device, platform, legal, release, or Base implementation proof |
| `rollback` | Revert only this receipt/test in a dedicated follow-up; do not remove the already-merged hygiene policy or historical evidence |
| `project_only_lessons` | Candidate policy, finite-delivery rules/content, and machine-primary validation scope remain in their existing owners |
| `base_promotion_candidates` | One unregistered observation: Windows path-depth prevention plus partial-cleanup receipt under Base BCP-046 |

## Current result and next boundary

Project-side learning absorption is complete only for the bounded operating-record/result described above. The Base-review PDF is a derived submission artifact containing the one observation; it does not submit a Base proposal, change a Registry, grant approval, or implement Base behavior. Any Base change requires its own proposal lifecycle and approval reference.
