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

## User-approved automatic consumer-image dual-preservation policy · 2026-08-26

실제 game runtime consumer가 확인된 필요한 이미지는 별도 이미지별 승인 없이 자동 생성할 수 있다. 생성 이미지는 Notion과 프로젝트 로컬 저장소에 모두 보존해야 하며, 기존 E+D Hybrid / Neo-Arcade 시각 언어를 유지한다. Runtime consumer가 없는 이미지 생성이나 runtime promotion은 이 권한에 포함되지 않는다.

```yaml
approved_image_record:
  creation_authority: USER_APPROVED_2026_08_26_AUTOMATIC_CONSUMER_IMAGE_POLICY | specific decision id
  visual_role: RUNTIME_PRODUCT_ASSET | VISUAL_REFERENCE | NOT_RUNTIME_PROOF
  notion_owner_page: 03 · Visual · UX · Assets or the approved Asset Library destination
  notion_attachment_or_preview: durable attachment/preview identifier
  notion_readback_at: required
  repository_local_path: tracked art/** or docs/visual-references/** path
  repository_sha256: required
  provenance_or_rights_record: required
  runtime_consumer: exact consumer path | NOT_APPLICABLE
  consumer_status: VERIFIED | REFERENCE_ONLY | NOT_APPLICABLE
  dual_preservation_status: APPROVED_DUAL_PRESERVED | INCOMPLETE
```

`APPROVED_DUAL_PRESERVED`은 Notion destination readback, 프로젝트 로컬 추적 파일, SHA-256, 생성 권한·권리 provenance가 모두 있는 경우에만 사용한다. Runtime consumer가 확인되지 않은 이미지는 `VISUAL_REFERENCE` 또는 `NOT_RUNTIME_PROOF`로 남기며, 실제 게임 product asset으로 승격하지 않는다. 이 규칙은 역사적 transport/corruption batch를 소급 변경하지 않는다.

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
