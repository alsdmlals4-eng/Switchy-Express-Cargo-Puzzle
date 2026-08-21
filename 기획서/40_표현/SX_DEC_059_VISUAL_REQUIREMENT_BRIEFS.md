# SX-DEC-059 · Visual Requirement Briefs

```yaml
status: BRIEF_ONLY · NO_IMAGE_GENERATED
owner_decision: SX-DEC-059
visual_generation_authority: NOT_REQUESTED
existing_asset_direction: E+D HYBRID · NEO-ARCADE READABILITY
existing_product_assets: 73
```

이미지는 아직 생성하지 않는다. 이 문서는 실제 current UI와 73개 semantic product asset을 먼저 재사용하기 위한 visual brief다.

## 공통 원칙

- 새로운 스타일을 만들지 않고 `E+D HYBRID · NEO-ARCADE READABILITY`를 유지한다.
- Blue locomotive = hero anchor.
- cargo/station = color + shape + text redundancy.
- PNG 안에 localized text를 baked-in하지 않는다.
- RUN semantic batch의 Stack/load/switch assets를 재사용한다.
- BUILD semantic batch의 valid/invalid/rotate/replacement/preflight assets를 재사용한다.
- VFX 2C의 pickup/unload/success/failure/route_end/time_expired glyph를 재사용한다.
- standard/reduced-motion 모두 같은 `information_key`를 유지한다.
- critical cargo/switch target을 VFX가 가리지 않는다.

## VIS-SX-059-01 · First Session Flow

```yaml
type: FLOW
priority: P0
image_generation: NOT_NEEDED_NOW
current_solution: NOTION_MERMAID
```

목적:
- T1→T6→Capstone의 prerequisite 누락을 검수.
- 각 lesson의 새 정보가 동시에 1개 수준인지 확인.

현재 Mermaid가 충분하므로 별도 그림 생성은 Delete Test에서 제외 가능하다.

## VIS-SX-059-02 · Capstone RUN Screen

```yaml
type: UI_SCREEN
priority: P1
question_supported: >
  플레이어가 달리는 열차를 보면서 동시에 TOP, load mode, switch state,
  remaining cargo/time을 읽고 다음 행동을 찾을 수 있는가?
implementation_consumer:
  - product_hud
  - product_board_renderer
  - route_control_overlay
  - semantic_event_overlay
reuse_first: REQUIRED
```

### 현재 screen truth

Current product surface:
- board occupies main left/center.
- StackPanel is right side.
- RunToolbar is bottom.
- TopStatus is top.
- RouteControlOverlay overlays board.
- SemanticEventOverlay uses full-screen overlay.

### 목표 정보 위계

```text
1. Train + board route            # 가장 큰 spatial information
2. Stack TOP                      # 다음 station 판단 핵심
3. Current load mode              # manual hold / auto on-off
4. Switch selected / occupied lock
5. Remaining cargo + time
6. Cost / secondary metrics
```

### 권장 배치

- Board는 현재처럼 가장 넓은 영역 유지.
- 오른쪽 StackPanel 폭은 board를 압박하지 않는 선에서 유지하되 TOP token을 첫 시선점으로 강화.
- Stack title은 `TOP → 마지막 적재`의 의미를 짧게 유지.
- RunToolbar에서 manual/auto control을 서로 붙여 `mode pair`로 읽히게 한다.
- switch는 toolbar button보다 실제 board switch 위 semantic overlay가 주정보.
- TopStatus의 cost는 RUN에서 정보 우선순위를 낮추고 remaining/time을 먼저 읽게 한다.

### 재사용 자산

RUN Batch 2A:
- Stack HUD semantic assets
- load-mode semantic assets
- switch selected/unselected/occupied-locked/inactive

VFX 2C:
- cargo_pickup
- cargo_unload
- route_selection

### 금지

- new decorative panel art that competes with board.
- animated VFX over the next switch/cargo target.
- color-only TOP or lock state.
- one-off tutorial HUD that disappears in campaign.

### Visual QA questions

1. 3초 정지 화면에서 TOP cargo가 무엇인지 찾을 수 있는가?
2. auto on/off를 텍스트 없이도 semantic badge + state로 구별 가능한가?
3. next switch가 locked인지 selected인지 board에서 읽히는가?
4. event VFX가 다음 조작 target을 가리지 않는가?
5. Reduced Motion에서도 동일 질문에 답할 수 있는가?

## VIS-SX-059-03 · Failure Result / Debrief

```yaml
type: UI_SCREEN
priority: P1
question_supported: >
  실패 직후 플레이어가 실패 종류와 남은 상태를 이해하고
  Retry와 Edit 중 어떤 행동을 할지 결정할 수 있는가?
implementation_consumer:
  - DemoFlowController ResultOverlay
  - Product HUD Result model
```

### 현재 screen truth

ResultOverlay는 gameplay container 위에 표시되므로 board context를 뒤에 유지할 수 있다.

현재 버튼:
- same-layout Retry
- Edit layout
- Title

현재 result copy는 시간/비용/하역 summary가 중심이고 TIMEOUT 문구가 일반화돼 있다.

### 권장 정보 위계

```text
[Failure semantic glyph] + 실패 종류
짧은 한 줄 설명
맵에 남은 화물 N · 열차에 실린 화물 N
--------------------------------
[같은 노선 다시 실행] [노선 수정]
                    [타이틀]
```

`ROUTE_END`와 `TIME_EXPIRED`는 기존 VFX glyph를 각각 사용한다.

### Board context

- overlay 뒤 board는 완전히 숨기지 않는다.
- dim 처리 가능하나 cargo/station/route silhouette이 식별 가능한 수준 유지.
- 059에서는 특정 problem station을 근거 없이 highlight하지 않는다.
- future 056A observation evidence가 생기면 exact relevant station/cell highlight를 추가 가능.

### Retry vs Edit 의미

- Retry: 현재 sealed layout이 맞다고 생각하고 load/switch execution만 다시 시도.
- Edit: 노선 자체를 수정.

두 버튼의 설명은 tooltip/secondary copy가 아니라 버튼명과 가까운 짧은 보조 문장으로만 사용한다.

### 재사용 자산

VFX 2C:
- `vfx_failure_feedback_v01.png`
- `vfx_route_end_feedback_v01.png`
- `vfx_time_expired_feedback_v01.png`

### 금지

- `정답 보기` primary CTA.
- optimal route preview.
- summary가 증명하지 않는 station mismatch 문장.
- 모든 실패를 동일 `다시 해보세요`로 축약.
- blocking full-screen illustration.

### Visual QA questions

1. 실패 원인을 3초 안에 `ROUTE_END` vs `TIME_EXPIRED`로 구분 가능한가?
2. map cargo vs train cargo가 서로 다른 의미로 읽히는가?
3. Retry와 Edit의 차이가 첫 사용에서도 예측 가능한가?
4. 결과 overlay가 board 원인을 검토할 시야를 과도하게 가리지 않는가?

## VIS-SX-059-04 · Progressive Disclosure Storyboard

```yaml
type: STORYBOARD
priority: P2
creation_condition: ONLY_IF_VIS_02_03_PLUS_FLOW_INSUFFICIENT
```

필요 시 7프레임:

```text
T1 BUILD minimal
T2 pickup/unload
T3 TOP
T4 selective manual
T5 manual/auto
T6 switch
Capstone full surface
```

그러나 01 Flow + 02 RUN + 03 Result로 implementation ambiguity가 해소되면 만들지 않는다.

## 이미지 생성 Gate

이미지를 실제 생성하려면:

1. GM-SX059-01 등 content blocker를 먼저 닫음.
2. 현재 73 asset으로 해결되지 않는 visual question인지 Delete Test.
3. user에게 다음 1개 visual brief 설명.
4. user가 이미지 생성을 명시 승인.
5. exactly one result 생성.
6. visual QA + user result approval.
7. Notion attach/readback.

현재 상태: `BRIEFS_READY · IMAGE_GENERATION_NOT_REQUESTED`.
