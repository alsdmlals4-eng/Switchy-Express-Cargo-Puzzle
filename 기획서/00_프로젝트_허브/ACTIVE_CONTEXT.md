# Active Context

Last updated: `2026-08-11 KST`

이 문서는 분야 정본을 복제하는 장문 요약이 아니라 **현재 상태·읽기 순서·미완료 작업·검증 경계·다음 실행 지점**을 연결하는 재개용 locator다.

중요: 저장된 SHA·PR 상태는 관측 시점의 snapshot이다. **현재 GitHub default branch, open PR, 실제 파일, configured Sheet가 항상 우선**한다. 이 문서 자신의 closure commit SHA를 다시 문서에 무한 추적하지 않는다.

## Continuation State

```yaml
baseline:
  repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
  default_branch: main
  current_main_source: LIVE_GITHUB_DEFAULT_BRANCH
  repository_main_observed: 2c9d62c73990c6aeafd55f3bc346d4918289357e
  open_project_prs_observed_after_pr_141: 0
  last_merged_project_pr: 141
  project_local_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  godot_project_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  engine: Godot 4.7.1-stable
  language: GDScript
  primary_platform: Android landscape
  base_pin: 9.4.3
  upstream_base_main_last_observed: 315c66eea9614c284b9c11c4d522141065dfa4b0
  upstream_base_main_is_reference_only: true
  configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo

authority:
  work_contract: PHASE_A_PLANNING_READY_FOR_USER_GATE · SX-DEC-055_RUNTIME_IMPLEMENTATION_USER_DEFERRED
  decision_span: SX-DEC-027~055
  planning_audit: SX-AUD-044 · VERIFIED_READY
  runtime_semantic_decision: SX-DEC-055
  approval_refs:
    - USER_APPROVAL_2026-08-10_RUNTIME_POC
    - USER_SPEC_APPROVAL_2026-08-10
    - USER_APPROVAL_2026-08-11_RECOMMENDED_CONTINUATION
  user_planning_complete_gate: NOT_GRANTED
  phase_b_final_planning_review: NOT_RUN
  build_authority: BLOCKED_BY_USER_PLANNING_COMPLETE_GATE_AND_PHASE_B
  protected_scope:
    - no new gameplay/domain rule
    - no new semantic meaning or atlas reinterpretation
    - no Base repin
    - no product PNG/manifests rewrite
    - no physical/device/human PASS inflation
    - no PowerShell/Codex/Godot BUILD before explicit user "기획 완료" + Phase B PASS

progress:
  completed_verified:
    - SX-DEC-041 ROUTE_END merged/automated/user-current-main F5 evidence
    - SX-DEC-042/SX-DEC-046 switch directions/direct select/U-turn/occupied-lock merged and user-current-main F5 evidence
    - SX-DEC-049 cargo pickup marker + retry user F5 evidence
    - SX-DEC-053/054 semantic asset production complete at 73 product PNGs
    - SX-DEC-055 decision/spec + exact-file RED-first DoR plan merged
    - PR #140 SX-AUD-035 Phase A canonical-freshness closure merged
    - PR #141 SX-AUD-044 first-session/acceptance-build/v4.5 planning package merged and exact-head verified
  in_progress: []
  ready_next:
    - await explicit user "기획 완료" gate
    - after that gate, run PHASE B final planning review
    - only if Phase B PASS, execute the already-approved SX-DEC-055 RED-first plan
  not_started:
    - user explicit "기획 완료" gate
    - Phase B final planning review
    - SX-DEC-055 Godot/GDScript/test runtime semantic POC implementation
    - post-POC exact acceptance-build assignment
    - Windows physical runtime/visual/audio/input validation
    - Android landscape device smoke
    - post-POC acceptance-build physical smoke
    - Five-person Comprehension
    - Connected physical Godot/Hera authoring validation
    - broader human/comprehension validation
  blocked:
    - BUILD: BLOCKED_BY_V4_5_USER_GATE_AND_PHASE_B
    - production cutover: BLOCKED_DEFERRED
    - asset-vault untrack: DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION

verification:
  pr_140:
    exact_head: 3da85302ebbed825bd5c51252c5bcfd040a3c5e7
    merge_main_observed: 398be2f12c6d279c83001bf36bfdd3ecb7f72a08
    project_contract_31434427283: PASS
    gut_31434427285: PASS
    godot_31434427318: PASS
    thin_31434427328: PASS
    review_threads: 0
  pr_141:
    initial_head: 45d6aa6087b737756785f32ee40a434676c85c58
    initial_project_contract: FAIL · ANDROID_DEVICE_SMOKE_COMPATIBILITY_ANCHOR
    exact_head: 4aa592d8c086a3d863d736696af4169a886391ad
    merge_main_observed: 2c9d62c73990c6aeafd55f3bc346d4918289357e
    project_contract_31436274979: PASS
    gut_31436274904: PASS
    godot_31436275078: PASS
    thin_31436274910: PASS
    review_threads: 0
    submitted_reviews: 0
    changed_files: 10_DOCS_PLANNING_ONLY
  sx_dec_055_runtime_poc_tests: NOT_RUN
  runtime_qa: NOT_RUN
  human_qa: NOT_RUN
  validation_ceiling:
    CANONICAL MAIN APK EXPORT: PASS · HISTORICAL PACKAGING/HASH EVIDENCE ONLY
    Android landscape device smoke: NOT_RUN
    POST_POC_ACCEPTANCE_BUILD_PHYSICAL_SMOKE: NOT_READY
    FIVE-PERSON COMPREHENSION: NOT_RUN
    CONNECTED_PHYSICAL_EDITOR: NOT_RUN
    PRODUCTION_CUTOVER: BLOCKED_DEFERRED

historical_compatibility_markers:
  legacy_audit_reference: SX-AUD-025
  repository_main_observed: 2c9d62c73990c6aeafd55f3bc346d4918289357e
  latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
  pc_local_route_and_mid_run_retest: RETEST_REQUIRED

base_learning:
  project_proposal_name: "BCP - Switchy Express: Cargo Puzzle"
  project_proposal_id: BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation
  proposal_status: SUBMITTED
  existing_solution_verdict: ABSORB_EXISTING_OWNERS
  base_implementation_authority: NOT_GRANTED_IN_THIS_STAGE

phase_a_sequence:
  current_step: READY_FOR_USER_PLANNING_COMPLETE_GATE
  required_user_gate_literal: "기획 완료"
  phase_b_after_user_gate: FINAL_PLANNING_REVIEW
  first_build_step_after_phase_b_pass: docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md Task 1 / Step 1.1 RED
```

## 현재 핵심 재미

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 unlimited LIFO 구성
→ 운행 중 분기·교차 경로 전환
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 필수 배송 완료
→ 결과를 보고 같은 조건 재도전 또는 후속 재설계
```

## 현재 제품·시각 상태

```yaml
finite_core: AUTOMATED_PASS
route_end: USER_CURRENT_MAIN_F5_PASS
switch_direction_and_uturn: USER_CURRENT_MAIN_F5_PASS
cargo_pickup_retry: USER_F5_PASS
semantic_product_assets: 73_TOTAL · PRODUCTION_COMPLETE
sx_dec_055_spec: APPROVED_AND_MERGED
sx_dec_055_dor_plan: MERGED
sx_dec_055_runtime_implementation: USER_DEFERRED · NOT_STARTED
runtime_integrated: false
```

`SX-DEC-055` 승인과 DoR은 취소되지 않았다. Phase A의 기능 분해·의존성·보호 영역·RED/GREEN blueprint·첫 세션 comprehension·post-POC acceptance-build·validation sequence는 PR #141 exact-head 검증/merge까지 완료되어 **사용자 planning-complete Gate를 받을 준비**가 되었다. 그러나 BUILD 권한은 아직 없다. 사용자가 명시적으로 `기획 완료`를 선언한 뒤 Phase B 최종 기획 검수를 통과해야만 기존 RED-first 구현 plan을 실행할 수 있다.

## 첫 세션·acceptance build 경계

- 과거 Android validation APK `eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea`는 역사적 packaging/validation-harness 증거다.
- post-SX-DEC-055 사람 이해도 Gate의 active acceptance build는 아직 존재하지 않으며 `UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE`다.
- Five-person Comprehension은 post-POC exact acceptance build의 reviewed physical smoke 뒤에만 실행한다.
- 자동화 POC PASS는 physical/device/human PASS를 대체하지 않는다.

## Base 경계

- 프로젝트 채택 release pin은 Base `v9.4.3`이다.
- upstream Base main은 관측 참고값일 뿐 release pin으로 자동 승격하지 않는다.
- `BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation`은 project-source proposal이며 새 broad Skill 또는 active project behavior를 자동 부여하지 않는다.

## 다음 읽기 순서

1. `AGENTS.md`
2. `기획서/00_프로젝트_허브/START_HERE.md`
3. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
4. 이 `ACTIVE_CONTEXT.md`
5. `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`
6. `기획서/50_제작_검증/PLAYTEST_PLAN.md`
7. `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
8. `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
9. `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`
10. configured Google Sheet current rows

## 금지

- prior approval 또는 `연속작업`을 v4.5의 명시적 `기획 완료` Gate로 해석
- Phase B 전에 SX-DEC-055 RED/GREEN/Godot 구현 시작
- planning readiness를 runtime POC 구현 완료로 보고
- 새 gameplay/domain signal을 combo VFX만을 위해 추가
- unnamed legacy atlas에 새 의미 부여
- historical semantic/product manifest의 `runtime_integrated=false` provenance 덮어쓰기
- 과거 validation APK를 post-POC human-comprehension build로 자동 재사용
- 자동/hosted export PASS를 physical runtime/human PASS로 확대
- Base 최신 main을 프로젝트 pin으로 자동 승격
- wrong `19Ff...` Sheet 변경
- legacy endless·fuel·BOOST 계약 재활성화
