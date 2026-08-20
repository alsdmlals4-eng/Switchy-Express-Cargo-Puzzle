# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 프로젝트 pin을 유지하면서, **사용자가 2026-08-20 제공한 v4.7 작업 계약**과 최신 Base completed `main`을 reference evidence로 사용하는 Godot 프로젝트다.

## 1. 권위 순서

1. 사용자의 최신 지시와 승인
2. 현재 환경 system/developer/security 제약
3. 이 `AGENTS.md`
4. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. 등록된 분야 책임 원본
8. 실제 code/data/Scene/Resource/assets/tests/runtime evidence
9. 프로젝트 Base v9.4.3 pin
10. Base remote latest completed `main` · REFERENCE_ONLY
11. 외부 사례·과거 대화·추정

프로젝트 문서와 실제 runtime/code가 충돌하면 숨기지 않는다. 실행하지 않은 test/build/render/physical/human 검증은 PASS라고 쓰지 않는다.

## 2. 매 작업 시작 fresh-read

```text
Base latest completed main
→ Project main/latest commit
→ all Open/Draft PR
→ exact Project Notion Home
→ this AGENTS.md
→ v4.7 Switchy adapter
→ CURRENT_CONFIRMED_DECISIONS
→ ACTIVE_CONTEXT
→ exact owner docs
→ actual code/data/Scene/Resource/assets/tests
```

Google Sheets는 `MIGRATION_ONLY_UNTIL_REMOVAL`이다. 신규 기획 입력·active workspace로 사용하지 않는다. Figma, external HTML, Tool Hub, QA Evidence Studio도 기본/필수 프로젝트 경로가 아니다.

## 3. 현재 작업지시문 / 엔진

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md
contract_version: 4.7
revision: 2026-08-20-r1
source_sha256: 767bbe3d69e9a0acb0e5706321564ad8c04a451f7c54914a2bbdd7579f642037
source_role: USER_PROVIDED_V4_7_CONTRACT
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
engine: Godot 4.7.1-stable
language: GDScript
project_base_pin: v9.4.3
base_remote_policy: REFETCH_CURRENT_COMPLETED_MAIN_REFERENCE_ONLY
```

v4.5 r2 bundle은 역사·rollback evidence로 보존하며 current work-instruction authority가 아니다.

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

## 5. 현재 Decision / 기획 완료 상태

```yaml
current_decision_span: SX-DEC-027~059
sx_dec_055_runtime_semantic: MERGED_MAIN_VERIFIED · PR_151
sx_dec_056a: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_056b: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
sx_dec_057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_057_fast_cheap: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
sx_dec_058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
sx_dec_059: USER_APPROVED · PLANNING_COMPLETE_GRANTED_2026_08_20
sx_dec_059_human_evidence: NOT_RUN
sx_dec_059_build_started: false
```

`SX-DEC-059`의 현재 승인된 첫 세션:

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

GM-SX059-01은 A안으로 승인 완료: T2는 prerequisite action, T4는 selective strategy를 가르친다.

## 6. SX-DEC-059 구현 경계

### 재사용
- current `ProductFiniteSlice`
- `FiniteMapDefinition` schema v2
- current finite domain/controller/presenter seams
- existing HUD/Board/RouteControl/SemanticEvent/DemoEffects/Audio
- current 73 semantic product PNGs
- existing `VS_DEMO_01` capstone

### 신규 sidecar owner 후보
- `FirstSessionDirector`
- `FirstSessionStagePolicy`
- first-session sequence/localization data
- five authored tutorial map definitions, exact bytes created RED-first in BUILD

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

현재 사용자 승인 범위에서 **PR #154 `feat: pilot reusable grid and semantic UI modules`는 READ_ONLY**다.

```text
inspect overlap only
DO NOT modify/rebase/update/close/merge
DO NOT vendor/absorb its unmerged delta into SX-DEC-059
if it later merges, reevaluate only the new completed main
```

과거 실수로 생성된 PR #155/#156은 CLOSED_UNMERGED 역사 상태이며 current workstream이 아니다.

## 8. Tooling authority

```yaml
godot: 4.7.1-stable
gut: 9.7.1
project_godot_ai_plugin_cfg: 3.1.4
upstream_godot_ai_main_observed: 3.1.5 @ 09a1e3311015153d967710fbe6502ac519585a9b
prior_verified_release_basis: v3.1.3 @ 22678e5f9b038d7203d6b43b0aae20a5417c500e
project_3_1_4_exact_provenance: REVERIFY_REQUIRED_BEFORE_BUILD
```

`docs/tooling/local_godot_tooling_state.json`가 현재 evidence owner다. Fresh PowerShell에서 local/repo tree parity를 다시 확인하기 전 local version을 추정하지 않는다.

Persistent Godot authoring은 프로젝트가 채택한 HiGodot/Godot-authoring authority를 따른다. GUT은 deterministic test authority, Hera는 live QA/observability only이며 acceptance source delta를 남기지 않는다.

## 9. Evidence ceiling

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME SEMANTIC: MERGED_MAIN_VERIFIED
SX-DEC-059 IMPLEMENTATION: NOT_STARTED
SX-DEC-059 DEVELOPER SELF-RUN: NOT_RUN
WINDOWS PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

자동화/export/package/self-run은 HUMAN/PLAYER EXPERIENCE PASS가 아니다.

## 10. Codex / Build Gate

사용자 `기획완료`는 2026-08-20에 GRANTED 됐다. 이후에는 fresh Phase-C review와 implementation package DoR를 닫는다.

실제 Codex 인계/실행은 v4.7의 on-demand rule을 따른다.

```text
package DoR closed
AND USER_REQUESTED_CODEX_HANDOFF
→ NEW POWERSHELL
→ LOCATION FIRST
→ project/worktree + Godot/HiGodot/CODEX_HOME/Hera preflight
→ codex.cmd -a never -s workspace-write
→ every task RED → expected fail → minimal GREEN → regression
```

Codex handoff 요청 전에는 PowerShell/Codex/Godot BUILD를 시작했다고 주장하지 않는다.

## 11. Notion / GitHub sync

- Notion: 사람용 Project Home / Flow / Visual / Production Handoff.
- GitHub: structured canon / code / data / Scene / Resource / assets / tests / runtime evidence.
- 승인 Decision은 같은 의미로 양쪽에 즉시 동기화하고 readback한다.

## 12. 현재 핵심 정본

- `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`
- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- `기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md`
- `기획서/30_UI_UX/FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md`
- `기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md`
- `기획서/40_표현/SX_DEC_059_VISUAL_REQUIREMENT_BRIEFS.md`
- `기획서/50_제작_검증/SX_DEC_059_RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE.md`
- `기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN.md`

현재 작업의 실행 locator는 `ACTIVE_CONTEXT.md`가 책임진다.
