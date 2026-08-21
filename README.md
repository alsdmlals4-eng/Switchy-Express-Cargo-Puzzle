# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 선로를 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, TOP의 연속 동일 화물 하역이 다음 설계를 낳는다.

## Current Authority

```yaml
product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decisions: SX-DEC-027~059
work_instruction: v4.7 · revision 2026-08-20-r1 · SWITCHY_THIN_ADAPTER
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-20 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
runtime_semantic_poc: SX-DEC-055 · IMPLEMENTED · PR_151_MERGED
runtime_integrated: true
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
release_near_first_session: SX-DEC-059 · MERGED_MAIN_VERIFIED
sx_dec_059_codex_handoff: USER_REQUESTED_AND_EXECUTED
SX_DEC_059_IMPLEMENTATION: MERGED_MAIN_VERIFIED
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_notion_post_merge_readback: PASS
sx_dec_059_adversarial_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
base_pin: v9.4.3
upstream_base_main: REFERENCE_ONLY
developer_self_run: NOT_RUN
physical_device_human: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

`GMB-003`의 route-end/switch implementation package와 과거 `SX-AUD-026` 실행 상태는 역사 증거이며 현재 제품 기준선/실행 라우팅이 아닙니다.

## Historical compatibility breadcrumbs

아래 값은 current execution routing이 아니라 과거 자동/merge evidence를 찾기 위한 호환 표식이다. current 상태를 이 값으로 되돌리지 않는다.

```yaml
pr_83: MERGED
historical_canonical_freshness_audit: SX-AUD-025
repository_main_observed: HISTORICAL_SNAPSHOT_ONLY
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
```

## 현재 제품 기준선

- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 철거 전액 환급
- 구조적 도달 가능성 검사 뒤 운행 시작
- 수동 적재 기본·자동 적재 토글
- 무제한 CargoStack
- 운행 중 persistent branch·crossing 직접 전환과 점유 잠금
- SWITCH reciprocal 방향 표시·직접 선택·진입 방향 U턴
- TOP 연속 동일 화물 하역
- 제한 시간 안에 모든 필수 배송 완료
- 배송 완료 전 이동 불가 시 `FAILURE · ROUTE_END`
- 색상+형상+텍스트 중복 정보 채널
- 동일 sealed layout fresh-runtime retry
- BUILD/RUN 중 안전한 메뉴 종료 흐름
- domain authority와 presentation authority 분리

폐기된 endless survival, fuel/fuel-zero, player BOOST, capacity-8, cargo slowdown, pickup respawn, switch auto-reset 규칙은 current product가 아닙니다.

## 현재 구현 지점

`SX-DEC-059`는 기존 finite core를 바꾸지 않는 presentation-sidecar로 구현되어 PR #158로 `main`에 병합됐습니다.

```text
FirstSessionDefinition + StagePolicy + Director + Copy
→ T1/T2 shared runtime
→ T3 LIFO
→ T4 selective revisit fixed scaffold
→ T5 auto/manual fixed scaffold
→ T6 one-switch preset selection + occupied lock
→ unchanged VS_DEMO_01 capstone
→ evidence-safe Result / Retry / Edit
```

상세 구현·5회 적대적 검토·패키지 증거는 `기획서/50_제작_검증/SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md`가 소유합니다.

`SX-DEC-055 Runtime Semantic POC`는 PR #151로 구현되어 main `534a7318b349cd3e784a3467125f9ebd23124d8a`에 병합되었습니다.

```text
SX-DEC-053/054 approved product manifests
→ presentation-owned SemanticAssetCatalog
→ pure semantic runtime-state mapping
→ existing presenter/render snapshot/events
→ HUD + BUILD + route + semantic event presentation
```

실제 merged runtime 변화:

- Stack/manual-auto/preflight semantic HUD reinforcement;
- BUILD valid/invalid/rotate/replacement semantic reinforcement;
- route-control selected/unselected/occupied-locked semantic reinforcement;
- pickup/unload/route/result semantic event feedback;
- Reduced Motion에서 동일 정보 identity 유지;
- 기존 한글 텍스트, controls, touch/hit geometry, gameplay/domain rules, scoring, maps, save authority, product PNG/manifest는 유지.

PR #151 exact head `63b0ed331e043db7d677ca097bdb209003bda4be` 검증:

```text
Project Contract #1242 PASS
GUT 9.7.1 #291 PASS
Godot Tests #1173 PASS
Thin Adapter #369 PASS
Windows Demo Export #241 PASS
custom suite: 97 cases / 0 failed / 11923 assertions
Windows Demo proof PCK: parsed_json=13
Android Validation preset proof PCK: parsed_json=13
review threads: 0
```

읽을 문서:

- `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
- `기획서/50_제작_검증/SX_AUD_054_SX_DEC_055_RUNTIME_POC_POST_MERGE_RECONCILIATION.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

Task 1 / Step 1.1 RED는 완료된 TDD 역사이며 현재 next action이 아닙니다.

## 바로 실행하기

사용자 로컬 확인은 항상 최신 `main`을 받은 뒤 진행합니다.

1. GitHub Desktop에서 저장소와 `main`을 선택합니다.
2. `Fetch origin → Pull origin`을 수행합니다.
3. Godot `4.7.1-stable`에서 저장소 루트의 `project.godot`을 엽니다.
4. 별도 Scene 선택 없이 **Project Play(F5 / ▶)** 를 사용합니다.

기본 진입점:

```text
project.godot
→ res://game/main/main.tscn
→ Title → Briefing → BUILD → RUN → Result
```

### 조작

```text
좌클릭: 설치·선택·분기/교차 전환
우클릭: 선택 취소·선로 철거
1~4: 직선·곡선·분기·교차 도구
R: 회전
Space: 운행 시작·일시정지·재개
Shift: 누르는 동안 수동 적재
A: 자동 적재 전환
Enter: 타이틀·브리핑 확인
Esc: 취소·뒤로
```

## 검증 경계

자동화/패키징 증거와 physical/device/human 증거를 혼동하지 않습니다.

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED
SX-DEC-059 FIRST SESSION: MERGED_MAIN_VERIFIED · PR #158
SX-DEC-059 NOTION READBACK: PASS
POST-059 ACCEPTANCE BUILD: UNASSIGNED
DEVELOPER SELF-RUN / SCREEN QA: NOT_RUN
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

기존 Android validation APK와 과거 Windows export는 역사적 packaging/diagnostic evidence이며 post-059 acceptance build를 대신하지 않습니다.

## 다음 유효 작업

```text
developer self-run / screen QA
→ exact acceptance build identity when physical validation is prepared
→ Windows physical smoke
→ Android device smoke
→ physical Reduced Motion/readability
→ Five-person comprehension on the same build
→ separate production cutover decision
```

`SX-DEC-056A/057/058`은 상세 planning이 닫혔지만 implementation authority가 별도이며, `SX-DEC-056B`와 057 fast/cheap subset은 authoritative runtime dependency를 기다립니다.

## 정본 읽기 순서

1. `AGENTS.md`
2. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`
3. `기획서/00_프로젝트_허브/START_HERE.md`
4. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
8. `기획서/50_제작_검증/SX_DEC_059_RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE.md`
9. `기획서/50_제작_검증/SX_DEC_059_CODEX_HANDOFF_PACKAGE.md`
10. `기획서/50_제작_검증/PLAYTEST_PLAN_V4_7_CURRENT.md`

## 기술

- Godot 4.7.1-stable
- GDScript
- Windows / Android landscape
- Notion 사람용 정본 + GitHub 구조화/런타임 정본
- Google Sheets는 migration-only이며 신규 작업 입력으로 사용하지 않음
