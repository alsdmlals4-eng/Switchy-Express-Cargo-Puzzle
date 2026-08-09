# SX-AUD-035 · Current Decision Registry Authority Refresh

**Date opened:** 2026-08-08 KST  
**Refresh date:** 2026-08-09 KST  
**Related decisions:** `SX-DEC-027~053` status registry; no new Decision ID  
**Refresh baseline main:** `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`  
**Base readback at refresh:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Resolution

`BOUNDED_AUTHORITY_REFRESH · SAME_ID_SX-AUD-035 · NO_PRODUCT_DIRECTION_CHANGE · NO_RUNTIME_CHANGE`

This audit originally reported that `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md` was too stale to be used as the sole recovered status source. The separate bounded refresh required by that finding is now the active scope of this audit.

The refresh changes only the compact current-status registry and this audit record. It does not create a new gameplay/product decision, change Godot runtime behavior, mutate Scene/Resource/Theme/Animation/signal/project settings, or promote any unvalidated physical/device/human gate.

The GitHub merge containing this refresh becomes the registry-refresh delivery merge. Its final merge SHA is intentionally recorded in the configured Google Sheet after merge, because a file cannot truthfully embed the SHA of its own future merge commit before that commit exists.

## Fresh authority readback

Required project-start recovery was performed again before editing:

- Base repository default branch: `main`;
- Base current main: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`;
- project default branch: `main`;
- project current main at refresh start: `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`;
- project open PRs at refresh start: `0`;
- configured Google Sheet metadata and current decision/audit rows were re-read live;
- user had separately confirmed the local checkout HEAD at the refresh baseline as `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd` after Pull origin. This is repository-sync evidence only, not runtime validation.

The project remains pinned to Base v9.4.3 by `AGENTS.md`; the newer Base upstream main readback is operational reference evidence and does not silently repin the project.

## Original stale conflict reproduced

At the refresh baseline, `CURRENT_CONFIRMED_DECISIONS.md` still reported an older PR #106-era snapshot including:

- `current_decision_batch: GMB-003`;
- no `SX-DEC-043~053` registry rows;
- `verified_code_main: 12d1ef9b5c49e401d32dfc283db11a12574b5da3` as if it were the current overall status anchor;
- `BLUE_ONE_SIDED_STATION_USER_FAIL_STALE_RUNTIME_EVIDENCE`;
- route-end and switch-direction local F5 retest requirements that predated the later current-main user PASS evidence;
- no `SX-DEC-049` feature/physical closure;
- no `SX-DEC-050` planning package, `SX-DEC-051` candidate package, `SX-DEC-052` tooling reconciliation, or `SX-DEC-053` final product-asset authority.

That conflict was therefore still real and was not treated as closed merely because later owner documents and Sheet rows existed.

## Current evidence used for the refresh

### Product/runtime decisions

The configured Sheet and registered GitHub evidence now support the following bounded current status:

- `SX-DEC-041`: merged automated route-end ordering plus later user current-main Godot 4.7.1 F5 PASS for BLUE no-cargo `FAILURE/ROUTE_END` without the old assertion/process termination and final-delivery SUCCESS priority;
- `SX-DEC-042`: merged automated switch/direct-selection behavior plus later user current-main F5 PASS for three arrows, direct selection, incoming-direction U-turn, and occupied lock;
- `SX-DEC-046`: same current-main visual/control PASS applies to the procedural RouteControlOverlay component; no new binary visual/audio asset;
- `SX-DEC-049`: PR #110 feature merge plus PR #111 physical closure; user F5 pickup/retry scenarios 3/3 PASS.

`SX-AUD-033` remains historical evidence of the earlier stale-local runtime fingerprint. It is not deleted or rewritten. The later same-ID user evidence exists in the configured Sheet; this refresh records that authority asymmetry explicitly instead of inventing a nonexistent replacement GitHub PR.

### Governance and validation decisions

- `SX-DEC-043`: pre-work evidence readback remains the governance rule; its original entry block is historical rather than the current overall project state.
- `SX-DEC-044`: GUT 9.7.1 remains the formal project RED/GREEN/JUnit test authority.
- `SX-DEC-045`: the single Godot authoring-authority boundary remains governing; current tracked tooling/version reconciliation is delegated to the later `SX-DEC-052` authority rather than freezing the old v3.1.2-era status as the current tooling snapshot.
- `SX-DEC-047`: superseded and not merged.
- `SX-DEC-048`: standard GitHub-hosted Actions remains the current validation execution authority for this public repository.

### Planning, assets, and tooling

- `SX-DEC-050`: finite visual planning package merged; runtime/POC remained deferred.
- `SX-DEC-051`: 31 production candidates remain tracked provenance and complete P0 role coverage; they are not themselves the final product-asset authority.
- `SX-DEC-052`: current tooling authority is Godot AI 3.1.3 synced, GUT 9.7.1 preserved, Hera repo-tracked/user-adopted from v1.0.0 provenance with bounded strict-headless compatibility and Pilot reconciliation; connected physical editor validation remains NOT_RUN; 14 legacy tracked `.asset-vault` paths remain preserved pending local hash-verified preservation attestation.
- `SX-DEC-053`: final E+D visual direction is merged; 31 dispositions are complete (`18 PROMOTE_AS_IS / 11 PROMOTE_AFTER_REVISION / 2 REPLACE`), 31 import-safe product assets are promoted, wagon visual scale is `0.74`, and runtime/POC remains deferred.

## GitHub ↔ Sheet conflict handling

The refresh does not assume either surface is automatically fresher in every cell.

### Conflict closed by this refresh

`CURRENT_CONFIRMED_DECISIONS.md` versus the configured Sheet/current owner docs:

- stale overall main/status snapshot;
- missing decisions `SX-DEC-043~053`;
- stale current-main physical status for `SX-DEC-041/042/046`;
- missing `SX-DEC-049~053` delivery state.

Resolution: refresh the GitHub current-status registry from the live evidence while preserving feature-specific evidence ceilings.

### Additional same-ID Sheet drift found during refresh

The `02_현재_확정결정` row for `SX-DEC-040` still carries the older planning-era `TEST_FIRST_IMPLEMENTATION_PENDING` status even though GitHub `SX-AUD-031` contains merged automated one-sided station color-parity evidence from PR #106. This is a status-synchronization drift, not a new gameplay conflict.

Handling: update only the status/evidence/sync cells needed to reflect the already-merged automated parity authority. Do not infer a full user physical station-parity PASS beyond the evidence actually recorded.

The `SX-DEC-037/038/039` rows retain remaining full-flow/manual gates; they are not silently promoted merely because specific later route-end, switch, pickup, or title observations passed.

## Refreshed registry contract

The refreshed `CURRENT_CONFIRMED_DECISIONS.md` must:

1. identify `9db05c0c...` as the **authority snapshot through which the refresh was read**, not as a self-referential future merge SHA;
2. include current registry rows through `SX-DEC-053`;
3. mark `SX-DEC-047` superseded by `SX-DEC-048`;
4. separate exact automated evidence from feature-scoped user F5 evidence;
5. keep Windows physical runtime, Android device, connected physical editor, and broader human validation open;
6. keep runtime/POC for `SX-DEC-053` deferred;
7. keep the six pending `SX-DEC-053` semantic asset splits explicitly incomplete;
8. keep `.asset-vault` legacy untrack deferred pending preservation evidence;
9. preserve the old endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset implementation as historical/non-current product authority;
10. avoid introducing any new product rule or unapproved numeric balance decision.

## Validation and delivery rule

Before merge, the exact PR HEAD must be re-read and the applicable hosted checks must be green. Review-thread state and changed-file scope must also be re-read.

Expected changed surface for the authority-refresh PR:

- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`;
- `기획서/50_제작_검증/SX_AUD_035_CURRENT_DECISION_REGISTRY_STALE.md`.

No `.gd`, `.tscn`, `.tres`, `.res`, `project.godot`, workflow, plugin, candidate PNG, product PNG, or `.asset-vault` byte belongs in this refresh.

After merge:

- re-read the merged project `main`;
- write the final registry-refresh merge SHA and exact validation evidence into Sheet `04_누락_충돌_감사` row `SX-AUD-035`;
- update only the directly affected same-ID/current-status cells in `02_현재_확정결정` needed to close the stale refresh and `SX-DEC-040` status drift;
- preserve existing Sheet formatting/validation;
- re-read the written cells and confirm the old `BOUNDED_SEPARATE_AUTHORITY_REFRESH_REQUIRED` state is gone.

## Evidence ceiling after refresh

Closing this authority drift does **not** close these gates:

- full PC manual demo flow: still partially open where recorded;
- Windows physical runtime / visual / audio / physical input: `NOT_RUN`;
- Android landscape device smoke: `NOT_RUN`;
- connected physical Godot/Hera authoring session: `NOT_RUN`;
- broader human/five-person comprehension: `NOT_RUN`;
- `SX-DEC-053` runtime integration / POC: `DEFERRED`;
- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`;
- production cutover: `BLOCKED_DEFERRED`.

The result is a current and bounded status registry, not a claim that the game is production-complete.
