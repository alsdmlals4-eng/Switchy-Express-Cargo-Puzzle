# Development Gates

Last updated: `2026-08-26 KST`

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 과거 commit/PR/run은 역사 evidence이며 current next action을 자동 정의하지 않는다.

## 0. Current authority

```yaml
current_work_instruction: v4.8 · 2026-08-26-r5.4-superset-final · SWITCHY_THIN_ADAPTER
work_instruction_role: USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT
base_latest_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
fresh_read_bootstrap: PROJECT_GITHUB_NOTION_ONLY_RECONSTRUCTION_REQUIRED
current_baseline: GMB-002 · AMENDED_BY_SX_DEC_060
current_decisions: SX-DEC-027~060
current_product_gate: SX_DEC_060_POST_MERGE_PACKAGE_PROOF_AND_CANDIDATE
```

## 1. Stable historical implementation evidence

```text
GMB-002 finite core: AUTOMATED PASS · PRE_SX_DEC_060 SEMANTICS
SX-DEC-053/054 semantic assets: 73 PRODUCT PNG · COMPLETE
SX-DEC-055 runtime semantic: PR #151 MERGED_MAIN_VERIFIED
SX-DEC-059 first session: PR #158 MERGED_MAIN_VERIFIED
Playable visual/UX POC: PR #166 MERGED_MAIN_VERIFIED
Physical preflight visual correction: PR #171 MERGED_MAIN_VERIFIED
Candidate 003 preparation: PR #172 MERGED_MAIN_VERIFIED
```

These remain valid for their exact historical bytes and bounded claims. They do not prove SX-DEC-060 runtime behavior.

Stable physical/human anchors remain:

```text
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

## 2. Candidate 003 evidence boundary

```yaml
candidate_id: SX59-POC-ACCEPT-003
package_integrity: PASS
pck_integrity: PASS · 472/472
product_texture_packaging: PASS · 73/73
powershell_51_live_download: PASS
physical_visual_recheck: NOT_RUN
role_after_sx_dec_060: HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY
```

SX-DEC-060 changes gameplay/data bytes. Candidate 003 must not be promoted as the post-change acceptance candidate. Its old Gate 0 instructions remain provenance only.

## 3. SX-DEC-060 Decision Gate

`PASS · USER_APPROVED_RULE · DESIGN_RECORDED`

Canonical rule:

```text
station service iff abs(train_x - station_x) + abs(train_y - station_y) == 1
→ UP / RIGHT / DOWN / LEFT only
→ diagonal excluded
→ station footprint itself excluded

cargo pickup = exact-cell Manual / Auto contact unchanged
LIFO/TOP = unchanged

preflight = start-reachable RUN component
→ all required cargo reachable
→ each required station has >=1 reachable cardinal service cell
→ irrelevant disconnected rail island does not block RUN
```

Technical implementation default:

```yaml
FiniteMapDefinition_schema: 3
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_overlap: FAIL_CLOSED
renderer: EXISTING_STATION_PNG + PROCEDURAL_SERVICE_INDICATOR
new_bitmap_assets: 0
```

## 4. SX-DEC-060 planning / handoff gate

`PASS · EXECUTED_AND_MERGED_MAIN_VERIFIED · PR #188`

Binding owners:

```text
docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md
docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md
docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md
기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md
```

Actual GDScript/Scene/Resource/map/runtime work is merged-main verified by PR #188; this handoff package remains implementation provenance.

## 5. SX-DEC-060 RED→GREEN runtime chain

S60-1~S60-10 implementation, regression, review, merge, and Notion readback are complete on `main` PR #188. Package and physical gates remain `NOT_RUN`.

```text
S60-1 schema-v3 + service-cell definition RED/GREEN
→ S60-2 cardinal delivery RED/GREEN
→ S60-3 start-reachable preflight RED/GREEN
→ S60-4 station footprint removed from v3 rail graph
→ S60-5 active map/tutorial migration + deterministic witnesses
→ S60-6 procedural service overlay with existing station PNGs
→ S60-7 T2 copy/localization update
→ S60-8 full current canon/static freshness reconciliation
→ S60-9 full Godot/static/package proof
→ S60-10 five-pass adversarial exact-head close
```

Each production behavior family must follow:

```text
write failing test
→ run and observe expected RED
→ minimal implementation
→ focused GREEN
→ full regression
→ commit
```

## 6. Map / schema gate

Required post-060 properties:

- current active finite maps use `FiniteMapDefinition` schema v3;
- station placement does not require a rail anchor;
- station footprint is excluded from player-buildable cells;
- cargo remains a direct-contact route object;
- current map IDs/revisions/ruleset/solution identities are explicitly migrated;
- deterministic witnesses are recomputed from actual intended v3 bytes;
- schema v2 historical bytes are not silently reinterpreted as v3.

Known active map locators must be re-inventoried from current main before editing:

```text
data/maps/fp_core_proof_01.json
data/maps/vs_demo_01.json
data/maps/tutorial/tut_01_02.json
data/maps/tutorial/tut_03_lifo.json
data/maps/tutorial/tut_04_selective_load.json
data/maps/tutorial/tut_05_auto_load.json
data/maps/tutorial/tut_06_switch.json
```

## 7. Delivery gate

Required tests:

```text
UP one tile → unload matching TOP group
RIGHT one tile → unload
DOWN one tile → unload
LEFT one tile → unload
station footprint → no unload
diagonal → no unload
distance 2+ → no unload
mismatched TOP → no unload
matching contiguous TOP group → existing behavior preserved
overlapping service ownership → fail closed
```

No multi-station priority is invented.

## 8. Preflight gate

Required tests:

```text
required cargo unreachable → FAIL
station has no reachable cardinal service cell → FAIL
station cardinal service reachable → PASS
diagonal-only station proximity → FAIL
irrelevant disconnected rail island → PASS
disconnected island containing required cargo → FAIL
invalid reachable switch/crossing → FAIL
invalid unreachable island → does not block active RUN
repeated validation → deterministic
```

Preflight is RUN safety/coverage, not a global topology linter.

## 9. UI / actual asset consumer gate

Existing actual station bitmap consumers stay:

```text
core_station_red_normal_v01.png
core_station_blue_normal_v01.png
core_station_yellow_normal_v01.png
```

SX-DEC-060 creates no new bitmap asset. `ProductBoardRenderer` adds a procedural static service indicator on cardinal service cells and exposes deterministic descriptors for tests.

The indicator must not obscure:

- rail geometry;
- cargo color+shape+text identity;
- train position;
- current switch/route state;
- stronger preflight problem outline.

Explanation sheets/full-screen concept images are not production assets.

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
visual_continuity: existing E+D Hybrid / Neo-Arcade visual language
```

When a verified runtime node/key/path proves a missing bitmap slot, generate only that required image automatically, save it in the tracked project-local asset path and the Notion Visual/Asset destination, record provenance/SHA-256, and read the Notion destination back. A per-image approval is not required; a concrete consumer and the existing visual language remain mandatory.

## 10. First-session / localization gate

Current flow remains T1→T6→Capstone. T2 changes mental model:

```text
Cargo: pass through the cargo tile to load.
Station: pass through one of four cardinal adjacent tiles to deliver.
Diagonal: no delivery.
```

Languages:

```text
ko
en
ja
zh-Hans
```

`zh-Hant` remains deferred. No raw localization key or text-in-PNG.

## 11. Automated validation gate

At implementation exact head, run current repository test/workflow owners discovered from merged main. Minimum known commands:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
```

Also run every new SX-DEC-060 freshness/map/witness/package contract and all required PR checks. Never report an unexecuted command as PASS.

## 12. Five-pass adversarial gate

Minimum complete loops after implementation:

1. cardinal delivery / cargo contact / LIFO / outcome semantics;
2. reachable topology / station coverage / safety / disconnected-island behavior;
3. schema-v3 / active map inventory / revisions / identities / witnesses;
4. renderer / actual asset consumers / localization / accessibility;
5. governance / current canon / Notion / Candidate 003 history / 056–058 / PR #174 / evidence ceiling.

Any finding is fixed and the affected full loop is repeated. `CLEAN_REVIEW_EXIT` is unavailable before all five loops are clean on exact head.

## 13. Post-implementation package / physical gate

Blocked until S60-1~10 are complete.

```text
SX60-POC-ACCEPT-002 isolated title → briefing → build visual/input observation complete (minimum source main 0e882764b837d13282a7642b115948d4e061d163)
→ Windows full physical smoke
→ audio perceptual QA
→ Android device smoke
→ Five-person first-contact comprehension
→ player-experience decision
```

Each gate is independent. Package/CI does not imply physical. Windows does not imply Android. Device does not imply human/player experience.

## 14. Concurrency / protected scope gate

```text
PR #174 → PRE_EXISTING_DRAFT · READ_ONLY
SX-DEC-056A → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B → BLOCKED
SX-DEC-057 → IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058 → IMPLEMENTATION_NOT_AUTHORIZED
endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset → NON_CURRENT
Base repin → NOT_AUTHORIZED
arbitrary station radius/diagonal/multi-station priority → OUT_OF_SCOPE
new generated image without concrete game consumer → OUT_OF_SCOPE
```

## 15. Runtime route readability gate · GitHub Issue #197

`MERGED_MAIN_VERIFIED_LOCAL_EVIDENCE · PR #198 · main a8eee4f875a95e8da69802c4e60452df3535fe0e`

```text
actual finite render snapshot + route-control state
→ procedural selected/unselected/occupied-locked trace
→ result-state trace retention
→ official headless-runner descriptor and resolution hierarchy regression
→ headless full suite + current contract checks
→ live 1280×720 screenshot/diagnostics
→ five-pass review + Notion readback
```

Official headless runner (112 cases / 13,480 assertions), Project Contract, GUT, and Godot 4.7.1 headless parse passed on the exact PR head. GitHub CI runs stayed queued without jobs, so the user explicitly authorized this merge bypass; remote CI GREEN and human/device acceptance remain unclaimed.

No bitmap asset is created: this gate is an existing `ProductBoardRenderer`/`RouteControlOverlay` consumer correction. It must not change station service, cargo contact, LIFO/TOP, preflight reachability, or PR #174.
