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
state: EXACT_HEAD_WORKFLOW_VERIFICATION_PENDING
```

## Reconciliation policy

Phase B does not blindly overwrite `addons/gut`. The dedicated workflow downloads the pinned official commit, compares every relative file path, and fails on any missing file, extra file, or byte divergence.

The only normalization permitted by `tools/gut_phase_b_guard.py` is removal of a redundant `load_steps=<n>` token in the first `[gd_scene ...]` line, and only for these two already identified vendor paths:

- `GutScene.tscn`
- `UserFileViewer.tscn`

No other `.tscn` metadata difference is normalized. GDScript, license, plugin, CLI, resource paths, scene nodes, connections, and all other bytes must match exactly.

## Direct readback evidence

The following pinned project/official blobs were read directly:

| Path | Project blob | Official blob | Classification |
|---|---|---|---|
| `LICENSE.md` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | `a38ac231fed3febe257c9e5fc31efb8ec7a39f90` | exact |
| `cli/gut_cli.gd` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | `4bc17de9218043ec6334aa0cf72ee44bd0f6001a` | exact |
| `gut_cmdln.gd` | `51c2937a0f30fc60a61da4144469692365e67926` | pinned project CLI entry point | project readback |
| `GutScene.tscn` | `7a2b52e78f0e3fab96b9e756a9ebc4ab797e2e52` | `82638cc5bd37f833d361842ecce77a35101a47ed` | first-line `load_steps=4` only |
| `UserFileViewer.tscn` | `673d70f9ca083eefb2b2076240e8ee43e5198d3d` | `15e2e86980b2c4400996ed4bbfc26f2c7e3ae362` | first-line `load_steps=2` only |

The complete path-by-path result is not claimed until the exact-head `GUT 9.7.1 Tests` workflow produces `test-results/gut/vendor-reconciliation.json`.

## Authoring boundary

The two divergent files are vendor Scene files. Phase B does not edit or replace them. This preserves the HiGodot single-authoring boundary while still requiring semantic equivalence to the pinned upstream files. Any future non-metadata Scene divergence requires a separate authoring decision and HiGodot evidence.

## Rollback

Phase B must stop and the PR must remain unmerged if the exact-head workflow reports:

- a missing or extra vendor path;
- any source or license divergence;
- any Scene difference beyond the two explicit first-line `load_steps` tokens;
- an unavailable pinned official archive;
- a protected production-tree mutation during GUT execution.
