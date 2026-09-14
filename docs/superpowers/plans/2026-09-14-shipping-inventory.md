# Read-only shipping inventory preparation

Baseline a82798d0 (D2 PR313 merged); approved finite product/package remains unchanged.
This is the existing R1 specification's first local coverage check, not release execution.
No signing, account, provider, autoload, export filter, vendor or pixel changes.

## Comparison and sequence

Current consumer is tools/verify_godot_pck_integrity.py and its synthetic-pack tests.
Official Godot export reference (checked 2026-09-14):
https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
All-resources packaging differs from runtime reachability; filters and imported/remapped
resources must be accounted for. Base platform/rights guide read at d830c0f6 without repin.

ADAPT existing verified PCK parser with opt-in entry metadata (selected: one parser,
exact bytes, no extraction). REJECT a second handwritten parser (drift/duplicate checks).
DEFER source-folder-only rights counting (cannot prove what is actually packaged).

1. RED tests for optional ordered entry metadata and tampered-entry integrity status.
2. Add optional --include-entries, keeping default summary and original acceptance intact.
3. Verify real unchanged C2 package and bind raw SHA/entry inventory to existing rights owner.
4. Distinguish source provenance, package inclusion, runtime use and legal rights.
5. Five-pass review, scoped corrections, full Python regression, normal CI/merge/readback.

Initial evidence: package f43eeebbedc1cab88e4ae9d5e2a4cab4cc20201c0134589019b9548fa9477c6b
has645 verified entries including89 addons/hera_agent_godot entries; this is not evidence
of remote access in an exported game. _process is editor-feature guarded, while _ready
and _input have separate behavior. Current autoload references the plugin, so blindly
excluding its directory would break startup. Preserve it pending a separately verified
export-only design. Topdown manifest registration is not legal clearance.

Rollback: scoped tooling/docs change only. Preserve216 pre-existing dirty entries and
PR174/254/281. No Base promotion: this is project-specific coverage evidence.
