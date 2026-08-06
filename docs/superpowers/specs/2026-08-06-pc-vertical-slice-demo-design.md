# PC 대응 고완성도 Vertical Slice Demo 설계

상태: `USER_APPROVED_DESIGN · IMPLEMENTATION_NOT_STARTED`

승인 기준:

- 사용자 승인: 2026-08-06 대화에서 권장안 A 승인
- 제품 권위: `GMB-002 · SX-DEC-027~036`
- 자동 코어 상태: `PASS`
- Android Device Smoke: `NOT_RUN · CURRENT`
- 기본 진입점: `LEGACY`
- Production Cutover: `BLOCKED`

## 1. 목적

현재 finite delivery 코어는 BUILD, 구조 검사, RUN, 수동·자동 적재, persistent branch, LIFO 하역, 성공·실패, 같은 노선 재시도와 노선 수정까지 자동 검증되어 있다. 그러나 기본 `game/main/main.tscn`은 제품 플레이 화면이 아니며, 현재 finite View는 검증과 자동 증거 수집에 적합한 기능 UI다.

이번 작업의 목적은 코어 POC를 추가하는 것이 아니다. 기존 finite 도메인과 검증된 command 경계를 재사용하여, Godot 에디터의 PC 환경에서 즉시 실행하고 외부 시연에 사용할 수 있는 단일 대표 스테이지 Vertical Slice Demo를 제작하는 것이다.

이 Vertical Slice는 다음 질문에 답해야 한다.

> Switchy Express의 핵심 퍼즐이 실제 출시 게임의 한 구간처럼 보이고, 읽히고, 조작되며, 한 세션 안에서 완결되는가?

## 2. 승인된 핵심 결정

### 2.1 콘텐츠 폭

- 단일 대표 스테이지에 집중한다.
- 목표 플레이 시간은 첫 시도 기준 약 5~10분이다.
- 여러 스테이지, 챕터, 온라인 기록, 일일·주간 도전은 이번 범위에 넣지 않는다.
- 기존 `data/maps/fp_core_proof_01.json`은 자동 증거 맵으로 보존한다.
- 제품형 데모 스테이지는 별도 map ID와 data file로 만든다.

### 2.2 실행 방식

- 전용 Scene: `res://game/demo/vertical_slice_demo.tscn`
- Godot 에디터에서는 해당 Scene을 열고 F6으로 실행한다.
- 구현·검수 완료 전에는 `project.godot`의 `run/main_scene`을 변경하지 않는다.
- Android validation harness와 canonical APK 증거를 변경하지 않는다.
- 기본 F5 진입점 변경은 별도 Production Cutover 승인 대상이다.

### 2.3 PC 조작

권장안 A를 승인한다.

| 입력 | 동작 |
|---|---|
| 좌클릭 | 셀 선택, 선로 설치, 분기 전환, UI 확인 |
| 우클릭 | 선택 취소, BUILD에서 선택 선로 철거 |
| `1` | 직선 도구 |
| `2` | 곡선 도구 |
| `3` | 분기 도구 |
| `4` | 교차 도구 |
| `R` | 선택 선로 회전 |
| `Space` | BUILD에서 운행 시작, RUN에서 일시정지·재개 |
| `Shift` 홀드 | 수동 적재 |
| `A` | 자동 적재 토글 |
| `Esc` | 선택 취소 또는 일시정지 메뉴 |
| `Enter` | 현재 주요 확인 버튼 실행 |

화면 버튼과 터치 입력은 유지한다. 키보드·마우스 입력은 별도의 PC 규칙을 만들지 않고 기존 command를 호출하는 adapter다.

### 2.4 시각 방향

- 산업 물류 보드게임형 UI
- 따뜻한 철도 디오라마 분위기
- 짙은 청록·철재색 외곽 UI와 크림색 지도판
- 선로, 역, 화물, 열차의 실루엣과 상태를 강하게 분리
- 색상+형상+텍스트의 중복 부호 유지
- 장식보다 퍼즐 상태 가독성을 우선

## 3. 범위

### 3.1 포함

- 타이틀 화면
- 스테이지 브리핑
- 단일 대표 스테이지
- BUILD, preflight, RUN, PAUSE, SUCCESS, FAILURE
- 같은 노선 재시도
- 노선 수정
- 타이틀 복귀
- PC 마우스·키보드 조작
- 기존 모바일 터치 조작 보존
- 제품형 board rendering
- 플레이어용 한국어 HUD와 상태 메시지
- 설치·철거·선택·적재·하역·분기·성공·실패 피드백
- 최소 제품 수준의 사운드와 화면 전환
- Windows debug export 검증
- 16:9 PC 해상도 대응
- 기존 Godot 자동 테스트와 신규 Demo 테스트

### 3.2 제외

- 2개 이상의 플레이 스테이지
- 챕터 선택과 진행 저장
- 별·온라인 리더보드·계정·닉네임
- UGC와 procedural generation
- 스팀 기능, 업적, 클라우드 저장
- 게임패드 입력
- 최종 상용 아트·최종 상용 음원
- 광고, 결제, 과금, 보상 경제
- Android Device Smoke 판정 변경
- 기본 production entrypoint 전환
- canonical Android APK 재생성

## 4. 제품 경험 흐름

```text
BOOT
→ TITLE
→ BRIEFING
→ BUILD
→ PREFLIGHT FEEDBACK
→ RUNNING / UNLOADING / PAUSED
→ SUCCESS 또는 FAILURE
→ RETRY SAME LAYOUT / EDIT LAYOUT / TITLE
```

### 4.1 타이틀

표시:

- 게임 로고와 한 문장 설명
- `데모 시작`
- `조작 방법`
- `종료`
- Vertical Slice 표식

행동:

- Enter 또는 좌클릭으로 데모 시작
- 조작 방법은 간단한 overlay로 표시
- 종료는 PC에서만 활성화하며 모바일에서는 숨길 수 있다.

### 4.2 브리핑

표시:

- 스테이지 이름
- 제한 시간
- 배송해야 할 화물 종류와 수량
- 퍼즐 목표 한 문장
- 핵심 규칙 3개 이하
- `건설 시작`

브리핑은 정답 경로, 적재 순서와 분기 순서를 알려주지 않는다.

### 4.3 BUILD

플레이어는 맵을 읽고 선로를 설치한다.

필수 피드백:

- hover cell
- selected cell
- selected build tool
- 회전 방향
- 설치 ghost
- 설치 가능·불가능
- 현재 비용
- 추천 기준 비용
- 문제 셀과 이해 가능한 오류 메시지
- 시작 가능 여부

시작 전 검사는 기존 구조적 preflight 권위를 그대로 사용한다. UI는 결과를 설명하지만 통과 여부를 결정하지 않는다.

### 4.4 RUN

필수 피드백:

- 열차 위치와 진행 방향
- 활성 분기 방향
- 점유 분기 잠금
- 수동 적재 홀드 상태
- 자동 적재 상태
- 화물 stack 순서
- TOP 강조
- 남은 배송
- 남은 시간
- 역 도착과 하역 수
- Combo 표시
- pause 상태

운행 규칙과 성공·실패 판정은 기존 finite domain이 소유한다.

### 4.5 결과

SUCCESS:

- 배송 완료
- 완료 시간
- 남은 시간
- 최종 건설비
- 하역 순서 요약
- `같은 노선 다시 실행`
- `노선 수정`
- `타이틀`

FAILURE:

- 실패 원인
- 남은 화물
- 막고 있던 TOP 화물 또는 시간 종료 정보
- `같은 노선 다시 실행`
- `노선 수정`
- `타이틀`

결과 화면은 새로운 점수나 별 규칙을 임의로 확정하지 않는다.

## 5. 구조

```text
VerticalSliceDemo
├─ DemoFlowController
├─ TitleScreen
├─ BriefingScreen
├─ GameplayContainer
│  └─ ProductFiniteSlice
│     ├─ FiniteSliceSessionController
│     ├─ ProductBoardRenderer
│     ├─ ProductHUD
│     ├─ DesktopInputAdapter
│     └─ PresentationEffects
├─ PauseOverlay
├─ ResultOverlay
└─ DemoAudioDirector

FiniteSliceSessionController
├─ ValidationFiniteSlice compatibility wrapper
└─ ProductFiniteSlice
```

### 5.1 `DemoFlowController`

책임:

- TITLE, BRIEFING, GAMEPLAY 화면 전환
- title 복귀
- PC 종료 요청
- overlay 열기·닫기
- finite gameplay Scene의 생성과 안전한 재초기화

금지:

- 선로, 적재, 분기, 배송, 시간, 결과 판정

### 5.2 `FiniteSliceSessionController`

현재 `game/finite/main/finite_slice.gd`에 결합된 finite orchestration을 재사용 가능한 순수 session controller로 추출한다. 이 controller가 validation UI와 제품형 Demo가 공유하는 유일한 application-state owner다.

책임:

- map load
- build session, preflight, run factory와 run session 수명주기
- command dispatch
- retry와 edit 전환
- presenter model 생성
- 제품형 renderer용 read-only snapshot 생성
- delivery와 result signal 발행

공개 경계:

```text
initialize(map_path)
request_command(command, payload)
advance_time(delta)
phase()
model()
render_snapshot()
current_layout_signature()
current_summary()
```

기존 `game/finite/main/finite_slice.gd`는 validation View signal을 controller command에 연결하고 model을 기존 View에 적용하는 얇은 compatibility wrapper로 남긴다. 기존 Scene path와 자동 테스트의 소비 경계를 보존한다.

금지:

- Control node 직접 탐색
- 제품 UI 문구와 animation 소유
- validation 전용 mode 분기
- 같은 상태를 validation wrapper와 Product View에 중복 보관

### 5.3 `ProductFiniteSlice`

책임:

- `FiniteSliceSessionController`의 생성과 수명주기
- Product View command를 controller에 전달
- controller model과 read-only snapshot을 HUD와 renderer에 배포
- gameplay result를 Demo Shell에 전달
- Demo가 title로 돌아갈 때 controller와 연결을 안전하게 폐기

도메인 규칙과 session state를 자체 구현하지 않는다.

### 5.4 `DesktopInputAdapter`

책임:

- InputMap action을 기존 command로 변환
- 현재 phase에서 허용된 입력만 전달
- 텍스트 입력이나 overlay가 활성화됐을 때 gameplay 입력 차단
- 키보드 반복 입력으로 인한 중복 설치 방지

PC 입력은 View 버튼과 동일한 controller command path를 사용한다.

### 5.5 `ProductBoardRenderer`

책임:

- 지형과 buildable/non-buildable cell
- 시작점, 역, 화물 지점
- 설치된 선로와 방향
- 선택·hover·ghost·problem cell
- 열차와 화물 시각화
- active branch와 occupied lock
- 적재·하역 presentation effect

금지:

- domain state mutation
- 자체 이동 시뮬레이션
- 자체 배송 판정

### 5.6 `ProductHUD`

책임:

- 단계별 tool strip
- 비용과 guide 비교
- 남은 시간
- stack과 TOP
- 적재 모드
- pause와 result action
- 조작 단축키 표시
- 오류와 성공·실패 메시지

HUD는 48dp 상당의 핵심 터치 영역을 유지하고, PC에서는 hover와 shortcut hint를 추가한다.

### 5.7 `DemoAudioDirector`

책임:

- 버튼, 설치, 철거, 분기, 적재, 하역, 성공, 실패 효과음
- 열차 구동 loop의 phase 기반 재생
- pause·화면 전환 시 bus 또는 volume 전환

오디오는 결과 판정이나 timing authority가 아니다.

## 6. 데이터 흐름

```text
Mouse / Keyboard / Touch
→ DesktopInputAdapter 또는 ProductView
→ FiniteSliceSessionController.request_command
→ Finite domain/controller
→ Presenter model + read-only render snapshot
→ ProductHUD / ProductBoardRenderer
→ animation·audio feedback
```

다음 원칙을 지킨다.

- domain과 `FiniteSliceSessionController`가 유일한 게임 상태 권위다.
- View animation이 늦거나 생략되어도 결과는 변하지 않는다.
- retry는 sealed layout을 유지하고 mutable runtime을 새로 만든다.
- edit는 보존된 layout을 새 build session에 복원한다.
- Demo Shell 재진입은 이전 signal과 runtime을 남기지 않는다.
- validation wrapper와 Product View는 같은 controller contract를 소비한다.

## 7. 대표 스테이지 설계 기준

새 데모 맵은 다음을 모두 한 번의 플레이에 포함한다.

- A와 B 두 화물 종류
- `A → B → A → A` 적재 가능성
- A역 재방문
- 최소 1개의 persistent branch
- 수동 적재와 자동 적재 중 하나를 선택할 여지
- 구조적으로 불완전한 노선에 대한 preflight 피드백
- 성공 가능한 시간 제한
- 실패 뒤 same-layout retry와 edit의 차이를 보여줄 수 있는 구조

맵은 정답이 하나뿐인 시험지가 아니라, 최소 2개의 성공 가능한 실행 변형을 허용해야 한다. 두 성공 경로는 authored solution fixture로 자동 검증하고, 추천 비용은 안전한 기준값이며 최적해를 의미하지 않는다.

기존 proof 맵의 자동 증거 목적과 데모 맵의 제품 경험 목적을 분리한다.

## 8. 시각·UI 규칙

### 8.1 레이아웃

16:9 기준:

- 상단: 목표, 시간, 비용, 상태
- 중앙: 지도와 선로
- 좌측 또는 하단 좌측: 건설 도구
- 우측: 화물 stack과 TOP
- 하단: 현재 phase의 주요 행동

1280×720, 1600×900, 1920×1080에서 정보 우선순위가 유지되어야 한다.

### 8.2 상태 표현

- buildable: 밝은 지도 cell
- non-buildable: 낮은 명도와 질감
- hover: 얇은 밝은 테두리
- selected: 두꺼운 테두리와 작은 방향 표식
- valid ghost: 반투명 선로
- invalid ghost: 금지 표식과 짧은 이유
- problem cell: 점멸 대신 안정적인 경고 테두리
- active branch: 화살표와 발광
- occupied lock: 자물쇠 표식과 짧은 shake
- TOP: 크기·위치·텍스트로 중복 강조

색상만으로 상태를 구분하지 않는다.

### 8.3 모션

- 화면 fade: 0.15~0.30초
- 패널 이동: 0.15~0.25초
- 설치·철거: 0.10~0.20초
- TOP 강조: 짧은 scale pulse
- 하역: 전체 1초 이하의 domain 계약을 침범하지 않는 presentation
- 성공·실패: 입력을 즉시 막고 0.3초 이내 결과 overlay 시작

모션 때문에 조작 입력과 상태 확인이 지연되어서는 안 된다.

## 9. 오디오·자산 정책

- 외부 자산은 권리와 출처를 기록한다.
- 원본·AI·외주·CC 자산을 혼합할 때 최종 asset record를 분리한다.
- 권리 확인이 끝나지 않은 자산은 `PLACEHOLDER_LICENSED` 또는 `PLACEHOLDER_GENERATED`로 표시한다.
- 임시 자산을 최종 출시 자산으로 표현하지 않는다.
- 코드로 생성 가능한 단순 UI 음과 shape 기반 그래픽을 우선 사용한다.
- 음소거 상태에서도 모든 게임 상태가 시각적으로 전달되어야 한다.

## 10. 플랫폼·Export

### PC

- Godot 4.7.1-stable에서 Scene F6 실행
- Windows debug export preset 추가
- 1280×720 windowed 기본
- resize 시 aspect와 최소 UI 크기 보존
- 종료 버튼과 `Esc` 흐름 지원

### Android

- 기존 Android validation preset과 package ID를 변경하지 않는다.
- 새 Demo Scene은 터치 입력 호환을 유지하지만 이번 작업에서 Android PASS를 주장하지 않는다.
- canonical APK source SHA와 hash는 이번 Demo 구현의 테스트 증거로 재사용하지 않는다.

## 11. 오류 처리

- map load 실패: 데모 시작을 막고 개발자용 명확한 오류 표시
- 잘못된 map data: fail closed
- `FiniteSliceSessionController` 초기화 실패: gameplay 진입 금지, title 복귀 제공
- invalid input action: 무시하고 state mutation 금지
- overlay 활성 중 gameplay command: 차단
- 중복 signal 연결: Scene 재생성 시 해제 또는 새 instance로 격리
- missing optional audio: silent fallback
- missing required visual resource: 테스트 실패
- unsupported window size: 최소 크기 유지 또는 letterbox

## 12. 테스트 전략

### 12.1 기존 회귀

- 전체 Godot headless suite
- Project Contract
- Android validation entrypoint invariance
- finite 자동 코어 테스트

### 12.2 신규 자동 테스트

- `FiniteSliceSessionController`가 기존 validation flow와 동일한 proof 결과 생성
- 기존 `finite_slice.tscn` compatibility wrapper boot와 command 회귀
- Demo Scene headless boot
- Title→Briefing→Gameplay 전환
- PC input action→기존 command mapping
- overlay 활성 시 gameplay input 차단
- mouse와 touch가 동일 command를 생성
- BUILD→preflight→RUN→SUCCESS smoke
- FAILURE→same-layout retry
- FAILURE→edit layout
- pause integrity
- Demo 재진입 시 stale runtime·signal 없음
- 2개 authored demo solution 성공
- 1280×720, 1600×900, 1920×1080 layout contract
- Windows export preset contract
- default main scene 불변
- Android validation harness 불변

### 12.3 수동 검증

- Godot 에디터 F6 실행
- 마우스만으로 완주
- 키보드 shortcut을 포함한 완주
- 마우스+키보드 혼합 완주
- 1280×720과 1920×1080 실화면 확인
- 실패 후 retry와 edit 확인
- 음소거 상태의 정보 전달 확인
- clipping, overlap, focus loss, stuck input 확인
- Windows debug export 실행

## 13. 완료 기준

다음을 모두 만족해야 Vertical Slice Demo 구현 완료로 판정한다.

1. Godot 에디터에서 `vertical_slice_demo.tscn` F6 실행 성공
2. Title→Briefing→BUILD→RUN→Result 완결
3. 단일 대표 스테이지 성공과 실패 모두 가능
4. same-layout retry와 edit가 서로 다르게 동작
5. 마우스 중심 조작과 승인된 keyboard shortcut 동작
6. 터치 command 경계 회귀 없음
7. 선로·역·화물·열차·TOP·분기 상태가 제품형 화면에서 읽힘
8. 1280×720, 1600×900, 1920×1080에서 주요 UI clipping 없음
9. Windows debug export 실행 성공
10. 전체 자동 테스트 성공
11. 기존 validation wrapper가 공용 controller 위에서 동일 proof 결과를 유지
12. default entrypoint와 Android validation harness 불변
13. Android, human, production Gate를 임의로 PASS 처리하지 않음
14. 외부 자산의 권리 상태가 기록됨
15. P0·P1 open finding 0

## 14. 구현 패키지 제안

구현 계획에서는 다음 순서로 분할한다.

1. `FiniteSliceSessionController` 추출과 compatibility 회귀
2. Demo entrypoint와 flow shell
3. PC InputMap과 adapter
4. 제품형 board renderer
5. 제품형 HUD와 한국어 상태 문구
6. 대표 데모 맵과 2개 authored solution
7. gameplay presentation effects
8. audio director와 placeholder asset record
9. result·retry·edit·title 흐름
10. responsive layout와 Windows export
11. 자동·수동·적대적 검증

각 패키지는 RED test, 최소 구현, GREEN, 회귀 검증 순서로 진행한다.

## 15. 적대적 경계

다음 오해를 금지한다.

- PC Demo가 Android Device Smoke PASS를 의미하지 않는다.
- Windows export가 production release readiness를 의미하지 않는다.
- 외부 시연 가능 상태가 기본 entrypoint cutover 승인을 의미하지 않는다.
- 제품형 View가 domain 권위를 소유하지 않는다.
- proof 맵을 수정해 데모 맵으로 대체하지 않는다.
- 다수의 낮은 완성도 스테이지를 추가해 단일 대표 스테이지 품질을 희생하지 않는다.
- 최종 자산 권리가 확인되지 않은 상태에서 출시 가능으로 판정하지 않는다.
- controller 추출 과정에서 validation harness의 command·proof 의미를 변경하지 않는다.

## 16. 자체 검토 결과

- Placeholder: 없음
- 미정 경로: 없음
- 제품 규칙 충돌: 없음
- Android·production Gate 오인 가능성: 불변 경계로 차단
- application-state 중복 위험: 공용 `FiniteSliceSessionController`로 해소
- 콘텐츠 과다 위험: 단일 대표 스테이지로 제한
- 성공 경로 검증 모호성: 2개 authored solution fixture로 명시
- 구현 단위: 하나의 계획으로 분해 가능한 범위

## 17. 현재 결론

```text
PC VERTICAL SLICE DESIGN: USER_APPROVED
SPEC SELF-REVIEW: PASS
IMPLEMENTATION: NOT_STARTED
FINITE AUTOMATED CORE: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

다음 단계는 이 설계에 대한 사용자 문서 검토 후, TDD 기반 구현 계획을 작성하는 것이다.
