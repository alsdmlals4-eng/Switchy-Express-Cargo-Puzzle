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
| 현재 작업 모드 | `HANDOFF_CLOSED / WAIT_FOR_EXPLICIT_RESUME` |
| 재개 시 첫 작업 | `SX-DEC-055 implementation plan · Task 1 · Step 1.1 RED` |
| 현재 project main source | `LIVE_GITHUB_DEFAULT_BRANCH` |
| PR #138 post-merge 관측점 | `eb07dcc39b9675a54c675694236f507a8e50e78a` · historical integration observation |
| 열린 프로젝트 PR 관측 | `0` after PR #138 merge |
| Base 채택 pin | `v9.4.3` |
| 최신 Base main 관측 | `58d5f27a907e28e16d28763c567e6ab5b4377a28` · reference only, no repin |
| Base project proposal | `BCP - Switchy Express: Cargo Puzzle` · `BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation` · Base PR #249 `MERGED` · Registry `SUBMITTED` |
| Windows physical runtime | `NOT_RUN` |
| Android landscape device | `NOT_RUN` |
| Connected physical editor | `NOT_RUN` |
| Broader human/comprehension | `NOT_RUN` |
| Production cutover | `BLOCKED_DEFERRED` |
| Sheet | `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo` |

`PR #138 post-merge 관측점`은 현재 main을 영구 고정하는 값이 아니다. 새 세션은 반드시 GitHub default branch를 다시 읽는다.

## 한 문장

> 선로를 건설해 화물 조우 순서를 설계하고, 수동·자동 적재로 LIFO 스택을 구성하며, 운행 중 분기 경로를 조절해 제한 시간 안에 모든 필수 배송을 완료하는 퍼즐.

## 반드시 먼저 읽기

새 채팅·새 에이전트·Codex는 과거 대화보다 현재 저장소를 우선하며 다음 순서로 읽는다.

1. 루트 `AGENTS.md`
2. 현재 GitHub `main` / open PR / latest commit
3. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
6. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
7. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
8. `기획서/00_프로젝트_허브/ROADMAP.md`
9. configured Google Sheet `SX-DEC-055` row and current audit rows
10. implementation을 재개할 때만 plan이 지목한 실제 Godot/GDScript/test/manifests를 current main에서 재조회

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

사용자 최신 runtime 지시:

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

## 최신 handoff 자동화 증거 경계

PR #137 exact head `7be35adf4fa98bb915616a1e6a89f67dcb19a4ca`:

- Project Contract `31354096765`: PASS
- GUT 9.7.1 `31354096767`: PASS
- Godot Tests `31354096757`: PASS
- Validate Thin Adapter Migration `31354096769`: PASS
- Windows Demo Export `31354096778`: PASS
- unresolved review threads: 0
- exact changed files: 5
- squash merge observation: `32a0d6c154188f36bdefdefe96e62bc2a4718565`

PR #138 exact head `51dbffef06f274ca319b4d23982d65c8d7753709`:

- Project Contract `31355199653`: PASS
- GUT 9.7.1 `31355199646`: PASS
- Godot Tests `31355199665`: PASS
- Validate Thin Adapter Migration `31355199592`: PASS
- Windows Demo Export: `NOT_CREATED` for this docs-only head
- unresolved review threads: 0
- exact changed files: 2 docs
- squash merge observation: `eb07dcc39b9675a54c675694236f507a8e50e78a`

이 증거는 **handoff/canonical-freshness 문서·회귀 증거**이며 `SX-DEC-055` runtime implementation PASS가 아니다.

PR #138 merge commit에 대한 별도 PR-trigger workflow는 즉시 조회에서 관측되지 않았으므로 `UNVERIFIED`로 남긴다.

## Base project proposal

사용자 명명 규칙:

```text
BCP - 프로젝트 이름
```

Switchy는 프로젝트 출처형 별도 proposal로 등록한다. 이 proposal은 새 broad active owner를 만들지 않고 기존 BCP-013/014에 검증된 project evidence를 제공한다.

```yaml
project_proposal_name: "BCP - Switchy Express: Cargo Puzzle"
proposal_id: BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation
proposal_status: SUBMITTED
proposal_path: "[수정제안서]/BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation/PROPOSAL.md"
evidence_path: "[수정제안서]/BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation/evidence/SWITCHY_EXPRESS_HANDOFF_RECONCILIATION_EVIDENCE.md"
related_existing_proposals:
  - BCP-2026-013-post-merge-continuation-state-reconciliation
  - BCP-2026-014-handoff-machine-consumer-compatibility-closeout
base_pr_249_exact_head: a86c5edb1d4a4e7244088ee78554d3195ca4a711
base_pr_249_validation: PASS
base_pr_249_ci_gate: PASS
base_pr_249_merge_main_observed: 58d5f27a907e28e16d28763c567e6ab5b4377a28
new_registry_entry: true
active_base_behavior_changed: false
base_implementation_authorized: false
prior_pr_245_evidence_only_placement: SUPERSEDED_HISTORY
```

Base PR #249의 정확한 변경 범위는 `[수정제안서]/**` 4개뿐이며 BCP-013/014 proposal 본문과 활성 Base Skill·Method·Template·Test·Tool·Workflow는 바꾸지 않았다.

## 별도 열린 검증 Gate

다음은 보류/미실행 상태를 유지하며 `SX-DEC-055` 자동화 증거로 대체하지 않는다.

- `CANONICAL MAIN APK EXPORT · PASS`: packaging/hash evidence only
- Windows exported artifact physical runtime / visual / audio / physical input: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- Connected physical Godot/Hera authoring session: `NOT_RUN`
- Broader human / comprehension: `NOT_RUN`
- `FIVE-PERSON COMPREHENSION`: `NOT_RUN`
- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`
- `PRODUCTION CUTOVER`: `BLOCKED_DEFERRED`

## 현재 중요한 경계

- LIFO, cargo/station 색상+모양 가독성, save/ruleset identity를 유지한다.
- 새 gameplay/domain signal을 combo VFX만을 위해 만들지 않는다.
- `run_stack_unloading_v01`을 predicted unload-group으로 재해석하지 않는다.
- 기존 semantic/product manifest의 historical `runtime_integrated=false`를 후속 소비 때문에 덮어쓰지 않는다.
- Hosted CI/Windows export를 physical runtime 또는 human PASS로 확대하지 않는다.
- 프로젝트는 Base `v9.4.3` pin을 유지하며 최신 Base main을 자동 채택하지 않는다.
- Wrong `19Ff...` Sheet는 변경하지 않는다.
