# SX-AUD-067 · Post-SX-DEC-059 Canon Freshness Closure

Date: `2026-08-21 KST`
Status: `CORRECTION_APPLIED · PR_VALIDATION_REQUIRED`

## Purpose

PR #158로 SX-DEC-059 first-session 구현이 `main`에 병합되고 Notion post-merge readback까지 완료된 뒤에도 일부 current authority가 pre-merge 상태를 유지하는 canonical drift를 교정한다.

이 감사는 **제품 규칙·GDScript·Scene·Resource·map/data·asset을 변경하지 않는다.** 목표는 다음 세 가지뿐이다.

1. current owner가 실제 `main`/Notion과 같은 상태를 말하게 한다.
2. 다음 작업을 구현 재시작이 아니라 developer/physical/human validation으로 이동한다.
3. 동일 종류의 drift를 Project Contract에서 회귀 검출한다.

## Fresh evidence baseline

```yaml
implementation_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
implementation_tree: d82363b2aba21bae3e524fe98e81421b526c0797
notion_project_home_sync: SYNCED
notion_production_handoff: PR_158_MERGED
notion_implementation_readback: PASS
open_implementation_pr: 0
pr_154: CLOSED_UNMERGED
physical_windows: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
```

## Findings

### F1 · P0 · Adapter implementation-state inversion

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

로 교정했다.

### F2 · P1 · Current resume/roadmap next-action drift

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

### F3 · P1 · Playtest authority implementation-state drift

**Before**

`PLAYTEST_PLAN_V4_7_CURRENT.md`가 current authority이면서 `sx_dec_059_implementation: NOT_STARTED`였다.

**After**

PR #158 merge identity와 Notion readback PASS를 기록하고, developer/physical/human evidence는 그대로 `NOT_RUN`으로 유지했다.

### F4 · P1 · Freshness regression blind spot

기존 `tests/python/test_sx_dec_059_implementation_canonical_freshness.py`는 여러 current file을 합친 문자열에서 구현 상태가 하나라도 존재하는지만 봤다. 따라서 한 파일의 올바른 값이 상위 Adapter의 퇴행 값을 가릴 수 있었다. 또한 Project Contract workflow에서 해당 테스트를 직접 실행하지 않았다.

**Correction**

- Adapter / AGENTS / README / START_HERE / Active Context / Current Decisions / Development Gates / Roadmap / Current Playtest Wrapper를 **개별** 검사한다.
- 알려진 pre-merge stale token을 current owner마다 금지한다.
- PR #158 merge identity, PR #154 CLOSED_UNMERGED, manual evidence ceiling, validation-first next action을 회귀 계약으로 고정한다.
- `.github/workflows/project-contract.yml`에서 해당 test를 직접 실행한다.

## Protected boundaries

변경 금지 / 실제 변경 없음:

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
physical/device/human evidence status
```

## Notion synchronization boundary

Notion Production Handoff와 Project Home은 이미 PR #158 merge와 automated/CI/package PASS, physical/human NOT_RUN을 정확히 기록한다.

이번 correction에서 Project Home의 아직 모호한 product-definition field만 GitHub platform owner와 같은 수준으로 최소 갱신한다.

```text
Platform: Android primary / Google Play primary release candidate
Target audience: general puzzle players pending validation
World/Tone: still unconfirmed
```

등급·Families·SDK/data/privacy·store submission·법률 검토는 별도 release evidence owner의 `UNDECIDED/NOT_RUN`을 유지한다.

## Acceptance / completion gate

이 감사는 다음이 모두 참일 때 `PASS · CLOSED`로 승격한다.

```text
branch diff contains only canon/docs/test/workflow changes
strengthened freshness test PASS
Project Contract PASS
Godot regression PASS
Thin Adapter PASS
no unresolved review threads
no REQUEST_CHANGES
PR merge to main
Notion Repo Main SHA / Notes readback updated to closure merge
Issue #3 / #7 current routing updated without closing them
```

## Rollback

이 correction은 product bytes를 변경하지 않는다. 문제가 발생하면 canon-freshness PR을 한 단위로 revert하고 Issue/Notion metadata를 PR #158 implementation state로 되돌린다. PR #158 product implementation 자체는 rollback 대상이 아니다.
