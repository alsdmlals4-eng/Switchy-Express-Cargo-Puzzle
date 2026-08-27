# Finite Image Exploration Brief V1

상태: `HISTORICAL_EXPLORATION · SX-DEC-050 · SUPERSEDED_FOR_CURRENT_VISUAL_DIRECTION_BY_SX-DEC-061`

> 이 brief의 mascot, progress, score/star/leaderboard, feature UI 예시는 현재 요구사항이 아니다. 현재 visual direction과 정확한 scene meaning은 `VISUAL_DIRECTION.md`와 `PROJECT_CORE_SCENE_VISUAL_BOARD.md`를 우선한다.

이 문서는 `VIS-FINITE-01/02/03`의 정보 위계와 시각 방향을 빠르게 비교하기 위한 생성형 목업 brief다. 생성 결과는 `GENERATED_EXPLORATION`이며 제품 자산·실제 UI·런타임 증거가 아니다.

## 공통 Visual Pillars

현재 `VISUAL_DIRECTION.md`의 다음 5개 Pillar를 고정한다.

1. Cute premium casual
2. Readable miniature railway
3. Color + shape redundancy
4. Cause before spectacle
5. LIFO is visible

추가 공통 조건:

- 가로형 16:9 landscape.
- 둥글고 부드러운 3D 카툰 미니어처 철도, 따뜻한 조명.
- 토끼 기관사는 세계관/제품 기억점으로 작게 유지하되 퍼즐 정보보다 앞서지 않는다.
- 실제 플레이 정보는 board/rail/station/cargo/switch/HUD가 우선한다.
- UI는 AI가 긴 문장을 그리도록 의존하지 않고 icon-like symbols, simple bars, short placeholder labels를 사용한다.
- 특정 상업 IP, 특정 게임 UI skin, 특정 작가/스튜디오의 식별 가능한 스타일을 모방하지 않는다.
- 생성 결과는 tracked `assets/`에 자동 편입하지 않는다.

## Concept board format

한 장의 넓은 concept board 안에 세 개의 명확한 panel을 둔다.

```text
[ BUILD / VIS-FINITE-01 ]
[ RUN / VIS-FINITE-02 ]
[ RESULT+PROGRESS / VIS-FINITE-03 ]
```

각 panel은 독립 화면처럼 읽히되 동일한 세계/shape language/재질/조명 family를 공유한다.

## Panel A · BUILD / Route Construction

### Must show

- 15×11 안팎의 miniature board 느낌.
- 시작점·역·화물의 색+형상 중복 부호.
- 건설 가능 영역의 은은한 grid/snap.
- 건설 불가 지점의 world reason + 명확한 금지 shape.
- 이미 설치된 실제 rail과 낮은 채도/점선/반투명 ghost recommendation의 강한 차이.
- track form selector: straight / curve / switch / crossing이 실루엣으로 구분.
- 선택 셀의 placement preview와 port 방향.
- neutral cost comparison blocks: current / preview / recommendation / optional target.
- preflight issue marker는 오류 위치와 연결되되 공포/실패 연출처럼 과장하지 않는다.

### Must not imply

- ghost rail이 정답/필수/자동 설치라는 인상.
- 비용 목표 초과가 일반 클리어 실패라는 인상.
- 첫 Slice에 아직 없는 가속·저비용·교량·터널을 실제 구현된 기능처럼 강조.
- BUILD 중 실제 run이 이미 진행 중이라는 인상.

### Linked requirements

`VR-FINITE-BUILD-01~04`

## Panel B · RUN / LIFO / Switch / Combo

### Must show

- board action surface가 가장 크게 보임.
- train world strip은 최근/TOP cargo 몇 개 + `+N` 압축 느낌.
- 별도의 persistent stack HUD에서 bottom→top 순서, TOP 강조, next unload group boundary가 읽힘.
- cargo 종류는 예: red star / blue diamond처럼 색+형상 중복.
- manual-load / auto-load 상태가 색만이 아닌 icon/shape로 구분.
- 기존 VIS-014 문법과 호환되는 세 방향 switch arrows, selected direction의 weight/fill 차이, occupied lock 예시.
- station unload 근처에 bounded Combo feedback.
- Combo/하역 연출이 다음 switch/cargo를 가리지 않음.
- pause/reduced-motion을 암시할 수 있는 안정된 static state variant.

### Must not imply

- 무제한 stack을 월드 화차 전체 길이로 늘어놓는 표현.
- cargo pickup 때문에 열차가 멈추거나 감속하는 표현.
- switch가 통과 뒤 자동 reset되는 표현.
- Combo가 별도 조작 power-up처럼 보이는 표현.

### Linked requirements

`VR-FINITE-RUN-01~04`

## Panel C · RESULT / PROGRESS / ARCHIVE

### Must show

- outcome heading area가 첫 시선.
- success/failure에 따라 time/undelivered, build cost, score, max combo를 compact stat blocks로 표현.
- 실패 예시에는 cause 1 + corrective action 1의 insight card.
- `Retry Same Layout`과 `Edit Route`가 서로 다른 의미의 primary/secondary action으로 구분.
- speed / cost / score 3-star axes와 leaderboard locked/unlocked gate.
- tutorial/chapter card strip 또는 small chapter progression area.
- archive filters: recent / favorites / uncleared 등의 compact filter chips/cards.
- 다른 플레이어의 정확한 route/replay는 노출하지 않는다.

### Must not imply

- 별/leaderboard/campaign/archive가 현재 런타임 구현 완료라는 인상.
- 타인의 정확한 선로 배치가 공개된다는 인상.
- cosmetic progression이 power progression처럼 보이는 인상.

### Linked requirements

`VR-FINITE-RESULT-01~02 · VR-FINITE-PROGRESS-01~02`

## Generation direction

Recommended generation target:

```yaml
asset_type: three-panel UI/gameplay concept board
status: GENERATED_EXPLORATION
role: REFERENCE_ONLY
aspect: wide landscape
rendering: polished 3D cartoon miniature railway + clean game UI overlays
text_strategy: minimal short placeholders and icon-like shapes; no dependence on legible AI typography
character: small friendly rabbit conductor, secondary to puzzle information
lighting: warm, soft, toy-diorama readability
board_camera: readable elevated oblique/top-down hybrid
visual_density: medium; board state must remain scannable
```

## Review checklist

A generated board passes exploration review only if all are true:

- [ ] BUILD: actual rail is visually stronger than ghost rail.
- [ ] BUILD: buildable/blocked areas can be told apart without color alone.
- [ ] BUILD: cost HUD does not imply optional-target miss = run failure.
- [ ] RUN: TOP and next unload group are visually obvious.
- [ ] RUN: stack concept still reads at a glance as compressible beyond visible tokens.
- [ ] RUN: switch arrows remain visible and selected/locked states are distinguishable by form/weight.
- [ ] RUN: Combo feedback does not cover likely next input locations.
- [ ] RESULT: outcome and next action dominate stars/progression decoration.
- [ ] RESULT: Retry Same Layout and Edit Route have clearly different hierarchy/meaning.
- [ ] PROGRESS: 3-star axes are distinguishable beyond color.
- [ ] World: rabbit/cosmetic charm never obscures puzzle information.
- [ ] Rights: no recognizable third-party IP/UI skin or living-artist imitation.

## Status boundary

Even a visually successful exploration remains:

`GENERATED_EXPLORATION · REFERENCE_ONLY · NOT_PROJECT_ASSET_APPROVED · NOT_RUNTIME_EVIDENCE`

Promotion to product asset requires a later explicit Decision, provenance/rights record, implementation path, and runtime validation.
