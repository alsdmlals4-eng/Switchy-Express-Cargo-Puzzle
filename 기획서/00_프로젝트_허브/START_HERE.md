# Switchy Express 프로젝트 허브

Last updated: `2026-08-11 KST`

## 현재 제품 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | Switchy Express: Cargo Puzzle |
| 장르 | 유한 스테이지 선로 건설·LIFO 화물 배송 퍼즐 |
| 플랫폼 | Android · landscape |
| 엔진 | Godot 4.7.1-stable · GDScript |
| 현재 결정 범위 | `SX-DEC-027~055` |
| 현재 작업지시문 | `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` · revision `2026-08-11-r2` · `SX-AUD-045` |
| 현재 제품/시각 상태 | finite core + 73 semantic product PNG package |
| 최신 runtime semantic 권위 | `SX-DEC-055 · Runtime Semantic POC` |
| SX-DEC-055 상태 | `USER_APPROVED · SPEC_APPROVED · IMPLEMENTATION_DOR_READY · USER_DEFERRED_AFTER_DOR` |
| Runtime semantic 구현 | `NOT_STARTED · runtime_integrated=false` |
| 현재 작업 모드 | `PHASE_A_PLANNING_COMPLETE · READY_FOR_USER_PLANNING_COMPLETE_GATE` |
| 사용자 planning-complete Gate | `NOT_GRANTED · explicit "기획 완료" required` |
| Phase B | `NOT_RUN` |
| BUILD | `BLOCKED until explicit user gate + Phase B PASS` |
| 현재 project main source | `LIVE_GITHUB_DEFAULT_BRANCH` |
| r2 audit-start main | `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6` · observation only |
| 열린 프로젝트 PR | 새 세션마다 전체 재조회 |
| Base 채택 pin | `v9.4.3` |
| Base current main | 새 작업마다 재조회 · reference only · no repin |
| Windows physical runtime | `NOT_RUN` |
| Android landscape device | `NOT_RUN` |
| Connected physical editor | `NOT_RUN` |
| Broader human/comprehension | `NOT_RUN` |
| FIVE-PERSON COMPREHENSION | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |

저장된 SHA·PR 값은 해당 시점 관측 증거다. 새 세션은 GitHub default branch와 모든 Open/Draft PR을 다시 읽는다.

## 한 문장

> 선로를 건설해 화물 조우 순서를 설계하고, 수동·자동 적재로 LIFO 스택을 구성하며, 운행 중 분기 경로를 조절해 제한 시간 안에 모든 필수 배송을 완료하는 퍼즐.

## 반드시 먼저 읽기

새 채팅·새 에이전트·Codex는 과거 대화보다 현재 저장소를 우선하며 다음 순서로 읽는다.

1. 루트 `AGENTS.md`
2. 루트 `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`
3. Base current `main` / 프로젝트 current `main` / 모든 Open·Draft PR / latest commit
4. configured Google Sheet current rows
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
7. `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`
8. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
9. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
10. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
11. 구현이 실제로 승인된 뒤에만 plan이 지목한 Godot/GDScript/test/manifests를 current main에서 재조회

`ACTIVE_CONTEXT.md`는 재개용 locator다. 저장된 SHA나 과거 handoff보다 현재 GitHub/Sheet/실제 파일이 우선한다.

## 현재 핵심 플레이

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ 운행 중 분기·교차 경로 전환
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 필수 배송 완료
→ 결과를 보고 same-layout retry 또는 재설계
```

## 현재 완료된 시각 패키지

```yaml
SX-DEC-053_product_assets: 39
SX-DEC-054_RUN_2A: 20
SX-DEC-054_BUILD_2B: 8
SX-DEC-054_VFX_2C: 6
total_product_pngs: 73
semantic_asset_production: COMPLETE
runtime_integrated: false
```

- legacy unnamed atlas regions는 non-authoritative/reference-only다.
- Reduced Motion 정보 등가는 VFX semantic package에 정의되어 있다.
- asset production 완료는 Godot runtime hookup 완료를 의미하지 않는다.

## 현재 실행 체크포인트

Phase A 계획 증거는 `SX-AUD-044` / PR #141/#142로 `READY_FOR_USER_PLANNING_COMPLETE_GATE`까지 닫혔다. r2 작업지시문 교체는 `SX-AUD-045`로 정본 provenance를 최신화하는 문서/운영 작업이다.

현재 순서:

```text
r2 GitHub canon replacement + exact-head PR verification + Sheet sync
→ READY_FOR_USER_PLANNING_COMPLETE_GATE 유지
→ 사용자의 명시적 "기획 완료"
→ PHASE B FINAL PLANNING REVIEW
→ Phase B PASS인 경우에만 SX-DEC-055 Task 1 / Step 1.1 RED
→ 그 뒤 PowerShell/Codex/Godot BUILD
```

**과거 `explicit resume → Task 1 RED` handoff는 current execution authority가 아니다.** 동일 SX-DEC-055 제품 승인 범위는 보존되지만 r2의 사용자 planning-complete Gate와 Phase B를 건너뛰지 않는다.

## 현재 validation ceiling

- `CANONICAL MAIN APK EXPORT: PASS` = historical packaging/hash evidence only
- `ANDROID DEVICE SMOKE`: historical validation-harness lane은 `NOT_RUN`; post-POC acceptance physical smoke와 동일하지 않음
- Windows exported artifact physical runtime / visual / audio / physical input: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- Connected physical Godot/Hera authoring session: `NOT_RUN`
- Broader human / comprehension: `NOT_RUN`
- `FIVE-PERSON COMPREHENSION`: `NOT_RUN`
- post-POC acceptance build: `UNASSIGNED`
- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`
- `PRODUCTION CUTOVER`: `BLOCKED_DEFERRED`

## 현재 중요한 경계

- LIFO, cargo/station 색상+모양 가독성, save/ruleset identity를 유지한다.
- 새 gameplay/domain signal을 combo VFX만을 위해 만들지 않는다.
- `run_stack_unloading_v01`을 predicted unload-group으로 재해석하지 않는다.
- historical semantic/product manifest의 `runtime_integrated=false`를 후속 소비 때문에 덮어쓰지 않는다.
- Hosted CI/Windows export를 physical runtime 또는 human PASS로 확대하지 않는다.
- 프로젝트는 Base `v9.4.3` pin을 유지하며 최신 Base main을 자동 채택하지 않는다.
- Wrong `19Ff...` Sheet는 변경하지 않는다.
- `권장안대로 승인`·`연속작업 진행`을 사용자 literal `기획 완료`로 해석하지 않는다.
