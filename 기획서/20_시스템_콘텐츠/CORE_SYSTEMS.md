# Core Systems

상태: `CURRENT_CANON · GMB-002 · AUTOMATED_CORE_PASS`

세부 제품 규칙은 `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`가 책임진다. 현재 실행·검증 상태는 `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`와 `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`를 우선하며, 아래 과거 자동화·APK 증거는 당시 검증 사실로 보존한다.

## 시스템 위계

```text
MapDefinition: 지형·시작점·역·화물·건설 가능 영역
→ TrackLayout: 플레이어가 건설한 선로·속성·비용
→ Preflight: 구조적 도달 가능성과 trap 검사
→ Run: 자동 이동·적재·분기·LIFO 하역
→ Result: 성공/실패·시간·비용·점수 분석
→ Retry: 같은 sealed layout·새 mutable runtime
```

기존 `MapDefinition = 완성된 RailGraph` 계약은 `[대체됨]`이다. 현재 finite 계약은 base map identity와 player-built layout identity를 분리한다.

## 맵 정의

맵이 소유하는 것:

- 시작점과 진입 방향
- 역과 종류
- 화물 지점과 종류
- 건설 가능·불가 셀
- 제한 시간
- 추천 설계도와 추천 비용 metadata
- 신속·절약·점수 목표 metadata
- map ID·revision·ruleset version

플레이어가 소유하는 것:

- 설치한 선로 형태와 회전
- 분기 초기 상태
- 최종 건설비
- sealed layout signature

확장 선로와 지형 규칙은 별도 후속 package에서 추가한다.

## 건설 비용

```text
current_build_cost = 운행 시작 시 존재하는 최종 TrackLayout 비용 합
```

- 설치 시 즉시 증가
- 철거·교체 시 기존 조각 비용 전액 환급
- 과거 설치·철거 누적 비용은 기록하지 않음
- 일반 클리어 비용 상한 없음
- 절약 목표와 가격 기록은 최종 비용 사용
- 상세 수치는 `TEST_VALUE`

첫 Slice 구현값:

| 요소 | 비용 |
|---|---:|
| 직선·곡선 | 100 |
| 분기·교차 | 200 |

가속·저비용·일방통행·회차·교량·터널은 현재 첫 Slice 범위 밖이다.

## 선로 그래프 의미

- 직선·곡선: 두 연결점
- 분기: 진입 방향에서 둘 이상의 유효 출구, 활성 출구 1개
- 교차: 가로·세로 연결은 독립이며 교차점에서 회전 불가
- 분기는 플레이어가 다시 탭할 때까지 상태 유지
- RUNNING/UNLOADING 중 비점유 분기 직접 탭 가능
- 열차가 분기 위에 있을 때만 변경 잠금
- 운행 중 선로 건설·회전·교체·철거 금지

## 시작 전 검사

검사함:

- 시작 연결과 유효 incoming 방향
- 모든 역 도달 가능
- 모든 화물 지점 도달 가능
- dangling edge와 잘못된 연결
- crossing lane 독립
- branch exit 유효성
- 필수 지점 진입 뒤 탈출 불가능한 permanent trap

검사하지 않음:

- 정확한 LIFO 해답
- 수동/자동 적재 타이밍
- 분기 조작 순서
- 제한 시간 성공 해답
- 최소 비용·최대 Combo 해답

PASS 뒤 map definition·layout·cost·graph를 sealed input으로 사용한다.

## 화물 스택

- 화물 지점당 1개
- 고정 배치, 적재 후 재생성 없음
- domain capacity 제한 없음
- 적재 시 stack TOP에 push
- 하역 시 TOP 연속 일치 그룹 pop
- 먼저 적재한 화물은 bottom, 마지막 적재 화물은 TOP
- 화물·역은 색상+형상+텍스트 중복 부호

무제한 스택은 월드 화차를 무한 길이로 펼친다는 뜻이 아니다. Presenter/View는 전체 순서, TOP과 다음 하역 그룹을 보존해야 하며 8/16/32개 가독성을 실기기에서 검증한다.

## 적재 상태

```text
manual_load = 기본
load_held = 접촉 순간 적재
manual_release = 적재하지 않음
auto_load = 활성 중 모든 접촉 화물 적재
```

- 운행 중 manual/auto 전환 가능
- 화물 접촉 시점에만 적재 판정
- 적재로 정차·감속 없음
- 적재하지 않은 화물은 authored 위치에 남음
- pause 중 운행 조작 금지

## 하역·Combo

```text
unload_count = TOP부터 station type과 연속 일치하는 수
combo_count = unload_count
```

- `unload_count == 0`: 정차 없이 통과
- `unload_count >= 1`: domain delivery commit과 가시 하역
- 총 가시 하역 시간 최대 1초
- 모든 domain commit이 presentation보다 먼저 확정
- 2개 이상 그룹의 가속·점수 보상은 후속 tuning 범위

첫 Slice는 `A → B → A → A` 적재와 `2 → 1 → 1` 하역, A역 재방문을 자동 증명한다.

## 운행 시간·판정

- BUILD 단계 clock 0
- 운행 시작과 동시에 finite run clock 시작
- pause 중 clock·열차 이동·화물 상태·하역 표시 동결
- 마지막 배송 commit이 제한 시간 이내면 success
- 제한 시간 도달 시 미배송 화물이 있으면 failure
- success/failure 뒤 domain mutation 금지
- presentation completion과 domain commit time을 분리

## 실패·재시도

- 실패 뒤 sealed TrackLayout 값 보존
- 같은 map·layout identity 유지
- 새 attempt serial과 identity 발급
- graph·train·cargo·input·delivery·controller 전부 새 mutable object graph
- 분기·화물·시간·pause·result 상태 초기화
- 전체 노선 초기화와 same-layout retry를 별도 명령으로 구분

## 제품 화면 권위

표시 상태:

- BUILD
- RUNNING
- UNLOADING
- PAUSED
- SUCCESS
- FAILURE

UI는 비용·preflight 문제·시간·stack·TOP·입력 상태·결과를 읽기 전용으로 표시한다. View와 animation은 layout, delivery, timer, score, result, retry identity 또는 save의 권위가 아니다.

## 목표·기록·캠페인 후속

승인된 미래 제품 방향:

- 신속·절약·점수 별
- 속도·가격·점수 기록
- tutorial 1~10과 11+ chapter
- fixed-seed daily/weekly challenge
- cosmetic-only rewards

첫 Slice와 Android Device Smoke의 필수 구현 범위는 아니다. 실제 구현 전까지 `NOT_STARTED` 또는 `NOT_RUN`으로 유지한다.

## 구형 시스템 상태

| 시스템 | 상태 |
|---|---|
| 완성형 generated connected rail | `[대체됨]` |
| capacity-eight domain limit | `[대체됨]` |
| pickup respawn | `[폐기]` |
| cargo-count slowdown | `[폐기]` |
| resource drain/recovery zero-ending loop | `[폐기]` |
| player acceleration hold input | `[폐기]` |
| timed endless pressure | `[폐기]` |
| switch auto-reset | `[대체됨]` |
| old tests/PR evidence | `[역사 증거]` |
| UGC/backend | `[보류]` |

구형 구현은 당시 동작·migration 참고로 보존하지만 current product 또는 next-work authority가 아니다.

## 역사적 구현·자동 증거 스냅샷

아래 값은 유한 코어·제품 표면·통합 증명·validation preparation·APK export가 당시 자동화/패키징 기준에서 통과했다는 **역사 증거**다. 현재 실행 순서나 physical/device/human PASS를 정의하지 않는다.

```text
FINITE AUTOMATED CORE: PASS
PRODUCT SURFACE: PASS
INTEGRATED PROOF: PASS
VALIDATION PREPARATION: PASS
CANONICAL MAIN APK EXPORT: PASS
```

Canonical validation APK 역사 증거:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

## 다음 검증 Gate

현재 실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 책임진다. 이 heading은 Android canonical-freshness consumer가 사용하는 안정 compatibility anchor로 유지한다.

```text
CURRENT EXECUTION AUTHORITY: CURRENT_CONFIRMED_DECISIONS + ACTIVE_CONTEXT
SX-DEC-055 RUNTIME POC: MERGED_MAIN_VERIFIED
SX-DEC-059 RELEASE-NEAR FIRST SESSION: USER_REQUESTED_CODEX_HANDOFF · IMPLEMENTATION_IN_PROGRESS
WINDOWS PHYSICAL RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
CONNECTED PHYSICAL EDITOR: NOT_RUN
BROADER HUMAN / COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

Android Device Smoke와 Five-person Comprehension은 여전히 유효한 후속 검증 Gate지만, 자동화/APK 역사 증거만으로 즉시 현재 작업으로 승격하거나 PASS로 확대하지 않는다. 프로젝트의 실제 다음 실행 지점은 current authority locator에서 다시 판정한다.
