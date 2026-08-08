# Finite Visual Requirement Package V1

상태: `SX-DEC-050 · PLANNING_PACKAGE_DEFINED · RUNTIME_DEFERRED`

Base Visual Requirement Gate를 적용해 `VIS-FINITE-01`, `VIS-FINITE-02`, `VIS-FINITE-03`에 필요한 시각 요소만 선정한다. 이 문서는 실제 이미지 파일·Godot Node·Scene·Resource·Theme의 존재를 주장하지 않는다.

## 공통 계약

```yaml
base_authority: fa69a77a14f923a756064f6ae151d34cadb374f7
project_baseline: cb6b69360f4ba865cd103573d2a2c22d5c16a1cd
decision_id: SX-DEC-050
visual_rows: VIS-FINITE-01 · VIS-FINITE-02 · VIS-FINITE-03
runtime_implementation: DEFERRED_NOT_RUN
poc: DEFERRED_NOT_RUN
windows_physical: NOT_RUN
android_device: NOT_RUN
connected_higodot: NOT_RUN
human_comprehension: NOT_RUN
image_status: GENERATED_EXPLORATION_ONLY
product_asset_status: NOT_APPROVED
```

## BUILD requirements

### VR-FINITE-BUILD-01 · Buildable Surface Readability

```yaml
surface_or_flow: BUILD board
player_question: 어디에 선로를 놓을 수 있고 어디에는 놓을 수 없는가?
element_type: board overlay / terrain state
role: INFORMATIONAL
why_needed: 건설 가능·불가 영역을 행동 전에 읽지 못하면 반복 오입력과 불필요한 실패가 발생한다.
delete_test: 제거하면 지형 장식만으로 가능/불가를 추측해야 하며 작은 화면에서 클릭 실수가 유의미하게 증가한다.
consumer: BUILD surface
priority: P0_BLOCKER
reuse_candidate: current board grid + authored terrain markers
disposition: ADAPT_EXISTING
required_states: buildable · blocked · occupied-authored-object · selected-cell
accessibility_equivalent: 밝기+형태+금지표식; 색상 단독 금지
platform_and_input: Windows mouse/keyboard · Android touch landscape
localization: no critical text dependency
production_cost: LOW
performance_risk: LOW
rights_or_provenance: procedural/project-owned presentation only
validation: future runtime capture + Android touch error observation
handoff: later Godot/Figma implementation
```

### VR-FINITE-BUILD-02 · Track Form Palette + Placement Preview

```yaml
surface_or_flow: BUILD selection/placement
player_question: 지금 어떤 선로 형태를 선택했고 이 칸에서 어느 방향으로 연결되는가?
element_type: functional selector + board preview
role: FUNCTIONAL
why_needed: 직선·곡선·분기·교차의 형태와 회전을 놓기 전에 이해해야 한다.
delete_test: 제거하면 설치 후 되돌리기로만 연결 형태를 확인하게 되어 건설 흐름과 학습성이 무너진다.
consumer: track-build interaction
priority: P0_BLOCKER
reuse_candidate: existing procedural rail geometry / current track-port semantics
disposition: CREATE_CUSTOM
required_states: idle · selected-form · preview-valid · preview-invalid · rotate · placed
accessibility_equivalent: 실루엣+포트 방향+선택 테두리; 색상 단독 금지
platform_and_input: Windows mouse/keyboard · Android touch landscape
localization: short track-form labels only; icon/shape remains primary
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: procedural/project-owned geometry
validation: future placement comprehension + port parity checks
handoff: preserve authoritative TrackPiece port meaning
```

### VR-FINITE-BUILD-03 · Ghost Route + Cost Comparison

```yaml
surface_or_flow: BUILD optimization support
player_question: 추천 설계는 어디이며 현재 노선/미리보기 비용은 선택 목표와 얼마나 차이 나는가?
element_type: informational overlay + HUD comparison
role: INFORMATIONAL
why_needed: 추천 설계와 비용 목표를 비교 가능하게 하되 정답 노선으로 오인하지 않게 해야 한다.
delete_test: 제거하면 비용/별 목표를 계획적으로 비교하기 어렵지만 기본 클리어 자체는 가능하다.
consumer: VIS-FINITE-01 exploration and later BUILD HUD
priority: P1_CLARITY
reuse_candidate: current board + neutral HUD blocks
disposition: GENERATE_EXPLORATION
required_states: ghost-hidden · ghost-visible · current-cost · preview-cost · recommendation-cost · optional-target-missed
accessibility_equivalent: 점선/재질 차이 + 숫자/아이콘; 금색 완료표현 금지
platform_and_input: Windows/Android landscape
localization: numeric-first; short labels tolerate ~140% expansion
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: exploration image must remain reference-only
validation: future ghost-answer-leakage and cost-language usability review
handoff: exploration image before implementation
```

### VR-FINITE-BUILD-04 · Preflight Issue Feedback

```yaml
surface_or_flow: BUILD → Run preflight
player_question: 왜 지금 출발할 수 없고 어느 위치를 고쳐야 하는가?
element_type: board marker + bounded issue banner
role: FEEDBACK
why_needed: 구조 오류를 추상 오류문만으로 주면 플레이어가 수정 지점을 찾기 어렵다.
delete_test: 제거하면 preflight 실패가 행동 가능한 피드백이 아니게 된다.
consumer: preflight result presentation
priority: P0_BLOCKER
reuse_candidate: current preflight issue data and board cell highlighting
disposition: CREATE_CUSTOM
required_states: no-issue · one-primary-issue · multiple-issues-summary · focused-cell
accessibility_equivalent: 문제 종류 아이콘/형태 + 위치 강조 + 텍스트 1줄
platform_and_input: Windows/Android landscape
localization: concise primary issue + optional details
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: project-owned UI
validation: future error-location comprehension
handoff: read-only projection of preflight authority
```

## RUN requirements

### VR-FINITE-RUN-01 · Persistent LIFO Stack Hierarchy

```yaml
surface_or_flow: RUNNING / UNLOADING
player_question: 현재 TOP은 무엇이고 다음 연속 하역 그룹은 무엇인가?
element_type: persistent stack HUD
role: INFORMATIONAL
why_needed: 무제한 stack에서 TOP과 다음 그룹이 보이지 않으면 퍼즐의 핵심 LIFO 판단이 불가능하다.
delete_test: 제거하면 월드 열차 표현만으로 8/16/32 cargo 순서를 복원해야 하므로 핵심 규칙 이해가 크게 약해진다.
consumer: VIS-FINITE-02 / RUN HUD
priority: P0_BLOCKER
reuse_candidate: current CargoStack snapshot data
disposition: CREATE_CUSTOM
required_states: empty · 1-7 · 8+ compressed · top-highlight · unload-group-highlight · paused
accessibility_equivalent: 색+형상+TOP 표식+group boundary
platform_and_input: Windows/Android landscape
localization: TOP/next-unload labels short; tokens remain self-identifying
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: project-owned UI
validation: future 8/16/32 readability and occlusion capture
handoff: presenter consumes stack authority read-only
```

### VR-FINITE-RUN-02 · Load Mode Control

```yaml
surface_or_flow: RUNNING
player_question: 지금 수동 적재인가 자동 적재인가, 입력이 접수됐는가?
element_type: toggle/hold control + persistent state feedback
role: FUNCTIONAL
why_needed: manual hold와 auto-load가 화물 접촉 결과를 바꾸므로 현재 모드를 항상 알 수 있어야 한다.
delete_test: 제거하면 같은 화물 접촉이 예상과 다르게 느껴지고 pickup 의도와 결과를 연결하기 어렵다.
consumer: RUN control surface
priority: P0_BLOCKER
reuse_candidate: current HUD/button interaction language
disposition: ADAPT_EXISTING
required_states: manual-idle · manual-held · auto-off · auto-on · paused-disabled · input-received
accessibility_equivalent: label+icon+shape state; color-only mode change 금지
platform_and_input: mouse/keyboard/touch
localization: short mode labels; icon grammar preserved
production_cost: LOW
performance_risk: LOW
rights_or_provenance: project-owned UI
validation: future mode recognition and touch test
handoff: no domain mutation ownership in View
```

### VR-FINITE-RUN-03 · Three-Direction Switch Selection

```yaml
surface_or_flow: RUNNING / UNLOADING
player_question: 이 분기에서 선택 가능한 방향은 무엇이고 어느 방향이 현재 선택/잠금 상태인가?
element_type: in-world directional targets
role: FUNCTIONAL / FEEDBACK
why_needed: 분기 세 포트와 U-turn 의미를 직접 선택해야 한다.
delete_test: 제거하면 연결된 방향과 선택 상태를 추론해야 하며 직접 조작성이 사라진다.
consumer: existing RouteControlOverlay
priority: P0_BLOCKER
reuse_candidate: VIS-014 · CMP-ROUTE-SWITCH-DIRECTION-ARROWS
disposition: REUSE_PROJECT
required_states: all-three-visible · selected · unselected · occupied-locked · inactive
accessibility_equivalent: line weight/fill + arrow direction; color-only 금지
platform_and_input: mouse/touch; current automated target descriptor >=44px when cell permits
localization: none
production_cost: LOW
performance_risk: LOW
rights_or_provenance: existing project procedural drawing
validation: existing automated + user F5 evidence retained; future Android touch still separate
handoff: no new binary asset or signal wiring
```

### VR-FINITE-RUN-04 · Unload + Combo Feedback

```yaml
surface_or_flow: station unload
player_question: 무엇이 몇 개 하역됐고 Combo 그룹은 몇 개인가?
element_type: local event feedback + compact combo badge
role: FEEDBACK
why_needed: domain delivery commit과 보이는 하역/Combo 결과를 연결해야 한다.
delete_test: 제거하면 하역 완료와 다음 출발 가속의 원인을 읽기 어렵지만 기본 조작은 가능하다.
consumer: VIS-FINITE-02 exploration
priority: P1_CLARITY
reuse_candidate: current station/cargo shapes and result copy language
disposition: GENERATE_EXPLORATION
required_states: unload-1 · unload-multi · combo-2plus · reduced-motion · muted
accessibility_equivalent: token movement + count/badge + motion-reduced static emphasis
platform_and_input: Windows/Android landscape
localization: minimal numeric emphasis
production_cost: MEDIUM
performance_risk: MEDIUM if over-animated
rights_or_provenance: exploration-only until later approval
validation: future occlusion and Reduced Motion capture
handoff: cause before spectacle; domain commit precedes animation
```

## RESULT / PROGRESS requirements

### VR-FINITE-RESULT-01 · Outcome Summary + Failure Insight

```yaml
surface_or_flow: SUCCESS / FAILURE result
player_question: 결과가 무엇이며 실패했다면 가장 먼저 무엇을 고쳐야 하는가?
element_type: result summary + insight card
role: INFORMATIONAL
why_needed: 결과 수치와 실패 원인을 다음 행동으로 연결해야 한다.
delete_test: 제거하면 실패가 재학습 기회가 아니라 단순 종료로 보인다.
consumer: result surface
priority: P0_BLOCKER
reuse_candidate: current result presenter and failure reason authority
disposition: CREATE_CUSTOM
required_states: success · route_end · time_expired · other-failure · personal-best
accessibility_equivalent: outcome icon/shape + heading + one cause + one action
platform_and_input: Windows/Android landscape
localization: cause/action copy designed for ~140% expansion
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: project-owned UI
validation: future failure-cause comprehension
handoff: never infer a cause not provided by authority
```

### VR-FINITE-RESULT-02 · Retry / Edit / Exit Action Hierarchy

```yaml
surface_or_flow: result actions
player_question: 같은 노선으로 다시 할지, 노선을 수정할지, 다른 흐름으로 나갈지 어떻게 선택하는가?
element_type: primary/secondary action group
role: FUNCTIONAL
why_needed: same-layout retry와 route-edit reset은 의미가 다르며 잘못 선택하면 학습 루프가 끊긴다.
delete_test: 제거하면 retry identity 차이를 이해하지 못하고 결과 화면에서 다음 행동이 불명확해진다.
consumer: result actions
priority: P0_BLOCKER
reuse_candidate: current result action/button language
disposition: CREATE_CUSTOM
required_states: retry-same-layout · edit-route · title/next · disabled-processing
accessibility_equivalent: distinct labels + placement + focus order; color-only hierarchy 금지
platform_and_input: mouse/keyboard/touch
localization: button copy tolerates expansion
production_cost: LOW
performance_risk: LOW
rights_or_provenance: project-owned UI
validation: future wrong-action rate and focus order
handoff: preserves retry authority semantics
```

### VR-FINITE-PROGRESS-01 · Three-Star + Leaderboard Gate

```yaml
surface_or_flow: result/progression
player_question: 신속·절약·점수 중 무엇을 달성했고 리더보드가 열렸는가?
element_type: achievement summary / gate feedback
role: INFORMATIONAL
why_needed: 세 목표가 서로 다른 개선 축임을 보여 주고 3별과 leaderboard 개방 관계를 설명한다.
delete_test: 제거하면 반복 최적화의 목표가 약해지고 leaderboard 개방 조건을 알기 어렵다.
consumer: VIS-FINITE-03 exploration
priority: P1_CLARITY
reuse_candidate: standard star/badge primitives + current score/cost/time metadata
disposition: GENERATE_EXPLORATION
required_states: 0-3 stars · each-axis-earned/missed · leaderboard-locked/unlocked
accessibility_equivalent: icon shape + label + earned/missed structure; color-only 금지
platform_and_input: Windows/Android landscape
localization: three short axis labels
production_cost: LOW
performance_risk: LOW
rights_or_provenance: exploration-only
validation: future axis/gate comprehension
handoff: SX-DEC-033 remains NOT_STARTED for runtime
```

### VR-FINITE-PROGRESS-02 · Chapter + Archive Navigation

```yaml
surface_or_flow: campaign/progress/archive
player_question: 다음 스테이지/챕터로 갈지, 기록을 찾을지, 최근·즐겨찾기·미클리어를 어떻게 구분하는가?
element_type: card + filter navigation
role: FUNCTIONAL / INFORMATIONAL
why_needed: 캠페인과 기록 보관소가 같은 화면군에서 일관된 선택 구조를 가져야 장기 탐색 비용이 낮아진다.
delete_test: 제거해도 한 번의 run은 가능하지만 반복 플레이와 11+ chapter 확장 시 탐색 비용이 크게 증가한다.
consumer: VIS-FINITE-03 exploration
priority: P2_CONSISTENCY
reuse_candidate: standard card/filter primitives
disposition: GENERATE_EXPLORATION
required_states: tutorial/chapter · current/complete/locked · recent/favorite/uncleared filters
accessibility_equivalent: icon+label+selection shape; keyboard focus order planned
platform_and_input: Windows/Android landscape menus
localization: card titles and filters tolerate ~140% expansion
production_cost: MEDIUM
performance_risk: LOW
rights_or_provenance: exploration-only
validation: future archive-findability and long-list scan
handoff: SX-DEC-034~035 runtime remains deferred/not-run
```

## Delete-Test summary

- P0 requirements are retained because their removal breaks core action/readability or causes ambiguous recovery.
- P1 requirements are retained because they materially weaken optimization, LIFO causality, or progression comprehension.
- Only one P2 navigation requirement is kept because it directly reduces repeated UI invention across campaign/archive surfaces.
- No P3 decorative requirement is activated in this package.

## Handoff boundary

```text
VR package approved
→ component catalog
→ exploration image brief
→ optional Figma translation
→ future Godot implementation package
```

Until a later implementation Decision is approved, all runtime implementation/PoC/device/human states remain `DEFERRED_NOT_RUN` or `NOT_RUN`.
