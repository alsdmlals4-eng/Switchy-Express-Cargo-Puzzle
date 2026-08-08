# E+D Hybrid Production Asset Pack Design

**Decision:** `SX-DEC-051`  
**Status:** `USER_APPROVED_DESIGN · IMPLEMENTATION_IN_PROGRESS · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-08 KST  
**Project baseline:** `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
**Base baseline:** `cf4c7a60c5b31b042043f91b268f381372fec69a`

## 1. Goal

`SX-DEC-050`에서 탐색용으로 정리한 `VIS-FINITE-01/02/03`을 실제 제작에 쓸 수 있는 **E+D 하이브리드 아트/컴포넌트 후보 패키지**로 승격한다.

이번 단계의 목표는 다음이다.

- 승인된 그림체를 반복 가능한 asset language로 고정한다.
- 컨셉 보드가 아니라 개별 재사용 가능한 이미지/상태 세트를 만든다.
- RUN/LIFO, BUILD, 버튼 상태, VFX, 화면 셸/메타 순서로 필요한 표현 요소를 채운다.
- GitHub에 provenance와 파일 명명 규칙을 포함한 production-candidate package를 기록한다.
- 실제 Godot Scene/Resource/Theme/signal authoring, runtime wiring, POC, Windows/Android 물리 검증은 계속 뒤로 미룬다.

## 2. Approved art direction

Working name: `E+D HYBRID · NEO-ARCADE READABILITY`

핵심 성격:
1. 젊고 세련된 네오 아케이드 셀셰이딩, 깊은 네이비/블루 베이스, 금색/네온 포인트.
2. 큰 실루엣과 빠른 정보 판독, 색+형상 중복 부호.
3. 게임판 우선: rail / switch / station / cargo / HUD 의미가 장식보다 먼저 읽힌다.
4. 글로벌 5세~20대 초반 범위를 겨냥하되 지나치게 유아적인 캐릭터 비중은 제한한다.
5. 기관차가 시각적 anchor이며 cargo wagon은 기관차보다 확실히 작다. 초기 목표 footprint는 약 65~75%, 최종 runtime scale은 POC에서 확정한다.

## 3. Rights / provenance boundary

특정 상업 IP, 특정 게임 UI skin, 특정 살아있는 작가/스튜디오의 식별 가능한 스타일을 모방하지 않는다.

각 생성 자산 상태:
`GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`

이는 Godot 실제 사용, 최종 출시 승인, POC/runtime evidence, Windows/Android physical PASS를 의미하지 않는다.

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

`art/production_candidates/.gdignore`로 현재 Godot runtime import authority와 분리한다.

## 5. Required candidate roles

### P0 Core/world
- locomotive_blue
- cargo_wagon_red / blue / yellow
- cargo_star_red / blue / yellow
- station_red / blue / yellow
- rail_straight / rail_curve / rail_crossing / rail_switch_three_way
- start_marker / route_end_marker

원칙:
- cargo/station identity는 색상만으로 전달하지 않는다.
- locomotive가 vehicle anchor다.
- rail silhouette는 연결 방향이 먼저 읽혀야 한다.

### P0 RUN/LIFO
- stack_hud: empty / compact / 8plus / 16plus / 32plus / TOP / group boundary / unloading / paused
- train_cargo_strip: empty / 1 / 2 / 3 / +N / unload transition
- switch_direction: visible / selected / unselected / occupied locked / inactive / U-turn-compatible
- load_mode: manual idle/held, auto off/on, paused disabled
- combo_feedback: unload/combo states + Reduced Motion static equivalent

### P0 BUILD
- build_states / placement preview: valid/invalid ghost, rotate/replacement, port markers
- track_palette: idle/selected/unavailable/focus/pressed
- ghost_route: hidden/visible/overlap
- cost_hud: baseline/preview delta/target missed/cap missed
- preflight_notice: clear/primary/multi/focused location

### P0 Controls
normal / hover / pressed / selected / disabled / locked / keyboard focus. State meaning must not rely on hue alone.

### P1 bounded first set
- feedback/VFX including Reduced Motion equivalents
- text-safe success/failure result shells
- progress/meta primitives without generated localized copy

## 6. Export rules

- PNG, transparent where applicable
- consistent padding
- reusable icon art contains no baked localization text unless explicitly copy-specific
- text-heavy UI uses text-safe blank panels + separate icon art where possible
- naming: `<family>_<role>_<variant>_<state>_v01.png`

## 7. Production workflow

1. Generate/curate coherent family source references.
2. Reject style drift or ambiguous semantics.
3. Separate accepted transparent candidates.
4. Record every candidate in `manifest.json`.
5. Commit to isolated branch.
6. Run candidate contract/rights/static checks that do not require runtime integration.
7. Review PR diff and provenance.
8. Merge candidate package only after exact-head gates.
9. Later Decision: selected candidate promotion/runtime integration through required Godot authoring authority.

## 8. Adversarial reject gates

Reject/redraw if:
- wagon appears equal/larger than locomotive;
- highlight obscures rail connectivity;
- cargo/station identity depends only on color;
- switch selected/locked state is ambiguous without color;
- LIFO TOP is not glance-readable;
- decorative props look interactable;
- button states differ only by hue;
- generated copy is relied on as localized final UI;
- VFX covers likely next input region;
- success decoration competes with primary action;
- candidate resembles recognizable third-party IP or named living-artist/studio style.

## 9. Acceptance for candidate phase

- all P0 role families have at least one coherent candidate;
- bounded P1 VFX/shell/meta first set exists;
- locomotive/wagon hierarchy is consistent;
- separated PNG candidates exist and manifest/provenance is complete;
- candidate tree remains outside runtime authority;
- no runtime/Scene/Resource/Theme/signal implementation is claimed;
- GitHub and configured Sheet carry the same `SX-DEC-051` status.

## 10. Explicitly deferred

Godot scene/resource/theme authoring, runtime sprite hookup, actual HUD implementation, POC, Windows physical runtime, Android device, connected HiGodot, human comprehension testing, final product-asset approval, cutover.
