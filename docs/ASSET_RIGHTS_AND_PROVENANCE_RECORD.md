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
