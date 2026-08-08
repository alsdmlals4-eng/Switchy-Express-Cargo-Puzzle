# E+D Hybrid Production Asset Pack Design

**Decision:** `SX-DEC-051`  
**Status:** `USER_APPROVED_DESIGN · IMPLEMENTATION_PLANNING · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-08 KST  
**Project baseline:** `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
**Base at approval recovery:** `a912cc001ff4d4e3415fb4b4931723c49eb08d9a`  
**Approval:** user message `권장안대로 승인` on 2026-08-08 KST

## 1. Goal

`SX-DEC-050`에서 탐색용으로 정리한 `VIS-FINITE-01/02/03`을 실제 제작에 넘길 수 있는 **E+D 하이브리드 production-candidate 아트/컴포넌트 패키지**로 승격한다.

이번 단계는 컨셉 보드 추가가 아니라 반복 가능한 asset language, 개별 이미지 후보, 상태 세트, provenance/manifest를 만든다. 실제 Godot Scene/Resource/Theme/signal authoring, runtime wiring, POC, Windows/Android 물리 검증은 뒤로 미룬다.

## 2. Approved art direction

Working name: `E+D HYBRID · NEO-ARCADE READABILITY`

- E 계열: 젊고 세련된 네오 아케이드 셀셰이딩, 깊은 네이비/블루, 금색·네온 포인트, 강한 보상 피드백.
- D 계열: 큰 실루엣, 빠른 판독, 강한 색+형상 중복 부호, 모바일 친화적 UI.
- 게임판 우선: rail / switch / station / cargo / HUD 의미가 장식보다 먼저 읽힌다.
- 글로벌 5세~20대 초반을 대상으로 친근함과 비유아적 세련미를 동시에 유지한다.
- 기관차가 이동체 anchor이며 뒤쪽 cargo wagon은 기관차 visual footprint의 약 65~75%를 목표로 한다. 최종 runtime scale은 POC에서 확정한다.

## 3. Rights / provenance boundary

특정 상업 IP, 특정 게임 UI skin, 특정 작가/스튜디오의 식별 가능한 스타일을 모방하지 않는다.

이 단계의 생성 자산 상태는 모두:

`GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`

최종 제품 자산 승인은 runtime integration + visual QA + rights/provenance review 뒤 별도 게이트다.

## 4. Repository placement

```text
art/production_candidates/ed_hybrid_v1/
  README.md
  manifest.json
  core/
  board/
  build/
  run/
  ui/
  vfx/
  shells/
  meta/
  sheets/
```

`art/production_candidates/.gdignore`로 현재 Godot import/runtime 경로와 분리한다.

## 5. P0 core world assets

필수:

- locomotive_blue
- cargo_wagon_red / blue / yellow
- cargo_star_red / blue / yellow
- station_red / blue / yellow
- rail_straight
- rail_curve variants
- rail_crossing
- rail_switch_three_way
- start marker
- finish / route-end marker

보조:

- cargo_star_green / purple / rainbow
- crate / barrel / rock / bush / lamp / sign props

원칙: cargo/station은 색상만이 아니라 shape/symbol redundancy를 유지하고, rail은 연결 방향이 장식보다 먼저 읽혀야 한다.

## 6. P0 RUN / LIFO

`CMP-RUN-STACK-HUD`: empty, compact 1~4, 8plus, 16plus, 32plus, TOP highlighted, next unload group boundary, unloading, paused.

`CMP-RUN-TRAIN-CARGO-STRIP`: empty, 1 token, 2 tokens, 3 tokens, compressed +N, unload transition.

`CMP-RUN-SWITCH-DIRECTION`: three visible, selected up/left/right, unselected, occupied locked, inactive, U-turn affordance compatible with VIS-014.

`CMP-RUN-LOAD-MODE`: manual idle/held, auto off/on, paused disabled.

`CMP-RUN-COMBO-FEEDBACK`: unload x1/x2+, combo x2/x3/x4+, reduced-motion static badge.

## 7. P0 BUILD

`CMP-BUILD-TRACK-PALETTE`: idle, selected, unavailable, focus, pressed.

`CMP-BUILD-PLACEMENT-PREVIEW`: valid ghost, invalid ghost, rotate preview, replacement preview, port markers.

`CMP-BUILD-GHOST-ROUTE`: hidden, visible dotted/low-saturation, overlap with actual rail.

`CMP-BUILD-COST-HUD`: baseline, preview delta +/-, optional target missed, leaderboard cap missed.

`CMP-BUILD-PREFLIGHT-NOTICE`: clear, primary issue, multi issue, focused board location.

## 8. P0 button/control states

States: normal, hover, pressed, selected, disabled, semantic locked, keyboard focus.

Controls: settings, undo, retry, menu/list, pause, play, hint, home, close, rotate, delete/remove, next level, retry same layout, edit route, level select.

상태 차이는 hue만이 아니라 outline, inset, brightness, icon treatment로 중복 전달한다.

## 9. P1 feedback / VFX

- cargo pickup pop
- pickup-star disappearance sparkle
- station unload pulse
- unload transfer trail
- combo burst
- success star flare
- confetti small/medium
- failure pulse
- ROUTE_END badge/marker
- TIME_EXPIRED badge/marker
- personal-best flare
- NEW/BEST chips

핵심 VFX마다 Reduced Motion용 static equivalent를 둔다.

## 10. P1 shells / result / meta

Shells: title, briefing, pause/menu, exit confirm, success result, failure result, stage select.

Result: outcome header, 0/1/2/3 star, score, time/build-cost/max-combo stats, personal best, failure reason, retry/edit/title-or-next hierarchy.

Meta: chapter card current/completed/available/locked/selected, stage node 0/1/2/3 star, leaderboard gate locked/unlocked, archive filter chips and recent/favorite/uncleared states.

`SX-DEC-033~035` runtime 규칙은 아직 미구현이므로 이 단계의 meta 결과도 production candidate일 뿐이다.

## 11. Export and naming

- PNG.
- 투명 배경이 가능한 개별 자산은 alpha PNG.
- 개별 자산에는 poster title/watermark/장식 프레임을 넣지 않는다.
- 일정한 padding.
- 재사용 아이콘에는 불필요한 baked Korean/English copy를 넣지 않는다.
- text-heavy UI는 blank/text-safe panel과 icon art를 분리한다.

Naming:

```text
<family>_<role>_<variant>_<state>_v01.png
```

Examples:

```text
core_train_locomotive_blue_normal_v01.png
core_wagon_cargo_red_normal_v01.png
run_stack_token_red_top_v01.png
run_switch_arrow_left_selected_v01.png
build_track_curve_valid_ghost_v01.png
ui_button_retry_pressed_v01.png
vfx_cargo_pickup_sparkle_static_v01.png
```

## 12. Production workflow

1. coherent contact sheet를 family별 생성/큐레이션.
2. E+D language에서 벗어난 결과를 적대적 검토로 거절.
3. 승인 family의 separated transparent candidates 생성.
4. `manifest.json`에 role/state/source-generation/provenance 기록.
5. isolated GitHub branch에 commit.
6. runtime integration 없이 가능한 repository contract / asset-rights / manifest 검증 수행.
7. PR diff/provenance 검토 후 candidate package만 merge.
8. Godot 통합·POC는 별도 Decision에서 수행.

## 13. Adversarial rejection gates

다음 중 하나라도 해당하면 redraw/reject한다.

- wagon이 기관차와 같거나 더 크게 읽힌다.
- neon/highlight가 rail connectivity를 가린다.
- cargo/station 구분이 색상에만 의존한다.
- switch selected/locked가 형태 없이 모호하다.
- LIFO TOP을 즉시 찾기 어렵다.
- 비상호작용 환경 prop이 버튼/퍼즐 오브젝트처럼 보인다.
- 버튼 상태 차이가 hue뿐이다.
- 생성된 글자를 최종 localized copy로 의존한다.
- VFX가 다음 switch/cargo 입력 영역을 가린다.
- success 장식이 primary next action과 경쟁한다.
- 특정 제3자 IP 또는 특정 작가/스튜디오 스타일을 식별 가능하게 닮는다.

## 14. Acceptance

- P0 family마다 coherent production-candidate set 존재.
- P1 VFX/shell/meta bounded first set 존재.
- locomotive/wagon hierarchy 일관.
- accepted core families의 separated PNG 존재.
- manifest/provenance 존재.
- Godot runtime/Scene/Resource/Theme/signal integration을 주장하지 않음.
- GitHub와 configured Sheet가 동일 `SX-DEC-051` 상태를 기록.

## 15. Explicitly deferred

Godot scene/resource/theme authoring, runtime sprite hookup, 실제 HUD 구현, POC, Windows physical runtime, Android device, connected HiGodot, human comprehension testing, final product-asset approval, cutover.