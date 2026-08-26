# GPT Work Handoff · SX-DEC-060

Date: `2026-08-26 KST`
Handoff target: `ChatGPT Work`
Status: `IN_PROGRESS · DO_NOT_TREAT_AS_MERGED_OR_RUNTIME_VERIFIED`

## 1. Fresh-read rule

This handoff is a resume locator, not a replacement for current authority. GPT Work must fresh-read before mutation:

```text
Base latest completed main
→ Base AGENTS.md + current Skill Registry/generated map
→ Project latest completed main
→ all open/draft PRs
→ Project Notion Home + Direction/Planning + Production/Validation + Visual owner as relevant
→ Project AGENTS.md
→ v4.8 r5.4 Switchy adapter
→ CURRENT_CONFIRMED_DECISIONS.md
→ ACTIVE_CONTEXT.md
→ SX-DEC-060 decision/spec/plan
→ actual current Godot code/data/tests
```

If GitHub / Notion / this handoff disagree, use fresh current sources and return to `CONTEXT_DRIFT_RECHECK_REQUIRED` before mutation.

## 2. Repository state at handoff

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
main_at_handoff: d4b3ce5454c6a30ce4f004136f91f26c7e099d44
main_commit_title: docs: lock compact LIFO cargo stack visual rule (#179)
current_task_pr: 180
current_task_branch: docs/sx-dec-060-cardinal-station-service-20260826
pr_head_at_handoff: 670364e4ffd573655b2d976b79a600b16c3d8e4d
pr_state_at_handoff: OPEN · INCOMPLETE
other_open_pr: 174 · PRE_EXISTING_DRAFT · READ_ONLY
```

Do not modify/rebase/merge/absorb PR #174 without separate explicit authorization.

## 3. User-approved product change · SX-DEC-060

Approved current intent:

1. A station is **not a rail tile the train must enter**.
2. Delivery triggers when the train enters a cell at exactly one cardinal step from the station:
   - UP
   - RIGHT
   - DOWN
   - LEFT
3. Diagonal adjacency does **not** deliver.
4. Cargo pickup remains exact-cell contact using the existing Manual / Auto load rules.
5. Unlimited LIFO / TOP contiguous matching-group unload semantics remain unchanged.
6. All placed rail pieces do **not** need to belong to one globally connected network.
7. A disconnected rail island that is irrelevant to the actual start-reachable RUN route must not fail preflight merely because it is disconnected.

## 4. Selected design direction

Trade study recorded in SX-DEC-060:

- A: keep station as rail anchor + add adjacent delivery → rejected because data semantics become contradictory.
- B: off-track station + exact one-cardinal-cell service rule → selected.
- C: generic configurable catchment/radius system → rejected as unnecessary generalization for the approved rule.

Prepared technical default, subject to current-source recheck during implementation:

```text
FiniteMapDefinition schema v3
station footprint = off-track / non-buildable service object
station service predicate = abs(dx) + abs(dy) == 1
cargo required reachability = exact cargo cell
station required reachability = at least one cardinal service cell in the start-reachable RUN component
irrelevant disconnected player rail = allowed
```

Do not silently generalize the radius, add diagonal service, or introduce arbitrary catchment metadata.

## 5. Actual code mismatch already verified

Current completed main still implements the old behavior:

- `game/finite/delivery/finite_delivery_loop.gd`
  - station unload is keyed by `station.cell` and happens only when the train enters the station cell.
- `game/finite/build/preflight_validator.gd`
  - current preflight requires every required station/cargo anchor to be reachable from start.
- `game/finite/map/finite_map_definition.gd`
  - schema v2 includes station placements in required/fixed anchor semantics.
- `game/finite/rail/finite_track_graph_builder.gd`
  - authored station anchors can become graph pieces under the old model.
- `game/demo/presentation/product_board_renderer.gd`
  - already has real station PNG consumers; station service-zone signaling can be procedural first.

This proves SX-DEC-060 runtime is `NOT_RUN`, not implemented.

## 6. Image / visual production boundary

User clarified that production images are created only when there is a real game consumer.

Current rule:

```yaml
new_explanation_sheets: FORBIDDEN_AS_PRODUCTION_BACKLOG
new_bitmap_for_sx_dec_060: 0
station_art: REUSE_EXISTING_PRODUCT_PNGS
station_service_zone: PROCEDURAL_FIRST
cargo_stack_visual_rule: VIS-SX-059-05
```

`VIS-SX-059-05` remains the approved cargo silhouette rule:
- short train;
- compact vertical LIFO cargo tower;
- clear TOP;
- no long freight-tail silhouette;
- exact full stack order remains the Stack HUD responsibility.

Do not generate a new PNG until a concrete runtime consumer/key/path proves it is required.

## 7. Planning/canon artifacts already created on PR #180

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
tests/python/test_sx_dec_060_canonical_freshness.py
```

Current owners on the branch were also partially migrated to SX-DEC-060, including AGENTS/README/START_HERE/CURRENT_CONFIRMED_DECISIONS/ACTIVE_CONTEXT/ROADMAP/DEVELOPMENT_GATES/FINITE_DELIVERY_PUZZLE_BASELINE/CORE_GAMEPLAY/project skill.

## 8. TDD / CI state at exact handoff head

Initial RED was intentionally observed after adding the new canonical-freshness expectation.

Exact head at handoff: `670364e4ffd573655b2d976b79a600b16c3d8e4d`

Known exact-head results:

```yaml
Validate_Thin_Adapter_Migration: PASS
Validate_platform_release_and_asset_rights: PASS
GUT_9_7_1: PASS
Godot_Tests: PASS
Project_Contract: FAIL
Windows_Demo_Export: FAIL
```

`Project Contract` fails at:

```text
Validate Android smoke canonical freshness
```

The Windows export workflow fails during its Python-contract stage, before Godot download/export, so **no new Windows export result exists for this head**.

Do not claim PR #180 GREEN, complete, review-clean, merge-ready, or runtime-verified.

## 9. Known incomplete canonical-freshness work

Work stopped while reconciling old `SX-DEC-059 / Candidate 003 current-gate` assumptions with the newly approved SX-DEC-060 product meaning.

At minimum, GPT Work must re-audit:

```text
tests/python/test_android_smoke_canonical_freshness_contract.py
tests/python/test_v48_protected_canon_freshness.py
README.md
기획서/10_경험/CORE_GAMEPLAY.md
기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md
skills/switchy-express-design/SKILL.md
Notion Home / Direction / Production current-next-gate wording
```

Historical SX-DEC-059 / Candidate 003 evidence must remain discoverable as exact pre-change evidence; it must not be deleted or rewritten as if it never existed.

## 10. Candidate/evidence interpretation

`SX59-POC-ACCEPT-003` is exact historical pre-SX-DEC-060 evidence.

It must not be used as the acceptance candidate for the changed gameplay semantics after SX-DEC-060 implementation. Do not spend user physical-validation time proving an obsolete product meaning before the new runtime exists.

Current evidence ceiling:

```yaml
sx_dec_060_user_rule: APPROVED
sx_dec_060_design: PREPARED
sx_dec_060_implementation_plan: PREPARED
sx_dec_060_runtime: NOT_RUN
sx_dec_060_full_regression: NOT_RUN
post_sx_dec_060_candidate: NOT_CREATED
windows_physical: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
```

## 11. Next first action in GPT Work

Do **not** start Godot product code immediately.

First:

1. fresh-read current Base main, project main, PR #180 exact head/checks, PR #174 read-only state, and exact Notion pages;
2. continue PR #180 canonical-freshness reconciliation until all active human/repository consumers describe the same SX-DEC-060 intent;
3. update stale Python freshness contracts instead of weakening or deleting their protection;
4. sync Notion human-facing current rule/next gate and read it back;
5. run minimum five full adversarial loops on the final planning/canon state;
6. require exact-head CI GREEN before any merge claim;
7. merge PR #180 only if it remains the single current-task PR and all gates are satisfied;
8. post-merge re-read main + Notion.

Only after the planning/canon package is merged should actual Godot product implementation start from that merged authority.

## 12. Godot implementation owner boundary

Under the current Base/project contract, ChatGPT Work remains the persistent orchestration/planning/review surface. Actual GDScript/Scene/Resource/runtime product mutation follows the project's Godot implementation-owner policy and `SX_DEC_060_CODEX_HANDOFF_PACKAGE.md` unless the user explicitly changes that governance.

Codex implementation must independently fresh-read Project GitHub + Notion; it must not treat this handoff as a stale executable instruction.

## 13. Protected scope

Do not absorb or expand:

```text
SX-DEC-056A / 056B
SX-DEC-057
SX-DEC-058
score / max-combo authority
new solver / optimal route reveal
endless / fuel / BOOST / capacity-8 / cargo slowdown / pickup respawn / switch auto-reset
Base repin
PR #174
new generated production images without a proven consumer
physical/device/human evidence inflation
```

## 14. GPT Work resume prompt

Use this as the first instruction inside the Switchy Express Work workspace:

```text
Switchy Express 작업을 재개해.
과거 채팅을 정본으로 가정하지 말고 Base 최신 completed main, 프로젝트 GitHub latest completed main, 모든 open/draft PR, Switchy Notion Home/Direction/Production/Visual, AGENTS.md, v4.8 r5.4 adapter, CURRENT_CONFIRMED_DECISIONS, ACTIVE_CONTEXT, 그리고 PR #180의 docs/handoffs/2026-08-26-gpt-work-handoff-sx-dec-060.md를 fresh-read해 현재 상태를 재구성해.

현재 사용자 승인 핵심은 SX-DEC-060: 역 상하좌우 정확히 1칸을 지나면 자동 배송, 대각선 제외, 모든 선로가 하나의 네트워크일 필요 없음. Cargo exact-cell Manual/Auto와 unlimited LIFO/TOP 의미는 유지.

PR #180은 인수인계 시점에 미완료이며 exact head 670364e4ffd573655b2d976b79a600b16c3d8e4d에서 Project Contract와 Windows Demo Export가 freshness/Python contract 때문에 실패했다. 완료/병합됐다고 가정하지 말고 현재 상태를 다시 확인해.

먼저 PR #180 canonical-freshness + Notion sync + 5회 적대적 검토 + exact-head CI를 닫고, 안전하면 merge/post-merge readback까지 진행해. 그 다음에만 SX-DEC-060 실제 Godot 구현 handoff로 넘어가.
```
