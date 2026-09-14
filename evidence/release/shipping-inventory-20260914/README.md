# Local shipping inventory, not rights clearance

Observed 2026-09-14; project baseline a82798d0, package product source c9e6a6dd.
Existing PCK verifier was extended only with opt-in entry metadata. RED:2 failed/6passed
(unsupported include_entries keyword). GREEN:10passed, including CLI output, tamper and
out-of-bounds entry checks. Full Python315passed/1optional Pilot environment skip.
No product/asset/export/vendor/autoload change; native/device/legal checks not run here.

Target: Downloads/Switchy_Playable_20260914_RouteBook03/SwitchyExpress.pck.
SHA256 f43eeebbedc1cab88e4ae9d5e2a4cab4cc20201c0134589019b9548fa9477c6b.
645/645 entries integrity-verified; MD5 is PCK payload integrity, not legal provenance.
`inventory.json` is exact generated command output, SHA256
7ad14bd2dba4dabab086a1c16d5befdec31b8e219367b81bf62dfa1753f4bfc7.

Reproduce with `python tools/verify_godot_pck_integrity.py <exact.pck> --include-entries`.
PCK paths omit res://; an initial res:// prefix query yielded zero and was rejected as
a namespace mismatch, not proof of absence. Correct prefix counts: addons/hera_agent_godot
89 (44gdc/44remap/1font import), addons/gut0, addons/godot_ai0, evidence0;
topdown_v1 has13import+1manifest entries, night_workshop_v1 has5import+1manifest.
Imported texture/font payloads live under .godot/imported, not asset source folders.
The Cormorant .fontdata is24609bytes and its import descriptor175bytes.

Confirmed all13 topdown source PNG hashes against their existing approved manifest.
That source check is distinct from the PCK imported/remapped representation. A complete
asset-by-asset source-to-import-to-rights mapping is NOT_DONE. Existing model/prompt and
post-processing records are linked by the rights owner, not copied into a new canon.

Five-pass local review: (1) preserve parser/default output/acceptance, (2) corrupt and
out-of-bounds entries remain failed, (3) imported-path namespace is explicit, (4) no
extraction/deletion/rights or remote-control inference, (5) exact package hashes and
partial coverage ceilings retained. Independent review and normal merge are separate.
Project-only learning: source-only counts and wrong prefixes cannot establish shipping
absence. No Base promotion; no confidential agreement/account/billing data collected.
