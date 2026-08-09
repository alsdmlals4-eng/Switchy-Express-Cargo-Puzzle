# E+D Hybrid V1 product assets

Decision: `SX-DEC-053`

Status: `DISPOSITION_31_COMPLETE · FIRST_PRODUCT_ASSET_BATCH_PARTIAL · IMPORT_SAFE_23_PROMOTED · LOCOMOTIVE_CONTROLS_REVISION_PENDING · NOT_RUNTIME_INTEGRATED`

This root contains assets explicitly promoted from the tracked `SX-DEC-051` production-candidate package. Promotion does not imply Godot runtime integration, device validation, human validation, or release cutover.

Current static result:

- source candidates: 31;
- dispositions: 31/31;
- promoted PNGs: 23;
- smaller cargo wagon v02 scale: 0.74;
- deep source-health failures: locomotive + controls atlas only;
- corrupt sources remain revision-pending and are not promoted as broken product assets.

Rules:

- source candidates stay unchanged under `art/production_candidates/ed_hybrid_v1/`;
- each source candidate has exactly one disposition in `manifest.json`;
- `PROMOTE_AS_IS` requires a deeply decodable PNG source and reuses exact candidate bytes when possible;
- deterministic crop/scale derivations record source path, blob, dimensions, and transform;
- every physical product PNG must appear exactly once in `manifest.json`;
- no generated localized copy is baked into reusable PNGs;
- blue locomotive remains the approved hero anchor even while its import-safe final revision is pending;
- trailing cargo wagons use the approved smaller hierarchy and never change gameplay/domain collision geometry;
- state meaning cannot depend on hue alone;
- runtime/Scene/Resource/Theme/Animation/signal hookup remains deferred.
