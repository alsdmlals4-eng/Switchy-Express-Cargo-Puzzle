# E+D Hybrid V1 production candidates

Decision: `SX-DEC-051`

Status: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`

This directory is intentionally isolated from Godot runtime import. The **31 tracked PNG candidates** are review/production handoff candidates only; they are not runtime evidence or final release-approved assets.

Art direction: `E+D HYBRID · NEO-ARCADE READABILITY`.

Core rules:
- locomotive is the vehicle anchor; cargo wagons remain visibly smaller;
- cargo/station/switch critical meaning never depends on color alone;
- generated localized text is not retained in reusable candidate art;
- success/failure/meta shells are text-safe blank primitives;
- critical feedback includes static/Reduced Motion-compatible candidates;
- no recognizable third-party IP/UI skin or identifiable living-artist/studio imitation;
- every tracked candidate is registered in `manifest.json` with source reference SHA256 and runtime/final-approval flags set to false.

P0 coverage now includes:
- locomotive + red/blue/yellow wagons;
- red/blue/yellow cargo stars and stations;
- straight/curve/crossing/three-way-switch rail;
- start and route-end markers;
- RUN/LIFO stack, switch, cargo-strip, load-mode and combo families;
- BUILD placement/track palette plus ghost-route, cost HUD and preflight notice;
- seven reusable button/control interaction states.

The 15 compact coverage candidates added after the strengthened P0 contract are 64×64 text-free alpha primitives derived from the approved E+D shape/palette contract. They are candidate-only and do not alter Godot runtime authority.

Runtime integration, Godot Scene/Resource/Theme authoring, POC, Windows/Android physical validation, connected HiGodot validation, human comprehension testing, and final product-asset approval remain deferred.
