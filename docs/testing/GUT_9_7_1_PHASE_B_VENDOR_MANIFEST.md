# GUT 9.7.1 Phase B Vendor Reconciliation Manifest

```yaml
phase: B
project_decision: SX-DEC-044
implementation_audit: SX-AUD-030
project_baseline: 281bc7b3aa8d66b8f39547475540ab8fcd88b4c5
project_addon_tree: 09d040309bbed0e07420ad72c4aa69cbd0e58190
official_repository: bitwes/Gut
official_branch: godot_4_7
official_commit: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
official_addon_tree: 5d6893836af4917ee62b1a395125a7530b1f239d
license: MIT
diagnostic_head: 453702ad62eeae7f8dc6189a0bbb569d397a0e3f
diagnostic_run: 31133547812
state: EXPLICIT_EXCEPTION_POLICY_DEFINED_RERUN_PENDING
```

## Reconciliation policy

Phase B does not overwrite `addons/gut`. The dedicated workflow downloads the pinned official commit, compares all 259 relative paths, and fails on missing files, extra files, unapproved byte divergence, or a changed frozen exception.

The diagnostic exact-head artifact reported:

```yaml
local_file_count: 259
official_file_count: 259
missing_local: []
extra_local: []
exact_byte_matches: 241
first_line_load_steps_only: 17
frozen_binary_divergence: 1
unclassified_after_policy: 0
```

These classifications are accepted only when the current exact-head workflow reproduces them. The diagnostic failure itself is not a Phase B PASS.

## Explicit first-line metadata paths

`tools/gut_phase_b_guard.py` may remove one `load_steps=<n>` token from the first line for the following exact paths only. The first line must begin with `[gd_scene` or `[gd_resource`, and all remaining bytes must match the pinned official file.

- `GutScene.tscn`
- `UserFileViewer.tscn`
- `gui/GutControl.tscn`
- `gui/GutLogo.tscn`
- `gui/GutRunner.tscn`
- `gui/GutSceneTheme.tres`
- `gui/MinGui.tscn`
- `gui/NormalGui.tscn`
- `gui/OutputText.tscn`
- `gui/ResizeHandle.tscn`
- `gui/RunAtCursor.tscn`
- `gui/RunExternally.tscn`
- `gui/RunResults.tscn`
- `gui/ShellOutOptions.tscn`
- `gui/ShortcutButton.tscn`
- `gui/run_from_editor.tscn`
- `gut_loader_the_scene.tscn`

There is no extension-wide or directory-wide normalization. An identical `load_steps` difference on an unlisted `.tscn` or `.tres` remains a failure.

## Frozen binary divergence

`source_code_pro.fnt` is not claimed byte-identical or semantically equivalent. It is a pre-existing GUT GUI font resource divergence, excluded from source/CLI authority and frozen to the exact diagnostic pair:

```yaml
path: source_code_pro.fnt
local_sha256: e1149f403f4aba18913fb500e4b34aa45f44afe9e36a3e7aed923c11aacf4686
official_sha256: 404094d0aae3de496a64fca1795bed8bd60c2411a3d992551f9e8f00789b71fe
local_size: 42799
official_size: 42799
classification: PINNED_PRE_EXISTING_BINARY_DIVERGENCE
```

The guard accepts this path only when both SHA-256 values and both sizes match the frozen pair. Any future local or upstream byte change fails. Runtime GUT CLI tests must still pass independently.

## Source authority

All GDScript, `.uid`, license, plugin, CLI, configuration, and other vendor files remain exact-byte requirements. Representative exact blobs already read include:

| Path | Project blob | Official blob | Classification |
|---|---|---|---|
| `LICENSE.md` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | exact |
| `cli/gut_cli.gd` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | exact |
| `gut_cmdln.gd` | `51c2937a0f30fc60a61da4144469692365e67926` | `51c2937a0f30fc60a61da4144469692365e67926` | exact |

## Authoring boundary

Phase B modifies no vendor Scene, Theme, Resource, or font file. The comparison policy is implemented in Codex-owned Python tests/tooling and CI only. Any proposal to replace or edit these Godot-authored assets requires a separate HiGodot-authorized change.

## Rollback

The PR remains unmerged if an exact-head workflow reports any of the following:

- missing or extra vendor path;
- GDScript, license, plugin, CLI, or configuration divergence;
- `load_steps` normalization outside the 17 explicit paths;
- any content difference beyond the first-line token on those paths;
- a changed `source_code_pro.fnt` hash or size pair;
- unavailable pinned official archive;
- GUT/JUnit failure or protected production-tree mutation.
