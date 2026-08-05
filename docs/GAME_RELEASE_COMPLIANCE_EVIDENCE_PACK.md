# Switchy Express Game Release Compliance Evidence Pack

> Google Play 제출 전 작성한다. 현재 문서는 실제 제출·등급·법률 검토가 아니다.

```yaml
release_pack_id:
project: SWITCHY_EXPRESS_CARGO_PUZZLE
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
baseline_commit:
target_build:
status: DRAFT | IN_PROGRESS | READY_FOR_SUBMISSION | SUBMITTED | APPROVED | RETURNED | RELEASE_BLOCKED_UNVERIFIED
rating_strategy: LOWEST_VIABLE_RATING
adult_only_avoidance: AVOID_ADULTS_ONLY
content_rating_target: UNASSIGNED_PENDING_REPRESENTATIVE_BUILD
target_audience:
children_in_target_audience: UNDECIDED
families_policy_applicable: UNDECIDED
```

```yaml
Google_Play:
  regional_iarc_ratings:
  questionnaire_version_or_checked_at:
  target_audience_declaration:
  families_policy_status:
  ads_sdk_data_privacy_status:
  build_evidence:
  store_listing_evidence:
  trailer_screenshot_evidence:
  cosmetic_currency_status:
  ads_iap_status:
  ai_generated_content_status:
  status: NOT_STARTED | IN_PROGRESS | READY_FOR_SUBMISSION | SUBMITTED | APPROVED | RETURNED | RELEASE_BLOCKED_UNVERIFIED
```

## Risk matrix

| Risk | Present | Context/evidence | Platform answer | Mitigation | Status |
|---|---|---|---|---|---|
| violence |  |  |  |  |  |
| sexual content |  |  |  |  |  |
| horror |  |  |  |  |  |
| language |  |  |  |  |  |
| drugs/alcohol/tobacco |  |  |  |  |  |
| crime |  |  |  |  |  |
| gambling/simulated gambling |  |  |  |  |  |
| ads/IAP |  |  |  |  |  |
| UGC/online interaction |  |  |  |  |  |
| AI-generated/live-generated content |  |  |  |  |  |

```yaml
build_store_questionnaire_consistency:
  target_build_matches_review_build:
  store_description_matches_features:
  screenshots_and_video_match_build:
  cosmetic_currency_and_rewards_match_store:
  ads_and_offers_match_content_rating:
  online_ugc_features_disclosed:
  ai_content_disclosed:
  result: PASS | REVISION_REQUIRED | RELEASE_BLOCKED_UNVERIFIED

asset_rights_coverage:
  MUSIC_SFX:
  FONT:
  CHARACTER_ILLUSTRATION:
  MODEL_3D_ANIMATION:
  PLUGIN_ASSET:
  OPEN_SOURCE_LIBRARY:
  AI_OUTPUT_MODEL_TERMS:
  OUTSOURCING_CONTRACT:
  VOICE_COMPOSER_TRANSLATOR_CONTRACT:
```

필요 권리 `UNKNOWN/PROHIBITED`, 조건 이행·OSS 고지·AI 입력 권리·계약 범위 누락, reference-only 원본 포함, build/store/questionnaire 불일치, Families·광고 SDK·데이터·개인정보·ads/IAP·cosmetic currency 미확인, 민감 원본 공개는 `RELEASE_BLOCKED_UNVERIFIED`다.

```yaml
release_decision: READY_FOR_SUBMISSION | RELEASE_BLOCKED_UNVERIFIED | RETURN_TO_PRODUCTION
runtime_asset_use_status: NOT_RUN
build_store_consistency_status: NOT_RUN
platform_submission_status: PLATFORM_SUBMISSION_NOT_RUN
legal_review_status: LEGAL_REVIEW_NOT_PERFORMED
```
