# SX-DEC-062 Runtime Composition Implementation Audit

Status: `IMPLEMENTATION_LOCAL_EVIDENCE_RECORDED · REMOTE_CI_AND_MERGE_PENDING`

## Identity and scope

| Field | Value |
|---|---|
| Decision / Issue | `SX-DEC-062` / GitHub Issue #235 |
| approved implementation baseline | `origin/main` `a4fa083c024f7dc78137dbdfa022d13c69a14f19` |
| Base completed main read | `7cfc75d607d1ed4d0f8323d4389e64da93df00c8` |
| implementation head | `4b1edf8` before this audit record |
| execution surface | local linked worktree `codex/sx-dec-062-runtime-composition` |
| permitted product delta | palette/theme roles, declared panel variations, station-service-before-route visual pass, deterministic tests |
| prohibited delta | product assets/manifest/paths, map/data/finite rules, first-session copy/locales, audio, Issue #227, PR #174 |

The player-visible intent is unchanged: the board remains the first decision surface; the compact control deck supplies contextual information; T2 keeps direct cargo-cell versus cardinal station-service meaning; selected, alternate, locked, and lesson states retain redundant non-colour cues.

## RED → GREEN evidence

1. Added role/variation/layer tests to the approved owners.
2. The registered Godot 4.7.1 runner failed as intended: `cases=112 failed=4 assertions=13503`. The absent lesson-focus role, scene variation assignments, and visual-layer diagnostic were the failure causes.
3. Implemented only the allowed nine-file delta.
4. Added the preflight/stack/focus style-box behavior checks, temporarily removed the variation registrations, and confirmed a second RED: `cases=112 failed=1 assertions=13512`.
5. Restored the minimal registrations and re-ran the full Godot runner: `cases=112 failed=0 assertions=13512`.

Additional exact-working-tree checks after the implementation code commit:

```text
python -m pytest tests/python -q
→ 214 passed, 1 skipped
python tools/validate_project_contract.py
→ project operating contract: PASS
python tests/python/test_v48_current_authority_migration.py -v
→ 7 tests OK
python tests/python/test_sx_dec_062_contract.py -v
→ 3 tests OK
git diff --cached --check
→ PASS
```

Fresh worktree import note: the first headless run lacked ignored `.godot/imported` cache files and therefore could not load otherwise present raw PNG assets. A headless Godot 4.7.1 editor import rebuilt that local cache, after which the baseline runner passed at `112 cases / 13,487 assertions`. The import rewrote tracked `.import` files only by environment line-ending handling and created one ignored test `.uid`; no such generated file is part of the implementation diff or will be staged.

## Five full-scope adversarial loops

### Loop 1

```yaml
input_state_or_head: 4b1edf8
evidence_delta: [approved-file diff, staged prohibited-path scan]
full_scope_findings: []
validated_findings: []
changes_applied: []
verification: [nine files only, no asset/map/finite/first-session/audio path in staged diff]
better_alternative_result: REJECTED_NEW_ASSET_OR_SKIN_FRAMEWORK
long_term_fit: existing DemoPalette and DemoThemeFactory remain the single visual-role authority
unresolved: [REMOTE_CI_PENDING, human/device evidence remains NOT_RUN]
output_state_or_head: 4b1edf8
clean_exit_candidate: false
```

### Loop 2

```yaml
input_state_or_head: 4b1edf8
evidence_delta: [theme RED→GREEN, five-viewport accessibility regression]
full_scope_findings: []
validated_findings: []
changes_applied: []
verification: [LessonFocusLabel violet, preflight crimson border, Stack neutral border, focused action trim, >=48px paths]
better_alternative_result: REJECTED_PER_NODE_OVERRIDE_OR_LAYOUT_REDESIGN
long_term_fit: named roles avoid a competing shell palette and keep existing node/input ownership
unresolved: [live-editor screenshot audit NOT_RUN]
output_state_or_head: 4b1edf8
clean_exit_candidate: false
```

### Loop 3

```yaml
input_state_or_head: 4b1edf8
evidence_delta: [renderer-layer RED→GREEN, existing route/cardinal tests]
full_scope_findings: []
validated_findings: []
changes_applied: []
verification: [STATION_SERVICE < ROUTE < MARKERS < STATE, selected > locked > alternate, cardinal descriptors unchanged]
better_alternative_result: REJECTED_STRONGER_OR_OPAQUE_SERVICE_TILE
long_term_fit: renderer diagnostic is visual-only; no delivery/preflight/map authority crossed into presentation
unresolved: [physical board legibility at target hardware NOT_RUN]
output_state_or_head: 4b1edf8
clean_exit_candidate: false
```

### Loop 4

```yaml
input_state_or_head: 4b1edf8
evidence_delta: [product-art integration regression, clean-import baseline]
full_scope_findings: []
validated_findings: []
changes_applied: []
verification: [existing title/result/T2-v02/T1-and-non-T2-v01 consumer tests, no new art path or manifest delta]
better_alternative_result: REJECTED_ISSUE_227_T2_REPLACEMENT_ABSORPTION
long_term_fit: current consumer-first asset contract stays intact
unresolved: [new exact package candidate pending official remote package workflow]
output_state_or_head: 4b1edf8
clean_exit_candidate: false
```

### Loop 5

```yaml
input_state_or_head: 4b1edf8
evidence_delta: [Godot full regression, Python contracts, protected scope scan]
full_scope_findings: []
validated_findings: []
changes_applied: []
verification: [112 cases/13512 assertions, 214 Python pass + 1 skipped, contract/migration/SX-DEC-062 tests pass]
better_alternative_result: REJECTED_GAMEPLAY_OR_DATA_EXPANSION
long_term_fit: one presentation slice with deterministic regression coverage is lower-risk than a new UI framework
unresolved: [REMOTE_CI_PENDING, exact package candidate pending, Windows/audio/Android/five-person/Player Experience NOT_RUN]
output_state_or_head: 4b1edf8
clean_exit_candidate: true
```

`CLEAN_REVIEW_EXIT` applies only to the implementation-scope review finding set. It does not promote any unresolved physical, device, human, Player Experience, release, or remote-CI evidence to PASS.

## Multi-lens implementation verdict

| Lens | Result | Evidence |
|---|---|---|
| Simplify | `APPLIED` | Reused the existing palette/theme/renderers; added no singleton, asset resolver, or gameplay state. |
| Style Guide | `APPLIED` | Existing Godot Theme, `PanelContainer` variations, Korean live copy, 48px regression, no new GDScript file. |
| Domain Review | `APPLIED` | T2 v02 selection, cargo direct contact, cardinal station descriptor, LIFO/route meaning and result/retry flows remain existing tested owners. |
| Security / Safety / Trust | `APPLIED` | No external input, persistence, rights, asset, package, or release-owner change; exact evidence ceiling retained. |

## Remaining work and gates

1. Publish the implementation commit through a new PR and obtain exact-head remote CI, including the official Windows export/package workflow.
2. Mint a new post-SX-DEC-062 package candidate only when the remote artifact identity and hashes exist; preserve `SX60-POC-ACCEPT-002` as pre-change evidence.
3. On the new exact build, run Windows physical + audio, Android device, five-person comprehension, and Player Experience gates. They are all `NOT_RUN` or `BLOCKED_UNVERIFIED` now.
4. After merge, update/read back the approved Switchy Notion owners and re-run post-merge review. PR #174 remains read-only and Issue #227 remains deferred.
