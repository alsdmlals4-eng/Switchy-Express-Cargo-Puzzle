# Visual Direction

상태: `CURRENT_CANON · GMB-002 · SX-DEC-061`

## SX-DEC-061 active visual lock · read this first

사용자는 `2026-08-28 KST`에 **Board-first Cozy Neo-Arcade** 보정안을 승인했다. 이는 기존 E+D Hybrid / Neo-Arcade의 월드 자산을 폐기하거나 새 게임 시스템을 추가하는 결정이 아니다. 따뜻한 미니어처 철도 세계를 유지하면서, 플레이 중 판단·선택·결과를 하나의 절제된 control-deck UI 언어로 묶는 방향이다.

```yaml
selected_candidate: BOARD_FIRST_COZY_NEO_ARCADE
global_style_anchor: cozy miniature railway world + deep-navy/charcoal neo-arcade control deck
world_anchor: warm grass, rounded rocks, conifers, brass-and-navy locomotive, warm gold practical lights
ui_anchor: dark framed panels, restrained gold trim, high-contrast state feedback, gameplay board remains dominant
semantic_state_language:
  valid_or_selected: lime + direction/shape/brightness
  invalid_or_route_end: crimson + prohibition/failure icon
  tutorial_focus: violet + bounded focus treatment
  cargo_and_station: color + silhouette/shape + Godot text layer when exact meaning is required
lifo_anchor: compact world token plus Stack HUD; TOP and next unload group remain readable; never lengthen the train horizontally to represent stack size
camera_anchor: elevated isometric 3/4 board view at actual gameplay readability scale
keep:
  - existing E+D Hybrid / Neo-Arcade runtime asset family and verified consumers
  - text-free artwork with exact copy in Godot/structured text owners
  - off-track station and cardinal-adjacent service readability
avoid:
  - copied reference layouts, logos, UI chrome, branded expression, or pseudo-text
  - dense economy/dashboard presentation, fake coins, save controls, score, ranking, or unimplemented system states
  - diagonal station service, station-footprint rail delivery, long cargo trains, fuel, BOOST, capacity limits, or generated asset promotion without a consumer
do_not_drift:
  - board first; decorative art may not hide rail, switch, cargo, station, valid/invalid, lock, or TOP meaning
  - one visual grammar across title, BUILD, lesson, RUN, and result while success/failure keep purposeful variation
allowed_variation:
  - crimson may dominate failure; violet may dominate a lesson focus; lime may dominate an active route/valid placement
  - regions, cargo types, and state severity may vary only within the shared material, silhouette, lighting, and camera grammar
```

The planning-only scene owner is `기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md`. It owns exact panel/flow meaning; its generated board is not a runtime screenshot, asset, Godot Scene, or human-usability result.

## Supersession boundary

The sections beginning **Base 상호작용 상태 계약** through **구형 표현 상태** are retained as historical design notes. They are not current requirements where they describe score/max-combo, stars/ranking, leaderboards, a 1–10 tutorial/progression, rail performance attributes, tunnels/bridges, or a mascot/character requirement. Current product scope is the implemented T1→T6→VS_DEMO_01 first-session chain in `CURRENT_CONFIRMED_DECISIONS.md`, amended by SX-DEC-060, and the SX-DEC-061 lock above.

## 유지하는 Visual Pillars

1. **Cute premium casual** — 둥글고 부드러운 3D 카툰, 따뜻한 조명, 친근한 표정
2. **Readable miniature railway** — 작은 화면에서도 선로·역·화물·분기·건설 불가 영역을 즉시 구분
3. **Color + shape redundancy** — 화물과 역은 색상만이 아니라 모양까지 일치
4. **Cause before spectacle** — 애니메이션은 적재·하역·분기 결과를 설명하며 domain 권위를 대신하지 않음
5. **LIFO is visible** — 마지막 적재 화물과 다음 연속 하역 그룹을 항상 읽을 수 있음

아늑한 미니어처 철도 세계는 유지한다. 특정 mascot 또는 character는 현재 Slice의 승인된 runtime consumer나 필수 화면 요소가 아니다.

## Historical pre-SX-DEC-061 interaction and feature notes · non-canon unless a current owner re-approves them

모든 중요 입력·저장·기록·건설 행동은 다음 상태 언어를 유지한다.

- `입력 접수`: 탭·홀드·토글이 시스템에 들어왔음을 즉시 표시
- `처리 중`: 저장·검증·온라인 등록처럼 즉시 끝나지 않는 작업 표시
- `중단`: 취소·실패·연결 끊김을 성공처럼 보이지 않게 표시
- `즉시 완료`: 로컬 분기 전환·건설 배치처럼 같은 frame에 확정된 결과 표시
- `빠른 반복`: 건설 재배치·재도전·결과 비교 흐름의 지연 최소화
- `재진입`: 앱 복귀·화면 재진입 시 현재 권위 상태 재표시
- `재시작`: 실패 후 노선을 유지한 run reset과 전체 노선 초기화를 구분
- `Reduced Motion`: 카메라 흔들림·강한 trail을 줄이고 정보 등가 표현 제공
- `mute`: 소리 없이도 적재·하역·Combo·분기 상태를 이해 가능
- `haptic-off`: 진동 없이도 모든 판정·모드·경고를 이해 가능
- `권위 시점`: domain commit과 animation 시작을 구분하고 결과·비용·기록은 commit 이후만 표시

## 건설 단계 화면

### 맵 표현

- 건설 가능 영역은 자연 지형 위에 은은한 격자·스냅 표시
- 건설 불가 지점은 세계 안의 이유와 명확한 금지 표시를 함께 사용
- 시작점·역·화물은 선로가 없어도 겹치지 않고 읽혀야 함
- 전체 맵과 핵심 오브젝트를 동시에 파악할 수 있는 가로형 구도

### 추천 설계도

- 반투명·낮은 채도의 ghost rail
- 실제 선로와 다른 재질·점선·광도
- 비용·연결 판정·열차 경로에 포함되지 않음
- 전체 표시/숨기기 토글
- 추천 총비용과 현재 노선에서 추천 완성까지 남은 비용 표시
- 튜토리얼 이후 기본 숨김 권장
- 별·랭킹 최적해처럼 보이는 금색·완료 표시 금지

### 비용 HUD

동시에 비교:

- 현재 최종 건설비
- 선택 중 선로 반영 예상 비용
- 추천 노선 예상 비용
- 절약 별 기준
- 속도 리더보드 비용 상한

기준을 초과해도 일반 클리어 실패처럼 표시하지 않고 해당 별·리더보드 자격만 놓쳤음을 보여준다.

## 선로 시각 언어

### 형태

- 직선·곡선: 기본 레일
- 분기: 선택 출구가 보이고 활성 방향이 밝게 연결
- 교차: 가로·세로 레일이 독립임을 높이·침목·표식으로 표시, 회전 불가
- 회차: 진행 방향 반전이 공간 형태로 이해됨
- 터널·교량: 맵이 허용한 지점에만 결합 가능

### 성능 속성

- 일반: 중립 재질
- 가속: 진행 방향 광띠·속도 표식
- 저비용: 간소한 침목·재질, 파손처럼 보이지 않음
- 일방통행: 반복 화살표와 역방향 진입 금지 표식

형태 선택과 성능 선택은 UI에서 분리한다. `가속 직선`, `저비용 곡선`을 모두 별도 버튼으로 늘리지 않는다.

## 분기 조작

- 맵 위 분기를 직접 탭
- 활성 경로는 밝기·레버·화살표·짧은 preview로 중복 표시
- 비활성 경로는 사라지지 않고 어둡게 유지
- 열차가 분기 위에 있을 때만 잠금 표시
- 먼 분기도 언제든 사전 설정 가능
- 상태는 열차 통과 뒤에도 유지

## 화물·LIFO 표현

Domain CargoStack은 무제한이지만 월드 화차를 무한 길이로 펼치지 않는다.

### 권장 이중 표현

1. **월드 train strip**
   - 기관차 뒤에 최근/TOP 중심 compact token
   - TOP token 가장 크게 강조
   - 더 많은 화물은 `+N` 압축 표시

2. **Stack HUD**
   - bottom→top 순서를 명확히 표시
   - TOP 라벨과 다음 하역 그룹 테두리
   - 많은 화물은 스크롤·구간 압축
   - 8/16/32개에서 종류 순서와 TOP 인지 가능

`앞/뒤`만 사용하면 열차 진행 방향과 혼동될 수 있으므로 `먼저 적재`, `TOP/다음 하역` 의미를 병기한다.

## 적재 피드백

- 화물 접근 시 적재 가능 범위를 미리 표시
- 수동 모드에서 LOAD 홀드 시 흡착·연결 연출
- 자동 적재 활성 시 버튼과 열차 주변에 지속 상태 표시
- 색상 변화만으로 모드를 표현하지 않음
- 적재 때문에 열차가 감속·정차한 것처럼 보이지 않음
- 적재하지 않은 화물은 맵에 그대로 남음

## 역·하역·Combo

- TOP이 역과 일치하면 진입 전 하역 예정 그룹 강조
- 일치하지 않으면 경고 정차 없이 통과
- 하역은 총 최대 1초
- 화물 수가 많을수록 빠르게 연속 배출하지만 각 물체 이동이 보임
- 화물은 TOP부터 역 플랫폼·창고로 이동
- `COMBO ×N`은 하역 그룹 가까이 표시
- 하역 완료 뒤 출발 순간 가속 trail 시작
- Combo 가속과 가속 선로 중첩 효과가 다음 입력을 가리지 않음
- Reduced Motion에서는 속도선·UI 게이지로 대체

## 일시정지

- 제한 시간·운행 시간이 멈췄음을 명확히 표시
- 분기·적재 모드·선로 컨트롤 비활성
- 맵과 스택 확인 가능
- 재개 카운트다운 뒤 입력 복귀
- 사용해도 랭킹 자격 유지

## 결과 화면

필수:

- 성공/실패
- 완료 시간 또는 남은 미배송 수
- 최종 건설비
- 종합점수
- 최대 Combo
- 신속·절약·점수 별 달성
- 개인 최고 기록 갱신
- 실패 원인 1개와 수정할 위치·행동 1개
- `노선 수정 후 재도전` primary action

3별을 획득하면 해당 맵 리더보드 개방을 표시한다.

## 튜토리얼 1~10

- 한 스테이지에 새 핵심 개념 1개
- 설명문보다 맵 배치와 첫 행동으로 학습
- 실패 허용
- 힌트는 요청형 3단계
- 정답 선로 자동 설치 금지
- 10스테이지 종합 시험 이후 본편·랭킹 개방

## 리더보드·도전

공개:

- 순위·닉네임
- 시간
- 건설비
- 점수
- 최대 Combo

비공개:

- 정확한 선로 배치
- 분기 조작 순서
- 적재 순서 timeline
- 전체 replay

기록 보관소는 날짜·기믹·난도·개인 성적·즐겨찾기·미클리어 필터를 우선한다.

## 아트 적대적 Guardrails

- ghost rail이 실제 선로보다 강하게 보이면 실패
- 건설 불가 영역이 장식처럼 보여 클릭 실수가 반복되면 실패
- 분기와 교차를 silhouette만으로 구분하지 못하면 실패
- 가속·저비용 속성을 색상만으로 구분하면 실패
- 16개 이상 적재에서 TOP과 다음 그룹을 읽지 못하면 실패
- Combo 연출이 다음 분기·화물 입력을 가리면 실패
- 비용 HUD가 일반 클리어 불가처럼 위협적으로 보이면 실패
- 토끼·꾸미기 연출이 퍼즐 정보보다 우선하면 실패

## 구형 표현 상태

- fuel gauge·fuel-zero panic: `[폐기]`
- BOOST hold UI: `[폐기]`
- endless escalation band: `[폐기]`
- capacity 8 full chain assumption: `[대체됨]`
- first endless run 2-line onboarding: `[대체됨]`
- old captures and visual approvals: `[역사 증거]`
