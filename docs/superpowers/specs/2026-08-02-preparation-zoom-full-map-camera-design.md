# Preparation Zoom + Full-Map Camera Design

```yaml
decision_id: SX-DEC-018
evidence_id: EV-USER-007
batch_id: GMB-001
batch_slot: 2/10
status: APPROVED_PENDING_BATCH_MERGE
authority: USER_REFINED_OPTION_A
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 목적

게임 진입 직후에는 기관차와 장난감 철도 세계를 조금 더 크게 보여 첫인상과 출발 준비를 돕되, 실제 운행이 시작되면 15×10 전체 철도망을 한 화면에 고정해 경로 계획과 분기 공정성을 보존한다.

## 사용자 결정 해석

사용자는 카메라 기본 정책으로 A안인 전체 맵 고정을 선택하면서, **준비 단계와 게임 시작 순간에는 조금 더 확대해 보자**고 보정했다.

따라서 최종 정책은 다음과 같다.

```text
첫 진입 PREP/READY: 기관차 주변을 약간 확대
START 접수: simulation·fuel·difficulty timer는 아직 정지
카메라: 전체 15×10 맵 framing으로 복귀
FULL_MAP_READY: 실제 run 시작
ACTIVE_RUN: 전체 맵 고정, 추적·자동 확대 없음
```

## 확정 계약

1. 실제 운행의 기본 카메라는 15×10 전체 맵 고정이다.
2. 최초 게임 진입 또는 수동 새 게임의 `PREP/READY`에서만 기관차 주변을 조금 더 크게 보여준다.
3. 준비 화면은 기관차뿐 아니라 첫 접근 가능 화물, 가까운 핵심 분기 또는 출발 경로 일부가 함께 읽혀야 한다.
4. `START` 입력 뒤 카메라가 전체 맵으로 복귀할 때까지 simulation, fuel drain, difficulty timer, spawn progression은 시작하지 않는다.
5. 전체 맵 framing이 확정된 뒤에만 실제 run clock과 도메인 진행을 시작한다.
6. 운행 중 열차 추적, 자동 줌, 화면 회전, 상황형 확대 창은 기본 정책에서 사용하지 않는다.
7. 첫 세션 온보딩의 LOAD·분기 safe pause는 카메라 이동 대신 기존 외곽선·아이콘·경로 강조를 사용한다.
8. 카메라·Tween·animation completion은 run 상태, 점수, 연료, 분기, spawn, onboarding 단계의 권위를 소유하지 않는다.
9. Reduced Motion에서는 줌 이동 없이 준비 framing에서 전체 맵 framing으로 즉시 전환한다.
10. 결과 화면의 즉시 `RESTART`는 재도전 속도를 위해 전체 맵 framing으로 직접 복귀하는 것을 권장 기본값으로 둔다. 준비 확대 반복 여부는 플레이테스트 가능한 `TEST_VALUE`다.

## 카메라 상태 모델

```text
SESSION_ENTRY
→ PREP_ZOOM
→ START_REQUESTED
→ FULL_MAP_TRANSITION
→ FULL_MAP_READY
→ ACTIVE_RUN
→ RESULT
→ RESTART_FULL_MAP
```

권장 상태 책임:

- `CameraPresentationState`는 현재 framing과 전환 요청만 관리한다.
- `RunController`는 `FULL_MAP_READY` 신호 전에는 run을 시작하지 않는다.
- `Camera2D`와 Tween은 도메인 상태를 직접 변경하지 않는다.
- 전환이 중단·스킵·즉시 완료돼도 `FULL_MAP_READY`는 정확히 한 번만 발생한다.

## PREP/READY framing

준비 단계는 전체 화면을 사용하며 별도 확대 창을 만들지 않는다.

포함해야 하는 요소:

- 기관차 전체 실루엣
- 출발 선로의 진행 방향
- 첫 접근 가능한 pickup 또는 출발 목표
- 가까운 핵심 분기가 있다면 방향 관계
- START·Help 등 준비 단계 UI

확대로 인해 첫 pickup과 출발 경로가 동시에 보이지 않으면 확대가 과도한 것으로 판정한다.

## TEST_VALUE

아래 값은 영구 밸런스가 아니라 Android 캡처와 사람 검증으로 조정한다.

```text
prep magnification: full-map 대비 1.15×~1.25×
recommended baseline: 1.20×
transition duration: 0.60~0.90초
recommended baseline: 0.75초
transition easing: overshoot 없는 ease-out
restart prep replay: OFF 기본, 비교 실험 가능
```

Godot의 실제 zoom vector 값은 Camera2D 좌표계 의미를 확인한 뒤 config로 변환하며, 문서의 `1.20×`는 플레이어가 체감하는 확대 배율을 뜻한다.

## 시작·재시작 흐름

### 최초 진입

1. PREP_ZOOM에서 기관차와 출발 주변을 보여준다.
2. 플레이어가 START를 누른다.
3. board 입력은 아직 잠그고 카메라만 전체 맵으로 복귀한다.
4. Reduced Motion이면 즉시 전체 맵으로 전환한다.
5. FULL_MAP_READY가 확정되면 board 입력, fuel drain, difficulty timer, run telemetry를 같은 도메인 시작 경계에서 연다.

### 즉시 재도전

- 결과 화면의 RESTART는 빠른 재도전을 우선한다.
- 기본은 전체 맵 framing으로 바로 복귀하고 run 준비 경계를 다시 초기화한다.
- 준비 확대를 매번 반복하는 안은 재도전 지연·멀미 가능성이 있어 기본에서 제외한다.
- 사람이 준비 확대 반복을 선호한다는 증거가 생기면 config로 비교할 수 있다.

## 첫 세션 온보딩과의 관계

- `SX-DEC-016`의 첫 LOAD와 첫 분기 safe pause는 FULL_MAP_READY 이후 발생한다.
- 온보딩 중 카메라가 다시 확대되거나 열차를 추적하지 않는다.
- rear compact token, HUD unload order, 분기 preview는 카메라 이동 없이 강조한다.
- 시작 카메라 전환과 온보딩 safe pause가 겹치지 않아야 한다.
- first-run assist timer는 실제 run 시작 경계부터 계산한다.

## 권위·입력 계약

```text
START input
→ CameraPresentationState requests FULL_MAP
→ FULL_MAP_READY emitted once
→ RunController starts domain run
→ HUD/telemetry observe started run
```

- 카메라 transition 시간이 run time에 포함되지 않는다.
- zoom 중 board tap을 분기 입력으로 오인하지 않는다.
- 화면 좌표→월드 좌표 변환은 full-map 상태에서 기존 터치 계약과 일치해야 한다.
- 앱 suspend/resume, 창 크기 변경, orientation 오류, Tween 중단 시 안전하게 FULL_MAP_READY 또는 PREP_ZOOM 중 하나로 수렴한다.
- 카메라 오류가 나면 전체 맵 즉시 전환으로 fallback하고 run 시작을 영구 차단하지 않는다.

## 접근성·멀미 방지

- 회전, 흔들림, overshoot, 급격한 bounce를 사용하지 않는다.
- Reduced Motion에서는 즉시 cut을 사용한다.
- transition 중 중요한 텍스트를 움직이는 월드에 고정하지 않는다.
- 16:9 기준 외에도 긴 화면·좁은 화면에서 HUD safe area와 전체 맵 framing을 검증한다.
- 준비 확대는 장식이 아니라 기관차·출발 방향·첫 목표의 식별 개선 여부로 평가한다.

## Telemetry

권장 bounded event:

```text
camera_prep_shown
camera_start_transition_started
camera_full_map_ready
camera_transition_skipped
camera_transition_recovered
run_started_after_camera_ready
```

필수 field:

```text
session_entry_type
prep_magnification
transition_duration_ms
reduced_motion
recovery_reason
restart_flow
```

카메라 event 실패는 run 시작·점수·저장·재시작을 막지 않는다.

## 합격 기준

자동 검증:

- FULL_MAP_READY 전에는 fuel, timer, difficulty, spawn progression이 0회 진행된다.
- START 반복 입력에도 run start와 FULL_MAP_READY가 각각 1회만 확정된다.
- transition skip·interrupt·suspend/resume 후 deadlock이 없다.
- ACTIVE_RUN 중 zoom과 camera target이 고정된다.
- 첫 세션 LOAD·분기 safe pause와 카메라 transition이 중첩되지 않는다.
- 즉시 RESTART가 이전 camera state를 누출하지 않는다.

Android·사람 검증:

- 준비 화면에서 5명 중 4명 이상이 기관차와 출발 방향을 즉시 찾는다.
- START 후 첫 실제 분기 판단 전에 전체 맵을 읽을 수 있다.
- 5명 중 4명 이상이 카메라 전환이 운행 시작을 방해하지 않았다고 평가한다.
- Reduced Motion에서 정보 손실이 없다.
- 전체 맵 상태에서 compact token·역·분기·preview가 기존 가독성 기준을 유지한다.

## 비목표

- 운행 중 열차 추적 카메라
- pinch zoom 또는 자유 pan
- 분기·LOAD마다 반복되는 자동 줌
- 별도 picture-in-picture 확대 창
- 카메라 위치에 따른 spawn·점수·연료·난이도 변경

## 적대적 검토

- 시작 transition 중 run이 진행되면 첫 선택이 불공정해진다.
- 준비 확대가 과하면 첫 pickup·분기 관계가 오히려 안 보인다.
- zoom 중 board 입력을 받으면 좌표 변환 오류가 발생할 수 있다.
- 매 재시작마다 연출을 반복하면 재도전 속도와 멀미 문제가 생긴다.
- Tween 완료를 유일한 시작 조건으로 삼으면 interruption deadlock 위험이 있다.

위험은 `SX-AUD-004-F31`~`F35`로 GMB 원장에 기록한다.

## 미검증 경계

- 1.20× 확대, 0.75초 전환, restart 반복 OFF는 `TEST_VALUE`다.
- 실제 Camera2D 구현, Android 비율별 framing, 터치 좌표, Reduced Motion, 사람 반응은 `NOT_RUN`이다.
- 본 결정은 기획 승인일 뿐 제품 구현·성능·Android 증거를 의미하지 않는다.
