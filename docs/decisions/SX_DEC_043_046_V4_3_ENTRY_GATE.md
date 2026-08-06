# GMB-004 — v4.3 Entry Gate and Tool Authority Decisions

```yaml
approval_batch_id: GMB-004
decision_ids:
  - SX-DEC-043
  - SX-DEC-044
  - SX-DEC-045
  - SX-DEC-046
count: 4
contract: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.3
audit_id: SX-AUD-027
baseline_main: 4c626513f55a0d180d90882ebe3ccbd314c08827
state: IN_REVIEW
```

## Entry gate readback

```yaml
entry_gate:
  decision_ledger_readback: PASS · SX-DEC-040~042 and PR #101 merge are aligned in GitHub and Sheet
  unresolved_list_readback: PASS_WITH_V4_3_NEW_BLOCKERS
  image_review_sheet_readback: MISSING_SX_DEC_042_VISUAL_REGISTRY_ROW
  originally_ready_items:
    - GMB-003 route-end and switch-direction implementation
  originally_awaiting_items: []
  corrected_statuses:
    - GMB-003 implementation READY -> BLOCKED_BY_GUT_ADOPTION_SPEC
    - Scene/UI arrow authoring READY -> BLOCKED_BY_HIGODOT_AUTHORITY
    - procedural arrow visual decision -> MISSING_REGISTRY_EVIDENCE
    - existing GUT install -> PRE_CONTRACT_EXISTING_INSTALL_UNVERIFIED
  blocking_reasons:
    - GUT_SPEC_NOT_STARTED at entry
    - formal project GutTest consumers and formal GUT CI not found
    - current GUT addon tree differs from pinned official tree
    - HiGodot source/version exists but connected authoring authority and Authoring Manifest path are not verified
    - SX-DEC-042 is absent from the visual work-surface registry
    - shared audio vault path cannot be read from this remote-only environment
  allowed_next_actions:
    - v4.3 entry-gate audit and canon/Sheet reconciliation
    - GUT 9.7.1 spec-only Draft PR
    - official source/license/tree/consumer/CI/removal/non-overlap verification
    - HiGodot provenance and authority contract verification
    - visual registry entry for procedural arrows and no-new-asset decision
  decision: BLOCK
```

`BLOCK`은 기능 방향의 재승인이 필요하다는 뜻이 아니다. `SX-DEC-040~042`는 계속 승인 상태다. 구현 진입에 필요한 v4.3 선행 증거가 부족하므로 production 변경만 차단한다.

## SX-DEC-043 — v4.3 entry-state reconciliation

현재 활성 통합 계약은 v4.3이다. 구현 시작 전 Decision Ledger, unresolved/audit list, image review Sheet, current PR/Goal과 merged main을 다시 읽고 표시 상태를 증거로 재계산한다.

```yaml
decision: SX-DEC-043
status: APPROVED_BY_USER_CONTRACT_UPDATE
implementation_ready: false
corrected_entry_status: BLOCKED
protected_gameplay_decisions:
  - SX-DEC-040
  - SX-DEC-041
  - SX-DEC-042
```

기존 `READY` 표시는 GUT 채택 명세, HiGodot authoring authority와 시각 Registry가 닫힐 때까지 `BLOCKED`로 되돌린다.

## SX-DEC-044 — GUT 9.7.1 formal test authority

GUT 9.7.1을 프로젝트의 정식 단위·통합·회귀 테스트 권위로 사용한다. 단, 현재 저장소의 기존 애드온 파일은 v4.3 이전 반입본이므로 소급해 정식 채택 완료로 간주하지 않는다.

필수 순서:

```text
spec-only Draft PR
→ official source/version/license/tree and current divergence review
→ consumer/CI/JUnit/discovery/mutation/removal/non-overlap review
→ exact-HEAD approval and merge
→ merged-main readback
→ separate Phase B installation/reconciliation branch
```

Phase B 전에는 기존 `tests/run_tests.gd`를 삭제하거나 GUT Required Check를 등록하지 않는다.

## SX-DEC-045 — HiGodot single Godot authoring authority

`hi-godot/godot-ai` v3.1.2 계열을 Scene·Node·Resource·Theme·Animation·signal wiring·project settings의 단일 저작 권위로 둔다.

```yaml
canonical_repository: hi-godot/godot-ai
pinned_tag: v3.1.2
pinned_commit: 678b16a6a0a335cf80cbb7d3f85c183cd3e616de
project_plugin_reported_version: 3.1.2
current_authoring_connection: BLOCKED_UNVERIFIED
```

Codex는 production `.gd`, test `.gd`, CI와 문서를 작성할 수 있지만 `.tscn`, `.tres`, `.res`, `project.godot`, signal/NodePath/owner/autoload/InputMap을 직접 저작하지 않는다. 대상 변경에는 `HIGODOT_AUTHORING_MANIFEST`가 필요하다.

현재 대화 도구에는 HiGodot authoring connector가 노출되지 않았으므로 Scene·Resource·project-setting 변경은 `BLOCKED_BY_HIGODOT_AUTHORITY`다.

## SX-DEC-046 — focused visual/audio and component decision

`SX-DEC-042`의 방향 표시는 기존 `RouteControlOverlay`의 절차적 line/polygon arrow를 안전하게 확장한다.

```yaml
visual_action: REUSE_WITH_SAFE_ADAPTATION
new_binary_visual_asset: NOT_REQUIRED
new_audio_asset_for_current_feature: NOT_REQUIRED
shared_audio_vault_consumption_for_current_feature: NOT_APPLICABLE
shared_audio_vault_global_verification: BLOCKED_UNVERIFIED_NO_LOCAL_ACCESS
component_status: COMPONENT_SPEC_READY_AFTER_VISUAL_REGISTRY_SYNC
```

화살표 컴포넌트 계약:

```yaml
component_id: CMP-ROUTE-SWITCH-DIRECTION-ARROWS
purpose: 분기 진입 전에 reciprocal 세 방향과 현재 선택을 표시하고 직접 선택 의도를 전달
states:
  - default
  - selected
  - occupied_locked
  - paused_disabled
  - hidden_in_build
input_methods:
  - mouse
  - touch
  - keyboard_cycle
minimum_touch_target: PROVISIONAL_RECOMMENDED_44_PX_EQUIVALENT
accessibility:
  - selected state uses thickness and fill, not color alone
  - all available directions remain visible
responsive_rules:
  - board-space arrows scale with existing route overlay and viewport stretch
production_authority: HIGODOT_FOR_SCENE_RESOURCE_OR_PROJECT_SETTING_CHANGES
script_authority: CODEX_FOR_PRODUCTION_GD_AFTER_GUT_SPEC_MERGE
```

외부 절대 오디오 경로를 production 파일에 추가하지 않는다.

## Implementation release conditions

`agent/sx-aud-026-route-end-switch-direction` 구현 브랜치는 다음 조건을 모두 만족한 merged main에서 새로 기준화하거나 대체한다.

```text
GUT_SPEC_MERGED_MAIN_VERIFIED
AND GUT formal consumer/CI installation authorized
AND HIGODOT source/connection/authoring manifest path verified for required Godot files
AND SX-DEC-042/SX-DEC-046 visual registry readback PASS
AND entry gate recalculated as PASS
```

조건 전에는 production code, test migration, Scene·Resource·project setting을 변경하지 않는다.
