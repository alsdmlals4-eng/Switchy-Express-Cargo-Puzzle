# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 선로를 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, TOP의 연속 동일 화물 하역이 다음 설계를 낳는다.

## Current Authority

```yaml
product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decisions: SX-DEC-027~055
work_instruction: v4.5 r2 · revision 2026-08-11-r2
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-11 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
runtime_semantic_poc: SX-DEC-055 · SPEC/DoR APPROVED · IMPLEMENTATION_NOT_STARTED
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
base_pin: v9.4.3
upstream_base_main: REFERENCE_ONLY
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

승인된 다음 구현은 `SX-DEC-055 Runtime Semantic POC`입니다.

```text
SX-DEC-053/054 approved product manifests
→ presentation-owned SemanticAssetCatalog
→ existing presenter model / render snapshot / existing events
→ HUD + board + route + semantic event presentation
```

Phase B는 기존 exact-file RED-first plan을 재검수했고 current runtime target files에 drift가 없음을 확인했습니다. Phase B에서 발견한 non-resource JSON export P1은 companion readiness amendment로 닫았습니다.

읽을 문서:

- `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

첫 Phase C 구현 단계는 기존 plan의 **Task 1 / Step 1.1 RED**이며, 새 product rule이나 새 semantic meaning을 만들지 않습니다.

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
SX-DEC-055 RUNTIME POC: NOT_STARTED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

기존 Android validation APK와 과거 Windows export는 역사적 packaging/diagnostic evidence이며 post-POC acceptance build를 대신하지 않습니다.

## 정본 읽기 순서

1. `AGENTS.md`
2. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
3. `기획서/00_프로젝트_허브/START_HERE.md`
4. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
8. `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
9. `기획서/50_제작_검증/PLAYTEST_PLAN.md`
10. `SX-DEC-055` decision/spec/plan + Phase B readiness amendment
11. configured Google Sheet current rows

## 기술

- Godot 4.7.1-stable
- GDScript
- Windows / Android landscape
- GitHub 정본 + configured Google Sheet 동기화
