# SX-AUD-025 — Post-Merge Canon Freshness and Gate Recovery

- Date: `2026-08-06`
- User approval: `진행해`
- Parent authority: `GMB-002 · SX-DEC-027~039`
- Repository observed main: `212d37e4577a6ffdb7b93e92de6a82785c2976eb`
- Latest automated verified product main: `1339a9467312d0ac680725894a9efb59746ec2cc`
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- State: `APPROVED_PENDING_MERGE`

## Scope

This audit compares:

- merged PR #83 metadata
- active README, Active Context, Development Gates, and Current Decisions
- Base v9.4.3 adapter and current Base main policy
- Draft PR #94 candidate pin and workflow state
- current Google Sheet status
- actual `project.godot` default main Scene

No product code, Scene, asset, balance value, Android APK, package ID, or gameplay rule is changed by this recovery.

## Finding F143 — PR #83 post-merge state drift

### Evidence

PR #83 is merged, but active documents and Sheet cells still described it as `DRAFT`, `MAIN_PENDING`, or merge-blocked.

### Risk

A user can be directed to an obsolete feature branch or wait for a merge that already happened.

### Correction

- user execution branch is `main`
- PR #83 state is `MERGED`
- merge completion is no longer blocked by local runtime gates
- local F5 and Windows artifact runtime remain independent manual gates

### State

`FIXED_IN_PR_99`

## Finding F144 — Repository HEAD and automated verified product HEAD conflation

### Evidence

The repository contains later documentation and UID commits after the latest full 92-case product regression.

### Risk

Recording the newest repository SHA as fully automated-verified would overclaim evidence; recording only the older verified SHA would hide current repository state.

### Correction

Both are recorded separately:

```yaml
repository_main_observed: 212d37e4577a6ffdb7b93e92de6a82785c2976eb
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
```

### State

`FIXED_IN_PR_99`

## Finding F145 — Base protection document preserved superseded product rules

### Evidence

`docs/BASE_RULES_VERSION.md` still protected endless survival, fuel, BOOST, capacity 8, pickup respawn, and the old connected generator.

### Risk

A later Base adoption or protected-change check could preserve or reactivate rules explicitly superseded by GMB-002.

### Correction

The release pin remains Base v9.4.3, but the human-readable protection boundary now points to the finite authored delivery puzzle and `SX-DEC-027~039`. Legacy rules are retained only as historical evidence.

### State

`FIXED_IN_PR_99`

## Finding F146 — Adapter and protected canon cannot change in one PR

### Evidence

The trusted Base adapter validator compares the adapter's protected baseline to the exact PR base and rejects changes under `project.godot`, `game/**`, `assets/**`, and `기획서/**`. PR #99 necessarily changes active files under `기획서/**`.

### Risk

Changing the Adapter in the same PR would bypass or weaken the intended fail-closed protected-change boundary, or leave the PR permanently failing.

### Correction

- restore `skills/PROJECT_BASE_ADAPTER.json` to the exact PR-base version in PR #99
- keep Base v9.4.3 sentinel semantics unchanged
- merge the canon-only recovery first
- create a separate adapter-only follow-up from the merged main, with no protected-path changes
- update the Adapter baseline and freshness metadata only in that follow-up

### State

`DEFERRED_TO_ADAPTER_ONLY_FOLLOWUP`

## Finding F147 — PR #94 candidate Pilot is not merge-ready

### Evidence

- PR title/body referred to Base C0.2 while actual diff pinned a C0.3 candidate
- candidate SHA was not an approved merged release pin
- candidate diverged from current Base main
- the core Pilot workflow failed
- current Base main adds selective addon use and HiGodot single-authority boundaries

### Decision

PR #94 was archived without merge. A future adoption must start from an approved merged immutable Base SHA, pass the full Pilot and product regression, and prove a non-duplicative actual consumption path.

### State

`ARCHIVED`

## Preserved evidence boundaries

```yaml
finite_automated_core: PASS
pc_vertical_slice_automated_core: PASS
one_sided_station_terminal: PASS_AUTOMATED
mid_run_exit: PASS_AUTOMATED
title_exit_visible: PASS_USER_LOCAL
pc_local_route_and_mid_run_retest: RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
android_device_smoke: NOT_RUN
five_person_comprehension: NOT_RUN
production_cutover: BLOCKED
```

## Required post-merge manual verification

```text
main Fetch/Pull
→ Godot fully reopen
→ F5
→ recommended layout
→ one-sided final station unload and SUCCESS
→ BUILD/RUN menu cancel and state preservation
→ confirm exit and Title return
→ Windows artifact runtime·visual·audio smoke
```

## Non-claims

This audit does not claim:

- local F5 PASS
- Windows exported executable runtime PASS
- Android device PASS
- five-person comprehension PASS
- production readiness
- Base main release adoption
- HiGodot or Pilot production authority
