# E+D Hybrid Production Asset Pack Design

**Decision:** `SX-DEC-051`  
**Status:** `USER_APPROVED_DIRECTION · WRITTEN_SPEC_REVIEW_REQUIRED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-08 KST  
**Project baseline:** `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
**Base baseline:** `eee98a930219065e30b4d7d14d99d5ac7db44c60`

## 1. Goal

`SX-DEC-050`에서 탐색용으로 정리한 `VIS-FINITE-01/02/03`을 실제 제작에 쓸 수 있는 **E+D 하이브리드 아트/컴포넌트 후보 패키지**로 승격한다.

이번 단계의 목표는 다음이다.

- 승인된 그림체를 반복 가능한 asset language로 고정한다.
- 컨셉 보드가 아니라 개별 재사용 가능한 이미지/상태 세트를 만든다.
- RUN/LIFO, BUILD, 버튼 상태, VFX, 화면 셸/메타 순서로 필요한 표현 요소를 채운다.
- GitHub에 provenance와 파일 명명 규칙을 포함한 production-candidate package를 기록한다.
- 실제 Godot Scene/Resource/Theme/signal authoring, runtime wiring, POC, Windows/Android 물리 검증은 계속 뒤로 미룬다.

## 2. Approved art direction

Working name:

`E+D HYBRID · NEO-ARCADE READABILITY`

핵심 성격:

1. **E 계열:** 젊고 세련된 네오 아케이드 셀셰이딩, 깊은 네이비/블루 베이스, 금색/네온 포인트, 강한 보상 피드백.
2. **D 계열:** 큰 실루엣, 단순하고 빠른 정보 판독, 강한 색+형상 중복 부호, 모바일에서 즉시 읽히는 UI.
3. **게임판 우선:** 장식보다 rail / switch / station / cargo / HUD의 의미가 먼저 읽혀야 한다.
4. **연령 폭:** 글로벌 5세~20대 초반에서 어린 층에게는 친근하고, 10대 후반~20대 초반에는 지나치게 유아적으로 보이지 않도록 캐릭터 비중을 제한한다.
5. **화차 축소:** 기관차를 시각적 anchor로 두고 뒤쪽 cargo wagon은 기관차보다 확실히 작게 표현한다. 초안 기준 visual footprint는 기관차의 약 65~75% 범위이며 최종 runtime scale은 POC에서 확정한다.

## 3. Rights / provenance boundary

생성형 결과는 특정 상업 IP, 특정 게임 UI skin, 특정 작가/스튜디오의 식별 가능한 스타일을 모방하지 않는다.

각 생성 자산은 다음 상태로 GitHub에 기록한다.

`GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`

즉, `SX-DEC-050`의 `REFERENCE_ONLY`보다 한 단계 승격하지만 다음을 의미하지 않는다.

- Godot에서 실제 사용 중이라는 주장
- 최종 출시 자산 승인
- POC/runtime evidence
- Windows/Android physical PASS

최종 제품 자산 승인은 runtime integration + visual QA + rights/provenance review 뒤 별도 게이트로 남긴다.

## 4. Repository placement

Godot의 자동 import/실행 경로와 분리하기 위해 production candidates는 다음 위치에 둔다.

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

`art/production_candidates/` 아래에는 `.gdignore`를 둬 현재 단계에서 Godot runtime import 대상으로 취급하지 않는다.

`README.md`는 상태 경계와 사용 금지를 설명하고, `manifest.json`은 각 파일의 role/state/source-generation/provenance를 기록한다.

## 5. Asset package

### 5.1 P0 · Core world assets

필수:

- locomotive_blue
- cargo_wagon_red
- cargo_wagon_blue
- cargo_wagon_yellow
- cargo_star_red
- cargo_star_blue
- cargo_star_yellow
- station_red
- station_blue
- station_yellow
- rail_straight
- rail_curve variants
- rail_crossing
- rail_switch_three_way
- start marker
- finish / route-end marker

보조:

- cargo_star_green
- cargo_star_purple
- cargo_star_rainbow
- crate / barrel / rock / bush / lamp / sign props

원칙:

- cargo/station은 `color + shape/symbol` redundancy 유지.
- 기관차가 가장 큰 이동체 anchor.
- wagon은 기관차보다 작은 비율을 유지.
- rail silhouette는 장식보다 연결 방향이 먼저 읽혀야 한다.

### 5.2 P0 · RUN / LIFO information assets

필수 상태:

`CMP-RUN-STACK-HUD`
- empty
- compact 1~4
- 8plus
- 16plus
- 32plus
- TOP highlighted
- next unload group boundary
- unloading
- paused

`CMP-RUN-TRAIN-CARGO-STRIP`
- empty
- 1 token
- 2 tokens
- 3 tokens
- compressed `+N`
- unload transition

`CMP-RUN-SWITCH-DIRECTION`
- three visible
- selected up
- selected left
- selected right
- unselected
- occupied locked
- inactive
- U-turn affordance compatible with VIS-014

`CMP-RUN-LOAD-MODE`
- manual idle
- manual held
- auto off
- auto on
- paused disabled

`CMP-RUN-COMBO-FEEDBACK`
- unload x1
- unload x2+
- combo x2 / x3 / x4+
- reduced-motion static badge

### 5.3 P0 · BUILD state assets

`CMP-BUILD-TRACK-PALETTE`
- idle
- selected
- unavailable
- focus
- pressed

`CMP-BUILD-PLACEMENT-PREVIEW`
- valid ghost
- invalid ghost
- rotate preview
- replacement preview
- port direction markers

`CMP-BUILD-GHOST-ROUTE`
- hidden
- visible dotted/low-saturation
- overlap with actual rail

`CMP-BUILD-COST-HUD`
- baseline
- preview delta positive/negative
- optional target missed
- leaderboard cap missed

`CMP-BUILD-PREFLIGHT-NOTICE`
- clear
- primary issue
- multi issue
- focused board location

### 5.4 P0 · Button / control state family

공통 버튼은 모든 상호작용 상태를 한 세트로 만든다.

States:

- normal
- hover
- pressed
- selected
- disabled
- locked when semantically needed
- keyboard focus

Controls:

- settings
- undo
- retry
- menu/list
- pause
- play
- hint
- home
- close
- rotate
- delete/remove
- next level
- retry same layout
- edit route
- level select

색상만으로 상태를 전달하지 않고 outline, inset, brightness, icon treatment를 함께 바꾼다.

## 6. P1 · Feedback / VFX pack

최소 조각 단위로 만든다.

- cargo pickup pop
- pickup star disappear sparkle
- station unload pulse
- unload token transfer trail
- combo burst
- success star flare
- confetti small/medium
- failure pulse
- ROUTE_END marker / badge
- TIME_EXPIRED marker / badge
- personal best flare
- NEW/BEST chips

Reduced Motion 대응:

- 각 핵심 VFX에는 motion 없이도 의미가 남는 static badge / outline / icon equivalent를 준비한다.

## 7. P1 · Shell / result / meta assets

### Shells

- title shell
- briefing shell
- pause/menu shell
- exit confirm shell
- success result shell
- failure result shell
- stage select shell

### Result

- outcome header
- 0/1/2/3 star states
- score block
- time/build cost/max combo stat blocks
- personal best state
- failure reason block
- retry/edit/title-or-next action hierarchy

### Meta / progress

- chapter card: current/completed/available/locked/selected
- stage node: 0/1/2/3 star
- leaderboard gate locked/unlocked
- archive filter chips
- recent/favorite/uncleared states

`SX-DEC-033~035`의 실제 runtime 규칙은 아직 미구현 상태이므로 이 단계의 meta asset은 production candidate일 뿐 구현 완료로 간주하지 않는다.

## 8. Export rules

### Individual production-candidate files

- format: PNG
- transparent background where applicable
- no poster title, watermark, or decorative board around individual asset
- consistent padding
- no baked Korean/English text inside reusable icon art unless the component itself is copy-specific
- text-heavy UI should use text-safe blank panels plus separate icon art where possible

### Preview sheets

`/sheets/`에는 검토 편의를 위한 contact sheet를 둘 수 있다.

Preview sheet는 실제 runtime sprite source가 아니다.

### Naming

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

## 9. Production workflow

1. Generate / curate one coherent contact sheet per asset family.
2. Reject assets that drift away from the E+D language.
3. Produce separated transparent candidates for accepted items.
4. Record each candidate in `manifest.json`.
5. Commit candidates to isolated GitHub branch.
6. Run repository contract / asset-rights checks that can run without runtime integration.
7. Review PR diff and provenance.
8. Merge planning/art candidate package only.
9. Later, in a separate Decision, integrate selected candidates into Godot through the required authoring authority and run POC/runtime validation.

## 10. Adversarial review gates

Reject or redraw an asset if any is true.

- wagon is visually equal to or larger than locomotive.
- neon/highlight obscures rail connectivity.
- cargo/station identity depends on color alone.
- switch selected/locked state is ambiguous without color.
- LIFO TOP cannot be identified in under a glance.
- decorative props look interactable when they are not.
- UI button state differs only by hue.
- generated text is relied on as final localized UI copy.
- VFX covers likely next switch/cargo input area.
- success decoration competes with the primary next action.
- asset resembles recognizable third-party IP or a specific living artist/studio style.

## 11. Acceptance for this phase

This phase is complete when:

- all P0 families have at least one coherent production-candidate set,
- P1 VFX/shell/meta have a bounded first set,
- locomotive/wagon hierarchy is consistent,
- separated PNG candidates exist for the accepted core families,
- manifest/provenance records exist,
- no Godot runtime/Scene/Resource/Theme/signal integration is claimed,
- GitHub and configured Sheet both record `SX-DEC-051` with the same status.

## 12. Explicitly deferred

- Godot scene/resource/theme authoring
- runtime sprite hookup
- actual HUD implementation
- POC
- Windows physical runtime
- Android device
- connected HiGodot
- human comprehension testing
- final product-asset approval
- cutover
