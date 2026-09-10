# Night workshop production candidates

Date: 2026-09-10 KST. State: GENERATED_CANDIDATE / ASEPRITE_PREPARED / USER_PIXEL_APPROVAL_PENDING / NOT_RUNTIME_PROOF.
Direction authority: the user selected the second direction sheet's navy/brass material and cream manifest composition, then requested continuation. Each image below is a new candidate, not automatically canonical.
This directory is excluded from Godot imports by `.gdignore`; no product renderer or production manifest points here.

## Files and real consumers

| Candidate | Intended existing consumer | Current result |
|---|---|---|
| `rail-master.png` / `.aseprite` | ProductBoardRenderer rail_straight / rail_curve / rail_crossing / rail_switch | One connected raster family, cleaned external border. Dedicated tile extraction/port validation NOT_VERIFIED. |
| `cargo-source.png`, `cargo-lift.aseprite`, `cargo-lift-ready.png` / `.json` | Confirmed cargo load/unload presentation adjacent to current demo semantic events | Four aligned frames, 60ms each, 240ms total, true alpha, source-visible-pixel preservation checked. No gameplay integration yet. |
| `train.png` | ProductBoardRenderer train | Overhead compact locomotive candidate; final pixel selection required. |
| `station-blue.png` | ProductBoardRenderer station_blue | Off-track building cutout, no baked terrain or entering rail; final pixel selection required. |

Production catalog ownership remains `art/product_assets/ed_hybrid_v2/manifest.json`; this candidate receipt is not a duplicate canonical asset catalog.

## Generation provenance and prompt brief

All original artwork used the built-in image model. No purchased API, third-party source image, SVG, procedural drawing or Python image synthesis was used.

- Rail source: `exec-c782bd4b-528d-4519-a4a9-ef3a7fe59d30.png`. Prompt: transparent square connected rounded railway loop, internal horizontal/vertical routes, four three-way turnouts and central crossing; overhead navy-workshop brass/wood materials; no terrain, scenery, text or disconnected pieces. Requested 1280×1280; actual 1254×1254. Exact requested grid coordinates were not met, so do not infer valid tile ports.
- Cargo source: `exec-faa943b2-ecaf-4679-97ab-4f2e27be2a22.png`. Prompt: 2×2 equal-cell sheet, identical navy/brass blue-diamond crate in preparation/lift/float/settle positions, no floor, cart, scenery, text or effects. Requested 1024×1024; actual 1254×1254. Source cells are 627×627. Generated placement differed from requested offsets and was measured before correction.
- Station: `exec-6817ed5e-086b-46db-8b69-7ce36c519475.png`. Prompt: compact off-track blue destination depot, navy roof, cream walls, brass trim, blue diamond plaque, attached lantern, transparent isolated building with no entering rail or ground rectangle.
- Initial train `exec-c4b25ec5-e64b-4994-ba17-29229d309e55.png` was rejected for side-elevation camera. Two overhead edit attempts produced baked RGB checkerboards and were rejected, not added to the candidate pack. Fresh overhead generation followed; its exact identifier is recorded in the verification receipt after readback.
- Rail model cleanup attempt `exec-a5763b8b-dc71-470a-a66e-41dc62202124.png` still contained alpha=1 at an outer corner and altered materials. It was not selected. The original rail pixels were retained and only verified nearly-empty exterior padding was cleaned with Aseprite.

## Aseprite processing

Tool version: 1.3.18.5-dev. Restricted MCP candidate workspace: `switchy-night-workshop-20260910-r1`. The actual tools were called and their outputs read back; this is stronger than tool discovery, but not live-editor or Godot evidence.

Cargo: create all blank frames before importing. Each frame uses the original source on layer `cargo`. Final canvas 448×448, source offsets `(-92,-105)`, `(-715,-129)`, `(-92,-722)`, `(-715,-753)`. These place all opaque horizontal bounds at x=56..392 and vertical bounds at y=132..440, 72..380, 12..320, 36..345 respectively. The 4px horizontal source wobble is removed. One-pixel final-frame height difference remains; internal painted detail varies slightly across generated frames and still needs visual review.

Export: horizontal, untrimmed, unrotated, scale1, 2px padding; sheet1798×448. Frame duration60ms each. Tags are absent, not falsely reported as authored. Intended playback is one-shot; fixed canvas pivot `(224,224)` must be carried into the eventual Godot resource. This pivot is recorded here, not embedded by an unsupported slice/tag API. The visible cargo width at the existing 0.62×64 marker rectangle would be approximately29.8px if the whole frame is fitted uniformly; actual consumer drawing must be verified before adoption.

Rail: source1254×1254. Read-only inspection found maximum alpha1 in the outer32px border, with no rail content there. Aseprite clipped a1190×1190 center and reinserted it at `(32,32)` into a fresh1254×1254 canvas. The resulting outer border is alpha0, while nontransparent central artwork is pixel-identical. This operation fixes padding only; it does not fix topology, tangent or gauge tolerances.

## Five self-review loops

1. Consumer/scope: keep existing slots and confirmed semantic events; one blue family is a representative production sample, not a complete color family or new rule.
2. Geometry/clarity: requested sizes differed; source coordinates were measured. Rail tile ports remain unverified, and train side view was rejected.
3. Motion/import: create blank frames before imports to avoid duplicated previous cels; align horizontal bounds and crop the common motion envelope without visible pixel changes.
4. Transparency/provenance: detect RGB checkerboards and alpha1 border residue rather than treating a preview background as transparency; retain original source hashes and use bounded Aseprite correction.
5. Evidence/retention: frame/alpha checks do not prove seamless tiles, attractive motion, runtime or user approval. Keep only selected candidate sources/exports in GitHub; rejected generator outputs remain tool history. Do not promote this process to Base before actual runtime adoption is validated.

## Verification and next gate

Run `python tools/validate_night_workshop_candidates.py` for source/export preservation, frame data, dimensions, transparent corners and hashes. Assertions are candidate-specific and do not declare a rail-geometry or gameplay PASS.
Remaining: final art selection; exact rail tiles and joins; complete cargo/station color families and waste/disposal states; state-to-effect integration; Godot import, regression and live title/build/run/result capture. Machine-primary policy is unchanged; no player study is added.
