# First-Session Comprehension + Phase Gate Design

Status: `USER_APPROVED_DIRECTION · PHASE_A_PLANNING · NO_NEW_PRODUCT_DECISION`

Audit: `SX-AUD-044`

Product/runtime authority remains `GMB-002 · SX-DEC-027~055`. This design does not create a new gameplay Decision ID and does not authorize Godot/GDScript/Codex implementation.

## 1. Goal

Close the remaining planning gap between the approved `SX-DEC-055` runtime semantic POC and trustworthy first-contact player evidence.

The package must prove, in planning only, that:

1. current owner documents enforce the project instruction sequence `PHASE A planning → explicit user "기획 완료" → PHASE B final planning review → only then BUILD`;
2. the old Android validation APK remains historical/diagnostic evidence rather than silently becoming the final player-comprehension build after presentation changes;
3. future human comprehension runs against an exact post-POC acceptance build whose identity is recorded after implementation, not against a fossilized pre-POC presentation;
4. player understanding is measured primarily from behavior, prediction, independent performance, and transfer, with verbal recall used as supporting evidence;
5. automated, physical-device, human-comprehension, and production-cutover evidence remain separate gates.

## 2. Current authority and conflict

Baseline at design freeze:

```yaml
project_main: 398be2f12c6d279c83001bf36bfdd3ecb7f72a08
open_project_prs: 0
base_reference_main: 315c66eea9614c284b9c11c4d522141065dfa4b0
project_base_pin: v9.4.3
sx_dec_055: SPEC_AND_DOR_APPROVED · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
semantic_assets: 73_PRODUCT_PNGS_COMPLETE
runtime_integrated: false
windows_physical: NOT_RUN
android_device: NOT_RUN
human_comprehension: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

### Conflict A — current-owner execution-order drift

`ACTIVE_CONTEXT.md` and `ROADMAP.md` still contain an older handoff path where an explicit resume can lead directly to `SX-DEC-055 Task 1 / Step 1.1 RED`.

The current project instruction v4.5 is stricter and higher priority:

```text
PHASE A — GPT CHAT PLANNING
→ user explicitly declares "기획 완료"
→ PHASE B — FINAL PLANNING REVIEW
→ only after Phase B: POWERSHELL / CODEX / GODOT BUILD
```

The owner documents must be updated to this sequence without cancelling the already-approved `SX-DEC-055` scope.

### Conflict B — comprehension build identity is historical

`PLAYTEST_PLAN.md` is bound to the historical validation APK:

```text
source commit 536911449018a3caf3511bc64e7bf1a66edf2016
SHA-256 eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
```

That artifact predates the approved 73-product semantic asset runtime POC. It remains valid packaging/validation-harness evidence, but it cannot prove comprehension of the post-POC current presentation.

### Conflict C — behavior vs questionnaire weight

The current plan has useful comprehension questions, but its pass criteria are dominated by verbal answers. For a puzzle whose core promise is route-order planning + LIFO + execution, the gate must first observe what the player does and predicts without coaching, then use neutral questions to probe the mental model.

## 3. Existing-solution-first verdict

`ABSORB_EXISTING_OWNERS · NO_NEW_GAMEPLAY_FEATURE`

Reuse:

- `CURRENT_CONFIRMED_DECISIONS.md` for current decision/evidence ceiling;
- `ACTIVE_CONTEXT.md` for continuation/gate routing;
- `ROADMAP.md` / `DEVELOPMENT_GATES.md` for validation dependencies;
- `PLAYTEST_PLAN.md` as the existing human-research owner;
- `SX-DEC-055` design and RED-first implementation plan for functions/dependencies/protected surfaces;
- historical Android runbook/template for the old validation-harness lane without rewriting its fixed hash in this Phase A package.

Do not create:

- a new gameplay/product Decision;
- a second semantic-runtime implementation plan;
- a new tutorial mechanic or forced hint system;
- a new map solely to manufacture comprehension evidence;
- a new runtime telemetry signal during Phase A.

## 4. Approach comparison

### Approach A — run the existing five-person plan on the old canonical APK

Rejected.

It would test a historical presentation before `SX-DEC-055`, so findings about TOP, load mode, switch state, preflight, and causal feedback could be invalidated by the very presentation change the approved POC is meant to introduce.

### Approach B — wait until after implementation to think about human validation

Rejected.

That violates planning-first: the build could be completed without a precommitted evidence contract, encouraging post-hoc success criteria.

### Approach C — precommit a post-POC exact acceptance-build contract now

Selected.

Plan the participant, task, observation, severity, build-identity, physical-smoke, and human-gate rules now. Populate concrete build SHA/artifact hash only after the authorized implementation exists. This preserves planning-first while avoiding invented future evidence.

## 5. Acceptance-build identity contract

A future acceptance build is not a specific artifact yet. Until Phase C creates and verifies it, fields remain explicit state values rather than placeholders:

```yaml
acceptance_build_state: UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE
source_commit: UNASSIGNED
artifact_platform: ANDROID_PRIMARY
artifact_sha256: UNASSIGNED
package_identity: UNASSIGNED
sx_dec_055_runtime_state_required: MERGED_AUTOMATED_POC_EVIDENCE
physical_smoke_state: NOT_RUN
human_comprehension_state: NOT_RUN
```

Rules:

1. Build identity is assigned only from a merged/current implementation state produced after the v4.5 user Gate and Phase B.
2. Human sessions may not use an artifact with a different hash than the one whose physical smoke was reviewed for that comprehension round.
3. Any player-facing presentation/input change affecting the tested learning targets invalidates carry-forward and requires a new acceptance-build identity and fresh affected evidence.
4. The historical `eb49225a...759ea` Android validation APK stays recorded as historical validation-harness packaging evidence and may still support its dedicated diagnostics, but it cannot close post-POC comprehension.
5. PC physical evidence may supplement diagnosis, but the approved Android-oriented Five-person Comprehension gate is not replaced by PC-only evidence.

## 6. First-session learning model

Use Base tutorial/onboarding reasoning:

```text
RULE → NEED → DISCOVER → FEEL → PROVE → TRANSFER
```

For this project:

| Learning target | NEED | DISCOVER / FEEL | PROVE | TRANSFER |
|---|---|---|---|---|
| Objective | all cargo must reach matching stations before time ends | map/goal/HUD context | starts a viable attempt without facilitator solution help | can state what remains after a partial run |
| Build + preflight | route must structurally reach required points | placement + invalid/issue feedback | fixes a blocking layout issue unaided | can diagnose a later different blocked cell/state |
| Encounter order | track path determines cargo encounter sequence | planned route vs actual encounters | predicts which cargo is encountered next | modifies route/load choice and predicts changed order |
| LIFO TOP | last loaded cargo is next unload candidate | stack/TOP presentation | predicts next unload before station arrival | predicts again after stack changes |
| Contiguous unload group | only same-type contiguous TOP group unloads | unload feedback + remaining stack | predicts group count | applies rule to later different stack state |
| Load mode | manual hold vs auto toggle are persistent/active state distinctions | actual state presentation | deliberately chooses and uses intended mode | notices/recovers when state differs on later contact |
| Switch direction | selected direction controls the next route; occupied switch locks | arrows/semantic reinforcement/lock feedback | selects intended path before entry | predicts consequence of a later switch state |
| Retry vs Edit | retry preserves sealed layout with fresh runtime; edit returns to layout changes | result choices | intentionally chooses correct recovery | explains which choice to use for a route-design vs execution mistake |
| Redundant identity | cargo/station/TOP are not color-only | shape/text/TOP signs | identifies without relying on color | repeats identification in later state |
| Causal feedback | pickup/unload/route selection/terminal result correspond to real events | semantic VFX + existing text/procedural fallback | attributes feedback to correct event | does not mistake decoration for gameplay authority |

No row above changes the product rule. It only defines what a first-time player must demonstrate about already-approved behavior.

## 7. Study design

### Participant contract

```yaml
research_goal: FIND_COMPREHENSION_AND_USABILITY_PROBLEMS
recruit_target: 6 · TEST_VALUE
minimum_analyzable_first_contact_sessions: 5
approved_gate_name: FIVE_PERSON_COMPREHENSION
prior_exposure_to_acceptance_build: NONE
participant_mix: target casual puzzle players; include variation in rail/puzzle familiarity
participant_aliases: P01..P06 as needed
personal_data: MINIMIZE_AND_REDACT
```

`recruit_target=6` is a pragmatic buffer from professional GUR practice, not a new product rule and not a claim that six is universally correct. The existing Five-person gate remains the minimum analyzable evidence requirement. If six valid sessions complete, analyze all six; do not discard a valid session to force a five-person denominator.

### Moderator contract

Before gameplay, give only the minimum product goal, equivalent to:

```text
"화물을 모두 알맞은 역에 배송하는 선로 퍼즐입니다. 화면을 보며 원하는 방식으로 진행해 주세요."
```

Do not explain route solution, LIFO answer, TOP meaning, unload-group answer, ideal load mode, or switch answer before observation.

Allowed neutral probes after a decision point or when the participant naturally pauses:

- `지금 무슨 일이 일어나고 있다고 생각하나요?`
- `현재 목표가 무엇이라고 생각하나요?`
- `다음에는 무엇을 할 생각인가요?`
- `왜 그렇게 생각했나요?`
- `이 표시가 무엇을 뜻한다고 생각하나요?`

Do not say whether an answer is correct during the task. Any facilitator intervention that provides a solution-relevant fact is recorded separately and contaminates that task result.

## 8. Behavior-first observation contract

Record separate evidence channels:

```yaml
observed_behavior:
prediction_before_outcome:
post_task_explanation:
moderator_intervention:
control_or_motor_issue:
comprehension_issue:
visual_readability_issue:
participant_self_report:
```

Never infer comprehension from a survey answer alone when observed behavior contradicts it.

Required observation IDs:

| ID | Evidence target |
|---|---|
| FS-01 | Identifies current objective and remaining work |
| FS-02 | Uses BUILD placement and understands blocking preflight feedback |
| FS-03 | Connects route to cargo encounter order |
| FS-04 | Uses manual/auto load intentionally and reads current state |
| FS-05 | Predicts TOP before an unload event |
| FS-06 | Predicts contiguous same-type unload group/count |
| FS-07 | Reads selected switch direction and occupied-lock state |
| FS-08 | Chooses Retry vs Edit for the stated problem type |
| FS-09 | Identifies cargo/station/TOP using non-color signifiers |
| FS-10 | Correctly attributes pickup/unload/route/terminal feedback |
| FS-11 | Transfers the learned rule to a later changed state without new explanation |
| FS-12 | Completes required flow without solution-relevant moderator intervention |

`FS-11` does not require a new production map. It can use a later changed stack/route/switch state in the same representative stage or a same-layout retry/edit situation.

## 9. Pass/fail thresholds

Keep the project’s existing qualitative 80% convention but apply it to analyzable behavior evidence, not only recall.

For 5 analyzable sessions: threshold = `4/5` where specified.
For `N > 5`: threshold = `ceil(N × 0.8)`.

Gate criteria:

| Gate | Criterion |
|---|---|
| HUM-01 | objective/progress understanding meets threshold |
| HUM-02 | route → encounter-order model meets threshold |
| HUM-03 | LIFO TOP prediction meets threshold |
| HUM-04 | contiguous unload-group prediction meets threshold |
| HUM-05 | manual/auto state understanding meets threshold |
| HUM-06 | selected switch direction/occupied-lock understanding meets threshold |
| HUM-07 | Retry vs Edit recovery model meets threshold |
| HUM-08 | non-color redundant identification meets threshold |
| HUM-09 | causal semantic feedback attribution meets threshold |
| HUM-10 | independent transfer FS-11 meets threshold |
| HUM-11 | repeated fatal reverse-switch-direction misconception = `0` analyzable sessions |
| HUM-12 | solution-relevant moderator intervention required to finish core proof = `0` analyzable sessions |
| HUM-13 | unresolved P0/P1 comprehension/accessibility finding at gate review = `0` |

The gate is not PASS if required recordings/notes/build identity are missing, even when participant answers look positive.

## 10. Severity model

### P0 / Critical

- cannot progress without solution-relevant moderator intervention;
- persistent wrong mental model reverses selected switch direction and repeatedly causes route failure;
- required cargo/station/TOP identity becomes unusable without color;
- intended presentation leaves the player unable to infer LIFO/TOP after the relevant observed event;
- acceptance build crashes/loses input or makes required evidence invalid.

### P1 / High

- player completes mainly by random trial but cannot form a reusable route/LIFO model;
- cannot transfer a learned core rule to the later changed state;
- repeatedly misreads manual/auto mode or preflight state enough to derail the intended plan;
- semantic feedback communicates the wrong cause or competes with the authoritative procedural/text state.

### P2 / Medium

- hesitation, wording, density, or local clarity problem that does not block the core proof and does not form a persistent wrong mental model.

### P3 / Low

- preference/polish issue with no demonstrated comprehension or accessibility consequence.

## 11. Evidence sequence

Current planning sequence:

```text
PHASE A planning package complete
→ explicit user "기획 완료"
→ PHASE B final planning review
→ authorized SX-DEC-055 implementation
→ exact-head automated POC evidence + merge
→ assign exact acceptance-build identity
→ required physical product smoke on that exact build
→ Five-person Comprehension on the same accepted build identity
→ adversarial evidence review
→ next product/rework/cutover decision
```

Automated POC PASS never substitutes for physical or human evidence.

## 12. Function/dependency/protection coverage

The existing `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md` already provides implementation-level planning for:

- exact files and interfaces;
- `SemanticAssetCatalog`;
- pure semantic runtime-state resolver;
- presenter/controller read-state projection;
- HUD/BUILD/route/VFX presentation;
- Reduced Motion information equivalence;
- event wiring;
- immutable asset/package protections;
- RED/GREEN sequencing;
- exact-head CI and merge closure;
- same-ID post-merge synchronization.

This Phase A package adds the missing **acceptance evidence dependency after implementation** rather than duplicating those tasks.

Protected areas remain:

- no gameplay/domain change;
- no route geometry/cycle/hit/lock mutation;
- no new combo domain signal solely for VFX;
- no historical semantic manifest rewrite;
- no Base repin;
- no asset-vault mutation;
- no physical/device/human PASS inflation;
- no BUILD before explicit v4.5 user gate and Phase B.

## 13. External evidence disposition

- Games User Research professional practice: `ADAPT` — one-to-one observation, unbiased probing, problem-finding sample sized pragmatically; use six recruits as a buffer but preserve project Five-person gate.
- Xbox Accessibility Guidelines: `ADOPT_AS_VALIDATION_LENS` — objective/UI context and multiple signifiers support the existing project readability constraints; they do not create new game rules.
- Competitor puzzle references such as Railbound: `REFERENCE_ONLY` for finite handcrafted/learnable puzzle framing; do not copy level mechanics or hint systems into current scope.

## 14. Phase A completion criteria for this package

This package can mark `READY_FOR_USER_PLANNING_COMPLETE_GATE` only after:

1. current owner docs encode the v4.5 sequence;
2. `PLAYTEST_PLAN.md` no longer treats the old APK as the current human-comprehension build;
3. the acceptance-build identity, participant, observation, threshold, severity, and invalidation rules are canonical;
4. existing SX-DEC-055 function/dependency/protection plan is linked rather than duplicated;
5. GitHub and the configured Sheet use the same current state/audit references;
6. adversarial review finds no P0/P1 planning conflict;
7. the planning PR exact head passes all applicable checks and merges.

`READY_FOR_USER_PLANNING_COMPLETE_GATE` is not the user declaration itself. BUILD remains prohibited until the user explicitly supplies the v4.5 planning-complete gate and Phase B subsequently passes.
