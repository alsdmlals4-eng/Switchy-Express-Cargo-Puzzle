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
validated_head: a556d58abc68aa1b4885a34e806443301bafd7a0
validated_run: 31134358839
state: EXACT_HEAD_RECONCILIATION_PASS
```

## Result

```yaml
local_file_count: 259
official_file_count: 259
missing_local: []
extra_local: []
exact_byte_matches: 241
first_line_load_steps_only: 17
frozen_binary_divergence: 1
unclassified_source_divergence: []
result: PASS
```

The exact-head artifact is `gut-phase-b-evidence` ID `8977314810`. Phase B does not overwrite `addons/gut`.

## Explicit first-line metadata paths

The guard may remove one `load_steps=<n>` token from the first line for these exact paths only. The first line must begin with `[gd_scene` or `[gd_resource`; all remaining bytes must match the pinned official file.

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

There is no extension-wide or directory-wide normalization. An identical token difference on an unlisted resource fails.

## Frozen binary divergence

`source_code_pro.fnt` is not claimed byte-identical or semantically equivalent. It is accepted only by the exact pair below:

```yaml
path: source_code_pro.fnt
local_sha256: e1149f403f4aba18913fb500e4b34aa45f44afe9e36a3e7aed923c11aacf4686
official_sha256: 404094d0aae3de496a64fca1795bed8bd60c2411a3d992551f9e8f00789b71fe
local_size: 42799
official_size: 42799
classification: PINNED_PRE_EXISTING_BINARY_DIVERGENCE
```

Any local or upstream byte/size change fails the check. GUT CLI runtime success is required independently.

## Source authority

All GDScript, `.uid`, license, plugin, CLI, configuration, and other vendor files remain exact-byte requirements. Representative exact blobs:

| Path | Project blob | Official blob | Classification |
|---|---|---|---|
| `LICENSE.md` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | exact |
| `cli/gut_cli.gd` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | exact |
| `gut_cmdln.gd` | `51c2937a0f30fc60a61da4144469692365e67926` | `51c2937a0f30fc60a61da4144469692365e67926` | exact |

## Authoring boundary

Phase B modifies no vendor Scene, Theme, Resource, or font file. Comparison policy lives only in Codex-owned Python tests/tooling and CI. Editing or replacing a Godot-authored asset requires a separate HiGodot-authorized change.

## Rollback conditions

- missing or extra vendor path;
- GDScript, license, plugin, CLI, or configuration divergence;
- normalization outside the 17 explicit paths;
- content difference beyond the first-line token on those paths;
- changed font hash/size pair;
- unavailable pinned official archive;
- GUT/JUnit failure or protected production-tree mutation.
