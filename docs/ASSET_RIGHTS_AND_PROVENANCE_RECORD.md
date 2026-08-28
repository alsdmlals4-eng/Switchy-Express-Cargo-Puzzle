# Switchy Express Asset Rights and Provenance Record

> 자산별 복사본을 작성한다. 빈 Template은 실제 권리 증거가 아니다.

```yaml
asset_id:
category: MUSIC_SFX | FONT | CHARACTER_ILLUSTRATION | MODEL_3D_ANIMATION | PLUGIN_ASSET | OPEN_SOURCE_LIBRARY | AI_OUTPUT_MODEL_TERMS | OUTSOURCING_CONTRACT | VOICE_COMPOSER_TRANSLATOR_CONTRACT | OTHER
name:
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: OWNED_ORIGINAL | COMMISSIONED_ORIGINAL | LICENSED_THIRD_PARTY | OPEN_SOURCE | AI_GENERATED | REFERENCE_TO_ORIGINAL | MIXED_ROUTE
creator_or_vendor:
source_url_or_path:
source_checked_at:
acquired_or_created_at:
license_or_contract:
license_version_or_terms_date:
commercial_use: ALLOWED | CONDITIONAL | PROHIBITED | NOT_REQUIRED | UNKNOWN
distribution_in_game_build: ALLOWED | CONDITIONAL | PROHIBITED | NOT_REQUIRED | UNKNOWN
raw_source_redistribution: ALLOWED | CONDITIONAL | PROHIBITED | NOT_REQUIRED | UNKNOWN
modification: ALLOWED | CONDITIONAL | PROHIBITED | NOT_REQUIRED | UNKNOWN
attribution:
platform_or_territory_restrictions:
open_source_notice_or_source_obligation:
ai_model_service_version:
ai_terms_checked_at:
ai_input_rights:
ai_output_terms:
contract_scope:
voice_clone_or_ai_training_rights:
reference_sources:
reference_brief:
forbidden_expression:
final_asset_record:
reference_similarity_status: PASS | REVISION_REQUIRED | BLOCKED_UNVERIFIED | NOT_APPLICABLE
shipping_and_marketing_usage:
proof_reference:
proof_hash:
secure_original_location:
redacted_excerpt:
reviewed_by:
reviewed_at:
status: APPROVED | CONDITIONAL | REJECTED | RELEASE_BLOCKED_UNVERIFIED | SUPERSEDED
notes:
```

`commercial_use`, `distribution_in_game_build`, `raw_source_redistribution`, `modification`은 별개다. 필요한 값이 `UNKNOWN`이거나 조건 증거가 없으면 `RELEASE_BLOCKED_UNVERIFIED`다.

## Reference-to-original

```yaml
reference_only_input_excluded_from_build:
functional_or_general_principles_extracted:
identifiable_expression_removed:
project_specific_canon_applied:
independent_working_files:
comparison_set:
reviewer:
reviewed_at:
reference_similarity_status:
```

기능·퍼즐 정보 위계·색상+모양 접근성·일반 형태·재질·주파수·타이밍·성능 원리만 분석한다. 지도·열차·역·화물·UI tracing, 음악 sample, mesh·texture·rig·font glyph 추출, 특정 작가·성우 모사, 원본 AI 변환은 독립 제작으로 인정하지 않는다.

공개 저장소에는 원계약서·신분증·서명·주소·계좌·결제·세금·개인정보를 넣지 않는다. `secure_original_location`, 최소 metadata, hash와 적법한 redacted excerpt만 기록한다.

## Historical dual-preservation record and current GitHub-only consumer-image policy · 2026-08-26 / 2026-08-28

> **2026-08-28 active policy:** Notion is `RETIRED_NO_ACTIVE_USE`. Existing Notion attachment/readback fields below are historical provenance and are not erased. New candidate/final image work is GitHub repository only. A candidate may be generated and machine-reviewed without an image-by-image approval; only user-approved promotion creates a tracked final project asset. `APPROVED_GITHUB_PRESERVED` requires a proven consumer, local tracked file, SHA-256, generation authority and rights provenance. It does not prove runtime, UX or release readiness.

## SX-BOARD-TERRAIN-002 · SX-DEC-063 approved terrain v02

```yaml
asset_id: SX-BOARD-TERRAIN-002
category: AI_OUTPUT_MODEL_TERMS
name: board_terrain_playfield_v02.png
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: AI_GENERATED
creator_or_vendor: OpenAI image generation service
source_generation_receipt: 01a04558-94b7-77f3-b4e0-a5ec4bf2a04e / exec-2601f225-c29d-40d9-9098-8784dc73961c
source_checked_at: 2026-08-28 KST
acquired_or_created_at: 2026-08-28 KST
license_or_contract: OpenAI Terms of Use / output ownership subject to applicable law; third-party rights must not be infringed
license_version_or_terms_date: official source rechecked 2026-08-28 · https://openai.com/policies/terms-of-use/
commercial_use: CONDITIONAL
distribution_in_game_build: CONDITIONAL
raw_source_redistribution: CONDITIONAL
modification: CONDITIONAL
attribution: NOT_REQUIRED_BY_CURRENT_SERVICE_TERM_EVIDENCE · final release review still required
ai_model_service_version: NOT_RECORDED_BY_SOURCE_RECEIPT
ai_input_rights: original project brief and project-owned visual canon only; no third-party layout, logo, asset, or prompt reference supplied
reference_similarity_status: REVIEWED_NO_BRAND_OR_REFERENCE_LAYOUT_VISIBLE · release review remains separate
forbidden_expression_check: PASS_MACHINE_AND_VISUAL_REVIEW · no text, UI, rail, train, station, cargo, logo, watermark, score, currency, save, or known brand visible
repository_local_path: art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png
sha256: 1b8cdeda06a940e70bf462e0e59b71e4130eeb1b266f606d7cd484ab5d145d0d
dimensions: 1672x941 RGB · no alpha required by the terrain backdrop consumer
planned_runtime_consumer: ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]
runtime_connection_status: NOT_CONNECTED
tracking_issue: 243
approval_ref: USER-APPROVAL-2026-08-28-SX-VIS-063-TERRAIN-CANDIDATE-001-PROMOTION
status: APPROVED_GITHUB_PRESERVED_RUNTIME_NOT_CONNECTED
notes: Existing v01 remains the current runtime path and rollback source. Asset presence, import compatibility, or automated tests do not prove Godot runtime appearance, physical/audio/device/human/Player Experience, release-rights, or production cutover.
```

실제 game runtime consumer가 확인된 필요한 이미지는 별도 이미지별 승인 없이 자동 생성할 수 있다. 생성 후보는 review-only로 유지하고, 사용자 승인 final만 GitHub tracked project-local asset로 보존하며 기존 E+D Hybrid / Neo-Arcade 시각 언어를 유지한다. Runtime consumer가 없는 이미지 생성이나 runtime promotion은 이 권한에 포함되지 않는다.

```yaml
approved_image_record:
  creation_authority: USER_APPROVED_2026_08_26_AUTOMATIC_CONSUMER_IMAGE_POLICY | specific decision id
  visual_role: RUNTIME_PRODUCT_ASSET | VISUAL_REFERENCE | NOT_RUNTIME_PROOF
  historical_notion_reference: optional history-only provenance, never a current completion requirement
  repository_local_path: tracked art/** or docs/visual-references/** path
  repository_sha256: required
  provenance_or_rights_record: required
  runtime_consumer: exact consumer path | NOT_APPLICABLE
  consumer_status: VERIFIED | REFERENCE_ONLY | NOT_APPLICABLE
  preservation_status: APPROVED_GITHUB_PRESERVED | INCOMPLETE
```

`APPROVED_GITHUB_PRESERVED`은 프로젝트 로컬 Git tracked file, SHA-256, 생성 권한·권리 provenance와 proven consumer가 모두 있는 경우에만 사용한다. Runtime consumer가 확인되지 않은 이미지는 `VISUAL_REFERENCE` 또는 `NOT_RUNTIME_PROOF`로 남기며, 실제 게임 product asset으로 승격하지 않는다. Historical `APPROVED_DUAL_PRESERVED` entries remain exact historical evidence and are not retroactively renamed.

## SX-TITLE-HERO-001 · Title runtime hero banner

```yaml
asset_id: SX-TITLE-HERO-001
category: AI_OUTPUT_MODEL_TERMS
name: shell_title_hero_v01.png
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: AI_GENERATED
creator_or_vendor: OpenAI Image Generation
source_url_or_path: art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png
acquired_or_created_at: 2026-08-27
license_or_contract: service output terms must be rechecked for release use
commercial_use: CONDITIONAL
distribution_in_game_build: CONDITIONAL
raw_source_redistribution: CONDITIONAL
modification: CONDITIONAL
attribution: NOT_REQUIRED
ai_model_service_version: OpenAI Image Generation (session-provided)
ai_terms_checked_at: NOT_YET_RECHECKED
ai_input_rights: original text prompt; no reference image or third-party source supplied
ai_output_terms: release-rights review remains separate from runtime integration
reference_sources: project E+D Hybrid / Neo-Arcade visual-language contract only
reference_brief: text-free, logo-free, wide miniature railway title banner; blue locomotive, golden switch rail, red star cargo, warm station silhouette
forbidden_expression: branded material, copied game UI, known logos, watermark, localized copy, fake interface
final_asset_record: 1774x887 PNG · SHA-256 ce7fcd3ec380bc8b0840bcf28d56debd0d170bf8ca7681fee208cc8347f2d5dd
reference_similarity_status: NOT_APPLICABLE
shipping_and_marketing_usage: CONDITIONAL · runtime vertical-slice use; release review still required
proof_reference: GitHub Issue #216 · ProductShellArt TITLE_HERO_PATH · shell_title_hero_manifest.json
secure_original_location: C:/Users/user/.codex/generated_images/01a03dda-4905-7c41-b072-bd224e063324/exec-f1f15bd0-fb75-4bf3-b39f-7f1ae9be3438.png
reviewed_by: automated runtime-consumer and validation workflow
reviewed_at: 2026-08-27
status: CONDITIONAL
notes: User-authorized automatic consumer image. Project-local tracked copy, Notion attachment `file-upload://3c91b237-eb1c-81b3-b06d-00b297b2a323`, SHA-256, runtime consumer, and Notion readback at 2026-08-27T13:00:52.213Z are present; dual preservation status is APPROVED_DUAL_PRESERVED. Release-rights review remains separate.
```

## SX-INGAME-VISUAL-001 · In-game visual language runtime set

```yaml
asset_ids:
  - SX-BOARD-TERRAIN-001
  - SX-LESSON-HERO-001
  - SX-LESSON-HERO-002
  - SX-RESULT-SUCCESS-002
  - SX-RESULT-FAILURE-002
category: AI_OUTPUT_MODEL_TERMS
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: AI_GENERATED
creator_or_vendor: OpenAI Image Generation
acquired_or_created_at: 2026-08-27, 2026-08-28
creation_authority: USER_APPROVED_2026_08_26_AUTOMATIC_CONSUMER_IMAGE_POLICY
license_or_contract: service output terms must be rechecked for release use
commercial_use: CONDITIONAL
distribution_in_game_build: CONDITIONAL
raw_source_redistribution: CONDITIONAL
modification: CONDITIONAL
attribution: NOT_REQUIRED
ai_terms_checked_at: NOT_YET_RECHECKED
ai_input_rights: original text prompts; project-owned SX-LESSON-HERO-001 used only as an in-project style reference; no third-party source supplied
reference_sources: project E+D Hybrid / Neo-Arcade visual-language contract and project-owned SX-LESSON-HERO-001 only
forbidden_expression: branded material, copied game UI, known logos, watermark, localized copy, fake interface
repository_local_paths:
  - art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png
  - art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v01.png
  - art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v02.png
  - art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png
  - art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png
runtime_consumers:
  - ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]
  - ProductShellArt::LESSON_HERO_PATH
  - ProductShellArt::T2_LESSON_HERO_PATH
  - ProductShellArt::RESULT_SUCCESS_PATH
  - ProductShellArt::RESULT_FAILURE_PATH
proof_reference: GitHub Issues #219, #224 · runtime_visual_manifest.json · live Godot Lesson/BUILD/SUCCESS/FAILURE checks
notion_owner_page: 03 · Visual · UX · Assets
notion_readback_at: 2026-08-27T13:57:00.541Z
dual_preservation_status: v01 and v02 APPROVED_DUAL_PRESERVED
reference_similarity_status: NOT_APPLICABLE
shipping_and_marketing_usage: CONDITIONAL · runtime vertical-slice use; release review remains separate
status: CONDITIONAL
notes: Both Lesson Heroes and the other active runtime assets are text-free, logo-free, watermark-free. v01 remains the neutral shared hero for T1, T3–T6, and CAPSTONE; v02 is limited to T2. v02 is attached at `file-upload://3c91b237-eb1c-8144-a921-00b221df883d`; Visual-page readback completed at 2026-08-27T21:34:35.550Z. The manifest records exact SHA-256 and attachment identifiers. Godot 4.7.1 runtime verification remains required before promotion; no game rule, map, HUD semantic color, or SX-DEC-060 behavior changes.
```

## VS-DEMO-PRESENTATION-001 · In-engine board and UI shapes

```yaml
asset_id: VS-DEMO-PRESENTATION-001
category: OTHER
name: PC Vertical Slice procedural board and UI presentation
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: OWNED_ORIGINAL
creator_or_vendor: project source code
source_url_or_path: game/demo/presentation/demo_palette.gd · demo_theme_factory.gd · product_board_renderer.gd · product_hud.tscn · demo_effects.gd
acquired_or_created_at: 2026-08-06
license_or_contract: project-owned source code
commercial_use: ALLOWED
distribution_in_game_build: ALLOWED
raw_source_redistribution: ALLOWED
modification: ALLOWED
attribution: NOT_REQUIRED
reference_sources: none
reference_similarity_status: NOT_APPLICABLE
shipping_and_marketing_usage: CONDITIONAL · Vertical Slice evidence only until final art review
proof_reference: PR #83 · SX-DEC-037 · SX-AUD-020
reviewed_by: implementation adversarial review
reviewed_at: 2026-08-06
status: APPROVED
notes: Godot draw primitives, StyleBoxFlat and Tween properties generate all board, marker, UI and feedback visuals at runtime. No external image, texture, model, font file or traced source is included.
```

## VS-DEMO-AUDIO-001 · In-engine procedural cues

```yaml
asset_id: VS-DEMO-AUDIO-001
category: MUSIC_SFX
name: PC Vertical Slice procedural UI and train audio
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: OWNED_ORIGINAL
creator_or_vendor: project source code
source_url_or_path: game/demo/audio/demo_audio_director.gd
acquired_or_created_at: 2026-08-06
license_or_contract: project-owned source code
commercial_use: ALLOWED
distribution_in_game_build: ALLOWED
raw_source_redistribution: ALLOWED
modification: ALLOWED
attribution: NOT_REQUIRED
reference_sources: none
reference_similarity_status: NOT_APPLICABLE
shipping_and_marketing_usage: CONDITIONAL · Vertical Slice evidence only until final audio review
proof_reference: PR #83 · SX-DEC-037 · SX-AUD-020
reviewed_by: implementation adversarial review
reviewed_at: 2026-08-06
status: APPROVED
notes: AudioStreamGenerator streams are synthesized from repository-defined frequencies, envelopes and timing. No third-party sample, recording, music file, voice or AI audio output is included.
```

## SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001 · Planning-only visual board

```yaml
asset_id: SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001
category: AI_OUTPUT_MODEL_TERMS
name: PROJECT_CORE_SCENE_VISUAL_BOARD · generated exploration
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: AI_GENERATED
creator_or_vendor: OpenAI Image Generation
acquired_or_created_at: 2026-08-28
creation_authority: SX-DEC-061 · user-approved visual-direction exploration
visual_role: GENERATED_EXPLORATION · NOT_RUNTIME_PROOF
source_url_or_path: C:/Users/user/.codex/generated_images/01a04558-94b7-77f3-b4e0-a5ec4bf2a04e/exec-bf7f16f4-f43b-458d-8e37-d01ebc315634.png
final_asset_record: SHA-256 6aabad5e9834e777cae9124b4279fef0a1bca48ab6b056b3aebd48f901d7fafc
commercial_use: CONDITIONAL
distribution_in_game_build: NOT_REQUIRED
raw_source_redistribution: CONDITIONAL
modification: CONDITIONAL
attribution: NOT_REQUIRED
ai_terms_checked_at: NOT_YET_RECHECKED
ai_input_rights: original text prompt based on project-owned runtime facts and current visual canon; the user-supplied collage was inspected as reference only and was not supplied as a generation input
reference_sources: current E+D Hybrid / Neo-Arcade project direction; user-provided comparison collage at C:/Users/user/Desktop/비교샷/카고/19651a96-74d9-4c3f-8930-51f5fcaeca87.png · reference only
forbidden_expression: reference-layout copying, branded UI, real game logo, pseudo-text as canon, coin/economy/score/save systems, diagonal station service, station-footprint delivery, long cargo train, fuel, BOOST, capacity limit
runtime_consumer: NOT_APPLICABLE
consumer_status: NOT_APPLICABLE
repository_local_path: NOT_CREATED · planning board awaits explicit user artifact approval; no runtime asset is being created
notion_owner_page: 03 · Visual · UX · Assets · decision text sync required; binary attachment is not approved
dual_preservation_status: NOT_APPLICABLE_UNTIL_USER_APPROVES_THE_BOARD_AS_A_DURABLE_REFERENCE
reference_similarity_status: BLOCKED_UNVERIFIED
shipping_and_marketing_usage: PROHIBITED_PENDING_SEPARATE_RIGHTS_REVIEW
status: CONDITIONAL
notes: The board validates AI understanding of Title/T1/T2/T3/T4/T5/T6/Capstone-result flow. Number badges and any generated pictograms are non-canonical; exact meanings live in PROJECT_CORE_SCENE_VISUAL_BOARD.md. It neither changes nor proves Godot runtime UI, assets, human usability, player experience, or release rights.
```
