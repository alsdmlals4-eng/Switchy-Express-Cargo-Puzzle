# Development Gates

Last updated: `2026-08-21 KST`

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 과거 commit/PR/run은 역사 evidence이며 current next action을 자동 정의하지 않는다.

## 1. v4.7 planning / build chain

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

`기획완료`는 승인된 059 계획을 잠근다. A6/A7은 설계·정본·인계 패키지의 정적 준비 상태이며, A8 이후 fresh execution preflight와 RED→GREEN 구현, exact-head 검증, merge/readback까지 완료됐다.

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
→ S12 developer self-run/screen QA: NOT_RUN
→ S13 exact acceptance build physical smoke: NOT_RUN
→ S14 Five-person first-contact comprehension: NOT_RUN
→ S15 product decision: NOT_RUN
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

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
upstream_3_1_4_version_bump_commit: 96cc8b8c3d25ce487e24801d01d5214fea150349
upstream_main_observed_plugin: 3.1.5
upstream_main_observed_commit: 09a1e3311015153d967710fbe6502ac519585a9b
prior_verified_release_basis: v3.1.3
project_3_1_4_exact_tree_parity: REVERIFY_REQUIRED_BEFORE_FUTURE_AUTHORING
local_repo_tree_parity: NOT_RUN
```

향후 authoring은 과거 implementation preflight를 자동 상속하지 않고 다음을 다시 확인한다.

- exact local repo location resolved by Git remote identity.
- clean/dirty state and user changes.
- exact project `HEAD` and `origin/main` relation.
- isolated workspace/worktree status where implementation is requested.
- Godot executable version.
- repo/local Godot AI addon parity/provenance.
- GUT availability.
- project HiGodot profile/ports only if actually consumed.
- project CODEX_HOME current value without silent credential/config replacement.
- Hera only when live QA is applicable; tracked source delta after acceptance must be zero.

## 12. Concurrency gate

### PR #154

`CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`.

- no unmerged `game/reuse/*` absorption.
- do not reopen without a new approved need and fresh evidence.

### PR #155 / #156

`CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

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

The package is execution history/rollback material. It must not restart Task 1.

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

## 15. Developer self-run gate

Current next executable evidence gate. After merged automated GREEN and before first-contact human evidence:

1. T1→T6→Capstone happy path.
2. T3 wrong LIFO order → Edit → recovery.
3. T4 overloading → selective non-load recovery.
4. T5 Auto ON safe → OFF before decision cargo.
5. T6 occupied-lock observation + successful route decision.
6. Capstone Retry same layout.
7. Capstone Edit layout.
8. Reduced Motion same-information path.

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
→ reviewed physical smoke on the same build
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
developer self-run / screen QA
→ designate exact acceptance build when physical validation is prepared
→ Windows physical smoke as applicable
→ Android device smoke as separate platform gate
→ Five-person first-contact comprehension on the same build
→ product decision
```

**PR #158 merge와 Notion implementation readback은 완료됐고 physical/device/human gates remain NOT_RUN.**
