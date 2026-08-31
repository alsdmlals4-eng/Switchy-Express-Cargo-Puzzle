# Export package hygiene correction after SX-DEC-068

**Status:** `CORRECTION_IMPLEMENTED · AWAITING_EXACT_MAIN_EXPORT_READBACK`
**Date:** 2026-08-31 KST

## Finding

The first exact-main package observation after the title-shell merge (`main@46c02bad0ff020b14040969b932e010fe871953e`) was structurally valid, but its Windows PCK had 721 entries rather than Candidate 007's 599. A direct entry-list comparison found 122 added entries and no removals.

The added entries were not gameplay content: 120 were Godot imports derived from the human-facing PDF render cache under `output/pdf/`, and two were internal Candidate 007 JSON evidence files. Both sets were pulled in by the two `all_resources` export presets.

## Correction

Both `Android Validation` and `Windows Demo` now exclude `output/**` and `evidence/**`, while retaining all runtime `game/`, `data/`, and tracked product-asset paths. The saved human blueprint/PDF, render-QA cache, and immutable candidate evidence remain in GitHub; only their accidental delivery inside game PCKs is prevented.

The new `tests/python/test_export_package_hygiene.py` fails closed if either runtime preset omits either exclusion.

## Required follow-up

Do not use the observed 721-entry package as Candidate 008. After this correction is merged, dispatch a new exact-main Windows export, verify the artifact ZIP and inner hashes, audit the PCK, and require zero `output/` and `evidence/` entries before minting Candidate 008. No physical, device, human, or final-user review result is implied.
