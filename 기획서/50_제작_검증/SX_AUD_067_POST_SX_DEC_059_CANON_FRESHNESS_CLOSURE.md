# SX-AUD-067 · Post-SX-DEC-059 Canon Freshness Closure

Date: `2026-08-21 KST`
Status: `PASS · CLOSED`

## Purpose

PR #158로 SX-DEC-059 first-session 구현이 `main`에 병합되고 Notion post-merge readback까지 완료된 뒤에도 일부 current authority가 pre-merge 상태를 유지한 canonical drift를 교정하고, 같은 회귀를 자동 검출한다.

이 감사는 **제품 규칙·GDScript·Scene·Resource·map/data·asset을 변경하지 않았다.**

1. current owner를 실제 `main`/Notion과 같은 상태로 복구했다.
2. 다음 작업을 구현 재시작이 아니라 developer/physical/human validation으로 이동했다.
3. 동일 종류의 drift를 Project Contract에서 회귀 검출하게 했다.

## Final closure evidence

```yaml
implementation_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_tree: d82363b2aba21bae3e524fe98e81421b526c0797
canon_freshness_pr: 159
canon_freshness_merge_main: e5dfc542616fc0dcad54ae27b4270504bccd459a
pr_159_exact_head: e773266b76bd19de60b8d53363c8cf820484f3eb
project_contract: PASS · run_1282
godot_tests: PASS · run_1213
gut_9_7_1: PASS · run_331
thin_adapter: PASS · run_403
windows_demo_export: PASS · run_257
platform_release_asset_rights: PASS · run_93
pr_159_changed_files: 12 · canon_docs_test_workflow_only
pr_159_behind_main: 0
unresolved_review_threads: 0
request_changes: 0
issue_3: OPEN · CURRENT_ROUTING_SX_AUD_067
issue_7: OPEN · CURRENT_QUALITY_GATE_SX_AUD_067
notion_project_home: SYNCED
notion_repo_main_sha: e5dfc542616fc0dcad54ae27b4270504bccd459a
notion_platform: Android_PRIMARY · Google_Play_PRIMARY_RELEASE_CANDIDATE
notion_target_audience: GENERAL_PUZZLE_PLAYERS_PENDING_VALIDATION
world_tone: UNCONFIRMED
pr_154: CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059
developer_self_run: NOT_RUN
physical_windows: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

Windows Demo Export PASS는 패키지/export 증거이며 physical Windows runtime PASS가 아니다.

## Findings

### F1 · P0 · Adapter implementation-state inversion · FIXED

**Before**

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md`가 current authority이면서:

```text
implementation_execution_state: NOT_STARTED
sx_dec_059_build_started: false
sx_dec_059_technical_implementation: NOT_RUN
PR #154 READ_ONLY
```

를 유지했다.

**After**

```text
implementation_execution_state: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_notion_readback: PASS
PR #154: CLOSED_UNMERGED · SUPERSEDED_BY_SX_DEC_059
```

### F2 · P1 · Current resume/roadmap next-action drift · FIXED

**Before**

Active Context / Development Gates / README / Roadmap 일부가 이미 끝난:

```text
implementation PR merge
→ PR #154 close
→ Notion post-merge readback
```

을 future work로 남겼다.

**After**

```text
developer self-run / screen QA
→ exact acceptance build identity
→ physical smoke
→ Five-person first-contact comprehension
→ product decision
```

을 current next action으로 고정했다.

### F3 · P1 · Playtest authority implementation-state drift · FIXED

`PLAYTEST_PLAN_V4_7_CURRENT.md`를 PR #158 `MERGED_MAIN_VERIFIED` + Notion readback PASS로 갱신했다. developer/physical/human evidence는 `NOT_RUN`을 유지했다.

### F4 · P1 · Freshness regression blind spot · FIXED

기존 freshness test는 여러 current file을 하나로 합쳐 확인해 한 파일의 올바른 값이 다른 current owner의 퇴행을 가릴 수 있었다.

교정:

- Adapter / AGENTS / README / START_HERE / Active Context / Current Decisions / Development Gates / Roadmap / Current Playtest Wrapper를 **개별** 검사한다.
- 알려진 pre-merge stale token을 current owner마다 금지한다.
- PR #158 merge identity, PR #154 `CLOSED_UNMERGED`, manual evidence ceiling, validation-first next action을 회귀 계약으로 고정한다.
- `.github/workflows/project-contract.yml`에서 focused freshness test를 직접 실행한다.
- PR #159 Project Contract #1282에서 GREEN을 확인했다.

### F5 · P1 · Issue execution queue drift · FIXED

Issue #3/#7은 닫지 않고 현재 역할을 유지했다.

```text
#3: Release-Near Vertical Slice umbrella quality/evidence Gate
#7: physical/device/human evidence execution Gate
```

둘 다 SX-DEC-059 PR #158 + canonical freshness PR #159 완료 뒤의 validation chain을 current routing으로 사용한다.

### F6 · P2 · Notion product-definition under-specification · FIXED_MINIMAL

Project Home의 `플랫폼·대상 이용자·세계/톤: 확인 필요`를 GitHub release owner가 이미 확정한 범위만 반영했다.

```text
Platform: Android primary / Google Play PRIMARY_RELEASE_CANDIDATE
Target audience: general puzzle players · validation pending
World/Tone: 확인 필요
```

등급·Families·SDK/data/privacy·store submission·법률 검토는 별도 release evidence owner의 `UNDECIDED/NOT_RUN`을 그대로 유지한다.

## Protected boundaries

실제 변경 없음:

```text
project.godot
game/**
data/**
assets/**
art/product_assets/**
*.tscn / *.tres / *.res
GMB-002 gameplay rules
SX-DEC-056/057/058 implementation authority
VS_DEMO_01 bytes/semantic
73 semantic product PNG + provenance
physical/device/human PASS state
```

## Current next product gate

```text
developer self-run / screen QA
→ designate exact acceptance build
→ reviewed physical smoke on that same build
→ Android device smoke as a separate platform gate
→ Five-person first-contact comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

추가 기능 구현보다 이 player-evidence sequence가 우선한다.

## Remaining non-blocking debt

이번 P0/P1 closure와 분리한다.

```text
Godot AI 3.1.4 exact provenance/local tree parity → P2 · REVERIFY_BEFORE_FUTURE_AUTHORING
.asset-vault legacy tracked 14 → P2 · preserve/hash/reference-check before untrack
```

둘 다 PR #158 제품 구현/자동 검증을 무효화하지 않는다.

## Rollback

이 correction은 product bytes를 변경하지 않는다. 문제가 발생하면 PR #159 canon-freshness merge를 revert하고 Issue/Notion metadata를 PR #158 implementation state로 되돌린다. PR #158 product implementation 자체는 rollback 대상이 아니다.
