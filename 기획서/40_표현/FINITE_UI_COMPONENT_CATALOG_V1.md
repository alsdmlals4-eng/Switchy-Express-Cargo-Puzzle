# Finite UI Component Catalog V1

상태: `SX-DEC-050 · COMPONENT_SCOPE_DEFINED · IMPLEMENTATION_DEFERRED`

이 카탈로그는 UI·게임 표현 요소의 **역할·상태·권위 경계**를 정의한다. 아직 Godot Node/Scene/Resource 이름을 확정하지 않으며 실제 구현 존재를 주장하지 않는다.

## 공통 규칙

- View는 domain/layout/result/save authority를 소유하지 않는다.
- critical state는 색상 단독으로 전달하지 않는다.
- mouse/keyboard/touch의 의미는 동일하게 유지한다.
- Reduced Motion, mute, haptic-off에서 정보 등가 표현을 유지한다.
- Android touch target은 향후 48dp-equivalent를 기본 목표로 하되, 기존 VIS-014의 board-cell 제약형 방향 타겟은 현행 automated descriptor 계약을 보존한다.
- localization은 약 140% 확장을 견딜 수 있는 구조로 계획한다.
- `IMPLEMENTATION_DEFERRED`는 미구현을 뜻하며 PASS가 아니다.

## Shared

### CMP-FINITE-SURFACE-SHELL

```yaml
purpose: Title/BUILD/RUN/RESULT 계층에서 board와 HUD가 충돌하지 않는 공통 safe-area / hierarchy 틀
consumes_authority: finite phase + shell navigation state
states: normal · paused · modal-open · reduced-motion
interaction: focus-order contract only
accessibility: focus visible; status conveyed by text+shape
linked_requirements: all
implementation: DEFERRED
```

## BUILD

### CMP-BUILD-TRACK-PALETTE

```yaml
purpose: 직선·곡선·분기·교차 형태 선택
consumes_authority: allowed track forms + selected build command
states: idle · selected · unavailable · keyboard-focus · touch-pressed
interaction: select form; does not place by itself
accessibility: silhouette + name + selected outline
linked_requirements: VR-FINITE-BUILD-02
implementation: DEFERRED
```

### CMP-BUILD-PLACEMENT-PREVIEW

```yaml
purpose: 선택 셀에서 회전/포트/유효성 미리보기
consumes_authority: selected form + rotation + board cell + placement validator
states: valid · invalid · rotate-preview · replacement-preview
interaction: preview only; final placement remains build authority command
accessibility: port geometry + valid/invalid icon/shape
linked_requirements: VR-FINITE-BUILD-01 · VR-FINITE-BUILD-02
implementation: DEFERRED
```

### CMP-BUILD-GHOST-ROUTE

```yaml
purpose: 추천 설계도 표시/숨김과 실제 선로와의 시각 분리
consumes_authority: recommendation metadata only
states: hidden · visible · partially-overlapped
interaction: toggle only
accessibility: dotted/material distinction; never gold/completion-like
linked_requirements: VR-FINITE-BUILD-03
implementation: DEFERRED
```

### CMP-BUILD-COST-HUD

```yaml
purpose: current / preview / recommendation / optional target 비용 비교
consumes_authority: current_build_cost + preview delta + metadata thresholds
states: baseline · preview-change · optional-target-missed · leaderboard-cap-missed
interaction: read-only
accessibility: numeric-first; optional goals must not look like general failure
linked_requirements: VR-FINITE-BUILD-03
implementation: DEFERRED
```

### CMP-BUILD-PREFLIGHT-NOTICE

```yaml
purpose: 출발 불가의 primary issue와 수정 위치 제시
consumes_authority: preflight issue list + referenced board cell/edge
states: clear · primary-issue · multi-issue-summary · focused-location
interaction: focus issue location / optional details
accessibility: issue type icon + text + board highlight
linked_requirements: VR-FINITE-BUILD-04
implementation: DEFERRED
```

## RUN

### CMP-RUN-STACK-HUD

```yaml
purpose: LIFO 전체 순서, TOP, 다음 하역 그룹 가독성
consumes_authority: CargoStack snapshot + predicted contiguous top group for current context
states: empty · compact · 8plus · 16plus · 32plus · unload-group · paused
interaction: read-only; optional scroll/section expansion later
accessibility: cargo color+shape+TOP badge+group boundary
linked_requirements: VR-FINITE-RUN-01
implementation: DEFERRED
```

### CMP-RUN-TRAIN-CARGO-STRIP

```yaml
purpose: 월드 열차 주변에서 최근/TOP cargo와 +N을 압축 표시
consumes_authority: stack count + recent/top tokens
states: empty · 1-3 tokens · compressed-plus-N · unload-transition
interaction: read-only
accessibility: never replaces full stack HUD; token shape redundancy retained
linked_requirements: VR-FINITE-RUN-01
implementation: DEFERRED
```

### CMP-RUN-LOAD-MODE

```yaml
purpose: manual hold / auto-load 모드와 입력 접수 표시
consumes_authority: load mode + current input state
states: manual-idle · manual-held · auto-off · auto-on · paused-disabled
interaction: hold/toggle intent; domain decides contact-time pickup
accessibility: icon+label+shape; color-only forbidden
linked_requirements: VR-FINITE-RUN-02
implementation: DEFERRED
```

### CMP-RUN-SWITCH-DIRECTION

```yaml
purpose: reciprocal 세 방향 표시·직접 선택·U-turn·occupied lock
consumes_authority: existing RouteControlOverlay / switch exit authority
states: three-visible · selected · unselected · occupied-locked · inactive
interaction: reuse existing VIS-014 pointer-intent boundary
accessibility: line weight/fill + arrow direction
linked_requirements: VR-FINITE-RUN-03
implementation: REUSE_PROJECT · EXISTING_AUTOMATED_AND_USER_F5_EVIDENCE
```

### CMP-RUN-COMBO-FEEDBACK

```yaml
purpose: 하역 그룹 수와 Combo 결과를 원인 가까이 표시
consumes_authority: committed unload_count/combo_count
states: single-unload · multi-unload · combo · reduced-motion · muted
interaction: none
accessibility: numeric badge + token movement/static equivalent
linked_requirements: VR-FINITE-RUN-04
implementation: DEFERRED
```

## RESULT

### CMP-RESULT-SUMMARY

```yaml
purpose: success/failure, time or undelivered, build cost, score, max combo, personal best 요약
consumes_authority: result summary only after terminal commit
states: success · route-end · time-expired · other-failure · personal-best
interaction: read-only
accessibility: outcome icon/shape + heading + stat labels
linked_requirements: VR-FINITE-RESULT-01
implementation: DEFERRED
```

### CMP-RESULT-FAILURE-INSIGHT

```yaml
purpose: 실패 원인 1개 + 수정 위치/행동 1개를 우선 제시
consumes_authority: explicit failure reason and known actionable location/context
states: route-end · time-expired · bounded-other
interaction: optional focus/highlight of edit target later
accessibility: concise copy + location marker; no inferred false diagnosis
linked_requirements: VR-FINITE-RESULT-01
implementation: DEFERRED
```

### CMP-RESULT-ACTIONS

```yaml
purpose: Retry Same Layout / Edit Route / Title-or-next 흐름을 의미별로 분리
consumes_authority: allowed post-result commands + retry identity semantics
states: retry-primary · edit-primary/secondary by context · processing-disabled · keyboard-focus
interaction: explicit command intents only
accessibility: distinct labels + placement + focus order
linked_requirements: VR-FINITE-RESULT-02
implementation: DEFERRED
```

## PROGRESS

### CMP-PROGRESS-STAR-GATE

```yaml
purpose: speed/cost/score stars와 3-star leaderboard gate 표시
consumes_authority: goal metadata + committed result eligibility
states: 0/1/2/3-star · each-axis-earned/missed · leaderboard-locked/unlocked
interaction: optional details only
accessibility: different icon/label states beyond color
linked_requirements: VR-FINITE-PROGRESS-01
implementation: DEFERRED · SX-DEC-033_RUNTIME_NOT_STARTED
```

### CMP-PROGRESS-CHAPTER-CARD

```yaml
purpose: tutorial 1~10 / 11+ chapter progression의 일관된 stage 선택 카드
consumes_authority: campaign progression metadata
states: current · completed · available · locked · selected
interaction: select stage/chapter
accessibility: status icon + label + focus outline
linked_requirements: VR-FINITE-PROGRESS-02
implementation: DEFERRED · SX-DEC-034_RUNTIME_NOT_STARTED
```

### CMP-PROGRESS-ARCHIVE-FILTER

```yaml
purpose: recent / favorite / uncleared / theme/date 등의 기록 탐색
consumes_authority: archive metadata only; never exposes another player's route/replay
states: default · selected-filter · empty-result · long-list
interaction: filter selection
accessibility: text+icon+selection shape; keyboard focus planned
linked_requirements: VR-FINITE-PROGRESS-02
implementation: DEFERRED
```

## Existing visual behavior not duplicated

- `VIS-014` / `CMP-ROUTE-SWITCH-DIRECTION-ARROWS`: reuse as `CMP-RUN-SWITCH-DIRECTION`.
- `VIS-015` cargo pickup marker visibility: remains renderer/snapshot behavior; no new component is invented.
- station/cargo color+shape identity: current Visual Direction continues to apply.

## Future implementation grouping

Recommended later implementation slices:

1. `BUILD_CORE_UI`: palette + preview + cost + preflight.
2. `RUN_INFORMATION_UI`: stack + load mode + existing switch + Combo feedback.
3. `RESULT_CORE_UI`: summary + insight + actions.
4. `PROGRESS_UI`: stars/chapter/archive after product rules are implementation-ready.

No future slice above is approved for implementation by this catalog alone.
