# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 필요한 선로망을 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 배송하는 가로형 물류 퍼즐입니다.

> 선로가 적재 순서를 만들고, LIFO가 하역 순서를 만들며, 운행 중 분기와 역 인접 배송이 계획을 실제 실행으로 바꾼다.

## Current Authority

```yaml
product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE · AMENDED_BY_SX_DEC_060
current_decisions: SX-DEC-027~060
current_product_decision: SX-DEC-060
work_instruction: v4.8 · revision 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
source_r5_4_sha256: fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0
historical_r4_revision: 2026-08-24-r4
historical_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
google_sheets: RETIRED_NO_ACTIVE_USE
sx_dec_060_user_rule: APPROVED
sx_dec_060_design_tdd_handoff: PREPARED
sx_dec_060_runtime: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
post_sx_dec_060_candidate: NOT_CREATED · minimum source main a8eee4f875a95e8da69802c4e60452df3535fe0e
sx60_poc_accept_001: HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003 · HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY
windows_physical_post_060: HISTORICAL_AUTOMATION_OBSERVED_INITIAL_TITLE_AND_BUILD_ENTRY · CURRENT_EXACT_CANDIDATE_NOT_RUN
android_device_post_060: NOT_RUN
five_person_post_060: NOT_RUN
player_experience_post_060: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

Historical compatibility anchors retained for earlier evidence readers:

```text
SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED
SX-DEC-059 FIRST SESSION: MERGED_MAIN_VERIFIED · PRE-SX-DEC-060
SX-AUD-047: PASS · HISTORICAL PLANNING REVIEW
ANDROID DEVICE SMOKE: NOT_RUN
```

## SX-DEC-060 · 현재 핵심 변경

사용자 승인 규칙:

```text
station service iff abs(train_x - station_x) + abs(train_y - station_y) == 1
→ 상·하·좌·우 정확히 1칸
→ 대각선 제외
→ 역 footprint 자체는 배송 접촉이 아님
```

Cargo는 기존처럼 **화물 셀을 직접 통과**할 때 Manual/Auto 규칙으로 적재합니다. Unlimited LIFO와 matching station에서의 contiguous TOP-group 하역 의미는 유지합니다.

Preflight도 전역 선로 연결 검사가 아니라 **start-reachable RUN component**를 기준으로 합니다.

- 모든 필수 cargo가 reachable이어야 합니다.
- 각 필수 station마다 상·하·좌·우 서비스 셀 중 최소 하나가 reachable이어야 합니다.
- start에서 완전히 도달할 수 없고 필수 cargo/station service에 쓰이지 않는 disconnected rail island는 그 자체로 RUN을 막지 않습니다.
- 실제 RUN에서 도달 가능한 잘못된 switch/crossing/trap은 계속 fail-closed입니다.

구현 기본값은 `FiniteMapDefinition schema v3`이며 station은 **off-track / non-buildable service object**로 분리합니다. 현재 v2 map bytes를 조용히 다른 의미로 재해석하지 않습니다.

## 현재 핵심 재미

```text
화물·역 배치 읽기
→ 필요한 RUN 선로망으로 화물 조우 순서 설계
→ Manual / Auto 적재로 unlimited LIFO 구성
→ 운행 중 persistent switch 실행
→ 역의 상·하·좌·우 인접 셀을 지나며 TOP 그룹 배송
→ Result를 읽고 Retry Same Layout 또는 Edit Layout
```

모든 배치 선로를 하나의 전역 connected network로 만드는 것은 제품 목표가 아닙니다. 길 만들기는 **화물 조우 순서와 재방문/분기 계획을 만드는 수단**입니다.

## First Session

현재 학습 흐름은 단계 수를 늘리지 않습니다.

```text
T1 · Track Connection
→ T2 · Cargo direct contact + Station cardinal-adjacent delivery
→ T3 · LIFO/TOP reverse planning
→ T4 · selective non-load + revisit
→ T5 · Auto ON safe / OFF decision
→ T6 · switch execution
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

T2가 현재 규칙을 명확히 가르칩니다.

```text
Cargo: 화물 칸을 직접 통과해서 적재
Station: 역의 상·하·좌·우 1칸을 통과해서 배송
Diagonal: 배송 안 됨
```

## 실제 이미지 소비처 원칙

Production 이미지 작업은 설명용 시트가 아니라 **실제 game consumer**를 먼저 증명해야 합니다.

현재 `ProductBoardRenderer`는 이미 승인 station PNG를 실제로 소비합니다.

```text
art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png
```

따라서 SX-DEC-060은 기존 station PNG를 재사용하고 service range를 procedural board indicator로 먼저 표현합니다.

```yaml
sx_dec_060_new_bitmap_assets: 0
consumer_first_image_policy: REQUIRED
explanation_sheet_without_runtime_consumer: OUT_OF_SCOPE
```

## Candidate / Evidence Boundary

`SX59-POC-ACCEPT-003`은 pre-SX-DEC-060 exact bytes에 대한 **historical evidence**입니다.

```yaml
candidate_003_package_integrity: PASS · HISTORICAL
candidate_003_pck_integrity: PASS · 472/472 · HISTORICAL
candidate_003_product_textures: PASS · 73/73 · HISTORICAL
candidate_003_physical_visual_recheck: NOT_RUN
```

SX-DEC-060이 gameplay/data semantics를 바꾸므로 Candidate 003을 post-060 acceptance로 승격하지 않습니다. post-060 runtime 구현·자동 검증·패키징 뒤 새 exact candidate가 필요합니다.

## Current Implementation Package

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
```

Actual GDScript/Scene/Resource/map/runtime implementation is merged-main verified by PR #188; the package/human evidence gates remain separate.

## Current Next Work

```text
→ mint a new exact post-route-readability package candidate (minimum main a8eee4f875a95e8da69802c4e60452df3535fe0e)
→ Windows physical smoke + audio perceptual QA
→ Android device smoke
→ Five-person comprehension
→ product decision
```

`SX-DEC-056A/057/058` implementation remains unauthorized/blocked. Draft PR #174 remains `READ_ONLY`.

## 바로 실행하기

현재 main의 실제 제품 진입점:

```text
project.godot
→ res://game/main/main.tscn
→ Title → Briefing → BUILD → RUN → Result
```

기본 조작:

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

SX-DEC-060 runtime은 schema v3/cardinal service/start-reachable preflight로 구현되어 PR #188로 병합됐고, headless regression 111 cases / 13,461 assertions와 exact-head CI 7개가 통과했습니다. 이는 자동 검증 증거이며 실제 Windows/Android/사람 검증이나 post-060 package candidate를 뜻하지 않습니다.
