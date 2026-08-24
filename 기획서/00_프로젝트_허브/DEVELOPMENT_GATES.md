# Development Gates

Last updated: `2026-08-25 KST`

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 과거 commit/PR/run은 역사 evidence이며 current next action을 자동 정의하지 않는다.

## 0. Current authority

```yaml
current_work_instruction: v4.8 · 2026-08-24-r4 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
historical_v48_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
v4_8_r2_authority_merge_pr: 164
v4_8_r2_authority_merge_main: 98ed1c65d678bfc262c32084bbf0e59368093c2c
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
current_candidate: SX59-POC-ACCEPT-003
```

이 authority 전환은 기획·런타임 범위를 넓히지 않는다. `GMB-002`, `SX-DEC-059` 구현 상태, `SX-DEC-056~058` 권한 경계와 physical/human evidence ceiling은 그대로 유지한다.

## 1. Historical planning / build chain

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
→ A15 PLAYABLE VISUAL/UX POC PR #166: MERGED_MAIN_VERIFIED
→ A16 CANDIDATE 002 WINDOWS STARTUP: PASS / ACCEPTANCE_BLOCKED_BY_P1_VISUAL
→ A17 P1 PRESENTATION CORRECTION PR #171: MERGED
→ A18 CANDIDATE 003 PREPARATION/POINTER/CANON PR #172/#173: MERGED
```

A0~A18은 완료된 history/evidence다. 현재 작업 방법론은 v4.8 r4 + latest Base owner를 따른다.

## 2. Stable implemented baseline chain

```text
GMB-002 finite core: AUTOMATED PASS
→ PC finite vertical-slice pipeline: IMPLEMENTED / HISTORICAL
→ SX-DEC-053/054 semantic assets: 73 PRODUCT PNG · COMPLETE
→ SX-DEC-055 runtime semantic: PR #151 MERGED_MAIN_VERIFIED
→ SX-DEC-059 first session: PR #158 MERGED_MAIN_VERIFIED
→ playable visual/UX POC: PR #166 MERGED_MAIN_VERIFIED
```

Stable historical merge compatibility locator:

```text
PR #83/#99/#100 MERGE: PASS
```

이 literal은 과거 PC Vertical Slice와 후속 정본 병합 완료 사실을 참조하는 post-merge freshness consumer용 anchor다.

## 3. Stable device / acceptance evidence anchors

```text
HISTORICAL CANONICAL APK EXPORT: PASS · HISTORICAL PACKAGE EVIDENCE
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

- Historical APK/export는 packaging/history evidence다.
- Android device smoke는 독립 platform gate다.
- Five-person comprehension은 같은 exact acceptance build의 별도 human gate다.
- automated/package/self-run 결과로 위 항목을 PASS로 올리지 않는다.

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
→ S11D playable visual/UX POC: PR #166 MERGED
→ S11E Candidate 002 physical startup: PASS / P1 BLOCKED
→ S11F Candidate 003 corrected package/current pointer: PASS
→ S12 Candidate 003 Gate 0 physical visual recheck: NOT_RUN
→ S13 same Candidate 003 developer self-run/screen QA + audio perceptual QA: NOT_RUN
→ S14 exact acceptance build + Windows physical smoke: NOT_RUN
→ S15 Android device smoke: NOT_RUN
→ S16 Five-person first-contact comprehension: NOT_RUN
→ S17 product decision: NOT_RUN
```

## 5. Implemented BUILD task families

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

모든 production behavior task는 `RED → expected failure → minimal GREEN → focused regression → full regression → commit` 순서를 따랐다.

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
- text-in-PNG forbidden.
- raw localization key player-facing fallback forbidden.
- CJK glyph/line-break/long string checks are automated; physical readability remains separate.
- same pixel layout is not required; same information/action/state meaning is required.

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

059 Result may use these facts. It may not fabricate station mismatch/actual trace causality. Detailed station mismatch is a future 056A observation concern and is outside 059.

## 10. Visual / audio gate

- existing 73 E+D Hybrid / Neo-Arcade semantic product assets first.
- existing `DemoEffects`, audio, SemanticEventOverlay first.
- no new image generation is currently required or authorized.
- Reduced Motion uses same information identity.
- VFX must not cover next critical cargo/switch target.
- package/audio-file presence is not `audio perceptual QA`.

## 11. Tooling / fresh execution preflight gate · r4

```yaml
project_engine: 4.7.1-stable
gut: 9.7.1
shared_host_godot_policy: ONE_APPROVED_COMPATIBLE_EXACT_PIN
shared_host_godot_ai_policy: ONE_APPROVED_EXACT_PIN
preferred_http_port: 8000
preferred_ws_port: 9500
session_isolation: EXACT_PROJECT_PATH_EDITOR_AND_SESSION_ID
update_policy: OFFICIAL_UPSTREAM_REVIEW_CANARY_ROLLBACK_THEN_EXACT_PIN
floating_latest: FORBIDDEN
```

향후 authoring/runtime은 과거 implementation preflight를 자동 상속하지 않고 exact local repo location, dirty/diverged state, fetch/safe reconciliation, official update state, compatible exact pin, Editor/project/session identity를 다시 확인한다.

문서/Notion-only 변경에서 Godot Editor/runtime은 acceptance에 필요하지 않으므로 `NOT_APPLICABLE`; 이를 실행했다고 과장하지 않는다.

## 12. Concurrency gate

- PR #154: `CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059`.
- PR #155/#156: `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`.
- unrelated open PR은 read-only.
- 하나의 current-task PR만 current continuation 예외로 exact-head 검증 뒤 merge한다.

## 13. Automated validation gate

기존 merged implementation은 Project Contract, GUT 9.7.1, Godot Tests, Thin Adapter, Windows export/package proof를 통과했다. 이 증거는 current docs-only r4 authority package의 exact-head checks를 대신하지 않으며, current package는 실제 변경 분류에 맞는 workflow를 다시 읽고 검증한다.

Hosted CI/package proof는 physical runtime 또는 human evidence가 아니다.

## 14. Candidate 003 Gate 0 · current blocking gate

```text
A. physical visual recheck
   preflight badge compact + Korean problem copy non-overlap
B. physical visual recheck
   disconnected station/cargo color+shape+text identity visible + problem reinforcement outline only
```

A/B 중 하나라도 실패하면 `BLOCKED_P1_VISUAL`로 중단한다. 둘 다 PASS일 때만 same exact Candidate 003 self-run/audio로 이어간다.

## 15. Developer self-run / audio gate

Gate 0 PASS 뒤 same exact Candidate 003으로:

1. T1→T6→Capstone happy path.
2. T3 wrong LIFO order → Edit → recovery.
3. T4 overloading → selective non-load recovery.
4. T5 Auto ON safe → OFF before decision cargo.
5. T6 occupied-lock observation + successful route decision.
6. Capstone Retry same layout.
7. Capstone Edit layout.
8. Reduced Motion same-information path.
9. 실제 audio cue의 timing/priority/readability를 별도 perceptual QA로 관찰.

Must record:

```text
progression dead-end 0
hidden-command bypass 0
raw localization key 0
player-facing placeholder 0
crash/script error 0
unsupported evidence claim 0
```

This gate is developer usability/technical/audio-perception evidence, not first-contact human/player evidence.

## 16. Physical / human gate

```text
Candidate 003 Gate 0 physical visual recheck
→ developer self-run / screen QA
→ audio perceptual QA
→ exact acceptance build identity
→ Windows full physical smoke
→ Android device smoke
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
SX59-POC-ACCEPT-003 · Candidate 003 Gate 0 · physical visual recheck
→ developer self-run / screen QA
→ audio perceptual QA
→ exact acceptance build designation
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

**PR #158/#166 implementation/visual merge와 Candidate 003 package preparation은 완료됐고 Candidate 003 physical/device/human gates remain NOT_RUN.**
