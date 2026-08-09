# E+D Hybrid V1 product assets

Decision: `SX-DEC-053`

Status: `DISPOSITION_31_COMPLETE · FIRST_PRODUCT_ASSET_BATCH_IN_PROGRESS · NOT_RUNTIME_INTEGRATED`

This root contains assets explicitly promoted from the tracked `SX-DEC-051` production-candidate package. Promotion does not imply Godot runtime integration, device validation, human validation, or release cutover.

Rules:
- source candidates stay unchanged under `art/production_candidates/ed_hybrid_v1/`;
- each of the 31 source candidates has exactly one disposition in `manifest.json`;
- `PROMOTE_AS_IS` reuses exact candidate bytes when possible;
- deterministic crop/rotate/scale derivations must record their source path and transform;
- no generated localized copy may be baked into reusable PNGs;
- blue locomotive is the hero visual anchor;
- trailing cargo wagons target approximately 70–75% visual scale and never change gameplay/domain collision geometry;
- state meaning cannot depend on hue alone;
- runtime/Scene/Resource/Theme/Animation/signal hookup remains deferred.
