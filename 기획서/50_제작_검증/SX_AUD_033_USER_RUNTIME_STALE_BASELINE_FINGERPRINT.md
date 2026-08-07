# SX-AUD-033 — User Runtime / Superseded Baseline Fingerprint Audit

Date: `2026-08-08 08:52 KST`

## Verdict

`USER_RUNTIME_FAIL · LOCAL_HEAD_UNVERIFIED · SUPERSEDED_BASELINE_FINGERPRINT_MATCH · RESYNC_RETEST_REQUIRED`

The user reported two physical/local runtime failures while validating `SX-DEC-041` / `SX-DEC-042`:

1. switch direction arrows are not displayed;
2. if BLUE cargo is not picked up and the train reaches the BLUE station at the route end, the run force-terminates with `Assertion failed: locked train target must remain connected`.

This audit does **not** classify those observations as a failure of current GitHub `main`. The exact assertion text is absent from current main and is present verbatim in the superseded pre-PR-106 baseline. The arrow implementation in that baseline is also the pre-three-direction version. The user's local HEAD is not directly visible from this environment, so the correct classification is a strong stale-local fingerprint pending local SHA verification and resync.

## Fresh authority recovery

- Base main: `fa69a77a14f923a756064f6ae151d34cadb374f7`
- project main before this audit: `bc662d6a2b4e4f80168838c5cfdf3921dad67b9e`
- product implementation merge: `12d1ef9b5c49e401d32dfc283db11a12574b5da3` · PR #106
- pre-PR-106 product baseline: `23981d0bb3d65487951be2cbbc5ee365da624e1e`
- open PRs at recovery: `0`
- Google Sheet still recorded current-main automated PASS with local/physical retest open; the new user observation had not yet been recorded.

## Runtime symptom fingerprint

### Route-end assertion

At superseded baseline `23981d0bb3d65487951be2cbbc5ee365da624e1e`, `game/train/train_controller.gd` contains in `_commit_next_cell()`:

```gdscript
assert(_graph.neighbors(departing_cell).has(next), "locked train target must remain connected")
```

At current main `bc662d6a2b4e4f80168838c5cfdf3921dad67b9e`, that assertion no longer exists. The current controller instead exposes `can_advance()`, stops timed movement when it cannot advance, and `_commit_next_cell()` returns the current cell rather than asserting when the route is exhausted.

Therefore the exact physical assertion text is a direct fingerprint of code predating PR #106, or an editor/runtime state that still has that superseded script loaded.

### Switch arrows

At the same superseded baseline `23981d0...`, `RouteControlOverlay`:

- has no three-direction `direction_targets` API;
- draws only the approach plus the single currently selected exit;
- sets `mouse_filter = MOUSE_FILTER_IGNORE` in `_ready()`;
- has no queued direct-selection request path.

Current main `bc662d6a...` contains the PR #106 implementation that:

- iterates all `available_exits` for a SWITCH;
- draws every connected direction;
- differentiates the selected direction by line weight/fill;
- enables input in `RUNNING` / `UNLOADING`;
- queues direct-selection requests for `ProductFiniteSlice`.

The user's “arrows not displayed” observation is therefore consistent with the same pre-PR-106 runtime fingerprint. It is not enough, by itself, to prove current main fails to draw the arrows.

## Automated-test gap retained

A separate coverage gap remains worth noting: the existing real Product-scene runtime UI regression test exercises a `CROSSING`, while the three-direction SWITCH overlay behavior is primarily proven through the isolated overlay/GUT contract. This audit does not change product code or claim that physical current-main SWITCH rendering has passed. Current-main F5 still needs the user's post-resync physical retest.

## Required local recovery before any new product fix

Close the running Godot editor/project first, then from the project checkout run:

```powershell
cd C:\Users\user\Documents\GitHub\Ninza\Switchy-Express-Cargo-Puzzle

git status --short --branch
git rev-parse HEAD
git fetch origin
git switch main
git pull --ff-only origin main
git rev-parse HEAD
```

After the pull, reopen the project in Godot 4.7.1 and run Project Play (`F5`).

Do not discard local changes automatically. If `git status` shows local modifications or `git pull --ff-only` refuses to advance, preserve that evidence and resolve the local divergence explicitly instead of resetting/force-cleaning.

## Required post-resync physical retest

Re-run exactly these scenarios on the newly fetched main:

1. Start a route containing a SWITCH and confirm all three connected direction arrows are visibly rendered.
2. Confirm direct arrow selection changes the selected direction.
3. Confirm selecting the incoming direction produces the approved U-turn behavior.
4. Confirm occupied switch lock rejects changes.
5. Run without picking up BLUE cargo, reach the BLUE one-sided station at the route end, and confirm the run resolves as `FAILURE / ROUTE_END` without any assertion or process termination.
6. Recheck final-required-delivery-at-route-end to confirm `SUCCESS` still wins.

## Evidence boundary

Until the local SHA is verified and the above scenarios are rerun:

- current-main automated implementation evidence: `PASS`
- user physical runtime observation: `FAIL`
- user local HEAD: `UNVERIFIED`
- stale-baseline fingerprint match: `STRONG`
- current-main physical F5: `NOT_RUN_AFTER_RESYNC`
- physical arrow visibility: `NOT_RUN_AFTER_RESYNC`
- physical route-end no-crash: `NOT_RUN_AFTER_RESYNC`
- Windows physical runtime: `NOT_RUN`
- Android device: `NOT_RUN`
- production cutover: `BLOCKED`

No new gameplay decision is created. `SX-DEC-041`, `SX-DEC-042`, and `SX-DEC-046` remain the governing decisions; this audit only records the new user runtime evidence and the version-fingerprint diagnosis.