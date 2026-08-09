# SX-DEC-053 · Final E+D Production Visual Direction

**Status:** `USER_APPROVED_DIRECTION · SPEC_WRITTEN · IMPLEMENTATION_NOT_STARTED · FINAL_PRODUCT_ASSET_DIRECTION_APPROVED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST  
**Project baseline:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

`E+D HYBRID · NEO-ARCADE READABILITY`를 Switchy Express의 최종 제작용 비주얼 방향으로 승격한다.

이 방향은 다음 두 축을 결합한다.

- **E:** premium neon/cel-shaded arcade polish, 깊이감 있는 네이비/메탈 프레임, 선명한 하이라이트, 보상 순간의 에너지.
- **D:** bold readable silhouette, 큰 방향 정보, 단순한 상태 판독, 작은 화면에서도 즉시 읽히는 퍼즐 정보 위계.

최종 결과는 액션게임처럼 어둡고 복잡한 네온 화면이 아니라, `Readable miniature railway`와 `Cause before spectacle`을 유지하는 premium casual puzzle 화면이어야 한다.

## Train hierarchy

- 파란 기관차는 월드 train strip의 1차 시각 anchor다.
- 뒤따르는 화물칸은 기관차보다 명확히 작게 보인다.
- 초기 제작 목표는 기관차 시각 footprint의 약 **70~75%**다. 이 수치는 물리 collision/게임 규칙이 아니라 아트 조형을 위한 초기 tuning 값이며, 작은 화면 가독성을 위해 조정할 수 있다.
- 화물칸 축소가 색/형태 식별, TOP 표시, 연결 관계를 손상시키면 안 된다.
- 긴 CargoStack은 월드에 무한 화차를 펼치지 않고 existing compact train strip + `+N` 압축 계약을 유지한다.

## Preserved visual canon

다음 기존 정본은 그대로 유지한다.

- cute premium casual;
- readable miniature railway;
- color + shape redundancy;
- LIFO is visible;
- cause before spectacle;
- 토끼 기관사와 아늑한 미니어처 철도 세계;
- warm railway board + dark navy premium frame;
- red / blue / yellow cargo-station semantics;
- 큰 방향 화살표와 상태 중복 표현;
- Reduced Motion / mute / haptic-off 정보 등가성.

## Candidate promotion policy

`SX-DEC-051`의 31개 PNG는 계속 `production-candidate`다. 본 Decision은 그 31개 전체를 자동으로 최종 product asset으로 승격하지 않는다.

각 자산은 아래 세 판정 중 하나를 받아야 한다.

1. `PROMOTE_AS_IS` — 현재 candidate를 제작 자산으로 승격.
2. `PROMOTE_AFTER_REVISION` — 역할은 유지하되 비율/실루엣/상태 분리/텍스트 안전 영역 등을 수정 후 승격.
3. `REPLACE` — 같은 역할을 새 제작 자산으로 대체.

최종 승격 root는 구현 단계에서 `art/product_assets/ed_hybrid_v1/`로 사용한다. candidate 원본과 provenance는 삭제하지 않는다.

## Priority

1. Core world: locomotive, smaller cargo wagons, cargo stars, stations, rails, start/route-end.
2. RUN/LIFO: stack HUD, train strip, switch direction, load mode, combo.
3. BUILD: placement states, palette, ghost route, cost HUD, preflight.
4. Controls: normal/hover/pressed/selected/disabled/locked/focus.
5. Feedback/VFX: pickup, unload, success/failure, route-end/time-expired, Reduced Motion equivalents.
6. Shell/meta: briefing/pause/result/progress/stage states.

## Hard guardrails

- 퍼즐 정보보다 장식/마스코트가 우선하지 않는다.
- active/inactive/locked/invalid 상태는 색상 하나로만 표현하지 않는다.
- ghost rail은 실제 선로보다 강하게 보이지 않는다.
- switch/rail/cargo/station 실루엣은 축소 화면에서도 분리된다.
- 텍스트가 생성 이미지 안에 박제되지 않는다. shell은 localization-safe blank area를 제공한다.
- 화려한 VFX가 다음 분기/화물 입력을 가리지 않는다.
- 이 Decision으로 Scene/Resource/Theme/Animation/signal/runtime hookup을 완료했다고 주장하지 않는다.

## Explicit boundary

Still deferred / NOT_RUN:

- actual product-asset file promotion;
- Godot Scene/Resource/Theme/Animation/signal authoring;
- runtime sprite/HUD/VFX hookup;
- runtime/POC;
- Windows physical runtime;
- Android device validation;
- connected physical editor/Hera session;
- 10-minute soak;
- human playtest;
- final cutover.

## Supporting documents

- `docs/superpowers/specs/2026-08-09-final-ed-production-visual-direction-design.md`
- `기획서/40_표현/FINAL_PRODUCT_ASSET_LIST_V1.md`
- `기획서/40_표현/VISUAL_DIRECTION.md`
- `docs/decisions/SX_DEC_051_ED_HYBRID_PRODUCTION_ASSET_PACK.md`
- `art/production_candidates/ed_hybrid_v1/manifest.json`
