# SX-AUD-035 · Current Decision Registry Authority Refresh

**Date opened:** 2026-08-08 KST  
**Initial refresh date:** 2026-08-09 KST  
**Post-batch recurrence refresh:** 2026-08-09 KST  
**SX-DEC-055 recurrence refresh:** 2026-08-10 KST  
**Related decisions:** status registry through `SX-DEC-055`; no new Decision ID  
**Authority repair type:** `BOUNDED_STATUS_REGISTRY_MAINTENANCE`

## Resolution

`SAME_ID_SX-AUD-035 · BOUNDED_AUTHORITY_REFRESH · NO_PRODUCT_DIRECTION_CHANGE · NO_RUNTIME_IMPLEMENTATION_CHANGE`

This audit tracks bounded repairs of `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md` when the compact status registry drifts behind registered owner documents and the configured Google Sheet. It never creates gameplay/product rules and never widens runtime, device, physical, or human validation evidence.

## Historical repairs retained

### Initial refresh — PR #124

The first repair closed an older PR #106-era registry drift. Historical validation evidence retained:
- exact head `cbfbf8111d2a3aa664beef9cc917f73ef74c107f`;
- Project Contract `31318702082` PASS;
- GUT `31318702125` PASS;
- Godot `31318702096` PASS;
- Thin `31318702099` PASS;
- unresolved review threads 0;
- merge/main `24d2e1121be7f967dfdd5246e1070cde4214772c`.

### SX-DEC-053 post-batch recurrence — PR #127

After the first authoritative slice batch, the compact registry still described 31 product assets and all semantic splits pending while owner docs/Sheet had moved to 39 assets and eight authoritative slices. That recurrence was repaired under this same audit ID, not a new product decision.

Historical recurrence evidence retained:
- recurrence baseline `2023f5c62afacfebd894010d3838880e6b7acf73`;
- PR #127 exact head `7b4c9a3c41bd438dff73715d42163054ce87628a`;
- Project Contract `31321244543` PASS;
- GUT `31321244524` PASS;
- Godot `31321244551` PASS;
- Thin `31321244527` PASS;
- review threads 0;
- merge/main `de302e7cfd56a23d53a6ec97509195564e36749d`;
- configured Sheet same-ID readback PASS.

Subsequent `SX-DEC-054` RUN/BUILD/VFX semantic batches and their closure moved the current asset package to 73 physical product PNGs while runtime integration remained a separate gate.

---

## 2026-08-10 recurrence: SX-DEC-055 runtime POC gate merged but compact registry stale

### Fresh authority recovery before repair

Required project-start recovery was performed before this write:

- Base repository current structure was reread;
- upstream Base current main observed: `53e63f7ebefbb5b2fc0dc528e335252692801421`;
- project remains pinned to Base v9.4.3 under `AGENTS.md`; upstream observation does not repin the project;
- project default branch: `main`;
- `SX-DEC-055` spec merge/current main: `34624a5d2a93306cd2b3c72dee6ce0035b751279`;
- open project PRs after PR #135 merge: 0;
- configured Google Sheet metadata and `02_현재_확정결정` rows for `SX-DEC-054`/`SX-DEC-055` were reread live;
- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md` and its approved design spec were merged on main;
- `CURRENT_CONFIRMED_DECISIONS.md` was reread from that main before repair.

### Authoritative SX-DEC-055 evidence

User approvals:
- runtime POC approval: `USER_APPROVAL_2026-08-10_RUNTIME_POC`;
- written spec approval: `USER_SPEC_APPROVAL_2026-08-10`.

Docs/spec PR #135:
- exact approved head: `383937ffe898d45b42d68cf21ef46d61981e4e09`;
- changed files: exactly two docs (`SX_DEC_055_RUNTIME_SEMANTIC_POC.md` and approved design spec);
- Project Contract `31350446399`: PASS;
- GUT 9.7.1 `31350446400`: PASS;
- Godot Tests `31350446412`: PASS;
- Thin Adapter Migration `31350446401`: PASS;
- mergeable at validation time: true;
- squash merge/main: `34624a5d2a93306cd2b3c72dee6ce0035b751279`.

The configured Sheet `SX-DEC-055` row was reconciled after merge to `SPEC_APPROVED · DOCS_MERGED_MAIN_VERIFIED · GODOT_IMPLEMENTATION_NOT_STARTED` with the exact PR/head/merge evidence.

### Reproduced compact-registry conflict

On main `34624a5d...`, the compact registry still contained stale pre-gate statements:

- `current_decision_span: SX-DEC-027~054`;
- no `SX-DEC-055` registry row;
- `visual_asset_state ... RUNTIME_POC_DEFERRED`;
- execution authority saying a separate runtime POC gate was still required;
- no runtime-semantic-POC delivery anchor;
- Base observation still showed the older upstream readback.

This conflicts with the merged owner decision and synchronized Sheet, which now explicitly authorize the bounded `SX-DEC-055` POC. The conflict is status-registry lag only. No gameplay/product semantics conflict was found.

### Repair contract for this recurrence

The compact registry must:

1. extend current decision span through `SX-DEC-055`;
2. record `SX-DEC-055` as the latest runtime semantic POC authority;
3. distinguish `SPEC_APPROVED/DOCS_MERGED` from actual Godot implementation, which remains not started;
4. preserve the 73-product semantic package and historical `runtime_integrated=false` manifest provenance;
5. record the RED-first implementation plan path;
6. preserve route geometry/cycle/lock authority and all finite-puzzle hard constraints;
7. preserve the combo boundary: resolve the semantic asset but introduce no new gameplay/domain trigger solely for VFX;
8. preserve Windows physical, Android device, connected editor, broader human, `.asset-vault`, and production-cutover evidence ceilings;
9. record project Base pin v9.4.3 separately from current upstream Base observation;
10. create no new Decision ID or product rule.

### Exact implementation DoR plan

The same docs-only repair package authors:

`docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

The plan is implementation instruction, not implementation evidence. It specifies RED-first tasks for:
- manifest-backed `SemanticAssetCatalog`;
- pure semantic runtime-state resolver;
- read-only manual-load projection from existing `FiniteGameplayInputState`;
- representative HUD Stack/load/preflight binding;
- BUILD placement/focused-preflight reinforcement;
- route-control semantic reinforcement with direction-target invariance tests;
- semantic event overlay with Reduced Motion information equivalence;
- wiring through existing pickup/unload/route-selection/terminal presentation seams;
- combo runtime trigger deferral when no existing presentation-readable seam exists;
- final exact-head automated regression and same-ID closure.

Per project `AGENTS.md`, actual Godot/GDScript/test execution belongs to Codex after this DoR package is merged and authority is reread.

## Expected changed surface for this recurrence

Docs-only changes are limited to:

- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`;
- `기획서/50_제작_검증/SX_AUD_035_CURRENT_DECISION_REGISTRY_STALE.md`;
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`.

No `.gd`, `.tscn`, `.tres`, `.res`, `project.godot`, workflow, plugin, map/data, test implementation, validator, candidate/product PNG, semantic sidecar, audio, or `.asset-vault` byte belongs in this DoR repair.

## Validation and delivery rule

Before merge:
- compare branch against `34624a5d2a93306cd2b3c72dee6ce0035b751279`;
- confirm exactly the three docs above changed;
- validate the final unchanged PR head with all applicable hosted checks;
- require unresolved review threads = 0 and mergeability true;
- merge using expected-head protection.

After merge:
- re-read project main/open PRs and compact registry;
- update the existing configured Sheet `SX-AUD-035` row with this recurrence evidence;
- update the existing `SX-DEC-055` Sheet row to the exact DoR-ready state and plan/merge evidence;
- re-read both Sheet rows;
- do not claim Godot implementation, Windows physical, Android device, connected editor, or human PASS.

## Evidence ceiling after this DoR repair

Still not completed by this docs-only work:

```text
SX-DEC-055 Godot/GDScript runtime POC implementation: NOT_STARTED
Combo runtime trigger without an existing presentation-readable seam: DEFERRED
Windows physical runtime / visual / audio / physical input: NOT_RUN
Android landscape device smoke: NOT_RUN
Connected physical Godot/Hera editor session: NOT_RUN
Broader human / comprehension: NOT_RUN
.asset-vault legacy untrack: DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION
Production cutover: BLOCKED_DEFERRED
```

The result of this recurrence repair is a current compact authority registry plus an implementation-ready Codex plan. It is not runtime implementation evidence.
