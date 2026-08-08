# E+D Hybrid V1 production candidates

Decision: `SX-DEC-051`

Status: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`

This directory is intentionally isolated from Godot runtime import. The 16 tracked PNG candidates are review/production handoff candidates only; they are not runtime evidence or final release-approved assets.

Art direction: `E+D HYBRID · NEO-ARCADE READABILITY`.

Core rules:
- locomotive is the vehicle anchor; cargo wagons remain visibly smaller;
- cargo/station/switch critical meaning never depends on color alone;
- generated localized text is not retained in reusable candidate art;
- success/failure/meta shells are text-safe blank primitives;
- critical feedback includes static/Reduced Motion-compatible candidates;
- no recognizable third-party IP/UI skin or identifiable living-artist/studio imitation;
- every tracked candidate is registered in `manifest.json` with source reference SHA256 and runtime/final-approval flags set to false.

Adversarial review auto-fixes in this approved scope:
1. removed generated labels from train/switch candidates;
2. rebuilt result shells as text-safe blank panels;
3. rebuilt progress/meta candidates without generated localized copy.

Runtime integration, Godot Scene/Resource/Theme authoring, POC, Windows/Android physical validation, connected HiGodot validation, human comprehension testing, and final product-asset approval remain deferred.
