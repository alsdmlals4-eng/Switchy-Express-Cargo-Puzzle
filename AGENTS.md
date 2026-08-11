# Switchy Express 공용 AI 작업 규칙

이 저장소는 `alsdmlals4-eng/Base` v9.4.3 운영 계약을 적용한 Godot 모바일 게임 프로젝트다.

## 우선순위

1. 사용자의 최신 지시
2. 현재 환경의 system/developer/security 제약
3. 이 `AGENTS.md`
4. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
5. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
6. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
7. 등록된 분야 책임 원본
8. 실제 코드·데이터·Scene·Resource·자산·테스트
9. 프로젝트 Base v9.4.3 pin
10. Base remote current `main` 비교·학습 근거
11. 외부 사례·과거 대화·추정

## 매 작업 시작 규칙

반드시 fresh-read 한다.

1. Base 저장소 current `main`과 현재 구조.
2. 프로젝트 GitHub default branch, 모든 Open/Draft PR, latest commit.
3. configured Google Sheet 현재 데이터.
4. 과거 채팅·메모리·업로드 파일을 latest state로 가정하지 않는다.
5. GitHub current canon과 Sheet가 충돌하면 명시적으로 보고하고 같은 작업 블록에서 가능한 범위를 재동기화한다.
6. 승인된 결정은 동일 Decision ID로 GitHub 정본과 Sheet에 반영한다.

## 현재 작업지시문 / 엔진

```yaml
work_instruction_canon: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md
contract_version: 4.5
revision: 2026-08-11-r2
source_sha256: 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
phase_a: COMPLETE
user_planning_complete_gate: GRANTED · explicit "기획 완료" · 2026-08-11 KST
phase_b_final_planning_review: SX-AUD-047 · PASS
engine: Godot 4.7.1-stable
language: GDScript
primary_platform: Android landscape
base_pin: v9.4.3
```

사용자가 알려준 Godot AI/HiGodot 계열 도구 버전 `3.1.4`는 현재 작업 환경 정보로 취급하되, persistent Godot authoring authority와 실제 adoption evidence는 프로젝트 정본/실행 환경에서 다시 검증한다.

## SX-DEC-055 현재 상태

`SX-DEC-055 Runtime Semantic POC`는 더 이상 NOT_STARTED가 아니다.

```yaml
approval: USER_APPROVED · SPEC_APPROVED · PHASE_B_DOR_PASS
implementation: MERGED_MAIN_VERIFIED
merge_pr: 151
merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a
runtime_integrated: true
exact_pr_head: 63b0ed331e043db7d677ca097bdb209003bda4be
project_contract: PASS
Gut_9_7_1: PASS
Godot_tests: PASS
thin_adapter: PASS
windows_export: PASS
runtime_json_pack_proof:
  windows_demo: 13_JSON_PARSED
  android_validation_preset: 13_JSON_PARSED
```

현재 merged runtime에는 manifest-backed semantic catalog/state mapping, Stack/manual/auto/preflight HUD reinforcement, BUILD ghost/preflight reinforcement, route-control semantic state, pickup/unload/route/result semantic feedback, Reduced Motion information-equivalence가 포함된다.

다음은 그대로 보호된다.

- existing Korean text, controls, hit/touch geometry;
- LIFO/cargo eligibility/route topology/cycle/U-turn/occupied-lock/time/scoring/failure/save/ruleset/map-content;
- product PNG와 semantic provenance sidecar;
- existing `DemoEffects`와 audio;
- Combo는 새 gameplay trigger를 만들지 않는다.

## 현재 제품 기준선 — GMB-002

- 수작업 유한 배송 퍼즐
- 자유 선로 건설 + 비용/전액 환급
- 구조 검사 뒤 운행
- 자동 운행 + 수동 적재 기본 + 자동 적재 토글 + 분기 직접 탭
- 무제한 LIFO stack
- TOP 연속 동일 화물 그룹 하역
- 제한 시간 실패 / 전량 배송 성공 / 배송 전 이동불가 `ROUTE_END`
- sealed layout fresh-runtime retry
- color+shape+text redundant information
- cosmetic-only progression boundary

다음 historical family를 current product 의미로 재활성화하지 않는다.

- endless survival
- fuel drain/recovery/fuel-zero
- player BOOST
- cargo capacity 8
- cargo-count slowdown
- timed pressure escalation
- pickup respawn
- switch auto-reset

코어 변경은 `USER_DECISION_REQUIRED`다.

## Post-Phase-B 승인 기획 경계

```text
SX-DEC-056A: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-057 fast/cheap content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
SX-DEC-058: DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
BMK-R09/R10: POST_VALIDATION_HOLD · NO_DECISION_ID
```

`SX-DEC-055` 병합은 위 범위의 구현 권한을 자동 확장하지 않는다.

## 역할 분리

- ChatGPT: 기획·벤치마킹·정본/Sheet 동기화·적대적 검토·승인 범위 구현 조정.
- Codex: 사용자가 요청한 경우 승인된 DoR 범위 집중 구현.
- Godot persistent authoring은 프로젝트가 채택한 Godot-authoring authority를 따른다.
- GUT은 deterministic GDScript test authority이며 production authoring 권위가 아니다.
- Hera 계열은 live QA/observability 경계를 따르고 acceptance에서 tracked source delta를 남기지 않는다.

## 현재 정본

- 작업지시문: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
- 제품 기준선: `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- 시작 허브: `기획서/00_프로젝트_허브/START_HERE.md`
- 현재 결정: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- 현재 context: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Roadmap: `기획서/00_프로젝트_허브/ROADMAP.md`
- 개발 Gate: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Phase B audit: `기획서/50_제작_검증/SX_AUD_047_PHASE_B_FINAL_PLANNING_REVIEW.md`
- SX-DEC-055 post-merge reconciliation: `기획서/50_제작_검증/SX_AUD_054_SX_DEC_055_RUNTIME_POC_POST_MERGE_RECONCILIATION.md`
- 사람 검증: `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- 사용자 GDD: `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit`

## 다음 작업 / 검증 경계

`SX-DEC-055`의 다음 단계는 다시 Task 1 RED를 수행하는 것이 아니라 **merged runtime acceptance evidence를 쌓는 것**이다.

```text
post-merge canon + Sheet reconciliation
→ exact acceptance build identity assignment when physical validation is prepared
→ Windows physical runtime/visual/audio/input smoke
→ Android device smoke
→ physical Reduced Motion/readability check
→ Five-person comprehension on the same acceptance build
→ separate production cutover decision
```

현재 증거 ceiling:

```text
FINITE CORE AUTOMATED: PASS
SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED
runtime_integrated: true
POST-POC ACCEPTANCE BUILD: UNASSIGNED
WINDOWS PHYSICAL RUNTIME/VISUAL/AUDIO/INPUT: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL GODOT/HERA: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

자동 test/export/package proof를 physical/device/human PASS로 과장하지 않는다.

## Base v9.4.3 운영 계약

```yaml
base_version: 9.4.3
base_payload_commit: 7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8
base_trusted_evidence_commit: da33a350d61b8adc52df97fccc7001708a933370
base_pin_finalization_commit: 0b7c94f38d959efc0fc9442274c60b2e268a3c97
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
```

Base remote current main은 매 작업 fresh-read하는 참고 권위이며 자동 repin하지 않는다. Windows와 Android는 하나의 게임 규칙/데이터 코어를 공유한다. 승인 범위 구현은 TDD/test-first, exact-current validation target, unresolved thread 0, merged-main readback을 요구한다.

## 플랫폼 출시·에셋 권리

출시·외부 자산·AI·외주·참조 기반 독립 제작 작업은 다음 증거를 읽는다.

- `docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md`
- `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- `docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md`

필수 권리·계약·약관·store/build 답변이 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다. 사용자 승인 없는 광고·가챠·에너지·성능 과금은 금지한다.
