# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 플레이어가 선로를 건설해 화물을 만나는 순서를 설계하고, 마지막에 실은 화물부터 내리는 LIFO 규칙을 역산해 제한 시간 안에 모든 배송을 끝내는 가로형 물류 퍼즐입니다.

## 핵심 재미

> 선로가 적재 순서를 만들고, LIFO가 역 방문 순서를 만들며, 운행 중 스위치 판단과 결과 피드백이 다음 설계를 낳는다.

## Current Authority

```yaml
product_baseline: GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE
current_decisions: SX-DEC-027~059
work_instruction: v4.8 · revision 2026-08-24-r4 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
historical_v48_r2_source_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · 2026-08-20 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
runtime_semantic_poc: SX-DEC-055 · IMPLEMENTED · PR_151_MERGED
runtime_integrated: true
sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
release_near_first_session: SX-DEC-059 · MERGED_MAIN_VERIFIED
sx_dec_059_merge_pr: 158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_notion_post_merge_readback: PASS
sx_dec_059_adversarial_review: FIVE_PASS_AND_INDEPENDENT_REVIEW_CLOSED
playable_visual_ux_poc: PR_166_MERGED_MAIN_VERIFIED
current_candidate: SX59-POC-ACCEPT-003
candidate_003_package_integrity: PASS
candidate_003_physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
audio_perceptual_qa: NOT_RUN
windows_full_physical_runtime: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
base_compatibility_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_runtime_authority: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
google_sheets: COMPATIBILITY_ONLY_MIGRATION_SOURCE
production_cutover: BLOCKED_DEFERRED
```

## Historical compatibility breadcrumbs

아래 값은 current execution routing이 아니라 과거 자동/merge/physical evidence를 찾기 위한 호환 표식이다. current 상태를 이 값으로 되돌리지 않는다.

```yaml
v4_8_r2: HISTORICAL_INITIAL_ADOPTION
v4_7_adapter: HISTORICAL_ROLLBACK_EVIDENCE
pr_83: MERGED
historical_canonical_freshness_audit: SX-AUD-025
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
candidate_002: SX59-POC-ACCEPT-002 · HISTORICAL_PHYSICAL_EVIDENCE
candidate_002_windows_startup: PASS
candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
candidate_002_acceptance_promotion: PROHIBITED
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

Playable Visual/UX POC는 PR #166에서 기존 승인 E+D Hybrid 자산을 Board/HUD/Title/Lesson/Result에 실제 연결했습니다. 새 gameplay system이나 새 생성 이미지는 추가하지 않았습니다.

Candidate 002를 실제 Windows에서 실행한 뒤 preflight badge/copy overlap과 problem-cell marker obscuration 위험이라는 P1 2건이 확인됐고 PR #171에서 교정했습니다. 수정 bytes를 가진 **SX59-POC-ACCEPT-003**이 현재 검증 대상입니다.

## 지금 플레이어가 겪는 전체 흐름

```text
Title / Briefing
→ BUILD · 선로 설계
→ Preflight · 구조 확인
→ RUN · 자동 운행
→ Pickup 선택 · LIFO/TOP 구성
→ Switch 판단 · 계획 실행
→ Delivery / Terminal
→ Result
→ Retry Same Layout 또는 Edit
```

핵심 사고 루프는 다음입니다.

```text
Plan
→ Commit
→ Observe
→ Diagnose
→ Re-design
```

첫 세션은 이 사고를 T1→T6→Capstone으로 한 단계씩 학습시킵니다.

## 바로 실행하기 · 현재 Candidate 003

사용자 로컬 확인은 항상 최신 `main`을 받은 뒤 current pointer를 사용합니다. Candidate 번호나 newest build를 추정하지 않습니다.

```powershell
$repo = "C:\Users\user\Documents\GitHub\Ninza\Switchy-Express-Cargo-Puzzle"
git -C $repo switch main
git -C $repo pull --ff-only
powershell -ExecutionPolicy Bypass -File "$repo\RUN_SX59_POC_SELF_RUN.ps1"
```

`RUN_SX59_POC_SELF_RUN.ps1`는 `evidence/acceptance/current_poc_candidate.json`이 지정한 exact candidate를 검증한 뒤 실행합니다.

### Candidate 003 Gate 0

1. **physical visual recheck A** — preflight badge가 compact lane에 있고 Korean problem copy와 겹치지 않는가.
2. **physical visual recheck B** — disconnected station/cargo의 color+shape+text identity가 보이고 problem reinforcement는 outline뿐인가.

하나라도 실패하면 `BLOCKED_P1_VISUAL`이며 이후 scenario를 진행하지 않습니다. 둘 다 PASS일 때만 같은 exact Candidate 003으로 이어갑니다.

```text
Candidate 003 Gate 0 · physical visual recheck
→ developer self-run / screen QA · 8 scenarios
→ audio perceptual QA
→ exact acceptance build designation
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

## 조작

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
PLAYABLE VISUAL/UX POC: MERGED_MAIN_VERIFIED · PR #166
CANDIDATE 002 WINDOWS STARTUP: PASS · HISTORICAL · ACCEPTANCE_BLOCKED
CURRENT CANDIDATE: SX59-POC-ACCEPT-003
CANDIDATE 003 PACKAGE/PCK/TEXTURE/POINTER: PASS
CANDIDATE 003 PHYSICAL VISUAL RECHECK: NOT_RUN
DEVELOPER SELF-RUN / SCREEN QA: NOT_RUN
AUDIO PERCEPTUAL QA: NOT_RUN
EXACT ACCEPTANCE BUILD: UNASSIGNED
WINDOWS FULL PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

기존 Android validation APK와 과거 Windows export는 역사적 packaging/diagnostic evidence이며 current Candidate 003의 physical/human evidence를 대신하지 않습니다.

## 정본 읽기 순서

1. latest Base completed `main` + Base root `AGENTS.md`
2. `AGENTS.md`
3. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
4. `기획서/00_프로젝트_허브/START_HERE.md`
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
6. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
7. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
8. `evidence/acceptance/current_poc_candidate.json`
9. `기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md`
10. `기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`
11. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md` + `ROADMAP.md`
12. `기획서/50_제작_검증/PLAYTEST_PLAN_V4_7_CURRENT.md` · compatibility filename only

## 기술 / 작업공간

- Project engine canon: Godot 4.7.1-stable
- GDScript
- Windows / Android landscape validation targets
- Notion 사람용 정본 + GitHub 구조화/런타임 정본
- Google Sheets는 migration-only이며 신규 작업 입력으로 사용하지 않음
- r4 host policy는 프로젝트별 동일 Godot binary/port를 기본 증식하지 않고, 호환되는 shared exact pin + exact project/editor/session identity를 사용함
- 문서/Notion-only 변경에는 Godot Editor/runtime 실행을 완료 증거로 요구하지 않음
