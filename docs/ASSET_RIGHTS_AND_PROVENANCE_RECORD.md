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
runtime_consumer: ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]
consumer_status: VERIFIED_AUTOMATED_RUNTIME
runtime_connection_status: VERIFIED
tracking_issue: 243
approval_ref: USER-APPROVAL-2026-08-28-SX-VIS-063-TERRAIN-CANDIDATE-001-PROMOTION
status: APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED_AUTOMATED
notes: The 2026-08-30 Core Board v02 runtime implementation now loads this asset from the ProductBoardRenderer v02 map. Existing v01 remains a tracked rollback source. Automated verification does not prove physical/audio/device/human/Player Experience, release-rights, or production cutover.
```

## SX-DEC-063 Core Board v02 · user-approved generated runtime family

```yaml
approval_ref: USER-APPROVAL-2026-08-30-CORE-BOARD-V02-PIXELS-AND-SEAM-UNDERLAY
decision_id: SX-DEC-063
artifact_family: SWITCHY_HYBRID_MINIATURE_DIORAMA
creation_route: AI_GENERATED_THEN_DETERMINISTIC_GODOT_RESAMPLE
creator_or_vendor: OpenAI image generation service
source_generation_root: C:/Users/user/.codex/generated_images/01a04af4-2ebb-7912-80d3-e4bfa4f1efe0/
prompt_record: docs/visual-references/sx-dec-063-core-board-v02/CORE_BOARD_V02_CANDIDATE_RECORD.md#common-image-model-prompt-contract
prompt_scope: original single-object transparent sprite prompts; common contract plus exact candidate subject suffix
reference_sources: project-owned HGB r02 rail/station language candidate only, material and silhouette reference; not cropped, embedded, shipped, or used as a layout source
ai_input_rights: original project brief, current ProductBoardRenderer consumer table, and project-owned visual reference only; no third-party source, game screenshot, logo, trademark, asset pack, or creator style
forbidden_expression_check: MACHINE_AND_VISUAL_CANDIDATE_REVIEW_PASS · no text, logo, watermark, UI panel, frame, score/currency/save cue, cargo wagon, route/lock state, or diagonal station-service implication
runtime_consumer_owner: game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS
runtime_connection_status: VERIFIED_AUTOMATED_RUNTIME
automated_evidence: 2026-08-30 Godot 4.7.1 full runner · 112 cases · 13532 assertions · all 14 v02 Texture2D slots loaded
seam_underlay: curve and switch only; renderer-owned muted visual underlay copied from authored ports; no map, input, routing, service, lock, or gameplay-state effect
v01_rollback: all fourteen v01 board/core sources remain tracked and are contract-tested
physical_windows_audio_android_human_player_experience_release: NOT_RUN
```

| Asset ID | Selected image-model receipt | Final tracked path | Final SHA-256 | Consumer slot |
| --- | --- | --- | --- | --- |
| `SX-CORE-TRAIN-002` | `exec-eb29fe34-ca5b-423b-9699-962cad5592ef.png` | `art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png` | `73d4a758eaa5d05842b313480116927eb6f86ce84e64db01110ff76f97c96348` | `train` |
| `SX-CORE-RAIL-STRAIGHT-002` | `exec-95b28d77-dfa4-43f9-92cc-40d9439e99a8.png` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png` | `b0d0e4d89d0f25ce35e060f47754ed4aabb416877ecd9d93567e89e1248bd884` | `rail_straight` |
| `SX-CORE-RAIL-CURVE-002` | `exec-5185a5bf-5907-4282-bcb0-feac95b9104d.png` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png` | `8ca1b2396bfa74cc9e9d6380260585381f8bff9342301d66b072b9347fe7459f` | `rail_curve` |
| `SX-CORE-RAIL-CROSSING-002` | `exec-0d0307f1-1e34-45fd-8b6e-9410bf859248.png` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png` | `bf77c0e0382a1af2d6b4a6ab38bc00158bfc1875d7642fbbd1e6c1fb31371244` | `rail_crossing` |
| `SX-CORE-RAIL-SWITCH-002` | `exec-52ac3317-0621-48b1-a837-550edeb6e5ab.png` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png` | `7d0c45093fae34b11b3ce122cc784db875b543e34aeaf1ff844bbc8701071d86` | `rail_switch` |
| `SX-CORE-MARKER-START-002` | `exec-3c8e8c35-d79b-4da4-b59b-f31338e71f1f.png` | `art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png` | `727cbc90ed667e013f402edc09e1e1be5e3cc031d043689f9dcdb74a8e3fdbe3` | `start_marker` |
| `SX-CORE-MARKER-END-002` | `exec-8f14bfa3-a06d-42e8-98dc-7a8b369187fe.png` | `art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png` | `9c5e07a8b868be88dcb9af6e708e1fb85d77105ddbab743e496cfadeea6d1e83` | `route_end_marker` |
| `SX-CORE-STATION-RED-002` | `exec-a5842278-90f2-4964-8c0a-215f0ec0fab6.png` | `art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png` | `15f5be85d0830b2970b036464a4ec7064b065071fb8b6a44ec2234c48c750703` | `station_red` |
| `SX-CORE-STATION-BLUE-002` | `exec-c3748987-887a-4209-a222-26ade19b7eab.png` | `art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png` | `558d15d0702d7b13cc522e26ba6db0d6c7c7f7226e31ca05e55ebfc14077ea12` | `station_blue` |
| `SX-CORE-STATION-YELLOW-002` | `exec-c9e9af7e-2139-4bb6-ba9a-c54abeeadae8.png` | `art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png` | `cc88f7f296b63b1bcc3858a515e5d28b7bb4f19c33e75cdde1fbd6e6462f433f` | `station_yellow` |
| `SX-CORE-CARGO-RED-002` | `exec-fca9e1d1-fd36-4d79-9e77-08b51f46b66d.png` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png` | `6feb7fa4a6b3a5401b97fb89d32fc38d0da4f27a3ea01404138453b90b865407` | `cargo_red` |
| `SX-CORE-CARGO-BLUE-002` | `exec-382a8f00-8c25-415b-872b-df80c7124ee6.png` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png` | `15ada5b6a14038d381e740304a8cf5cbf480f50f45a8c38e14b37a83b787f831` | `cargo_blue` |
| `SX-CORE-CARGO-YELLOW-002` | `exec-cdee6143-289f-41fe-979f-c9ce33add219.png` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png` | `96f667e507fc0d956fd34070ee1aa36d3ce195b39a208a80a7cd71db8ce9bc8f` | `cargo_yellow` |

Every final binary above is user-approved, GitHub-preserved, and machine-verified only at its actual renderer consumer boundary. The candidate source and its review previews remain outside product paths as evidence; the project ships only the listed deterministic v02 PNGs. The four v02 rail binaries remain rollback/provenance bytes after the separate user-approved v03 rail-master correction below. `RELEASE_RIGHTS_NOT_APPROVED` and all human/device gates remain separate.

## SX-DEC-063 Rail Network Master v03 · user-approved runtime-derived rail family

```yaml
approval_ref: USER-APPROVAL-2026-08-30-RAIL-NETWORK-MASTER-V03
decision_id: SX-DEC-063
source_candidate_id: SX-VIS-063-RAIL-NETWORK-MASTER-003
creation_route: AI_GENERATED_THEN_DETERMINISTIC_RASTER_CROP_AND_RESAMPLE
creator_or_vendor: OpenAI image generation service
source_generation_root: C:/Users/user/.codex/generated_images/01a04af4-2ebb-7912-80d3-e4bfa4f1efe0/
source_generation_receipt: exec-c20ff7f8-a3b4-4b7d-a2d9-4a37d460ca3b.png
tracked_master_path: art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png
tracked_master_dimensions: 1254x1254 RGBA
tracked_master_sha256: f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b
derivation_operator: deterministic rectangular crop followed by 256x256-to-64x64 high-quality bicubic resample
ai_input_rights: original project brief and current product-owned visual canon only; no third-party layout, logo, asset, screenshot, or style reference supplied
reference_similarity_status: REVIEWED_NO_BRAND_OR_REFERENCE_LAYOUT_VISIBLE · release review remains separate
forbidden_expression_check: MACHINE_AND_VISUAL_CANDIDATE_REVIEW_PASS · no text, logo, watermark, UI panel, score/currency/save cue, station, cargo, train, or gameplay-state expression embedded
runtime_consumer_owner: game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS
runtime_connection_status: VERIFIED_AUTOMATED_RUNTIME
renderer_treatment: four product textures draw at the full cell rectangle; no renderer-local rail seam underlay remains
v02_rail_rollback: core_rail_*_normal_v02.png remain tracked, but no longer occupy a runtime rail slot
physical_windows_audio_android_human_player_experience_release: NOT_RUN
```

| Asset ID | Master crop rectangle `[x, y, width, height]` | Final tracked path | Final SHA-256 | Consumer slot |
| --- | --- | --- | --- | --- |
| `SX-CORE-RAIL-STRAIGHT-003` | `[0, 316, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v03.png` | `7f7ab656c5ef16a09cea2dd723c8985dccfb357231b9f2a99772be82e77c32ad` | `rail_straight` |
| `SX-CORE-RAIL-CURVE-003` | `[374, 749, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v03.png` | `43cb0e419a1f1cca7e81115740c1cee9264d5f0496165ba8578aa7bc520b6d49` | `rail_curve` |
| `SX-CORE-RAIL-CROSSING-003` | `[374, 318, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v03.png` | `85c176ea41fed46982c1929448854e2b4819495d11cd60dd0cfd851d1952c6da` | `rail_crossing` |
| `SX-CORE-RAIL-SWITCH-003` | `[821, 318, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v03.png` | `a30dd23d29d6b2158f81120d98a313b3448e1085982bd5fd447d55a12ecc68e9` | `rail_switch` |

The v03 master is a reproducibility source only and is excluded from Godot import/runtime use by its local `.gdignore`. The v03 table remains historical rollback/provenance evidence; its four paths are no longer runtime-selected after the centred-port correction below. Automated renderer/import evidence is distinct from remaining package, physical Windows/audio, Android device, accessibility, player-comprehension, release-rights, and production-cutover gates.

## SX-DEC-063 Rail Network Master v04 · centred-port runtime correction

```yaml
approval_ref: USER-APPROVAL-2026-08-30-RAIL-NETWORK-MASTER-V03_PLUS_USER-DIRECTION-2026-08-30-NATURAL-RAIL-CONNECTION
decision_id: SX-DEC-063
source_candidate_id: SX-VIS-063-RAIL-NETWORK-MASTER-003
creation_route: EXISTING_USER_APPROVED_AI_GENERATED_MASTER_THEN_DETERMINISTIC_RASTER_CROP_AND_RESAMPLE
new_image_generation_or_external_asset: NONE_PROMOTED
tracked_master_path: art/product_assets/ed_hybrid_v2/source/core_rail_network_master_v03.png
tracked_master_dimensions: 1254x1254 RGBA
tracked_master_sha256: f3a6f070b728e319a15b3fc1b72ac7c4732f3b632e73e5dda202a52e95bb5d5b
derivation_tool: tools/derive_sx_dec_063_master_rail_v04.gd
derivation_operator: deterministic rectangular crop followed by 256x256-to-64x64 Lanczos resample
derivation_verification: --verify re-derives and byte-compares all four tracked outputs without writing them
selection_rule: every declared visual rail port must be centred on its logical 64px tile edge within two pixels
runtime_consumer_owner: game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS
runtime_connection_status: LOCAL_AUTOMATED_AND_MACHINE_RUNTIME_VERIFIED
renderer_treatment: four product textures draw at the full cell rectangle; rotations 1/3 pre-swap non-square local draw dimensions before renderer rotation; no renderer-local rail seam underlay remains
v01_v02_v03_rail_rollback: tracked and not runtime-selected
local_windows_android_package_proof: VERIFIED_LOCAL_ONLY
remote_runtime_byte_ci: PASS_PR_255_4D5C5EF_7_REQUIRED_CHECKS
physical_windows_audio_android_human_player_experience_release: NOT_RUN
```

| Asset ID | Master crop rectangle `[x, y, width, height]` | Final tracked path | Final SHA-256 | Consumer slot |
| --- | --- | --- | --- | --- |
| `SX-CORE-RAIL-STRAIGHT-004` | `[650, 803, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v04.png` | `f8ef22f4410891956d22662bee7eadc6ae5686042fee8a2fce6e27d48eae172f` | `rail_straight` |
| `SX-CORE-RAIL-CURVE-004` | `[394, 803, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v04.png` | `2d75843d4ccd7cb11bc679814690e954c15c69477364df4414eec0b19c7499c7` | `rail_curve` |
| `SX-CORE-RAIL-CROSSING-004` | `[388, 300, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v04.png` | `0500d474f628272f33c1cf29622d30e7ad86b79ed5c77476894f75b566a5f3d9` | `rail_crossing` |
| `SX-CORE-RAIL-SWITCH-004` | `[855, 300, 256, 256]` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v04.png` | `08341ce6b346c2225bbc146c7dbde12e2854b57cca7dc9369e6f6bdcd9ebca37` | `rail_switch` |

The v04 correction does not add a new generated image or third-party reference. The user-visible defect was an off-centre v03 crop, not a missing rail family. The real-byte port contract, import, full suite, live recommended board capture, local package proof, and all seven required remote checks for PR #255 runtime-byte head `4d5c5ef09040c36aa064b8b79ddb69443b465877` verify the current consumer at their stated machine evidence ceiling. Immutable candidate and all physical/human/release gates remain separate.

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

## SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B · Planning-only core-systems board

```yaml
asset_id: SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B
category: AI_OUTPUT_MODEL_TERMS
name: PROJECT_CORE_SCENE_VISUAL_BOARD · core-systems explanatory exploration
project: SWITCHY_EXPRESS_CARGO_PUZZLE
creation_route: AI_GENERATED
creator_or_vendor: OpenAI Image Generation
acquired_or_created_at: 2026-08-28
creation_authority: user-authorized regeneration against SX-DEC-061/063 current direction
tracking_issue: '#246'
visual_role: USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · NOT_RUNTIME_PROOF
source_url_or_path: C:/Users/user/.codex/generated_images/01a04558-94b7-77f3-b4e0-a5ec4bf2a04e/exec-acc36215-2087-46a2-855e-0f0c3fffaa62.png
source_checked_at: 2026-08-29 KST · source readable; SHA-256 and dimensions matched
final_asset_record: SHA-256 6577d7ac5e490b1303af0105ef0573cf5b4be10a52cbdd4ccecb24ec116993bc · 1672x941 PNG
previous_rejected_exploration: SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002A · SHA-256 591c6799c0202ee70858fd89cd3fc6530bd81e124fc8eeb00bc34436b24e1cf · switch picture exposed three exits
commercial_use: CONDITIONAL
distribution_in_game_build: PROHIBITED
raw_source_redistribution: CONDITIONAL
modification: CONDITIONAL
attribution: NOT_REQUIRED
ai_terms_checked_at: NOT_YET_RECHECKED
ai_input_rights: original prompt from project-owned rules, code facts, and current visual canon; the user-provided collage was inspected as reference only and was not a generation input
reference_sources: current E+D Hybrid / Neo-Arcade direction; user-provided comparison collage at C:/Users/user/Desktop/비교샷/카고/19651a96-74d9-4c3f-8930-51f5fcaeca87.png · reference only
forbidden_expression: branded/copycat layout, pseudo-text as canon, coin/economy/score/save systems, diagonal station service, station-footprint delivery, long cargo train, fuel, BOOST, capacity limit, three-exit switch depiction, runtime proof claim
runtime_consumer: NOT_APPLICABLE
consumer_status: NOT_APPLICABLE
repository_local_path: docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png
notion_owner_page: RETIRED_NO_ACTIVE_USE · no new Notion read/write/sync
preservation_status: USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · source readback SHA-256/dimensions matched on 2026-08-29 KST
reference_similarity_status: BLOCKED_UNVERIFIED
shipping_and_marketing_usage: PROHIBITED_PENDING_SEPARATE_RIGHTS_REVIEW
status: CONDITIONAL
notes: The user approved this planning reference on 2026-08-29 KST. The six panels cover build/preflight, exact cargo versus cardinal station service, Manual/Auto LIFO order, direct switch commitment, capstone chain, and factual Retry/Edit recovery. Its structured meaning is owned by PROJECT_CORE_SCENE_VISUAL_BOARD.md. It changes and proves neither Godot runtime UI, assets, human usability, player experience, release rights, nor any product rule.
```
