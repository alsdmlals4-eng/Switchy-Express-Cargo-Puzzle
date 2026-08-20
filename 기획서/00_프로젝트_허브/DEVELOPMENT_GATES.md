# Development Gates

Last updated: `2026-08-20 KST`

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 과거 commit/PR/run은 역사 evidence이며 current next action을 자동 정의하지 않는다.

## 1. v4.7 planning / build chain

```text
A0 CURRENT AUTHORITY RECOVERY: PASS
→ A1 SX-DEC-059 DIRECTION: USER_APPROVED
→ A2 GM-SX059-01 A: USER_APPROVED
→ A3 DETAIL PLAN / VISUAL BRIEF / PLAYTEST DELTA: PASS
→ A4 POST-APPROVAL ADVERSARIAL CLEAN REVIEW: PASS · SX-AUD-063
→ A5 explicit user "기획완료": GRANTED · 2026-08-20 KST
→ A6 FRESH PHASE-C REVIEW + CANON/NOTION RECONCILIATION: IN_PROGRESS
→ A7 IMPLEMENTATION PACKAGE DoR: IN_PROGRESS
→ A8 USER_REQUESTED_CODEX_HANDOFF: NOT_REQUESTED
→ A9 FRESH POWERSHELL/CODEX BUILD: NOT_STARTED
```

`기획완료`는 승인된 059 계획을 잠그는 Gate다. 실제 Codex 실행은 package DoR + `USER_REQUESTED_CODEX_HANDOFF` 뒤에만 시작한다.

## 2. Historical implemented baseline chain

```text
GMB-002 finite core: AUTOMATED PASS
→ PC finite vertical-slice pipeline: IMPLEMENTED / HISTORICAL
→ SX-DEC-053/054 semantic assets: 73 PRODUCT PNG · COMPLETE
→ SX-DEC-055 runtime semantic: PR #151 MERGED_MAIN_VERIFIED
```

SX-DEC-055는 이미 끝났으므로 과거 `SemanticAssetCatalog RED`를 current next action으로 되살리지 않는다.

## 3. SX-DEC-059 release-near first-session chain

```text
S0 PLAN: COMPLETE
→ S1 T1/T2 shared-map contract: PLAN PASS
→ S2 T3 LIFO content contract: PLAN PASS
→ S3 T4 selective manual content contract: PLAN PASS
→ S4 T5 auto-mode content contract: PLAN PASS
→ S5 T6 switch content contract: PLAN PASS
→ S6 VS_DEMO_01 capstone contract: PLAN PASS
→ S7 FirstSessionDirector/StagePolicy ownership: PLAN PASS
→ S8 localization/responsive/visual reuse contract: PLAN PASS
→ S9 playtest/evidence contract: PLAN PASS
→ S10 implementation RED-first package: PREPARING
→ S11 Codex/Godot implementation: NOT_STARTED
→ S12 developer self-run/screen QA: NOT_RUN
→ S13 exact acceptance build physical smoke: NOT_RUN
→ S14 Five-person first-contact comprehension: NOT_RUN
→ S15 product decision: NOT_RUN
```

## 4. Planned BUILD task families

Actual production code may start only after S10 DoR + A8 handoff trigger.

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
B10 evidence-safe Result debrief
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

순서를 따른다.

## 5. Content gate

### Map policy

- New tutorial map target = 5.
- `FiniteMapDefinition` schema v2 reuse.
- tutorial metadata is sidecar, not map schema.
- map coordinates/JSON are BUILD outputs and require deterministic success witness tests.
- no player-facing witness/solver.
- `VS_DEMO_01` bytes/semantic are immutable by default.

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

## 6. UI / input gate

`FirstSessionStagePolicy` must gate **both presentation and command path**.

```text
HUD button
keyboard shortcut
future touch input
→ same allowed-command policy
→ current ProductFiniteSlice dispatch
→ current finite domain authority
```

Hidden system must not remain usable through shortcut bypass.

## 7. Localization / responsive gate

Minimum planned languages:

```text
ko
en
ja
zh-*   # exact Hans/Hant target to lock before resource authoring
```

- copy key/data separation.
- text-in-PNG forbidden.
- CJK glyph/line-break/long string checks.

Responsive meaning targets:

```text
1280×720
1600×900
1920×1080
pc_wide_or_ultrawide semantic check
mobile_landscape semantic check
```

Same pixel layout is not required; same information/action/state meaning is required.

## 8. Result evidence gate

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

## 9. Visual / audio gate

- existing 73 E+D Hybrid / Neo-Arcade semantic product assets first.
- existing `DemoEffects`, audio, SemanticEventOverlay first.
- no new image generation is currently required or authorized.
- Reduced Motion uses same information identity.
- VFX must not cover next critical cargo/switch target.

## 10. Tooling pre-build gate

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
upstream_main_observed_plugin: 3.1.5
upstream_main_observed_commit: 09a1e3311015153d967710fbe6502ac519585a9b
prior_verified_release_basis: v3.1.3
project_3_1_4_provenance: REVERIFY_REQUIRED
local_repo_tree_parity: NOT_RUN
```

Fresh PowerShell에서 다음을 확인하기 전 persistent authoring을 시작하지 않는다.

- exact local repo location.
- clean/dirty state and user changes.
- exact project `HEAD` and `origin/main` relation.
- Godot executable version.
- repo/local Godot AI addon parity/provenance.
- GUT availability.
- project HiGodot profile/ports if actually consumed.
- project CODEX_HOME if configured.
- Hera only when live QA is applicable; source delta must remain zero.

## 11. Concurrency gate

### PR #154

`READ_ONLY` for SX-DEC-059.

- no modify/rebase/update/close/merge.
- no unmerged `game/reuse/*` absorption.
- if it completes later, new `main` may be reevaluated.

### PR #155 / #156

`CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.

## 12. Automated validation gate

Minimum required before an implementation PR can be called review-ready:

- new focused first-session tests.
- existing custom Godot suite.
- GUT 9.7.1.
- Project Contract / relevant static policy check.
- Thin Adapter validation.
- Windows export/package proof when applicable.
- no unauthorized change to current core/map/semantic asset owners.
- no unresolved review thread on exact head.

Hosted CI/package proof is not physical runtime or human evidence.

## 13. Developer self-run gate

After automated GREEN and before first-contact human evidence:

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

## 14. Physical / human gate

```text
exact acceptance build identity
→ reviewed physical smoke on the same build
→ Five-person first-contact comprehension
```

Minimum analyzable first-contact sessions remains 5. Use `PLAYTEST_PLAN.md` + `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`.

Human decision states:

```text
EXPAND
REWORK
REPEAT_SLICE
HOLD
STOP
```

## 15. Production cutover

`BLOCKED_DEFERRED`.

No merge/build/export result automatically authorizes store release.

## Current next action

```text
complete A6 fresh Phase-C review + canon/Notion sync
→ close A7 implementation package DoR
→ wait for A8 USER_REQUESTED_CODEX_HANDOFF
```

**BUILD is not running.**
