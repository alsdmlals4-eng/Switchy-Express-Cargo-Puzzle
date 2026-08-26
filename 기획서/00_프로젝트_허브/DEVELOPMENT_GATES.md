# Development Gates

Last updated: `2026-08-26 KST`

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 과거 commit/PR/run은 역사 evidence이며 current next action을 자동 정의하지 않는다.

## 0. Current authority

```yaml
current_work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r4_role: USER_PROVIDED_V4_8_R4_CONTRACT
historical_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_r2_authority_merge_pr: 164
v4_8_r2_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
```

이 authority 전환은 기획·런타임 범위를 넓히지 않는다. `GMB-002`, `SX-DEC-059` 구현 상태, `SX-DEC-056~058` 권한 경계와 physical/human evidence ceiling은 그대로 유지한다.

## 1. Historical v4.7 planning / build chain

```text
A0 CURRENT AUTHORITY RECOVERY: PASS
→ A1 SX-DEC-059 DIRECTION: USER_APPROVED
→ A2 GM-SX059-01 A: USER_APPROVED
→ A3 DETAIL PLAN / VISUAL BRIEF / PLAYTEST DELTA: PASS
→ A4 POST-APPROVAL ADVERSARIAL CLEAN REVIEW: PASS · SX-AUD-063
→ A5 explicit user "기획완료": GRANTED · 2026-08-20 KST
→ A6 FRESH PHASE-C REVIEW + CANON/NOTION RECONCILIATION: PASS · SX-AUD-064
→ A7 IMPLEMENTATION PACKAGE SPEC DoR: PASS
→ A8 USER_REQUESTED_CODEX_HANDOFF: USER_REQUESTED_AND_EXECUTED
→ A9 FRESH EXECUTION PREFLIGHT / ISOLATED WORKTREE: PASS
→ A10 SX_DEC_059_IMPLEMENTATION: IMPLEMENTED_AUTOMATED
→ A11 FIVE-PASS ADVERSARIAL REVIEW: CLOSED · SX-AUD-066
→ A12 INDEPENDENT CODE REVIEW + RED/GREEN CORRECTION: CLOSED · SX-AUD-066
→ A13 IMPLEMENTATION PR #158: MERGED_MAIN_VERIFIED · 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
→ A14 NOTION POST-MERGE IMPLEMENTATION READBACK: PASS
```

`기획완료`는 승인된 059 계획을 잠근다. A6/A7은 설계·정본·인계 패키지의 정적 준비 상태이며, A8 이후 fresh execution preflight와 RED→GREEN 구현, exact-head 검증, merge/readback까지 완료됐다. 이 chain은 v4.7 시기에 실행된 **역사 evidence**이며 현재 작업 방법론은 위 v4.8 r5.4 authority와 최신 Base owner를 따른다.

## 2. Historical implemented baseline chain

```text
GMB-002 finite core: AUTOMATED PASS
→ PC finite vertical-slice pipeline: IMPLEMENTED / HISTORICAL
→ SX-DEC-053/054 semantic assets: 73 PRODUCT PNG · COMPLETE
→ SX-DEC-055 runtime semantic: PR #151 MERGED_MAIN_VERIFIED
```

Stable historical merge compatibility locator:

```text
PR #83/#99/#100 MERGE: PASS
```

이 literal은 과거 PC Vertical Slice와 후속 정본 병합 완료 사실을 참조하는 post-merge freshness consumer용 anchor다. SX-DEC-059의 새 구현 권한을 의미하지 않는다.

SX-DEC-055는 이미 끝났으므로 과거 `SemanticAssetCatalog RED`를 current next action으로 되살리지 않는다.

## 3. Stable device / acceptance evidence anchors

이 literal은 device-smoke canonical-freshness consumer와 과거 evidence locator가 사용하므로 SX-DEC-059가 추가되어도 유지한다.

```text
HISTORICAL CANONICAL APK EXPORT: PASS · HISTORICAL PACKAGE EVIDENCE
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

- Historical canonical APK/export evidence is packaging/history evidence, not the future SX-DEC-059 acceptance build.
- Android device smoke remains an independent platform gate.
- Five-person comprehension requires a later exact acceptance build and reviewed physical smoke.
- no automated/package/self-run result upgrades these anchors to PASS.

## 4. SX-DEC-059 release-near first-session chain

```text
S0 PLAN: COMPLETE
→ S1 T1/T2 shared-map contract: PLAN PASS
→ S2 T3 LIFO content contract: PLAN PASS
→ S3 T4 selective manual content contract: PLAN PASS
→ S4 T5 auto-mode content contract: PLAN PASS
→ S5 T6 switch content contract: PLAN PASS
→ S6 VS_DEMO_01 capstone contract: PLAN PASS
→ S7 first-session sidecar ownership: PLAN PASS
→ S8 localization/responsive/visual reuse contract: PLAN PASS
→ S9 playtest/evidence contract: PLAN PASS
→ S10 RED-first implementation package spec: PASS
→ S11 Codex/Godot implementation: IMPLEMENTED_AUTOMATED
→ S11A custom/GUT/export-pack proof: PASS
→ S11B five-pass adversarial review: CLOSED
→ S11C PR #158 merge + Notion implementation readback: PASS
→ S12 Candidate 003 Gate 0 physical visual recheck: NOT_RUN
→ S13 same exact Candidate 003 developer self-run/screen QA + audio perceptual QA: NOT_RUN
→ S14 exact acceptance build physical/device smoke: NOT_RUN
→ S15 Five-person first-contact comprehension: NOT_RUN
→ S16 product decision: NOT_RUN
```

## 5. Implemented BUILD task families

The following families were implemented after A8 handoff and fresh preflight.

```text
B1 first-session sequence schema / validator
B2 FirstSessionStagePolicy command+visibility enforcement
B3 FirstSessionDirector lesson transition state
B4 MAP-01 T1/T2 shared lesson
B5 MAP-02 T3 LIFO
B6 MAP-03 T4 selective manual
B7 MAP-04 T5 manual/auto switching
B8 MAP-05 T6 switch execution
B9 progressive HUD/contextual copy/localization
B10 evidence-safe Result summary
B11 VS_DEMO_01 capstone integration without map mutation
B12 reduced-motion/responsive/accessibility regression
B13 package/export/clean regression evidence
```

모든 production behavior task는:

```text
RED
→ expected failure verified
→ minimal GREEN
→ focused test GREEN
→ full regression GREEN
→ commit
```

순서를 따랐다.

## 6. Content gate

### Map policy

- New tutorial map target = 5; implementation complete.
- `FiniteMapDefinition` schema v2 reuse.
- tutorial metadata is sidecar, not map schema.
- map coordinates/JSON have deterministic success witness tests.
- no player-facing witness/solver.
- `VS_DEMO_01` bytes/semantic remain immutable by default.

### Learning policy

```text
T1 new concept: track connection
T2 new concept: cargo/station + manual pickup prerequisite
T3 new concept: LIFO TOP reverse planning
T4 new concept: intentional non-load / revisit
T5 new concept: auto-load mode switching
T6 new concept: switch execution / occupied lock
Capstone: transfer without new explanation
```

## 7. UI / input gate

`FirstSessionStagePolicy` gates **both presentation and command path**.

```text
HUD button
keyboard shortcut
touch input
board / route-control request
→ same allowed-command policy
→ current ProductFiniteSlice dispatch boundary
→ current finite domain authority
```

Hidden system must not remain usable through shortcut bypass. Stage visibility must survive subsequent HUD `apply_model()` refreshes and may only narrow phase-valid controls.

## 8. Localization / responsive gate

First-slice languages:

```text
ko
en
ja
zh-Hans
```

`zh-Hant` is deferred until a release target requires it.

- copy key/data separation.
- Lesson Card uses `title_key` + `objective_key`.
- CTA keys come from `FIRST_SESSION_LOCALIZATION_COPY_ADDENDUM_01.md`.
- text-in-PNG forbidden.
- raw localization key player-facing fallback forbidden.
- CJK glyph/line-break/long string checks are automated; physical readability remains separate.

Responsive meaning targets:

```text
1280×720
1600×900
1920×1080
pc_wide_or_ultrawide semantic check
mobile_landscape semantic check
```

Same pixel layout is not required; same information/action/state meaning is required.

## 9. Result evidence gate

Current `FiniteRunSummary` supports:

```text
outcome
failure_reason
completion_time
final_delivery_commit_time
time_limit_seconds
remaining_map_cargo
stack_size
```

059 Result may use these facts. It may not fabricate station mismatch/actual trace causality.

```text
ROUTE_END / TIME_EXPIRED
+ map cargo remaining
+ train stack size
```

Detailed station mismatch is a future 056A observation concern and is outside 059.

## 10. Visual / audio gate

- existing 73 E+D Hybrid / Neo-Arcade semantic product assets first.
- existing `DemoEffects`, audio, SemanticEventOverlay first.
- no new image generation is currently required or authorized.
- Reduced Motion uses same information identity.
- VFX must not cover next critical cargo/switch target.

## 11. Tooling / fresh execution preflight gate

Current project-local observed state remains evidence, not a floating latest pin:

```yaml
godot_project_baseline: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
project_local_tree_parity: REVERIFY_REQUIRED_BEFORE_FUTURE_AUTHORING
```

향후 authoring/runtime 작업은 r5.4와 최신 Base owner에 따라 과거 implementation preflight를 자동 상속하지 않고 다음을 다시 확인한다.

```text
fresh shell
→ exact local repo/project LOCATION
→ clean/dirty/diverged state
→ fetch/prune + safe ff-only reconciliation only when safe
→ official upstream update check
→ compatibility + rollback + canary를 통과한 reviewed safe update only
→ exact pin readback
→ exact Godot Editor/project/session identity
→ GUT / adopted tooling readiness
→ authoring/test/runtime/readback
```

compatible host에서는 프로젝트별 동일 Godot binary·전용 port 증식을 기본 경로로 사용하지 않는다. shared approved exact pins + provider default fixed ports + exact session routing을 우선한다. breaking/migration/비용/권한 확대는 자동 승인하지 않는다. PowerShell은 local Codex launcher가 아니며, 새 Godot 제품 구현은 필요할 때만 `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF`를 사용한다.

## 12. Concurrency gate

### PR #154

`CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`.

- no unmerged `game/reuse/*` absorption.
- do not reopen without a new approved need and fresh evidence.

### PR #155 / #156

`CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

### PR #174

`PRE_EXISTING_DRAFT · READ_ONLY`.

- r5.4 current-task PR에서 수정·rebase·merge·흡수하지 않는다.
- 별도 명시 승인 없이는 historical r4 workstream으로 유지한다.

## 13. Implementation package authority

Binding historical read order:

```text
SX_DEC_059_CODEX_HANDOFF_PACKAGE.md
→ handoff Amendment 01
→ handoff Amendment 02
→ parent implementation plan
→ implementation Amendment 01
→ implementation Amendment 02
→ actual current code/tests
```

The package is execution history/rollback material. It must not restart Task 1. 과거 local Codex 실행 기록은 history이며 current r5.4 실행 route가 아니다.

## 14. Automated validation gate

The merged PR #158 proved:

- focused first-session tests.
- existing custom Godot suite.
- GUT 9.7.1.
- Project Contract / relevant static policy checks.
- Thin Adapter validation.
- Windows export/package proof.
- first-session JSON/localization/tutorial map inclusion proof.
- no unauthorized change to current core/map/semantic asset owners.
- no unresolved review thread on exact head.

Hosted CI/package proof is not physical runtime or human evidence.

## 15. Candidate 003 physical / developer self-run gate

Current next executable evidence gate begins with Candidate 003 Gate 0, because Candidate 002 found physical P1 presentation defects and Candidate 003 contains corrected bytes.

Gate 0:

1. preflight badge compact lane / Korean copy non-overlap.
2. disconnected station/cargo identity visible / problem reinforcement outline only.

If both PASS, continue on the **same exact Candidate 003**:

1. T1→T6→Capstone happy path.
2. T3 wrong LIFO order → Edit → recovery.
3. T4 overloading → selective non-load recovery.
4. T5 Auto ON safe → OFF before decision cargo.
5. T6 occupied-lock observation + successful route decision.
6. Capstone Retry same layout.
7. Capstone Edit layout.
8. Reduced Motion same-information path.
9. audio perceptual QA.

Must record:

```text
progression dead-end 0
hidden-command bypass 0
raw localization key 0
player-facing placeholder 0
crash/script error 0
unsupported evidence claim 0
```

This gate is developer usability/technical evidence only.

## 16. Physical / human gate

```text
exact acceptance build identity
→ reviewed Windows physical smoke on the same build
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension
```

Minimum analyzable first-contact sessions remains 5. Use `PLAYTEST_PLAN_V4_7_CURRENT.md` + `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`.

Human decision states:

```text
EXPAND
REWORK
REPEAT_SLICE
HOLD
STOP
```

## 17. Production cutover

`BLOCKED_DEFERRED`.

No merge/build/export result automatically authorizes store release.

## Current next action

```text
Candidate 003 physical visual recheck
→ same exact Candidate 003 developer self-run / screen QA + audio perceptual QA
→ designate exact acceptance build when physical validation is prepared
→ Windows full physical smoke
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension on the same build
→ product decision
```

**PR #158 merge와 Notion implementation readback은 완료됐고 Candidate 003 physical/developer/device/human gates remain NOT_RUN.**
