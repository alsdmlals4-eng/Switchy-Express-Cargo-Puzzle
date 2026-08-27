# T2 Cardinal Station Lesson Hero v02

## Scope

- GitHub Issue: `#224`
- Asset: `SX-LESSON-HERO-002`
- Local path: `art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v02.png`
- Actual consumer: `game/demo/vertical_slice_demo.tscn::BriefingScreen/Panel/Content/LessonArt` through `ProductShellArt::T2_LESSON_HERO_PATH`, only while the active first-session lesson is `T2`

## Player-facing intent

T2 continues to use Godot text to state exact rules. The background must support, never replace, that meaning: a station is an off-track service object beside the rail, with cargo in the rail context. The image contains no text, fake UI, station-footprint rail, or diagonal-service claim. Exact cargo-cell and Manual/Auto meaning remain in Godot UI and gameplay, not in this illustration.

## Asset and preservation record

- Generator: OpenAI Image Generation
- Authority: explicit user request on 2026-08-28, under the existing consumer-first image policy
- Dimensions: `1672×941`
- SHA-256: `a270a91e9d7cbc218a654e94bb0fc13d94f256ea52985679260bca2a31c77753`
- Notion attachment: `file-upload://3c91b237-eb1c-8144-a921-00b221df883d`
- Notion Visual/Assets readback: `2026-08-27T21:34:35.550Z`
- `SX-LESSON-HERO-001` v01 stays project-local and Notion-preserved as the neutral shared hero for T1, T3–T6, and CAPSTONE. It is not shown during T2.

## Rule boundary

No map, schema, station predicate, cargo input behavior, LIFO/TOP behavior, tutorial count, localization, or gameplay code changes. The exact rule remains: cargo loads by existing Manual/Auto exact-cell contact; station delivery is orthogonally adjacent at Manhattan distance one, never diagonal or on the station footprint.

## Verification required

- consumer path and asset manifest tests
- PNG integrity/SHA validation
- official Godot headless suite
- live Godot T2 capture and diagnostics
- human/device/release gates remain separate and are not promoted by this record

## Branch-stage verification

- RED proof: the first T1 card initially selected v02 and failed the new T1-neutral assertion. The failure was corrected before promotion.
- Automated: Godot 4.7.1 headless suite passed `112` cases / `13,486` assertions; the first-session flow test verifies `T1 → v01` and the end-to-end flow verifies the real `T1 → T2 → v02` transition.
- Asset validation: PNG/SHA, the tracked Godot `.png.import` sidecar, consumer-first manifest, and project-contract validators pass.
- Live Godot: Hera captured the T1 card with neutral v01, then selected the T2 consumer path in the live `LessonArt` node and captured v02 without runtime errors or warnings. This proves the live renderer and crop; the deterministic first-session test owns the real T1-to-T2 state transition.
- Not promoted: human comprehension, Windows physical build, Android device, and release/right-to-ship gates.
