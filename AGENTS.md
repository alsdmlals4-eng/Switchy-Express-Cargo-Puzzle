# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 운영 계약을 적용한 Godot 모바일 게임 프로젝트다.

## 우선순위

1. 사용자의 최신 지시
2. 현재 환경의 system/developer/security 제약
3. 이 `AGENTS.md`
4. 현재 작업지시문 정본 `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
6. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
7. 등록된 분야 책임 원본
8. 실제 코드·데이터·Scene·Resource·자산·테스트
9. 프로젝트에 고정된 Base v9.4.3 기준
10. Base remote current `main`의 비교·학습 근거
11. 외부 사례·과거 대화·추정

## 현재 작업지시문 — v4.5 r2

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md
contract_version: 4.5
revision: 2026-08-11-r2
source_sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
work_instruction_audit: SX-AUD-045
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · explicit "기획 완료" · 2026-08-11 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE
sx_dec_055_runtime_implementation: NOT_STARTED
```

- 매 작업 시작 시 Base current `main`, 프로젝트 default branch/open PR/latest commit, configured Google Sheet를 다시 읽는다.
- 사용자의 `기획 완료` Gate는 2026-08-11 KST에 명시적으로 충족됐다.
- `SX-AUD-047` Phase B Final Planning Review가 PASS했다.
- 이 Phase-B canon-sync가 merged-main에 반영되고 Sheet가 동기화된 뒤에만 Phase C BUILD를 시작한다.
- 첫 Phase C 단계는 기존 `SX-DEC-055` plan의 **Task 1 / Step 1.1 RED**다.
- Phase B는 제품/runtime 구현을 수행하지 않았다.

## SX-DEC-055 current implementation package

Authoritative documents:

- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
- `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
- `docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

Approved architecture:

```text
SX-DEC-053/054 product manifests
→ presentation-owned SemanticAssetCatalog
→ existing presenter model / render snapshot / existing events
→ HUD + board + route + semantic event presentation
```

Phase B added one mandatory packaging prerequisite: finite-map/semantic JSON are non-resource runtime files, so Phase C must use narrow non-resource export inclusion plus exported-pack proof before hosted export/package evidence can satisfy the POC gate.

## 역할 분리

- ChatGPT: 핵심 재미, 콘텐츠·맵·규칙 기획, 벤치마킹, 아트·UX 방향, Google Sheets GDD, GitHub 정본·Issue, 적대적 검토, Codex 전달 명세
- Codex: 승인된 Definition of Ready 범위에서 실제 Godot/GDScript 코드·테스트 변경
- Godot-authoring authority는 `SX-DEC-045`를 따른다. Scene·Node·Resource·Theme·Animation·signal wiring·project settings는 승인된 Godot authoring 경계를 우회하지 않는다.
- 사용자가 명시하지 않은 게임 규칙·세계관·과금·콘텐츠를 임의로 확정하지 않는다.

## 엔진·플랫폼

- Engine: Godot `4.7.1-stable`
- Language: GDScript
- Primary platform: Android / Google Play
- Orientation: landscape
- Godot 용어를 사용하며 Unity/C#/Prefab/MonoBehaviour 프레이밍을 사용하지 않는다.

## 현재 제품 기준선 — GMB-002

- 수작업 유한 배송 퍼즐
- 건설 불가 구역을 제외한 자유 선로 건설
- 선로별 건설비와 전액 환급 가능한 건설 단계
- 모든 역·화물의 구조적 도달 가능성 완료 후 운행 시작
- 자동 운행 + 수동 적재 기본 + 자동 적재 토글 + 분기 직접 탭
- 화물칸 수량 제한 없음
- 마지막에 실은 화물부터 하역하는 LIFO
- TOP에서 같은 종류가 연속되는 그룹만 자동 하역
- 제한 시간 종료 시 미배송 화물이 있으면 실패
- 마지막 하역 완료 시 즉시 성공
- 배송 완료 전 이동 불가 시 `ROUTE_END` 실패
- 동일 sealed layout fresh-runtime retry
- color+shape+text redundant information channels
- cosmetic-only progression boundary

`SX-DEC-033~035`의 stars/leaderboard/tutorial/chapter/daily-weekly packages are approved future work but do not widen the current `SX-DEC-055` POC.

코어 변경은 `USER_DECISION_REQUIRED`다.

## 현재 정본

- 작업지시문: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
- 제품 기준선: `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- 현재 허브: `기획서/00_프로젝트_허브/START_HERE.md`
- 현재 결정: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- 현재 context: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- 개발 Gate: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Phase B audit: `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
- 핵심 경험: `기획서/10_경험/CORE_GAMEPLAY.md`
- 시스템 규칙: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- 아트·UI: `기획서/40_표현/VISUAL_DIRECTION.md`
- 제작·검증: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- 사람 검증: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- 사용자 GDD: `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit`

## 구형 구현 처리

현재 main의 RailGraph·자동 이동·분기·CargoStack·LIFO·map/session/restart/selection 계열은 실제 구현 증거이며 승인된 finite seam에서 재사용할 수 있다.

다음은 current product 의미로 사용하지 않는다.

- endless survival
- fuel drain/recovery/fuel-zero end
- player BOOST input
- cargo capacity 8
- cargo-count slowdown
- timed speed/fuel pressure escalation
- pickup respawn
- switch auto-reset after passing

`GMB-003`는 과거 route-end/switch implementation package context이며 current finite product baseline이 아니다.

## SX-DEC-055 보호 영역

Phase C에서 금지:

- LIFO/cargo eligibility/route topology/cycle/U-turn/occupied-lock/time/scoring/failure/save/ruleset/map-content 변경
- 새 gameplay/domain signal을 semantic art 또는 combo VFX만을 위해 추가
- unnamed legacy atlas에 새 semantic meaning 부여
- product PNG 또는 semantic sidecar provenance rewrite
- historical `runtime_integrated=false`를 후속 소비 때문에 변경
- existing procedural direction/hit/input authority를 semantic overlay가 소유
- existing Korean text/procedural fallback을 POC 중 불필요하게 제거
- Base repin
- `.asset-vault` untrack
- 자동/hosted export를 physical/device/human PASS로 승격
- production cutover 자동 승인

## Phase C first step

Merged-main readback + Sheet sync 뒤:

```text
SX-DEC-055
Task 1 / Step 1.1 RED
→ tests/demo/test_semantic_asset_catalog.gd
→ tests/run_tests.gd registration
→ run custom Godot test suite
→ expected RED: SemanticAssetCatalog missing
```

이후 기존 plan의 Task 2~10을 순서대로 따른다. Phase B readiness amendment의 Task 9A는 최종 export/package acceptance 전 필수다.

## 검증 경계

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: NOT_STARTED
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL GODOT/HERA: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

실행하지 않은 테스트를 PASS로 보고하지 않는다.

## Base v9.4.3 운영 계약

```yaml
base_version: 9.4.3
base_payload_commit: 7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8
base_trusted_evidence_commit: da33a350d61b8adc52df97fccc7001708a933370
base_pin_finalization_commit: 0b7c94f38d959efc0fc9442274c60b2e268a3c97
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
```

- 위 pin은 프로젝트 채택 release다. Base remote current `main`은 비교·학습용이며 자동 repin하지 않는다.
- L1 이상 지시문은 `route → first-prompt → contract → clarify`를 따른다.
- 기획 충돌은 Grill Me 사용자 승인을 요구한다.
- 가역적 상세 수치는 이유·조정 조건·검증 한계를 기록한 `TEST_VALUE`로 진행할 수 있다.
- LIFO·화물/역 색상+모양·저장 호환성·랭킹 ruleset identity는 `HARD_CONSTRAINT`다.
- UI 모션은 퍼즐 결과·점수·적재·하역·저장의 권위가 아니다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작 작업은 다음 프로젝트 증거를 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

Android·Google Play가 우선이다. 필수 권리·계약·약관 버전·플랫폼 답변·build/store/questionnaire 일치가 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다. 사용자 승인 없는 광고·가챠·에너지·성능 과금은 금지한다.
