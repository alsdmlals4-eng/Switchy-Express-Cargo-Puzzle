# Switchy Express 플랫폼 출시·에셋 권리 Profile

> Base 정본: `alsdmlals4-eng/Base/docs/knowledge/game-development/PLATFORM_REVIEW_ASSET_RIGHTS_AND_REFERENCE_PRODUCTION_GUIDE.md`

## 전략

```yaml
rating_strategy: LOWEST_VIABLE_RATING
adult_only_avoidance: AVOID_ADULTS_ONLY
content_rating_target: UNASSIGNED_PENDING_REPRESENTATIVE_BUILD
rating_candidate_range: ALL_AGES_CANDIDATE
target_audience: GENERAL_PUZZLE_PLAYERS_PENDING_VALIDATION
children_in_target_audience: UNDECIDED
families_policy_applicable: UNDECIDED
platforms:
  Android: PRIMARY
  Google_Play: PRIMARY_RELEASE_CANDIDATE
  Steam: NOT_CURRENT_SCOPE
  STOVE: NOT_CURRENT_SCOPE
```

전체이용가는 강제 확정이 아니라 현재 퍼즐 내용에 맞는 후보다. 콘텐츠 등급과 아동 대상 선언을 분리하고, 대표 build·store·광고·보상 구조를 확인한 뒤 최종 설문을 작성한다.

## 콘텐츠·운영 위험 초안

| Risk | 현재 관찰 | 출시 전 확인 |
|---|---|---|
| violence / sexual content / horror / drugs / crime | 핵심 퍼즐 정본에서 확인되지 않음 | 전체 시각·문구·광고 전수 확인 |
| language | 안내·상점 문구 미완성 | 지역화 전수 확인 |
| gambling/simulated gambling | 확률형 보상은 승인되지 않음 | cosmetic_currency 획득·구매·확률 관계 |
| ads/IAP | 사용자 승인 없이 추가 금지 | 광고 SDK, 보상형 광고, IAP, 환불·가격·연령 적합성 |
| UGC/online interaction | 리더보드·도전 기능 범위 확인 필요 | 계정·닉네임·신고·개인정보 |
| AI-generated/live-generated content | 제작 자산별 증빙 필요 | 모델·서비스·버전·입력 권리·약관·Google Play 공개 |

`cosmetic_currency`는 성능 없는 꾸미기 보상 원칙을 우회하지 않는다. 유료 판매·광고 보상·확률 지급이 생기면 별도 사용자 Decision과 플랫폼 검토가 필요하다.

## 자산·참조 기반 독립 제작

음악·효과음, 폰트, 열차·역·화물·UI 일러스트, 3D·애니메이션, 플러그인·에셋, OSS, AI 출력·약관, 외주, 성우·작곡·번역 계약을 자산별로 관리한다.

```text
합법적인 reference source
→ 기능·정보 위계·퍼즐 가독성·일반 제작 원리
→ forbidden_expression
→ Switchy 고유 reference_brief
→ 독립 working files·final_asset_record
→ similarity and rights review
```

다른 퍼즐 게임의 지도·열차·UI skin·아이콘·캐릭터를 식별 가능하게 복제하거나 원본을 AI로 변환하는 방식은 독립 제작으로 인정하지 않는다.

## Gate

권리·조건 이행·OSS 고지·AI 입력 권리·Google Play target audience/Families/SDK·build/store/questionnaire·광고/IAP 일치 중 하나라도 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다.

```text
RUNTIME_ASSET_USE_CHECKED: NOT_RUN
BUILD_STORE_CONSISTENCY_CHECKED: NOT_RUN
GOOGLE_PLAY_SUBMISSION: PLATFORM_SUBMISSION_NOT_RUN
FINAL_RATING: NOT_ASSIGNED
LEGAL_REVIEW_NOT_PERFORMED
```
