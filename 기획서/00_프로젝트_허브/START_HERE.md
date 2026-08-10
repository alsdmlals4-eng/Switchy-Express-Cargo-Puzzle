# Switchy Express 프로젝트 허브

Last updated: `2026-08-10 KST`

## 현재 제품 요약

| 항목 | 현재 값 |
|---|---|
| 제목 | Switchy Express: Cargo Puzzle |
| 장르 | 유한 스테이지 선로 건설·LIFO 화물 배송 퍼즐 |
| 플랫폼 | Android · landscape |
| 엔진 | Godot 4.7.1-stable · GDScript |
| 현재 결정 범위 | `SX-DEC-027~055` |
| 현재 제품/시각 상태 | finite core + 73 semantic product PNG package |
| 최신 runtime semantic 권위 | `SX-DEC-055 · Runtime Semantic POC` |
| SX-DEC-055 상태 | `USER_APPROVED · SPEC_APPROVED · IMPLEMENTATION_DOR_READY · USER_DEFERRED_AFTER_DOR` |
| Runtime semantic 구현 | `NOT_STARTED · runtime_integrated=false` |
| 현재 작업 모드 | `HANDOFF / CONTINUATION STATE REFRESH` |
| 재개 시 첫 작업 | `SX-DEC-055 implementation plan · Task 1 · Step 1.1 RED` |
| 프로젝트 main 관측점 | `6cd14324a3de1a1b2a9898aaee1e9535c87c8fdc` |
| 열린 프로젝트 PR | `0` at handoff refresh start |
| Base 채택 pin | `v9.4.3` |
| 최신 Base main 관측 | `637dad32c773c56a27d44d847518580848dee493` · reference only, no repin |
| Windows physical runtime | `NOT_RUN` |
| Android landscape device | `NOT_RUN` |
| Connected physical editor | `NOT_RUN` |
| Broader human/comprehension | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |

## 한 문장

> 선로를 건설해 화물 조우 순서를 설계하고, 수동·자동 적재로 LIFO 스택을 구성하며, 운행 중 분기 경로를 조절해 제한 시간 안에 모든 필수 배송을 완료하는 퍼즐.

## 반드시 먼저 읽기

새 채팅·새 에이전트·Codex는 과거 대화보다 현재 저장소를 우선하며 다음 순서로 읽는다.

1. 루트 `AGENTS.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
4. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
5. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
6. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
7. `기획서/00_프로젝트_허브/ROADMAP.md`
8. configured Google Sheet `SX-DEC-055` row and current audit rows
9. implementation을 재개할 때만 plan이 지목한 실제 Godot/GDScript/test/manifests를 current main에서 재조회

`ACTIVE_CONTEXT.md`는 재개용 locator다. 저장된 SHA나 PR 상태보다 현재 GitHub main/open PR/실제 파일이 우선한다.

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

- legacy unnamed atlas regions는 계속 non-authoritative/reference-only다.
- Reduced Motion 정보 등가는 VFX semantic package에 정의되어 있다.
- asset production 완료는 Godot runtime hookup 완료를 의미하지 않는다.

## 현재 인수인계 체크포인트

사용자 최신 지시:

```text
SX-DEC-055 구현은 지금 시작하지 않는다.
→ 현재 상태를 인수인계 정본에 저장한다.
→ 나중에 사용자가 재개를 요청하면 같은 승인 범위를 재사용한다.
```

따라서 **현재 즉시 실행할 제품/Godot 작업은 없다.**

`SX-DEC-055`를 나중에 재개할 때는:

```text
Base current structure/latest main 확인
→ project current main/open PR/latest commit 확인
→ configured Sheet SX-DEC-055 재조회
→ owner docs와 실제 code/test/manifests 충돌 확인
→ implementation plan exact-file assumptions 재검증
→ Task 1 / Step 1.1 RED부터 실행
```

동일 승인 범위 재개에는 새 승인 질문이 필요하지 않다. 다만 새 gameplay/product 방향, 새로운 semantic 의미, 승인 범위 확대, P0/P1 blocker가 생기면 `USER_DECISION_REQUIRED`다.

## 최신 자동화 증거 경계

`SX-DEC-055` DoR docs closure PR #136 exact head `d3cb8c9a681b3c9839c8e06acec3ecc8daaf0b27`:

- Project Contract `31351253902`: PASS
- GUT 9.7.1 `31351253900`: PASS
- Godot Tests `31351253898`: PASS
- Validate Thin Adapter Migration `31351253899`: PASS
- unresolved review threads: 0
- docs-only change: 3 files
- merge/main at DoR close: `6cd14324a3de1a1b2a9898aaee1e9535c87c8fdc`

이 증거는 **DoR 문서/회귀 증거**이며 `SX-DEC-055` runtime implementation PASS가 아니다.

## 별도 열린 검증 Gate

다음은 보류/미실행 상태를 유지하며 `SX-DEC-055` 자동화 증거로 대체하지 않는다.

- Windows exported artifact physical runtime / visual / audio / physical input: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- Connected physical Godot/Hera authoring session: `NOT_RUN`
- Broader human / comprehension: `NOT_RUN`
- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`
- Production cutover: `BLOCKED_DEFERRED`

## 현재 중요한 경계

- LIFO, cargo/station 색상+모양 가독성, save/ruleset identity를 유지한다.
- 새 gameplay/domain signal을 combo VFX만을 위해 만들지 않는다.
- `run_stack_unloading_v01`을 predicted unload-group으로 재해석하지 않는다.
- 기존 semantic/product manifest의 historical `runtime_integrated=false`를 후속 소비 때문에 덮어쓰지 않는다.
- Hosted CI/Windows export를 physical runtime 또는 human PASS로 확대하지 않는다.
- 프로젝트는 Base `v9.4.3` pin을 유지하며 최신 Base main을 자동 채택하지 않는다.
- Wrong `19Ff...` Sheet는 변경하지 않는다.
