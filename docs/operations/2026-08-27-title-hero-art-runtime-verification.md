# Title HeroArt runtime verification · 2026-08-27

## Scope

GitHub Issue #216 establishes a single, consumer-backed product-art change:

```text
game/demo/vertical_slice_demo.tscn
→ TitleScreen/Panel/Content/HeroArt
→ ProductShellArt TITLE_HERO_PATH
→ art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png
```

No gameplay, map, tutorial, station-service, LIFO/TOP, or result-screen behavior changes.

## Asset identity and preservation

```yaml
asset_id: SX-TITLE-HERO-001
path: art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png
dimensions: 1774x887
sha256: ce7fcd3ec380bc8b0840bcf28d56debd0d170bf8ca7681fee208cc8347f2d5dd
creation_authority: USER_APPROVED_2026_08_26_AUTOMATIC_CONSUMER_IMAGE_POLICY
visual_language: E+D_HYBRID_NEO_ARCADE
notion_visual_attachment: file-upload://3c91b237-eb1c-81b3-b06d-00b297b2a323
notion_readback: PASS · 2026-08-27T13:01:28.132Z
dual_preservation: APPROVED_DUAL_PRESERVED
release_rights: CONDITIONAL · separate review required
```

The bitmap contains no title copy, logo, watermark, or UI. Godot continues to own the title and buttons as live localized controls.

## Verification

- RED-first assertion initially failed because Title used four composited core sprites rather than the exact hero asset.
- Godot 4.7.1 headless runner after implementation: **112 cases / 13,479 assertions / 0 failures**.
- Project operating contract: PASS.
- Platform/release asset-rights contract: PASS.
- Live Godot AI session `codex-title-hero-art@33b8`: game helper live, title screen observed. `HeroArt` reported `472×96` logical display bounds and the Title asset rendered blue locomotive, golden switch rail, and red star cargo.

This is machine runtime/UI evidence, not human comprehension, physical audio, Android device, or release-rights approval.

## Adversarial review summary

1. **Consumer validity:** verified exact scene node and GDScript load path.
2. **Information separation:** live title/button text stays outside the bitmap.
3. **Scope guard:** Lesson/Result asset mapping and finite gameplay rules stay unchanged.
4. **Display risk:** title mode uses center-crop cover so the central rail/train/cargo read inside the shallow banner.
5. **Provenance/storage:** local checksum, rights record, Notion binary attachment, and Notion readback all exist.

No reusable Base lesson is promoted: this is one project-specific runtime consumer and does not establish cross-project evidence.
