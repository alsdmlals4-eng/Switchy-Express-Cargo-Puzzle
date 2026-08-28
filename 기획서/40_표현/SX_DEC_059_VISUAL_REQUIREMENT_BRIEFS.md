# SX-DEC-059 · Visual Requirement Briefs

```yaml
status: USER_APPROVED_VISUAL_REFERENCES_ACTIVE · NOT_RUNTIME_PROOF
owner_decision: SX-DEC-059
visual_generation_authority: USER_REQUESTED_AND_APPROVED_REFERENCE_WORK
existing_asset_direction: E+D HYBRID · NEO-ARCADE READABILITY
existing_product_assets: 73
latest_visual_decision: VIS-SX-059-05 · CARGO_STACK_SILHOUETTE
```

이 문서는 실제 current UI와 73개 semantic product asset을 우선 재사용하면서, 사용자 승인 visual reference를 구현 가이드로 관리한다. 생성 reference는 product asset이나 runtime/physical evidence로 자동 승격하지 않는다.

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
current_solution: GITHUB_FLOW_OWNER · PROJECT_CORE_SCENE_VISUAL_BOARD
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

### Runtime route readability extension · GitHub Issue #197

```yaml
status: MERGED_MAIN_VERIFIED_LOCAL_EVIDENCE
merge: PR_198 · main_a8eee4f875a95e8da69802c4e60452df3535fe0e
remote_ci: QUEUED_WITHOUT_JOBS · USER_AUTHORIZED_BYPASS
runtime_consumer: ProductBoardRenderer + RouteControlOverlay
new_bitmap_assets: 0
source_of_truth: actual finite render snapshot / FiniteTrackGraph route-control state
```

- RUN/UNLOADING/PAUSED/SUCCESS/FAILURE에서 현재 선택된 rail route는 굵은 녹색 trace와 진행 방향 cue로 보인다.
- 선택되지 않은 연결 rail은 얇은 청색 trace로 남겨 선택 경로와 혼동되지 않는다.
- 점유/잠김 route-control cell은 적색 trace와 기존 lock semantic overlay로 즉시 구별한다.
- Result에서도 선택 route trace를 유지한다. 결과 panel은 context를 가리는 이유가 되지 않는다.
- 기존 rail/station/cargo PNG 위에 procedural trace만 겹친다. 이 변경의 실제 bitmap consumer는 없으므로 새 이미지를 생성하지 않는다.
- 공식 headless runner에는 `test_product_board_route_clarity.gd`를 등록해 state descriptor·result 유지·960×540/1280×720/1920×1080 두께 위계를 회귀 검증한다.
- exact-head local 검증은 통과했지만 GitHub CI는 job 없이 queued로 남아 있다. 사용자가 병합을 명시 승인했으므로 remote CI GREEN이나 human/device PASS로 해석하지 않는다.

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
6. 960×540, 1280×720, 1920×1080에서 selected > occupied/locked > unselected 두께 위계가 유지되는가?

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

## VIS-SX-059-05 · Cargo Stack Silhouette

```yaml
type: VISUAL_SEMANTIC_RULE
decision_status: USER_APPROVED · 2026-08-26
question_supported: >
  cargo count가 늘어날 때 긴 freight tail이 아니라 compact LIFO stack으로 읽히고,
  가장 위 cargo가 TOP / next unload candidate로 즉시 보이는가?
visual_reference_role: IMPLEMENTATION_GUIDE · NOT_RUNTIME_PROOF
```

### 사용자 승인 방향

화물은 열차 뒤에 cargo별 wagon을 계속 붙여 긴 꼬리를 만드는 방식보다, **짧은 열차 위 또는 직결 적재부에 수직으로 쌓이는 LIFO 탑 실루엣**을 기본 표현으로 사용한다.

### 핵심 의미

- cargo count 증가 → train horizontal length 증가가 아니라 `stack height / compact stack mass` 증가.
- 가장 위 cargo = `TOP`이며 next unload candidate로 가장 먼저 읽혀야 한다.
- locomotive와 cargo stack은 하나의 짧고 강한 silhouette로 읽힌다.
- unlimited LIFO 규칙을 시각화하되, 실제 capacity limit이 있는 것처럼 보이는 고정 slot/wagon count는 만들지 않는다.
- world/train silhouette은 LIFO를 빠르게 읽히게 하는 presentation cue이며, **정확한 전체 stack order의 authority는 기존 Stack HUD**가 유지한다.

### 표현 규칙

1. locomotive는 이동 주체의 전방 anchor.
2. cargo stack은 locomotive 바로 뒤 또는 직결 적재 플랫폼 위의 compact vertical tower.
3. TOP cargo는 가장 높은 위치 + strongest outline/brightness/state cue.
4. cargo identity는 color뿐 아니라 shape/icon/outline/위치로 중복 전달.
5. stack가 높아져도 route, switch, station 등 board의 다음 판단 대상을 과도하게 가리지 않는다.
6. **unlimited LIFO display boundary:** 표시 안전 높이를 넘으면 world silhouette의 layer spacing/scale을 압축하거나 `+N`/count 보조를 사용할 수 있다. 이것은 시각 압축일 뿐 capacity 제한이나 cargo 삭제를 의미하지 않으며, exact full order는 Stack HUD에서 보존한다.
7. isometric/perspective에서도 위→아래 stack order와 현재 TOP이 명확히 읽혀야 한다.
8. Success/Failure Result의 stack summary와 RUN의 실제 train silhouette이 같은 LIFO 의미를 사용한다.

### 금지

- cargo마다 독립 wagon을 붙여 train tail이 길어지는 표현.
- snake/train-tail처럼 cargo count를 수평 길이에 직접 대응.
- TOP을 color-only로 표시.
- capacity 제한을 암시하는 고정 wagon/slot 수.
- tall stack가 board의 switch/station/critical cargo target을 가리는 구도.
- visual compression을 실제 cargo loss/capacity로 오해하게 만드는 표현.

### 적용 범위

향후 Success/Failure Result, Capstone RUN, Tutorial, BUILD-related visual reference에서 cargo-loaded train을 그릴 때 `VIS-SX-059-05`를 기본 visual semantic rule로 적용한다.

## 이미지 생성 Gate (2026-08-28 current policy)

새 visual reference를 실제 생성하려면:

1. current content/runtime authority를 fresh-read.
2. 현재 73 asset + 승인 reference로 해결되지 않는 visual question인지 Delete Test.
3. next visual brief와 actual consumer를 GitHub 정본에서 확인.
4. 후보 생성은 별도 이미지별 승인 없이 진행한다.
5. 요청한 cardinality대로 독립 결과를 생성.
6. visual QA와 기계 검토를 기록한다.
7. 사용자에게는 생성 여부가 아니라 최종 disposition(승격 / 수정 / 폐기)만 요청한다.
8. 승인 final만 프로젝트 로컬 Git-tracked 파일, SHA-256, provenance, Decision ID 및 GitHub 원격 readback으로 보존한다. Notion은 현행 workflow에 사용하지 않는다.

현재 상태: `USER_APPROVED_VISUAL_REFERENCES_ACTIVE · VIS-SX-059-05 CURRENT · NOT_RUNTIME_PROOF`.
