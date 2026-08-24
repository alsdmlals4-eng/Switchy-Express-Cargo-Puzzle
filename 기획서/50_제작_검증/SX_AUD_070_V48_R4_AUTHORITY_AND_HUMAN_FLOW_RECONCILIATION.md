# SX-AUD-070 · v4.8 r4 Authority & Human Flow Reconciliation

Last updated: `2026-08-25 KST`

```yaml
audit_id: SX-AUD-070
status: IN_PROGRESS
approval: USER_APPROVED_2026_08_25
product_decision_anchor: SX-DEC-059
scope: AUTHORITY_REFERENCE_FRESHNESS_AND_HUMAN_HOME_PROJECTION
product_runtime_change: NONE
baseline_project_main: cf207f29cd4dcabc5796769f0eb0ca6764c2370e
base_completed_main_observed_at_start: ceb83c680f76fead5811956bd6503fd5e4da8577
work_instruction: v4.8 · 2026-08-24-r4
work_instruction_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
historical_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
current_candidate: SX59-POC-ACCEPT-003
player_experience: NOT_RUN
```

## 1. Why this reconciliation exists

Project runtime/product meaning was already on the finite `GMB-002` baseline and `SX-DEC-059` had been implemented and merged, but current entry surfaces still advertised the initial v4.8 `r2` contract or the superseded Candidate 001 validation sequence. This created a real routing risk: a later AI/Codex session could read a stale current locator even though `ACTIVE_CONTEXT.md` and Candidate 003 evidence had already advanced.

The approved package therefore performs **reference freshness + human-facing projection**, not product redesign.

## 2. Protected product boundary

No change is authorized to:

- `GMB-002` finite delivery core;
- track build/refund, structural preflight, manual/auto loading, unlimited LIFO, TOP-group unload, switch occupied lock, timer/ROUTE_END/success, Retry/Edit semantics;
- `SX-DEC-056A/056B/057/058` authorization state;
- score/combo formula, save/schema, maps, Scene, Resource, gameplay data;
- product image/audio bytes or generated visual;
- physical/audio/device/human/player evidence ceiling.

Current next product gate remains Candidate 003 physical validation.

## 3. Existing Solution First

Reused and adapted:

- prior `docs/superpowers/plans/2026-08-24-v48-current-authority-reconciliation.md`;
- existing v4.8 Switchy thin adapter;
- existing `tests/python/test_v48_current_authority_migration.py`;
- existing `switchy-express-design` project Skill;
- existing Notion `Switchy Express · Home` + five L2 Domains;
- current Candidate 003 pointer/evidence model.

Rejected:

- second adapter or new project-management surface;
- reopening Google Sheets as active workspace;
- new gameplay feature/system;
- new generated visual.

## 4. Trade study

### A · authority-first → Human-flow-first → validation-first — SELECTED

Correct current routing, improve Human Home projection, then continue Candidate 003 physical/human validation.

### B · Candidate 003 physical validation first, docs later — REJECTED FOR THIS PACKAGE

Would execute through known stale r2/current-candidate locators and conflict with the approved planning-first order.

### C · reopen 056~058 broad product planning now — REJECTED

Adds breadth before first-session physical/human evidence exists and increases maintenance/content cost without resolving the actual bottleneck.

## 5. Benchmark disposition · 2026-08-25

Evidence is directional and not treated as causal proof.

| Reference | Observation | Switchy disposition |
|---|---|---|
| Mini Metro | small legible rule set and limited-resource decisions | `ADAPT` · keep decisions compact instead of widening feature count |
| Railbound | prepare-the-field then watch execution; developer reports regular playtests and visual-clarity work | `ADAPT` · reinforce Plan→Execute→Observe and human readability |
| Train Valley 2 | railway challenges deepen through progression/mastery | `ADAPT_LATER` · mastery can grow after first-session comprehension |
| Rail Route | much broader construction/dispatch/upgrade/automation/management surface; mixed recent reception cannot prove complexity caused reception | `REFERENCE_ONLY / REJECT_NOW` · breadth is not evidence to expand before validation |

Research sources are recorded in the approved design spec:
`docs/superpowers/specs/2026-08-25-v48-r4-authority-and-human-flow-reconciliation-design.md`.

## 6. Active-consumer freshness finding

Fresh repository search identified current routing declarations that still used r2 or an old candidate/gate:

- `AGENTS.md`
- `README.md`
- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- `기획서/00_프로젝트_허브/START_HERE.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- `skills/switchy-express-design/SKILL.md`

Historical r2/v4.7/Candidate 001/002 evidence is retained when explicitly historical. Only current-routing semantics are refreshed.

## 7. TDD evidence

### RED

```yaml
pr: 174
exact_red_head: fe2d13f9286841782a6126730878614d378e96ca
workflow_run: 32788306219
result: EXPECTED_FAIL
failed_step: Validate v4.8 current authority migration
preexisting_contract_steps_before_target: PASS
```

The RED proved that the strengthened r4/Candidate 003 regression was exercising the stale current owners rather than an unrelated runtime defect.

### GREEN work applied so far

- r4 revision + exact user-file hash routed through current owners;
- Candidate 003 Gate 0 → same-candidate self-run/audio → acceptance build → Windows → Android → five-person sequence routed through current owners;
- r4 shared compatible exact-pin / fixed-port / exact-session host boundary added without copying Base playbook;
- stable legacy/freshness literals restored when regression tests proved they remain active consumers.

GREEN exact-head closure is still pending while the protected-path approval contract and generated project-operating artifacts are reconciled.

## 8. Protected-path contract finding

`Validate Project Base Adapter` failed after the first GREEN because `skills/PROJECT_BASE_ADAPTER.json` still recorded protected baseline `ae8f4ae...`, while PR #174 actual base is `cf207f29...`.

This is a **contract deadlock/freshness issue**, not a product failure. The Base-approved pattern is:

```text
exact PR base
→ exact protected-path approval manifest
→ external GitHub approval marker
→ approved protected-change gate
→ all non-protected contract errors remain fatal
```

The project will ADAPT the already proven Base/Ten-Paces pattern. `기획서/**` protection is not removed or weakened.

## 9. Compatibility regressions found during GREEN

Exact workflow logs identified three non-regression literals lost during document compaction:

1. `ACTIVE_CONTEXT.md` stable `SX-DEC-055: MERGED_MAIN_VERIFIED` token;
2. `ROADMAP.md` stable `M6 · Physical/device/human validation` locator;
3. v4.8 adapter PR #154 `CLOSED_UNMERGED` protection statement.

All three were restored without changing current product meaning. This is evidence that the revision non-regression gate was useful and that shorter current docs must preserve live consumers.

## 10. Notion Human Home result

The existing `Switchy Express · Home` was reused rather than replaced with a new dashboard.

Human-facing top projection now explains:

1. 10-second game promise;
2. full flow: `Title/Briefing → BUILD → Preflight → RUN → Pickup → LIFO/TOP → Switch → Delivery/Terminal → Result → Retry Same Layout / Edit`;
3. decision loop: `Plan → Commit → Observe → Diagnose → Re-design`;
4. player questions at BUILD/Pickup/RUN/Result;
5. T1→T6→VS_DEMO_01 learning purpose per stage;
6. existing approved E+D Hybrid visual/accessibility language;
7. Candidate 003 evidence boundary;
8. links to the five existing L2 Domains and separate AI/System surface.

No image was generated or edited.

## 11. Notion mutation incident / recovery / lesson

### Incident

While selecting the Notion mutation route, the wrong create-database action was invoked twice under Home, creating two empty temporary data sources:

- `e43dad05-b03b-49a6-922b-02ca777fce8d`
- `bd5fcafb-63fa-480a-bb87-526fdd9f13af`

No project/user data was written into either temporary database.

### Recovery

```text
side-effect readback
→ Base case search
→ exact data-source identity recovery
→ trash both temporary data sources
→ Home readback confirms accidental children absent
→ correct bounded update_content call
→ post-update Home readback
```

### Lesson / recurrence guard

Before any Notion mutation, verify the exact callable action name and schema. Never use a create-database action as a proxy for page-content editing. For page text changes: fetch exact page → use bounded `update_content`/`insert_content` → destination readback.

## 12. Implementation Reality Gate

```yaml
DISCOVERY:
  base_current: PASS_AT_START
  project_current: PASS_AT_START
  notion_current: PASS
  sheet_migration_source: PASS_READ_ONLY
IMPLEMENTED:
  github_branch_changes: IN_PROGRESS
  notion_human_home: PASS
EXECUTED:
  red_contract: PASS_EXPECTED_FAILURE
  green_exact_head: IN_PROGRESS
DURABLE_READBACK:
  notion_home: PASS
  github_new_main: NOT_YET_MERGED
RUNTIME_CLIENT_HUMAN:
  docs_only_runtime_gate: NOT_APPLICABLE
  candidate_003_physical_visual_recheck: NOT_RUN
  developer_self_run: NOT_RUN
  audio_perceptual_qa: NOT_RUN
  windows_full_physical: NOT_RUN
  android_device: NOT_RUN
  five_person_comprehension: NOT_RUN
  player_experience: NOT_RUN
```

Lower evidence layers are not promoted upward.

## 13. Local/toolchain evidence

This package is documentation/authority/Notion-only. No Godot Scene/Resource/gameplay/runtime authoring is required.

```yaml
LOCAL_WINDOWS_FETCH_PULL: NOT_RUN · NO_LOCAL_EXECUTOR
GODOT_EDITOR_SESSION: NOT_APPLICABLE
GODOT_RUNTIME: NOT_APPLICABLE
LOCAL_GODOT_SAFE_AUTO_UPDATE: NOT_RUN
LOCAL_GODOT_AI_SAFE_AUTO_UPDATE: NOT_RUN
```

The r4 host policy is documented, but no user-local installation/update/session completion is claimed.

## 14. Review / merge state

```yaml
five_full_adversarial_loops: NOT_YET_COMPLETE
exact_green_head: NOT_YET_CLOSED
required_or_applicable_checks: IN_PROGRESS
current_task_pr: 174
merge_sha: NOT_YET_MERGED
postmerge_main_readback: NOT_RUN
notion_postmerge_readback: NOT_RUN
remaining_required_work: PROTECTED_GATE_GENERATED_ARTIFACTS_GREEN_REVIEW_MERGE_READBACK
```

This audit will be finalized on the same workstream after exact-head GREEN, five full adversarial loops, merge, and post-merge readback.
