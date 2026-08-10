# Active Context

Last updated: `2026-08-10 KST`

이 문서는 분야 정본을 복제하는 장문 요약이 아니라 **현재 상태·읽기 순서·미완료 작업·검증 경계·다음 실행 지점**을 연결하는 재개용 locator다. 현재 GitHub main/open PR/실제 파일이 이 문서의 저장된 SHA보다 항상 우선한다.

## Continuation State

```yaml
baseline:
  repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
  default_branch: main
  main_sha_observed_at_handoff_start: 6cd14324a3de1a1b2a9898aaee1e9535c87c8fdc
  open_project_prs_at_handoff_start: 0
  project_local_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  godot_project_path: C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle
  engine: Godot 4.7.1-stable
  language: GDScript
  primary_platform: Android landscape
  base_pin: 9.4.3
  upstream_base_main_observed: 3ff790116bc08f49e126cd286ec453bf6e46376e
  configured_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo

authority:
  work_contract: HANDOFF_NOW · SX-DEC-055_RUNTIME_IMPLEMENTATION_USER_DEFERRED
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
  completed_not_merged: []
  in_progress: []
  ready_next:
    - SX-DEC-055 implementation plan Task 1 / Step 1.1 RED, but only after explicit user resume
  not_started:
    - SX-DEC-055 Godot/GDScript/test runtime semantic POC implementation
    - Windows physical runtime/visual/audio/input validation
    - Android landscape device smoke
    - Connected physical Godot/Hera authoring validation
    - Broader human/comprehension validation
  blocked:
    - production cutover: BLOCKED_DEFERRED
    - asset-vault untrack: DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION
  superseded:
    - previous ACTIVE_CONTEXT execution queue ending around PR #83~100 / SX-DEC-042 implementation-pending state
    - START_HERE/ROADMAP wording that treated Android Device Smoke as the immediate current task

verification:
  exact_head_evidence:
    sx_dec_055_spec_pr_135:
      exact_head: 383937ffe898d45b42d68cf21ef46d61981e4e09
      merge_main: 34624a5d2a93306cd2b3c72dee6ce0035b751279
    sx_dec_055_dor_pr_136:
      exact_head: d3cb8c9a681b3c9839c8e06acec3ecc8daaf0b27
      merge_main: 6cd14324a3de1a1b2a9898aaee1e9535c87c8fdc
    handoff_pr_137_initial_red:
      exact_head: cccf58ef0dfc484b0e53f18b0dba46fff1f96a7a
      project_contract: FAIL · stale Android-immediate canonical-freshness assertion
  ci:
    project_contract_31351253902: PASS
    gut_31351253900: PASS
    godot_31351253898: PASS
    thin_31351253899: PASS
    pr_136_review_threads: 0
    pr_137_initial_project_contract_31352205255: FAIL_EXPECTED_CANONICAL_FRESHNESS_RED
    pr_137_initial_gut_31352205262: PASS
    pr_137_initial_godot_31352205245: PASS
    pr_137_initial_thin_31352205251: PASS
  tests:
    sx_dec_055_runtime_poc_tests: NOT_RUN
    android_smoke_canonical_freshness: RED_ON_PR137_INITIAL_HEAD · MINIMAL_FIX_IN_PROGRESS
  human_qa: NOT_RUN for SX-DEC-055
  runtime_qa: NOT_RUN for SX-DEC-055
  not_run:
    - Windows physical runtime
    - Android landscape device
    - Connected physical editor
    - Broader human/comprehension
  blocked_unverified: []

changes:
  current_changed_files:
    - handoff refresh only: START_HERE.md
    - handoff refresh only: ACTIVE_CONTEXT.md
    - handoff refresh only: ROADMAP.md
    - canonical-freshness regression only: tests/python/test_android_smoke_canonical_freshness_contract.py
  product_or_runtime_bytes_changed_by_handoff: false
  project_skill_or_workflow_changes: none
  project_only_improvements:
    - reuse existing project hub owners instead of adding a duplicate HANDOFF file
    - remove stale current-task routing from cold-start documents
    - keep Android device/human validation open while removing its superseded immediate-task authority
  base_candidates:
    - BCP-2026-013-post-merge-continuation-state-reconciliation: REUSE_EXISTING_BCP
  base_proposal_ids:
    - BCP-2026-013-post-merge-continuation-state-reconciliation
  base_concurrency:
    source_project: Switchy Express: Cargo Puzzle
    base_main_seen: 3ff790116bc08f49e126cd286ec453bf6e46376e
    proposal_id: BCP-2026-013-post-merge-continuation-state-reconciliation
    proposal_branch: none · owned by another project and already merged
    proposal_pr: alsdmlals4-eng/Base#235 · MERGED
    same_goal_state: REUSE_EXISTING_BCP
    last_registry_recheck: Base main 3ff790116bc08f49e126cd286ec453bf6e46376e
    other_project_changes_preserved: true
    proposal_status: SUBMITTED
    proposal_storage_merge_authority: GRANTED_BY_CURRENT_SINGLE_FILE_INSTRUCTION
    proposal_storage_action: REUSED_ALREADY_MERGED_PROPOSAL_NO_SWITCHY_BASE_WRITE
    base_implementation_authority: NOT_GRANTED_IN_THIS_STAGE
    implementation_status: NOT_STARTED_IN_THIS_STAGE
    implementation_boundary: SEPARATE_FOLLOWUP_STAGE

review:
  adversarial_findings_remaining:
    - physical/device/human validation remains open and must stay NOT_RUN
  unresolved_project_pr_threads: 0 at handoff start
  same_goal_prs:
    - project PR #135: MERGED · SX-DEC-055 decision/spec
    - project PR #136: MERGED · SX-DEC-055 DoR/plan/registry
    - Base PR #215/#216/#217: historical merged handoff owner/routing evidence
    - Base PR #235: MERGED · BCP-2026-013 post-merge continuation-state reconciliation · REUSE_EXISTING_BCP
  stale_or_reference_only_items:
    - old ACTIVE_CONTEXT SHA/PR queue: SUPERSEDED_BY_THIS_CONTEXT_REFRESH
    - old Android-device-immediate START_HERE/ROADMAP routing: SUPERSEDED_AS_IMMEDIATE_TASK, gate itself remains open

resume:
  trigger: explicit user request to resume SX-DEC-055 runtime semantic POC
  next_executable_step: re-read current authority, then execute docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md Task 1 / Step 1.1 RED
  next_read_order:
    - AGENTS.md
    - 기획서/00_프로젝트_허브/START_HERE.md
    - 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
    - docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md
    - docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md
    - docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md
    - configured Google Sheet SX-DEC-055 row
  commands_or_tools_if_canonical:
    - Godot custom suite: godot --headless --path . --script res://tests/run_tests.gd
    - semantic validators: validate SX-DEC-053/054 product, RUN, BUILD, VFX manifests before/after implementation
  stop_conditions:
    - current main touches planned exact files and invalidates assumptions
    - GitHub owner docs and Sheet conflict
    - new product/gameplay/semantic decision is required
    - P0/P1 blocker prevents the approved design from being preserved
    - required product asset/manifests are missing or corrupted
  user_decision_needed: false for exact approved SX-DEC-055 scope after explicit resume; true for material scope/product changes
  last_updated: 2026-08-10 KST
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

`SX-DEC-055` 승인과 DoR은 취소되지 않았다. **실행 순서만 사용자의 최신 지시로 나중으로 미뤄졌다.** 따라서 향후 사용자가 재개를 요청하면 동일 승인 범위를 재사용하고, 저장소/Sheet 재조회 후 plan Task 1 RED부터 이어간다.

## Base 경계

- 프로젝트 채택 release pin은 Base `v9.4.3`이다.
- handoff refresh 중 최신 upstream Base main은 `3ff790116bc08f49e126cd286ec453bf6e46376e`로 재관측됐다.
- 최신 Base는 `maintaining-project-context-and-handoff` owner와 on-demand handoff routing을 이미 제공하므로 이 프로젝트에 새 broad Handoff/Progress Skill을 추가하지 않는다.
- 이번 프로젝트에서 발견한 post-merge live continuation-state stale edge는 이미 `BCP-2026-013-post-merge-continuation-state-reconciliation` / Base PR #235로 proposal-only 병합되어 `REUSE_EXISTING_BCP`로 연결한다.
- BCP-013 status는 `SUBMITTED`; Base 활성 구현 권한은 이번 단계에 없으며 `SEPARATE_FOLLOWUP_STAGE`다.
- Switchy 실행자는 다른 프로젝트가 소유한 BCP-013 branch/file/Registry entry를 수정하지 않았고, Base 활성 파일도 변경하지 않는다.
- upstream Base 최신 main을 release pin으로 자동 승격하지 않는다.

## SX-DEC-055 재개 시 첫 RED

Implementation plan의 첫 미완료 항목은 다음이다.

```text
Task 1: manifest-backed SemanticAssetCatalog
Step 1.1 RED
→ tests/demo/test_semantic_asset_catalog.gd 생성
→ tests/run_tests.gd 등록
→ production catalog가 아직 없다는 focused RED 확인
→ 이후 최소 GREEN 구현
```

현재 handoff 단계에서는 위 Godot/GDScript/test 변경을 시작하지 않는다.

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
