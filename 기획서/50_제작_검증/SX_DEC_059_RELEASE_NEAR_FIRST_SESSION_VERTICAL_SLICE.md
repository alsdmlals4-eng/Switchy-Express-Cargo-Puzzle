# SX-DEC-059 · Release-Near First-Session Vertical Slice

```yaml
decision_id: SX-DEC-059
status: IMPLEMENTED_AUTOMATED · FIVE_PASS_REVIEW_CLOSED
planning_complete_date: 2026-08-20 KST
approval_reference:
  - "권장안 승인,연속작업 진행해"
  - "GM-SX059-01 권장안 승인"
  - "기획완료"
product_baseline: GMB-002
work_instruction: v4.7 · 2026-08-20-r1
pr_154: "AUDITED · SUPERSEDED_UNMERGED_BY_059"
implementation_scope: APPROVED_CANON
codex_handoff: USER_REQUESTED_AND_EXECUTED
build_state: RELEASE_NEAR_VERTICAL_SLICE_AUTOMATED_GREEN
human_evidence: NOT_RUN
```

## 결정

새 기능 확장을 먼저 쌓지 않는다. 이미 구현된 finite delivery core와 `SX-DEC-055` semantic runtime을 바탕으로 **처음 보는 플레이어가 `선로 계획 → 적재 순서 → LIFO → 적재 모드 → 분기 실행 → 결과 해석 → 재설계`를 한 세션에서 이해·전이할 수 있는 release-near Vertical Slice**를 우선 제작한다.

## First-session flow

```text
T1 · Track Connection
→ T2 · Cargo/Station + basic manual pickup prerequisite
→ T3 · LIFO/TOP reverse planning
→ T4 · selective manual non-load + revisit
→ T5 · Auto ON safe segment / OFF decision segment
→ T6 · switch execution
→ existing VS_DEMO_01 · Capstone
→ Result / Retry / Edit
```

현재 승인된 Tutorial 1~10 순서는 보호한다. 059는 첫 Slice에서 T1~T6만 production candidate로 연결하고 T7~T10은 후속 범위다.

## Player promise

> 내가 만든 선로와 적재 선택이 화물 스택 순서를 만들고, 그 순서를 읽어 분기와 배송을 해결한다.

의도 감정:

```text
T1: 연결했다
T2: 실어서 보냈다
T3: 거꾸로 생각했다
T4: 안 싣는 것도 선택했다
T5: 자동을 켜고 끄며 계획했다
T6: 운행 중 계획을 실행했다
Capstone: 새 설명 없이 종합했다
```

## GM-SX059-01 · APPROVED

`A · PREREQUISITE_ACTION_EARLY · STRATEGY_LATER`

- T2에서 manual pickup의 **기본 조작**을 just-in-time으로 소개한다.
- T4에서 같은 조작을 다시 설명하는 대신 **일부러 적재하지 않는 전략**을 가르친다.
- manual-load default=false, auto-load default=false는 변경하지 않는다.
- tutorial-only auto assist / preloaded stack / curriculum reorder는 채택하지 않는다.

## Content contract

```yaml
new_tutorial_map_target: 5
MAP_01: T1+T2_SHARED
MAP_02: T3_LIFO
MAP_03: T4_SELECTIVE_MANUAL
MAP_04: T5_AUTO_MODE
MAP_05: T6_SWITCH
capstone: VS_DEMO_01_REUSE
map_schema: FiniteMapDefinition_v2_UNCHANGED
exact_map_bytes: BUILD_TIME_RED_FIRST_OUTPUT
```

T1/T2는 같은 map + valid layout을 공유한다. T1은 preflight PASS에서 종료되고 T2가 그 layout을 그대로 RUN한다.

## Architecture contract

```text
FirstSessionDefinition
+ FirstSessionStagePolicy
+ FirstSessionDirector
+ FirstSessionCopy
        ↓ presentation/onboarding only
ProductFiniteSlice
        ↓
FiniteSliceSessionController / current finite domain
```

- Tutorial metadata는 `FiniteMapDefinition`에 넣지 않는다.
- StagePolicy는 UI visibility와 keyboard/touch/board/route-control command 허용을 함께 관리한다.
- `ProductFiniteSlice`가 command convergence boundary다.
- standalone `vertical_slice_demo.tscn`은 first-session opt-in=false로 기존 동작을 유지한다.
- `game/main/main.tscn`의 product instance만 first-session opt-in을 켜는 구현이 우선안이다.

## Failure / Result contract

059는 **current runtime이 실제 증명하는 정보만** 사용한다.

Current allowed baseline:

```text
outcome
failure_reason: ROUTE_END | TIME_EXPIRED
remaining_map_cargo
stack_size
completion/time/cost existing facts
```

예:

```text
ROUTE_END · 노선이 끝났습니다.
맵에 남은 화물: 1
열차에 실린 화물: 2
```

금지:
- `B역에서 TOP=A라서 실패`처럼 current summary가 직접 증명하지 않는 문장.
- replay/encounter trace 재구성 추측.
- 정답 노선/추천 switch sequence/최적 적재 순서.
- 059 명목의 056A Route Probe/PB/Fingerprint/observation 선구현.

Future 056A가 별도 권한으로 observational event를 구현하면 같은 Result consumer를 확장할 수 있다.

## Visual / UI contract

- E+D Hybrid · Neo-Arcade Readability 유지.
- current 73 semantic product PNGs를 우선 재사용한다.
- cargo/station = color + shape + text.
- TOP = position + semantic identity + text.
- switch = direction + selected/occupied-lock state.
- Reduced Motion에서도 same information.
- event VFX가 next critical cargo/switch target을 가리지 않는다.
- 별도 이미지 생성은 사용자 명시 요청 전 수행하지 않는다.

## Localization contract

```yaml
source: ko
first_slice_locales: [ko, en, ja, zh-Hans]
zh_Hant: DEFER_UNTIL_RELEASE_TARGET_REQUIRES
text_in_png: FORBIDDEN
raw_key_player_facing: FORBIDDEN
```

Approved copy owner: `FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md`.

## Timing · TEST_VALUE

```yaml
T1: 45~60s
T2: 45~60s
T3: 60~90s
T4: 60~90s
T5: 60~90s
T6: 75~105s
capstone_first_attempt: 180~240s
recommended_total: 8~12m
soft_range: 7~15m
warning: ">15m before first capstone result"
```

시간은 단독 PASS 기준이 아니다. 이해 가능한 고민과 자발적 재설계가 더 중요하다.

## Player evidence contract

`PLAYTEST_PLAN_V4_7_CURRENT.md` + `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`를 사용한다.

```text
AUTOMATED CONTRACT
→ developer self-run / screen QA
→ exact acceptance build + reviewed physical smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

자동화·export·developer self-run으로 재미/이해 PASS를 주장하지 않는다.

## Explicit exclusions

- full SX-DEC-056A Route Probe / trace / PB / Fingerprint.
- SX-DEC-056B score/max-combo.
- SX-DEC-057 Yard Lab/Mastery.
- SX-DEC-058 Daily/Weekly generator/publication pipeline.
- shareable Route Card.
- editor/UGC/backend/leaderboard.
- endless/fuel/BOOST/capacity-8/cargo slowdown/pickup respawn/switch auto-reset.
- Base repin.
- PR #154 unmerged delta absorption.

## Pre-build operational evidence

### v4.7

Project current adapter:

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`

v4.5 r2 remains historical/rollback evidence, not current authority.

### Godot AI

```yaml
project_plugin_cfg: 3.1.4
prior_verified_release_basis: v3.1.3
upstream_main_observed: 3.1.5 @ 09a1e3311015153d967710fbe6502ac519585a9b
project_3_1_4_exact_provenance: REVERIFY_REQUIRED_BEFORE_BUILD
```

Do not invent an official v3.1.4 provenance. Fresh PowerShell must verify local/repo tree parity before persistent authoring.

## Implementation package

- `docs/superpowers/plans/2026-08-20-sx-dec-059-first-session-vertical-slice-implementation.md`
- `기획서/50_제작_검증/SX_DEC_059_CODEX_HANDOFF_PACKAGE.md`

The package is RED-first and protects current domain authority.

## Current Gate

```text
USER PLANNING COMPLETE: GRANTED
PHASE-C FINAL REVIEW: FINALIZING
IMPLEMENTATION PACKAGE: WRITTEN
CODEX HANDOFF REQUEST: NOT PRESENT
BUILD: IMPLEMENTED_AUTOMATED
HUMAN EVIDENCE: NOT_RUN
```

Actual Codex execution begins only after `USER_REQUESTED_CODEX_HANDOFF` and fresh location/worktree/tooling/baseline preflight.
