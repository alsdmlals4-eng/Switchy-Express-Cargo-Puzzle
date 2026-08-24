# Switchy Express 프로젝트 허브

Last updated: `2026-08-24 KST`

이 문서는 현재 제품 기준선과 **다음 실행 지점**을 빠르게 찾는 허브다. 실행 전에는 항상 fresh Base completed `main`, fresh project `main`, Open/Draft PR, Notion을 다시 읽는다.

## Current State

| 항목 | 현재 값 |
|---|---|
| 제품 기준선 | `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE` |
| 결정 범위 | `SX-DEC-027~059` |
| 작업지시문 | `v4.8 · revision 2026-08-24-r2 · Switchy thin adapter` |
| 작업지시문 source SHA-256 | `6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508` |
| v4.8 authority merge | `PR #164 · main 98ed1c65d678bfc262c32084bbf0e59368093c2c` |
| User planning-complete gate | `GRANTED · 2026-08-20 KST` |
| SX-DEC-059 implementation | `PR #158 MERGED_MAIN_VERIFIED · main 162e8a0a5e8ddc8472e74a6152e87dc12008e34c` |
| Playable visual/UX POC | `PR #166 MERGED_MAIN_VERIFIED · main 1bf798cedf28dffba9185edb62fb1c50c108fe90` |
| Candidate 002 physical evidence | `SX59-POC-ACCEPT-002 · Windows startup smoke PASS · BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS · acceptance promotion PROHIBITED` |
| Physical P1 correction | `PR #171 MERGED_MAIN_VERIFIED · main 9d82b004b2ebf3f7d69d0376c79daae1040e94a4` |
| Candidate 003 preparation | `PR #172 MERGED_MAIN_VERIFIED · main 2521f3be600ea950f9893ce45940604c2d0ac88a` |
| Current POC candidate | `SX59-POC-ACCEPT-003 · PREPARED · PHYSICAL_VISUAL_RECHECK_FIRST` |
| Current candidate pointer | `evidence/acceptance/current_poc_candidate.json` |
| Candidate 003 package | `ZIP/API + EXE/PCK + PCK 472/472 + product CTEX 73/73 PASS` |
| Candidate 003 PowerShell 5.1 live-download | `PASS` |
| Candidate 003 physical visual recheck | `NOT_RUN` |
| developer self-run | `NOT_RUN` |
| acceptance build | `NOT_YET_DESIGNATED` |
| Windows full physical runtime | `NOT_RUN` |
| audio perceptual QA | `NOT_RUN` |
| ANDROID DEVICE SMOKE | `NOT_RUN` |
| FIVE-PERSON COMPREHENSION | `NOT_RUN` |
| Player experience | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| SX-DEC-056A | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-056B | `BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME` |
| SX-DEC-057 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| SX-DEC-058 | `PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED` |
| semantic product PNG | `73 · PRODUCTION_COMPLETE · PLAYABLE_POC_CONSUMED` |
| PR #154 | `CLOSED_UNMERGED · SUPERSEDED_BY_059` |

## Base authority

```yaml
base_v4_8_authority_time_snapshot: 2828a74f60c1ed09546171040f4178c8848ea686
base_latest_observed: 7a8b1c596f9cf1e8da8d2652be076a0624e0b4a2
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
```

`2828a74...`는 v4.8 protected-canon migration 당시 호환성 증거다. 실제 작업 권위는 항상 `ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN` 정책에 따라 fresh Base completed main을 다시 읽는다.

## Stable acceptance compatibility anchors

```text
SX-DEC-055: MERGED_MAIN_VERIFIED
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

위 literal은 기존 device/human canonical-freshness consumer가 사용하는 안정 locator다.

## One-line product promise

> 노선을 그려 화물 조우 순서를 만들고, 적재 선택으로 LIFO를 설계한 뒤, 운행 중 분기 판단으로 계획을 실행하고 결과를 보고 다시 설계하는 finite cargo puzzle.

## Current first-session flow

```text
T1 · Track Connection
→ T2 · Cargo/Station + basic manual pickup
→ T3 · LIFO/TOP reverse planning
→ T4 · selective non-load + revisit
→ T5 · Auto ON safe / OFF decision
→ T6 · switch execution
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

역사적 endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset는 current product로 되살리지 않는다.

## Physical evidence boundary

`SX59-POC-ACCEPT-002`는 exact package verification 뒤 실제 사용자 Windows 환경에서 Godot 4.7.1/OpenGL Compatibility/NVIDIA GeForce RTX 3050으로 기동했다. 따라서 **Candidate 002 Windows startup smoke는 PASS**다.

그러나 실제 화면에서 다음 P1이 확인됐다.

1. preflight semantic badge가 상단 banner 전체로 늘어나 Korean problem copy와 겹침.
2. problem-cell semantic composition이 station/cargo identity를 가릴 수 있음.

PR #171이 이 두 player-visible presentation defect를 교정했다. 따라서 Candidate 002는 역사 evidence로만 보존하고 acceptance build로 승격하지 않는다.

현재 수정 bytes의 exact validation 대상은 **SX59-POC-ACCEPT-003**이다. 아직 실제 화면에서 수정 결과를 다시 보지 않았으므로 `physical visual recheck: NOT_RUN`이다.

## Mandatory read order

1. fresh Base completed `main` + Base root `AGENTS.md`.
2. fresh Project `main`, latest commit, all Open/Draft PR.
3. exact Switchy Notion Project Home.
4. `AGENTS.md`.
5. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`.
6. `FINITE_DELIVERY_PUZZLE_BASELINE.md`.
7. `CURRENT_CONFIRMED_DECISIONS.md`.
8. `ACTIVE_CONTEXT.md`.
9. `evidence/acceptance/current_poc_candidate.json`.
10. `SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md` + `SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md` for the current manual gate.
11. `SX_AUD_069_PLAYABLE_VISUAL_UX_POC.md` and Candidate 002 evidence when historical comparison is needed.
12. `ROADMAP.md` + `DEVELOPMENT_GATES.md`.
13. actual code/data/Scene/Resource/assets/tests.

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`는 historical rollback/provenance evidence다. Google Sheets는 migration-only다.

## Current execution entry

```powershell
$repo = "C:\Users\user\Documents\GitHub\Ninza\Switchy-Express-Cargo-Puzzle"
git -C $repo switch main
git -C $repo pull --ff-only
powershell -ExecutionPolicy Bypass -File "$repo\RUN_SX59_POC_SELF_RUN.ps1"
```

Launcher는 `evidence/acceptance/current_poc_candidate.json`이 명시한 candidate만 사용한다. Candidate 번호를 하드코딩하거나 newest build를 추정하지 않는다.

## Current next action

```text
SX59-POC-ACCEPT-003 physical visual recheck
→ A. preflight badge compact / Korean copy non-overlap
→ B. disconnected station/cargo identity visible / problem outline only
→ if both PASS: same exact Candidate 003 developer self-run 8 scenarios + audio perceptual QA
→ if blocker 0: designate exact acceptance build
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

`developer self-run`, Candidate 003 full physical runtime, audio perceptual QA, Android device, Five-person comprehension, player experience는 모두 아직 `NOT_RUN`이다. Automated/package/launcher PASS를 이 항목들의 PASS로 승격하지 않는다.
