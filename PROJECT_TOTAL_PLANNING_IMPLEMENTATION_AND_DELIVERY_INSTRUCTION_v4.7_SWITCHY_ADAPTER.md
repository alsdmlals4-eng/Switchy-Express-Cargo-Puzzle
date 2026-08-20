---
contract_name: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION
contract_version: '4.7'
revision: '2026-08-20-r1'
project: SWITCHY
status: CURRENT_PROJECT_THIN_ADAPTER
source_role: USER_PROVIDED_V4_7_CONTRACT
source_filename: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7(4).md
source_sha256: 767bbe3d69e9a0acb0e5706321564ad8c04a451f7c54914a2bbdd7579f642037
source_bytes: 93063
source_lf_count: 3386
adapter_policy: THIN_ADAPTER_DO_NOT_DUPLICATE_BASE_CANON
base_remote_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN_REFERENCE_ONLY
project_base_pin: v9.4.3
human_workspace: NOTION_DEFAULT_PROJECT_WORKSPACE
runtime_structured_authority: GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME
google_sheets_policy: MIGRATION_ONLY_UNTIL_REMOVAL
figma_policy: DEPRECATED_NOT_ACTIVE_AUTHORITY
tool_hub_policy: NOT_USED_AS_DEFAULT_OR_REQUIRED_PROJECT_PATH
qa_evidence_studio_policy: NOT_USED_AS_DEFAULT_OR_REQUIRED_PROJECT_PATH
planning_completion_trigger: USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION
user_planning_complete_gate: GRANTED_2026_08_20_KST
current_decision: SX-DEC-059
implementation_execution_state: NOT_STARTED
codex_handoff_policy: ON_DEMAND_CODEX_HANDOFF
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
---

# Switchy Express · v4.7 Project Adapter

이 파일은 사용자가 2026-08-20 제공한 **v4.7 원문을 프로젝트에 중복 복제하지 않고**, Switchy Express에서 필요한 current authority와 project-specific override만 고정하는 thin adapter다.

## 1. 권위 순서

```text
사용자의 최신 지시 / 승인
→ 현재 환경 system/developer/security
→ 이 프로젝트 AGENTS.md
→ 이 v4.7 Switchy adapter + 사용자가 제공한 v4.7 원문 identity
→ CURRENT_CONFIRMED_DECISIONS / ACTIVE_CONTEXT / 분야 정본
→ 실제 code/data/Scene/Resource/assets/tests
→ project Base v9.4.3 local pin
→ Base remote latest completed main · REFERENCE_ONLY
→ 외부 근거
```

Base remote current main은 매 작업 fresh-read하지만 자동 repin하지 않는다.

## 2. 현재 승인 상태

```yaml
product_baseline: GMB-002
current_decision_span: SX-DEC-027~059
sx_dec_059_direction: USER_APPROVED
sx_dec_059_gm_01: A_SELECTED · T2 prerequisite action / T4 selective strategy
sx_dec_059_planning_complete: GRANTED · explicit user "기획완료" · 2026-08-20 KST
sx_dec_059_human_evidence: NOT_RUN
sx_dec_059_build_started: false
```

`기획완료`는 SX-DEC-059의 현재 승인된 기획 내용을 잠그는 Gate다. 새 코어 방향·범위 확대·파괴적 migration·추가비용·계정/보안 권한 확대는 별도 사용자 결정이 필요하다.

## 3. 현재 구현 목표

Release-near first-session Vertical Slice:

```text
T1 Track Connection
→ T2 Cargo/Station + basic manual pickup prerequisite
→ T3 LIFO/TOP reverse planning
→ T4 selective manual non-load + revisit
→ T5 Auto ON safe segment / OFF decision segment
→ T6 switch execution
→ existing VS_DEMO_01 Capstone
→ evidence-safe Result / Retry / Edit
```

새 tutorial map target은 5개이며 `VS_DEMO_01`은 기존 bytes/semantic을 우선 보존한다.

## 4. 보호 범위

- GMB-002 finite delivery core.
- manual-load default, auto toggle, unlimited LIFO, TOP contiguous unload.
- route topology/cycle/U-turn/occupied-lock/time/failure/save/ruleset authority.
- historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset는 비현행.
- SX-DEC-056/057/058 implementation은 059에 흡수하지 않는다.
- BMK-R09/R10은 POST_VALIDATION_HOLD.
- 기존 73 semantic product PNG와 provenance를 우선 재사용한다.
- 이미지 생성은 사용자의 명시적 이미지 생성 요청 전 수행하지 않는다.
- 현재 별도 Draft PR #154는 이 059 작업에서 READ_ONLY이며 vendor/absorb/rebase/close/merge하지 않는다.

## 5. 데이터·UI 경계

- Tutorial metadata는 `FiniteMapDefinition` schema v2에 넣지 않는다.
- onboarding은 `FirstSessionDirector + FirstSessionStagePolicy` sidecar가 소유한다.
- StagePolicy는 UI visibility와 keyboard/touch를 포함한 allowed-command를 함께 통제한다.
- product/domain command 의미를 바꾸지 않는다.
- player-facing copy는 localization key/data로 분리한다.
- 최소 언어: ko / en / ja / zh-*; exact zh variant는 implementation package의 localization owner에서 고정한다.
- responsive 목표는 pc_standard / pc_wide_or_ultrawide / mobile_landscape의 동일 정보 위계다.

## 6. Evidence ceiling

```yaml
finite_core_automated: PASS_HISTORICAL_CURRENT_BASELINE
sx_dec_055_runtime_semantic: MERGED_MAIN_VERIFIED
sx_dec_059_technical_implementation: NOT_RUN
sx_dec_059_developer_self_run: NOT_RUN
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

자동 test/export/self-run은 사람 재미·이해 PASS가 아니다.

## 7. Build / Codex Gate

v4.7에 따라 제품 BUILD는 다음 순서만 허용한다.

```text
user planning complete
→ fresh Phase-C final review
→ project canon/Notion readback
→ package Definition of Ready
→ USER_REQUESTED_CODEX_HANDOFF
→ NEW POWERSHELL · LOCATION FIRST
→ codex.cmd -a never -s workspace-write
→ RED → expected fail → minimal GREEN → regression
```

현재 `기획완료`는 받았지만 **Codex 실행 요청은 별도**다. 이 채팅에서는 구현 패키지를 준비할 수 있으나 PowerShell/Codex/Godot BUILD를 실행했다고 주장하지 않는다.

## 8. Tooling freshness

- Godot target: `4.7.1-stable`.
- GUT: `9.7.1` current project test authority.
- project `addons/godot_ai/plugin.cfg`: `3.1.4` observed.
- upstream godot-ai main plugin: `3.1.5` observed at commit `09a1e3311015153d967710fbe6502ac519585a9b`.
- prior verified release basis in project tooling state: `v3.1.3` / `22678e5f9b038d7203d6b43b0aae20a5417c500e`.
- therefore project 3.1.4 exact provenance/local parity is `REVERIFY_REQUIRED_BEFORE_BUILD`, not guessed as an official 3.1.4 release.

## 9. Human-facing sync

Notion is the default human-facing project workspace. GitHub remains structured/runtime authority. Google Sheets is migration-only and must not be revived as the active work surface.

Current Notion surfaces to keep in sync:

- Project Home
- `07 · SX-DEC-059 · First-Session Vertical Slice`
- `03 · UI · 퍼즐 Flow Map`
- `02 · 비주얼 바이블` / 059 visual briefs
- Production/Handoff when the Codex package is handed off

## 10. Rollback

This adapter does not delete v4.5 r2 historical payload. If v4.7 adoption must be rolled back, restore `AGENTS.md` and current entrypoint references to the prior adapter/manifest; historical files remain available for audit.