# Active Context

Last updated: `2026-08-10 KST`

이 문서는 분야 정본을 복제하는 장문 요약이 아니라 **현재 상태·읽기 순서·미완료 작업·검증 경계·다음 실행 지점**을 연결하는 재개용 locator다.

중요: 저장된 SHA·PR 상태는 관측 시점의 snapshot이다. **현재 GitHub default branch, open PR, 실제 파일, configured Sheet가 항상 우선**한다. 이 문서 자신의 closure commit SHA를 다시 문서에 무한 추적하지 않는다.

## Continuation State

```yaml
baseline:
  repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
  default_branch: main
  current_main_source: LIVE_GITHUB_DEFAULT_BRANCH
  post_merge_main_observed_after_pr_137: 32a0d6c154188f36bdefdefe96e62bc2a4718565
  post_merge_main_observed_after_pr_138: eb07dcc39b9675a54c675694236f507a8e50e78a
  post_merge_open_project_prs_observed_after_pr_138: 0
  integration_pr_137: MERGED
  integration_pr_138: MERGED
  project_local_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  godot_project_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  engine: Godot 4.7.1-stable
  language: GDScript
  primary_platform: Android landscape
  base_pin: 9.4.3
  upstream_base_main_last_observed: 58d5f27a907e28e16d28763c567e6ab5b4377a28
  upstream_base_main_is_reference_only: true
  configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo

authority:
  work_contract: HANDOFF_CLOSED · SX-DEC-055_RUNTIME_IMPLEMENTATION_USER_DEFERRED
  decision_span: SX-DEC-027~055
  runtime_semantic_decision: SX-DEC-055
  approval_refs:
    - USER_APPROVAL_2026-08-10_RUNTIME_POC
    - USER_SPEC_APPROVAL_2026-08-10
  protected_scope:
    - no new gameplay/domain rule
    - no new semantic meaning or atlas reinterpretation
    - no Base repin
    - no product PNG/manifests rewrite
    - no physical/device/human PASS inflation

progress:
  completed_verified:
    - SX-DEC-041 ROUTE_END merged/automated/user-current-main F5 evidence
    - SX-DEC-042/SX-DEC-046 switch directions/direct select/U-turn/occupied-lock merged and user-current-main F5 evidence
    - SX-DEC-049 cargo pickup marker + retry user F5 evidence
    - SX-DEC-053 39 product assets + authoritative slice batch 1
    - SX-DEC-054 RUN_2A 20 + BUILD_2B 8 + VFX_2C 6 = 73 total product PNGs
    - SX-DEC-055 decision/spec merged via PR #135
    - SX-DEC-055 exact-file RED-first DoR plan merged via PR #136
    - PR #137 handoff/current-task refresh + canonical-freshness consumer migration merged
    - PR #138 post-merge live-source handoff reconciliation merged
    - Base project-source proposal BCP - Switchy Express: Cargo Puzzle registered and merged via Base PR #249
  in_progress: []
  ready_next:
    - SX-DEC-055 implementation plan Task 1 / Step 1.1 RED, only after explicit user resume
  not_started:
    - SX-DEC-055 Godot/GDScript/test runtime semantic POC implementation
    - Windows physical runtime/visual/audio/input validation
    - Android landscape device smoke
    - Connected physical Godot/Hera authoring validation
    - Broader human/comprehension validation
  blocked:
    - production cutover: BLOCKED_DEFERRED
    - asset-vault untrack: DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION

verification:
  pr_137:
    exact_head: 7be35adf4fa98bb915616a1e6a89f67dcb19a4ca
    merge_main_observed: 32a0d6c154188f36bdefdefe96e62bc2a4718565
    project_contract_31354096765: PASS
    gut_31354096767: PASS
    godot_31354096757: PASS
    thin_31354096769: PASS
    windows_demo_export_31354096778: PASS
    review_threads: 0
    changed_files: 5
  pr_138:
    exact_head: 51dbffef06f274ca319b4d23982d65c8d7753709
    merge_main_observed: eb07dcc39b9675a54c675694236f507a8e50e78a
    project_contract_31355199653: PASS
    gut_31355199646: PASS
    godot_31355199665: PASS
    thin_31355199592: PASS
    windows_demo_export: NOT_CREATED_FOR_DOCS_ONLY_HEAD
    review_threads: 0
    changed_files: 2
  post_merge_default_branch_ci_for_eb07dcc: NOT_OBSERVED · UNVERIFIED
  sx_dec_055_runtime_poc_tests: NOT_RUN
  runtime_qa: NOT_RUN
  human_qa: NOT_RUN
  validation_ceiling:
    CANONICAL MAIN APK EXPORT: PASS · PACKAGING/HASH EVIDENCE ONLY
    ANDROID DEVICE SMOKE: NOT_RUN
    FIVE-PERSON COMPREHENSION: NOT_RUN
    PRODUCTION CUTOVER: BLOCKED_DEFERRED

historical_compatibility_markers:
  legacy_audit_reference: SX-AUD-025
  repository_main_observed: 32a0d6c154188f36bdefdefe96e62bc2a4718565
  latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
  pc_local_route_and_mid_run_retest: RETEST_REQUIRED

changes:
  last_merged_handoff_pr: 138
  product_or_runtime_bytes_changed_by_handoff: false
  project_skill_or_workflow_changes: none
  canonical_freshness_consumers:
    - Android immediate-task literal migrated to deferred-runtime + OPEN_NOT_RUN semantics
    - post-merge consumer migrated from fossilized literal field spelling to semantic current-main/history contract

base_learning:
  project_proposal_name: "BCP - Switchy Express: Cargo Puzzle"
  project_proposal_id: BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation
  proposal_status: SUBMITTED
  proposal_path: "[수정제안서]/BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation/PROPOSAL.md"
  evidence_path: "[수정제안서]/BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation/evidence/SWITCHY_EXPRESS_HANDOFF_RECONCILIATION_EVIDENCE.md"
  related_existing_proposals:
    - BCP-2026-013-post-merge-continuation-state-reconciliation
    - BCP-2026-014-handoff-machine-consumer-compatibility-closeout
  existing_solution_verdict: ABSORB_EXISTING_OWNERS
  base_pr_249:
    exact_head: a86c5edb1d4a4e7244088ee78554d3195ca4a711
    validate_game_project_operating_system_31359998809: PASS
    required_ci_gate: PASS
    merge_main_observed: 58d5f27a907e28e16d28763c567e6ab5b4377a28
    status: MERGED · PROJECT_SOURCE_PROPOSAL_REGISTERED
  prior_base_pr_245: SUPERSEDED_EVIDENCE_ONLY_HISTORY
  new_registry_entry: true
  new_active_base_behavior: false
  base_implementation_authority: NOT_GRANTED_IN_THIS_STAGE

resume:
  trigger: explicit user request to resume SX-DEC-055 runtime semantic POC
  first_action: re-read Base structure/main/open PRs + project main/open PRs + configured Sheet
  next_executable_step: docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md Task 1 / Step 1.1 RED
  next_read_order:
    - AGENTS.md
    - 기획서/00_프로젝트_허브/START_HERE.md
    - 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
    - docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md
    - docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md
    - docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md
    - configured Google Sheet SX-DEC-055 row
  stop_conditions:
    - current main touches planned exact files and invalidates assumptions
    - GitHub owner docs and Sheet conflict
    - new product/gameplay/semantic decision is required
    - P0/P1 blocker prevents approved design preservation
    - required product asset/manifests are missing or corrupted
  user_decision_needed: false for exact approved SX-DEC-055 scope after explicit resume; true for material scope/product changes
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

`SX-DEC-055` 승인과 DoR은 취소되지 않았다. 실행 순서만 사용자의 최신 지시로 미뤄졌다. 향후 사용자가 재개를 명시하면 동일 승인 범위를 재사용하되, 반드시 최신 저장소/Sheet를 다시 읽고 Task 1 RED부터 이어간다.

## Base 경계

- 프로젝트 채택 release pin은 Base `v9.4.3`이다.
- upstream Base main은 관측 참고값일 뿐 release pin으로 자동 승격하지 않는다.
- Switchy 프로젝트 학습은 사용자 명명 규칙에 따라 **`BCP - Switchy Express: Cargo Puzzle`**로 별도 project-source proposal `BCP-2026-016-live-source-handoff-semantic-consumer-reconciliation`에 등록했고 Base PR #249로 병합됐다.
- 기존 `BCP-2026-013-post-merge-continuation-state-reconciliation`과 `BCP-2026-014-handoff-machine-consumer-compatibility-closeout`은 관련 기존 owner이며 proposal 본문은 #249에서 변경하지 않았다.
- BCP-016 Registry 상태는 `SUBMITTED`다. 새 broad Skill이나 활성 Base 구현은 이 단계에 없다.
- 이전 Base PR #245의 BCP-013 하위 Switchy evidence-only 배치는 historical/superseded 상태이며 현재 proposal 정본이 아니다.

## SX-DEC-055 재개 시 첫 RED

```text
Task 1: manifest-backed SemanticAssetCatalog
Step 1.1 RED
→ tests/demo/test_semantic_asset_catalog.gd 생성
→ tests/run_tests.gd 등록
→ production catalog가 아직 없다는 focused RED 확인
→ 이후 최소 GREEN 구현
```

현재 handoff closure에서는 위 Godot/GDScript/test 변경을 시작하지 않는다.

## 금지

- 이 handoff를 `SX-DEC-055` 구현 완료로 보고
- 사용자 재개 요청 전에 runtime POC 구현 자동 시작
- 새 gameplay/domain signal을 combo VFX만을 위해 추가
- unnamed legacy atlas에 새 의미 부여
- `run_stack_unloading_v01`을 predicted unload-group으로 재해석
- historical semantic/product manifest의 `runtime_integrated=false` provenance 덮어쓰기
- 자동/hosted export PASS를 physical runtime/human PASS로 확대
- Base 최신 main을 프로젝트 pin으로 자동 승격
- wrong `19Ff...` Sheet 변경
- legacy endless·fuel·BOOST 계약 재활성화
