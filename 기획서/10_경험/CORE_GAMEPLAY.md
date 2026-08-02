# Core Gameplay

## 현재 상태

```yaml
rail_switch_cargo_lifo: IMPLEMENTED · PASSED
run_lifecycle_economy_combo_difficulty: IMPLEMENTED · HEADLESS_PASSED
compact_token_footprint: CONFIRMED · VS03-02_READY_FOR_BUILD
product_scene_hud_result_camera: NOT_STARTED
android_human_evidence: NOT_RUN
```

구현 증거:

```text
VS03-01 PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
```

## 플레이어 약속

> 필요한 화물을 고르고, 분기기를 미리 바꾸고, 마지막에 실은 화물부터 같은 종류 역에 연속 하역해 연료와 점수를 이어간다.

## 핵심 재미

> 앞으로 필요한 하역 순서를 역산해 화물을 골라 싣고, 목적 역까지 경로를 준비하며, 무게와 연료 압박을 감수해 큰 LIFO 하역 그룹을 성공시키는 계획형 생존 퍼즐.

핵심 위계:

```text
LIFO 적재 순서 계획
→ 노선 선행 결정
→ 위험·생존 판단
→ BOOST·배송 tempo
→ 결과 학습·재도전
→ 기록·꾸미기·맵 발견·UGC
```

상세: `CORE_FUN_SYSTEM_HIERARCHY.md`.

## 핵심 루프

```text
자동 운행
→ 화물 접근
→ LOAD를 누르는 동안 선택 적재
→ 작은 token형 화차가 뒤에 추가
→ 분기기 상태 확인·전환
→ station 도착
→ 뒤쪽 token부터 LIFO 연속 하역
→ 하역 그룹 Combo·점수·연료 회복
→ 시간 경과로 속도·연료 압박 증가
→ BOOST로 이동 시간과 연료·LOAD 기회를 교환
→ 연료 0에서 결과
→ 같은 맵 또는 새 공식 맵으로 재도전
```

## 플레이어 고민

1. 지금 화물을 실으면 원하는 LIFO 순서가 만들어지는가
2. 현재 분기 상태가 원하는 역·화물 구간으로 이어지는가
3. 더 싣고 큰 Combo를 노릴지 지금 하역할지
4. 가장 뒤 token, 즉 다음 하역 화물이 무엇인지
5. 화물 무게를 감수할지 BOOST로 이동 시간을 줄일지
6. 안전 생존과 시간당 점수 중 무엇을 우선할지

빠른 탭 자체보다 적재 순서와 경로를 먼저 준비한 판단이 성공 원인이어야 한다.

## 조작

| 입력 | 행동 | 현재 구현 |
|---|---|---|
| `LOAD` 홀드 | 지나가는 화물을 선택 적재 | 도메인 로직 구현·검증 |
| 분기기 탭 | 다음 활성 노선으로 순환 | 라우팅 로직 구현·검증, 제품 touch UI 미구현 |
| `BOOST` 홀드 | 속도를 높이고 연료를 추가 소비 | 경제·LOAD 배제 구현·검증, 제품 UI 미구현 |
| 일시정지 | 운행·권위 시간·입력 정지 | RunState pause 구현·검증, 제품 pause UI 미구현 |

`LOAD`와 `BOOST`가 동시에 요청되면 BOOST를 우선하고 적재를 비활성화한다.

가로형 `한 손 중심`은 물리적으로 한 손만 사용한다는 보장이 아니라 다음을 뜻한다.

```text
single-pointer friendly
+ 동시 chord input 불필요
+ 한 번에 한 의도 입력
```

전체 맵 분기 reach와 LOAD/BOOST 배치는 Android 실기기에서 검증한다.

## 맵 경험

- 가로형 15×10 격자
- 모든 선로가 하나의 네트워크로 연결
- 막다른길 없음
- 최소 3개의 의미 있는 순환 경로
- 분기 후 경로가 최소 3칸 이상 다르게 이어지는 실제 선택
- 한 판 중 맵은 고정되어 학습과 숙련이 가능
- 같은 맵 재시작은 exact map identity와 fresh run state를 사용
- VS-03은 최소 3개 validated official maps
- Production 100+ unique official layouts는 별도 Gate이며 `F58 NOT_MET`

구조 계약은 구현됐지만 target3 session/restart/selection은 VS03-03, target100은 Production 범위다.

## 분기기

- 2단계: `A → B → A`
- 3단계: `A → B → C → A`
- 직진 가능한 경우 기본 A노선은 직진 우선
- 직진 출구가 없으면 결정론적 첫 유효 출구
- 즉시 180도 반전 금지
- 열차가 segment에 진입하면 목표 exit 잠금
- 통과 후 기본 상태 복귀
- 선택 경로 3~5칸 preview
- preview 첫 칸과 실제 next cell 불일치는 P0
- 제품 RailBoardView·레버·화살표·48dp 터치 영역은 VS03-05 범위

## 화물·token형 화차·LIFO — SX-DEC-015

현재 구현·검증:

- 최대 capacity 8 CargoStack
- 타입: 빨강/별, 파랑/마름모, 노랑/삼각형
- LOAD 중에만 pickup 적재
- 실제 적재 순서의 역순을 Unload Order로 제공
- 같은 타입 역에서 stack top의 연속 동일 타입 그룹만 하역
- 적재 `R,R,B,R`의 하역 순서 `R,B,R,R`
- TrainController는 bounded route history와 fractional path sample seam을 제공

확정 제품 표현:

- 화물 1개 = 작은 token형 화차 1개
- 화물 0개 = 기관차만 표시
- front→rear = stack bottom→top
- rear token = 마지막 적재 화물 = 다음 LIFO 하역 대상
- 적재 시 뒤에 token 1개 추가
- 유효 하역 시 뒤쪽 동일 타입 연속 token 제거
- 색상+모양 이중 부호
- 8개 token 열 권장 시험값 2.18칸, trailing 점유 최대 3칸
- CargoStack 변경과 token count/order·점유 갱신은 같은 domain step
- animation completion은 적재·하역·점유 권위가 아님

현재 compact token/TrainFootprint/DeliveryLoop occupancy 연결은 VS03-02의 실행 권위다.

## Combo — SX-DEC-014

```text
combo_count = 이번 한 번의 역 도착에서 연속 하역된 동일 cargo type 개수
max_combo = 한 판의 최대 combo_count
```

- `combo_count == Station.try_unload().count`
- 다른 배송까지 이어지는 streak가 아님
- 빠른 배송은 독립 `speed_bonus`
- 배송 직전 화물 6개 이상은 독립 `heavy_bonus TEST_VALUE`
- 빈 역·타입 불일치는 Combo·점수·연료 보상 0
- 실제 RunController·RunState·metrics·DeliveryLoop integration에서 구현·검증됨
- 제품 HUD·결과 표현은 VS03-05 범위

## 생존 경제 — VS03-01

구현된 의미:

- 시간 경과에 따라 기본 속도와 연료 소모 증가
- 화물 수에 따라 이동 속도 감소
- 화물 감속은 초당 연료 소모를 낮추지 않음
- BOOST는 속도 증가·연료 추가 소모·LOAD 기회 포기
- 하역 그룹 크기에 따라 점수와 연료 회복
- fuel zero는 run을 한 번만 종료
- 종료 뒤 이동·pickup·unload·score·fuel·metrics mutation 없음
- pause 동안 run clock·fuel·difficulty 진행 없음

현재 수치는 `TEST_VALUE`이며 플레이테스트·경제 시뮬레이션 전 영구 밸런스가 아니다.

## 핵심 재미 적대적 guardrail

- 같은 색만 골라 싣는 전략이 거의 항상 최적이면 LIFO 퍼즐 실패
- speed/heavy bonus가 group-size 계획보다 강하면 방향 이탈
- BOOST 상시 사용이 생존과 점수 모두의 지배 전략이면 실패
- compact token에서 rear item을 즉시 읽지 못하면 core가 보이지 않음
- 난이도 증가가 판단 빈도보다 반사신경만 요구하면 실패
- 기록·재화·맵 수가 실제 run보다 주된 반복 동기가 되면 meta 과잉

필수 후속 관찰:

- mixed-stack 비율과 distinct type count
- mono-color delivery 비율
- Combo 1/2/3/4/5+ 분포
- base score와 speed/heavy bonus 기여 비중
- 경로 선행 전환 성공·실수·복구
- BOOST uptime과 포기한 LOAD 기회

## 첫 세션 상황형 온보딩 — SX-DEC-016

별도 tutorial map이 아니라 실제 첫 endless run에서 다음을 가르친다.

```text
첫 LOAD
→ 화물 1개 = rear token 1개
→ 첫 분기와 preview/target lock
→ mixed stack에서 rear item 먼저 하역
→ 같은 타입 2개 이상으로 COMBO ×N
→ 저연료 BOOST 위험
→ 같은 run을 일반 무한 운행으로 계속
```

- 첫 LOAD와 첫 분기 접근에서만 safe full pause 요청 가능
- 일반 branch slow motion 없음
- assist 시험값: fuel drain 0.5×, escalation paused, max 120 sec, restore 3 sec
- 완료·skip·timeout 중 먼저 발생한 시점에 종료
- OnboardingState는 실제 domain event 소비
- overlay·copy·animation은 gameplay/save 권위가 아님
- Help는 규칙을 다시 보여주지만 assist를 재활성화하지 않음
- assisted run은 standard record·reward·balance evidence와 분리

구현은 VS03-06 범위다.

## 실패·복구

- 주 게임오버 조건은 연료 0
- 잘못된 분기·적재는 즉시 종료보다 점수·연료 효율 악화
- RunSummary는 score·survival·max Combo·metrics를 immutable하게 봉인
- 결과는 근거 있는 실패 원인 1개와 다음 행동 1개를 표시하고 불확실하면 neutral fallback
- restart는 같은 맵 primary action
- 결과·기록·restart UI와 persistence는 후속 package 범위

## Benchmark Positioning

- Mini Metro에서 점진적 생존 압력과 실패 후 학습을 참고
- Conduct THIS!에서 적은 입력과 즉각적인 분기 feedback을 참고
- Railbound에서 화차 순서와 경로 인과 가독성을 참고
- Train Valley 2에서 official/UGC 콘텐츠 단계를 분리하는 방식을 참고
- Rail Route에서 경로 권위와 presentation 분리를 참고

채택하지 않는 방향:

- 철도망 건설을 주 core로 확대
- 충돌 회피·반사신경 중심 전환
- 정답형 authored puzzle로 endless run 대체
- core 검증 전 tycoon·automation·UGC 규모 확대

## 현재 기획·구현 Gate

```text
SX-AUD-007 core-fun/benchmark Draft review
+ VS03-02 compact token/footprint TDD
→ VS03-03 target3 session/restart/selection
→ playable core surface 검증 시점 재검토
```

중요 방향 차이는 benchmark-backed Grill Me로 질문하고, 의미를 보존하는 수치 조정은 `TEST_VALUE` 재보정으로 처리한다.
