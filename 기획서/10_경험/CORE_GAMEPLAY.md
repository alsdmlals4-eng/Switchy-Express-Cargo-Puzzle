# Core Gameplay

## 플레이어 약속

> 필요한 화물을 고르고, 분기기를 미리 바꾸고, 마지막에 실은 화물부터 같은 종류 역에 연속 하역해 연료와 점수를 이어간다.

## 핵심 루프

```text
자동 운행
→ 화물 접근
→ LOAD를 누르는 동안 선택 적재
→ 작은 토큰형 화차가 뒤에 추가
→ 분기기 상태 확인·전환
→ 스테이션 도착
→ 뒤쪽 토큰부터 LIFO 연속 하역
→ 하역 그룹 Combo·점수·연료 회복
→ 시간 경과로 속도·연료 압박 증가
→ BOOST로 이동 시간과 연료를 교환
→ 연료 0에서 결과
→ 즉시 재도전
```

## 조작

| 입력 | 행동 | 현재 구현 |
|---|---|---|
| `LOAD` 홀드 | 지나가는 화물을 적재 | 도메인 로직 구현·검증 |
| 분기기 탭 | 다음 활성 노선으로 순환 | 라우팅 로직 구현·검증, 제품 터치 UI 미구현 |
| `BOOST` 홀드 | 속도를 높이고 연료를 추가 소비 | 입력 우선 계약만 구현 |
| 일시정지 | 운행과 입력 정지 | 일반 pause 미구현; 첫 LOAD·첫 분기 safe pause는 `SX-DEC-016` 계획 승인 |

`LOAD`와 `BOOST`가 동시에 요청되면 BOOST를 우선하고 적재를 비활성화한다. 이 입력 계약은 구현됐으며 실제 BOOST 경제와 UI는 VS-03 범위다.

## 맵 경험

- 가로형 15×10 격자
- 모든 선로가 하나의 네트워크로 연결
- 막다른길 없음
- 최소 3개의 의미 있는 순환 경로
- 분기 후 경로가 최소 3칸 이상 다르게 이어지는 실제 선택
- 한 판 중 맵은 고정되어 학습과 숙련이 가능
- 새 판 시작 시 검증된 생성 규칙 안에서 노선·역·화물 배치를 변경
- 구조 계약은 검증됐지만 반복 플레이에 충분한 unique-map 수·경로 엔트로피는 `NOT_RUN`

## 분기기

- 2단계: `A → B → A`
- 3단계: `A → B → C → A`
- 직진 가능한 경우 기본 A노선은 직진 우선
- 직진 출구가 없으면 결정론적 첫 유효 출구
- 즉시 180도 반전 금지
- 열차가 segment에 진입하면 해당 목표를 잠그고 중간 전환으로 경로를 스냅하지 않음
- 통과 후 기본 상태 복귀
- 선택 경로 3~5칸 미리보기
- 미리보기 첫 칸과 실제 다음 칸 불일치는 P0
- 제품 RailBoardView·레버·화살표·터치 영역은 미구현

## 화물·토큰형 화차·LIFO — SX-DEC-015

현재 구현·검증:

- 최대 capacity 8 CargoStack
- 화물 타입은 빨강/별, 파랑/마름모, 노랑/삼각형
- LOAD 중에만 pickup 적재
- 실제 적재 순서의 역순을 Unload Order로 제공
- 같은 타입 역에서 stack top의 연속 동일 타입 그룹만 하역
- 적재 `R,R,B,R`의 하역 순서는 `R,B,R,R`
- 기존 TrainState는 최대 8개 wagon 위치 계산 API를 제공

확정 제품 표현:

- 화물 1개를 작은 토큰형 화차 1개로 표시한다.
- 화물 0개에서는 기관차만 보이며 빈 화차는 표시하지 않는다.
- 기관차에 가까운 토큰부터 뒤쪽까지 stack bottom→top 순서다.
- 가장 뒤 토큰은 마지막 적재 화물이자 다음 LIFO 하역 대상이다.
- 적재하면 뒤에 토큰 1개가 추가되고, 유효 하역은 뒤쪽의 같은 타입 연속 토큰을 제거한다.
- 각 토큰은 화물의 색상+모양 부호를 그대로 가진다.
- 최대 8개 토큰 열은 권장 시험값 2.18칸, 최대 trailing 점유 3칸 안에 압축한다.
- 화물 8개를 8개의 full-size 선로 칸 점유로 취급하지 않는다.
- CargoStack 변경과 토큰 count/order·압축 점유 갱신은 같은 도메인 단계에서 완료한다.
- 토큰 추가·제거 애니메이션 완료는 적재·하역·점유의 권위가 아니다.

상세 규격: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`.

## Combo — SX-DEC-014

- `Combo`는 한 번의 역 도착에서 stack top부터 연속 하역된 동일 화물 타입의 개수다.
- 예: 상단부터 `RED_STAR ×3`이 빨강 역에서 하역되면 `COMBO ×3`이다.
- `max_combo`는 한 판에서 기록한 가장 큰 하역 그룹 크기다.
- 다른 배송까지 이어지는 Combo streak는 없다.
- 이전 배송 뒤 빠르게 다음 배송을 성공한 보상은 Combo가 아니라 별도 `speed_bonus` 시험값이다.
- 빈 역 도착·타입 불일치는 Combo 0이며 보상을 주지 않는다.
- 성공 배송 때 즉시 `COMBO ×N` 피드백을 주고, 결과 화면에는 `MAX COMBO`를 표시한다.

이 정의는 LIFO 적재 순서를 직접 보상하며 `try_unload().count`, 점수 입력, HUD, telemetry, 저장의 의미를 하나로 통일한다.

## 첫 세션 상황형 온보딩 — SX-DEC-016

별도 튜토리얼 맵이나 설명 화면만 제공하지 않는다. 실제 첫 무한 run을 안전하게 시작하고, 플레이어 행동 직후 다음 의미를 순차적으로 보여준다.

```text
첫 LOAD
→ 화물 1개 = rear compact token 1개
→ 첫 분기와 preview/target lock
→ A,B mixed stack에서 rear B 먼저 하역
→ 같은 타입 2개 이상 하역으로 COMBO ×N
→ 연료 35% 이하에서 BOOST 위험 안내
→ 같은 run을 일반 무한 운행으로 계속
```

확정 계약:

- 첫 LOAD와 첫 분기 접근에서만 full simulation safe pause를 요청할 수 있다.
- 일반 branch slow motion은 추가하지 않는다.
- first-run assist는 연료 소모 0.5×·난이도 상승 정지·최대 120초·종료 후 3초 복귀를 권장 `TEST_VALUE`로 사용한다.
- core 완료·명시적 skip·120초 timeout 중 먼저 발생한 시점에 assist를 종료한다.
- OnboardingState는 CargoStack·RailSwitch·DeliveryLoop·RunController가 낸 실제 domain event를 소비한다.
- overlay·카피·강조·animation completion은 pickup·route·unload·score·fuel·Combo·save를 소유하지 않는다.
- 완료 후 Help 카드에서 규칙을 다시 볼 수 있지만 first-run spawn preference·fuel assist를 다시 켜지 않는다.
- assisted first run은 일반 balance 분석과 분리한다.

상세 설계: `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`.

## 플레이어 고민

1. 지금 화물을 실으면 원하는 LIFO 순서가 만들어지는가
2. 현재 분기 상태가 원하는 역·화물 구간으로 이어지는가
3. 더 싣고 큰 Combo를 노릴지 지금 하역할지
4. 작은 토큰 열에서 가장 뒤의 다음 하역 화물이 무엇인지
5. 화물 무게를 감수할지 BOOST로 보완할지
6. 안전 생존과 시간당 점수 중 무엇을 우선할지

## 실패·복구

- 주 게임오버 조건은 연료 0이다.
- 잘못된 분기·적재는 즉시 종료보다 점수·연료 효율 악화로 이어진다.
- 결과 화면에서 원인·점수·생존·최대 Combo·기록과 재시작 행동을 제공한다.
- 게임오버·결과·재시작·저장 구현은 VS-03 범위다.
- 애니메이션 완료 signal은 점수·연료·저장·게임오버의 권위가 아니다.
- 결과 화면에서 어떤 실패 원인과 다음 행동을 최우선으로 보여줄지는 `SX-DEC-017` 후보이며 GMB-001에서 결정한다.

## 구현 증거

- VS-01: PR #9 / `EV-VS01-001`
- VS-02: PR #12 / `EV-VS02-001`
- VS-02 런타임 회복: PR #13 / `EV-VS02-FIX-001`
- Combo 의미: 사용자 승인 / `SX-DEC-014` / `EV-USER-002`
- compact wagon token 의미: 사용자 승인 / `SX-DEC-015` / `EV-USER-003`
- 상황형 온보딩 의미: 사용자 승인 / `SX-DEC-016` / `EV-USER-004`
- Godot headless: `9 cases / 6915 assertions / 0 failures`

## 다음 기획 Gate

- 현재 catch-up canonical PR·Sheet closure
- `SX-DEC-017` 결과 화면 실패 원인·다음 행동 정보 (`GMB-001` slot 1)
- compact token 크기·간격·카메라와 onboarding assist 타이밍은 VS-03의 `TEST_VALUE`
- 중요한 방향 차이는 Grill Me, 상세 타이밍·수치는 시험값으로 설계
