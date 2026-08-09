# E+D Hybrid V1 product assets

Decision: `SX-DEC-053`

Status: `DISPOSITION_31_COMPLETE · IMPORT_SAFE_31_PROMOTED · HERO_CONTROLS_RECOVERED · SEMANTIC_SPLITS_DEFERRED · NOT_RUNTIME_INTEGRATED`

This root contains assets explicitly promoted from the tracked `SX-DEC-051` production-candidate package. Promotion does not imply Godot runtime integration, device validation, human validation, or release cutover.

Current static result:

- source candidates: 31;
- dispositions: 31/31;
- promoted PNGs: 31;
- smaller cargo wagon v02 scale: 0.74;
- deep source-health failures remain in the historical locomotive candidate and controls-atlas candidate;
- those two corrupt candidates are preserved for provenance and classified `REPLACE`;
- one import-safe locomotive and seven import-safe control states were recovered from their exact approved E+D reference sources and registered in `manifest.json`.

Rules:

- source candidates stay unchanged under `art/production_candidates/ed_hybrid_v1/`;
- each source candidate has exactly one disposition in `manifest.json`;
- `PROMOTE_AS_IS` requires a deeply decodable PNG source and reuses exact candidate bytes when possible;
- deterministic crop/scale derivations record source path, blob, dimensions, and transform;
- approved-reference recovery records the reference filename and SHA-256 and never overwrites the corrupt provenance candidate;
- every physical product PNG must appear exactly once in `manifest.json`;
- no generated localized copy is baked into reusable PNGs;
- blue locomotive remains the approved hero anchor;
- trailing cargo wagons use the approved smaller hierarchy and never change gameplay/domain collision geometry;
- state meaning cannot depend on hue alone;
- runtime/Scene/Resource/Theme/Animation/signal hookup remains deferred.
