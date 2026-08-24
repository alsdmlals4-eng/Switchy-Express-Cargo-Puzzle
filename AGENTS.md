# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 project compatibility pin을 역사 증거로 보존하면서, **사용자가 2026-08-24 제공한 v4.8 r4 작업 계약**과 실행 시점의 최신 Base completed `main`을 현재 실행 방법론으로 사용하는 Godot 프로젝트다.

## 1. 권위 순서

1. 사용자의 최신 지시와 승인
2. 현재 환경 system/developer/security 제약
3. 이 `AGENTS.md`
4. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. 등록된 분야 책임 원본
8. 실제 code/data/Scene/Resource/assets/tests/runtime evidence
9. 프로젝트가 채택한 compatibility lock/adapter
10. Base remote latest completed `main`
11. 외부 사례·과거 대화·추정

프로젝트 문서와 실제 runtime/code가 충돌하면 숨기지 않는다. 실행하지 않은 test/build/render/physical/human 검증은 PASS라고 쓰지 않는다.

### 작업 목표

모든 프로젝트 작업은 **가장 효율적이고 장기적으로 유지되는 출시 수준에 가까운 버티컬 슬라이스**를 목표로 한다. 빠른 답이나 국소 패치보다 현재 코드·PR·Notion 정본을 먼저 읽고, 중요 결정은 공식 자료·동종 제품 벤치마킹·현업 성공/실패 사례와 최소 3개 실질 대안을 비교한 뒤 선택한다. 시간과 토큰보다 결과 품질, 증거, 회귀 방지, 장기 유지비를 우선한다.

구현·병합 작업은 적용 가능한 범위에서 다음을 기본 완료 조건으로 삼는다.

```text
fresh authority recovery
→ benchmark / industry comparison
→ RED-first implementation or acceptance-first evidence
→ exact automated/package evidence
→ minimum five full-scope adversarial loops until clean
→ corrections and regression
→ GitHub merge
→ Notion destination sync + readback
```

## 2. 매 작업 시작 fresh-read

```text
Base latest completed main
→ Base root AGENTS.md
→ Project main/latest commit
→ all Open/Draft PR
→ exact Project Notion Home
→ this AGENTS.md
→ v4.8 Switchy adapter
→ CURRENT_CONFIRMED_DECISIONS
→ ACTIVE_CONTEXT
→ exact owner docs
→ actual code/data/Scene/Resource/assets/tests
```

Google Sheets는 `MIGRATION_ONLY_UNTIL_REMOVAL`이다. 신규 기획 입력·active workspace로 사용하지 않는다. Figma, external HTML, Tool Hub, QA Evidence Studio도 기본/필수 프로젝트 경로가 아니다.

## 3. 현재 작업지시문 / 엔진

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md
contract_version: 4.8
revision: 2026-08-24-r4
source_v4_8_r4_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
source_v4_8_r2_sha256: 6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508 · HISTORICAL_PROVENANCE
source_role: USER_PROVIDED_V4_8_R4_CONTRACT
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
engine: Godot 4.7.1-stable
language: GDScript
project_base_pin: v9.4.3 · HISTORICAL_COMPATIBILITY
base_snapshot_observed_when_v4_8_adopted: 2828a74f60c1ed09546171040f4178c8848ea686
base_remote_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
```

v4.8 r2 도입 기록, v4.7 Switchy adapter와 v4.5 r2 bundle은 역사·rollback evidence로 보존하며 current work-instruction authority가 아니다.

## 4. 현재 제품 기준선 — GMB-002

- handcrafted finite delivery puzzle
- free rail build + cost / full refund
- structural preflight before RUN
- automatic train movement
- manual load default + auto-load toggle
- unlimited LIFO stack
- contiguous matching TOP group unload
- direct route-control/switch interaction with occupied lock
- time failure / all-delivered success / `ROUTE_END`
- same-layout fresh-runtime Retry + Edit layout
- color + shape + text redundant information
- cosmetic-only progression boundary

다음 historical family는 current product로 되살리지 않는다.

```text
endless survival
fuel drain/recovery/fuel-zero
player BOOST
cargo capacity 8
cargo-count slowdown
pickup respawn
switch auto-reset
```

코어 의미 변경은 `USER_DECISION_REQUIRED`다.

## 5. 현재 Decision / Candidate 상태

```yaml
current_decision_span: SX-DEC-027~059
sx_dec_055_runtime_semantic: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_059: USER_APPROVED · PLANNING_COMPLETE_GRANTED_2026_08_20
sx_dec_059_build: MERGED_MAIN_VERIFIED · PR_158 · main_162e8a0a5e8ddc8472e74a6152e87dc12008e34c
sx_dec_059_notion_post_merge_readback: PASS
playable_visual_ux_poc: MERGED_MAIN_VERIFIED · PR_166
candidate_002: SX59-POC-ACCEPT-002 · HISTORICAL_PHYSICAL_EVIDENCE
candidate_002_windows_startup: PASS
candidate_002_acceptance: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
current_candidate: SX59-POC-ACCEPT-003
candidate_003_package_integrity: PASS
candidate_003_physical_visual_recheck: NOT_RUN
developer_self_run: NOT_RUN
audio_perceptual_qa: NOT_RUN
windows_full_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
```

`SX-DEC-059`의 승인된 첫 세션은 다음이다.

```text
T1 Track Connection
→ T2 Cargo/Station + basic manual pickup
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ existing VS_DEMO_01 Capstone
→ Result / Retry / Edit
```

### Candidate 003 Gate 0 · current next product gate

```text
A. physical visual recheck: preflight badge compact + Korean problem copy non-overlap
B. physical visual recheck: disconnected station/cargo color+shape+text identity visible + problem outline only
```

둘 중 하나라도 실패하면 `BLOCKED_P1_VISUAL`이다. 둘 다 PASS일 때만 같은 exact `SX59-POC-ACCEPT-003`으로 진행한다.

```text
Candidate 003 Gate 0
→ developer self-run / screen QA · 8 scenarios
→ audio perceptual QA
→ exact acceptance build designation
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

Automated/package/launcher PASS를 physical/audio/device/human/player PASS로 승격하지 않는다.

## 6. SX-DEC-059 구현 경계

### 재사용
- current `ProductFiniteSlice`
- `FiniteMapDefinition` schema v2
- current finite domain/controller/presenter seams
- existing HUD/Board/RouteControl/SemanticEvent/DemoEffects/Audio
- current 73 semantic product PNGs
- existing `VS_DEMO_01` capstone

### 구현된 sidecar owner
- `FirstSessionDefinition`
- `FirstSessionDirector`
- `FirstSessionStagePolicy`
- `FirstSessionCopy`
- first-session sequence/localization data
- five authored tutorial map definitions and deterministic success witnesses

### 금지
- tutorial metadata를 `FiniteMapDefinition` schema에 집어넣기
- hidden button만 숨기고 keyboard/touch bypass 허용
- 056A Route Probe/PB/Fingerprint/observation을 059 명목으로 선구현
- 056B score/max-combo
- 057 Yard Lab/Mastery
- 058 Daily/Weekly generator
- new solver/optimal route reveal
- `VS_DEMO_01` bytes 변경 without separate validated need
- Base repin

## 7. 별도 PR 보호

PR #154 `feat: pilot reusable grid and semantic UI modules`는 **CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059**다. 과거 PR #155/#156도 `CLOSED_UNMERGED · HISTORICAL_ACCIDENT`이며 current workstream이 아니다. 별도 사용자 승인 없이 재흡수·재개하지 않는다.

## 8. Tooling authority · r4 host overlay

```yaml
godot_project_version: 4.7.1-stable
gut: 9.7.1
shared_host_godot_policy: ONE_APPROVED_COMPATIBLE_EXACT_PIN
shared_host_godot_ai_policy: ONE_APPROVED_EXACT_PIN
preferred_http_port: 8000
preferred_ws_port: 9500
session_isolation: EXACT_PROJECT_PATH_EDITOR_AND_SESSION_ID
update_policy: OFFICIAL_UPSTREAM_REVIEW_CANARY_ROLLBACK_THEN_EXACT_PIN
floating_latest: FORBIDDEN
```

`docs/tooling/local_godot_tooling_state.json`가 local tooling evidence owner다. 실제 로컬 bootstrap 전 user-local installed version이나 session을 추정하지 않는다.

- Godot authoring/runtime 작업은 fresh location/git/update preflight 뒤 exact Editor/project/session identity를 확인한다.
- shared pin과 project exact version 호환성이 확인되지 않으면 임의로 열지 않는다.
- breaking/migration/비용/권한 변경은 자동 업데이트하지 않는다.
- 문서/Notion-only 작업처럼 Godot authoring/runtime evidence가 acceptance에 필요하지 않으면 Editor 실행은 `NOT_APPLICABLE`이다.
- GUT은 deterministic test authority, Hera는 live QA/observability only이며 acceptance source delta를 남기지 않는다.

## 9. Platform / Release / Asset Rights routing

플랫폼·등급·스토어·광고/IAP·권리·출처·reference independence 판단은 다음 프로젝트 정본을 함께 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`
- `기획서/50_제작_검증/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PLAN.md`

현재 구현/병합 완료가 `PLATFORM_SUBMISSION_NOT_RUN`, `LEGAL_REVIEW_NOT_PERFORMED`, store cutover 같은 별도 evidence gate를 PASS로 승격하지 않는다.

## 10. Evidence ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME SEMANTIC: MERGED_MAIN_VERIFIED
SX-DEC-059 IMPLEMENTATION: MERGED_MAIN_VERIFIED · PR #158
PLAYABLE VISUAL/UX POC: MERGED_MAIN_VERIFIED · PR #166
CANDIDATE 002 WINDOWS STARTUP: PASS · HISTORICAL · ACCEPTANCE_BLOCKED
CURRENT CANDIDATE: SX59-POC-ACCEPT-003
CANDIDATE 003 PACKAGE/PCK/TEXTURE POINTER: PASS
CANDIDATE 003 PHYSICAL VISUAL RECHECK: NOT_RUN
SX-DEC-059 DEVELOPER SELF-RUN: NOT_RUN
AUDIO PERCEPTUAL QA: NOT_RUN
WINDOWS FULL PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

## 11. Build / validation boundary

사용자 `기획완료`는 2026-08-20에 GRANTED 됐고 PR #158 구현과 Notion readback도 완료됐다. 현재는 구현 완료를 되풀이하지 않고 Candidate 003의 fail-closed validation chain을 따른다.

현재 manual owners:

- `evidence/acceptance/current_poc_candidate.json`
- `기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md`
- `기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`

## 12. Notion / GitHub sync

- Notion: 사람용 Project Home / Flow / Visual / Production Handoff.
- GitHub: structured canon / code / data / Scene / Resource / assets / tests / runtime evidence.
- Google Sheets: compatibility-only migration source; active workspace/decision authority가 아니다.
- Home에는 전체 게임 이해에 필요한 흐름과 시각 의미를 두고 SHA/CI/hash/tool routing 같은 운영 메타데이터는 System/Production surface에 둔다.
- 이후 player evidence나 제품 결정이 바뀔 때 같은 의미로 양쪽을 다시 동기화한다.

## 13. 현재 핵심 정본

- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- `기획서/00_프로젝트_허브/START_HERE.md`
- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `evidence/acceptance/current_poc_candidate.json`
- `기획서/00_프로젝트_허브/ROADMAP.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- `기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md`
- `기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN_V4_7_CURRENT.md` (compatibility filename)

v4.7 adapter와 v4.8 r2 도입 자료는 history/rollback evidence다. 현재 작업의 실행 locator는 fresh `ACTIVE_CONTEXT.md`와 current candidate pointer가 책임진다.
