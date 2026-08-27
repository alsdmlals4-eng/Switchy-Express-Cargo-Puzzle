# Core Gameplay

상태: `CURRENT_CANON · GMB-002 · AMENDED_BY_SX_DEC_060 · MERGED_MAIN_VERIFIED · PR_188`

세부 제품 정본은 `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`다. 이 문서는 플레이어가 실제로 이해해야 하는 **현재 gameplay mental model**을 압축한다.

## 플레이어 약속

> 필요한 선로망을 건설해 화물을 원하는 순서로 만나고, 마지막에 실은 화물부터 내리는 LIFO를 역산한 뒤, 운행 중 분기와 역 인접 배송으로 계획을 실행한다.

## 뾰족한 재미

```text
선로가 화물 조우 순서를 만든다
+ LIFO가 하역 순서를 강제한다
+ 분기가 운행 중 실행 판단을 만든다
+ 역의 상·하·좌·우 서비스 범위가 노선 기하를 배송 계획으로 바꾼다
+ 결과가 다음 재설계 가설을 만든다
```

모든 선로 조각을 하나의 전역 connected network로 만드는 것은 목표가 아니다. **start-reachable RUN network가 필요한 화물 조우와 station service를 만족하는지**가 중요하다.

## 핵심 루프

```text
맵·화물·역 읽기
→ 필요한 RUN 선로망과 비용 비교
→ Preflight: start-reachable required coverage 확인
→ 운행 시작
→ 수동 적재 또는 자동 적재 전환
→ 분기 사전 전환
→ 화물 셀 직접 통과로 LIFO 적재
→ 역의 상·하·좌·우 인접 셀을 지나 TOP 연속 동일 화물 하역
→ 성공/실패 결과 확인
→ Retry Same Layout 또는 Edit Layout
```

## SX-DEC-060 · Station Service

공식 판정:

```text
distance = abs(train_x - station_x) + abs(train_y - station_y)
DELIVER_SERVICEABLE iff distance == 1
```

- 상·하·좌·우 정확히 1칸만 station service cell이다.
- 대각선은 service가 아니다.
- station footprint 자체도 service가 아니다.
- 거리 2칸 이상도 service가 아니다.
- Cargo는 기존처럼 cargo cell을 직접 통과할 때만 적재 판정을 한다.
- matching station에서만 현재 contiguous same-type TOP group이 내려간다.
- TOP 종류가 다르면 하역하지 않는다.

기술 구현은 station을 **off-track/non-buildable service object**로 두는 `FiniteMapDefinition schema v3`로 완료됐다. headless automated regression은 통과했고, PR merge 및 물리·사람 검증은 아직 별도다.

## 건설 단계

- 운행 시간 정지
- 건설 불가 구역 외 자유 설치
- station footprint는 post-060 schema v3에서 non-buildable/off-track
- 선로 조각별 비용
- 철거 전액 환급
- 반투명 추천 설계도와 예상 비용
- 추천은 안전한 기본 해법이지 별·랭킹 정답이 아님
- 사용하지 않는 disconnected rail island는 그 자체로 RUN 차단 사유가 아님

### Preflight가 확인하는 것

```text
start/incoming에서 실제 RUN 가능한 reachable states 계산
→ 모든 필수 cargo cell reachable
→ 모든 필수 station마다 상·하·좌·우 service cell 중 최소 1개 reachable
→ reachable switch/crossing/route state 유효
→ applicable reachable trap/route-end contract 유효
```

start에서 완전히 도달할 수 없고 required cargo/station service에 쓰이지 않는 disconnected rail island는 허용한다. 반대로 실제 RUN component가 required cargo나 station service를 충족하지 못하면 출발을 막는다.

Preflight가 풀어주지 않는 것:

- 정확한 LIFO 해답
- 수동/자동 적재 타이밍
- 분기 조작 순서
- 제한 시간 성공 해답
- 최소 비용 또는 별도 승인 없는 성과 지표 해답

## 운행 조작

| 입력 | 행동 |
|---|---|
| 적재 홀드 | 누르고 있는 동안 통과한 cargo 직접 접촉 시 적재 |
| 자동 적재 토글 | 활성 중 통과한 모든 cargo 직접 접촉 시 적재 |
| 분기 탭 | 선택 방향 변경, 다시 조작할 때까지 유지 |
| 일시정지 | 시간 정지·상태 확인, 운행 조작 금지 |

플레이어 직접 가속·감속과 운행 중 선로 편집은 없다.

## 적재·LIFO

- 화물 지점당 1개
- cargo cell 직접 통과 시에만 적재 판정
- 적재 정차 없음
- 화물칸 domain 수량 제한 없음
- 먼저 적재한 화물은 bottom, 마지막 적재 화물은 `TOP`
- station service cell 통과 시 TOP부터 station 종류와 연속 일치하는 동안만 자동 하역
- TOP 종류가 다르면 정차·하역 없이 통과

```text
조우 A → B → A → A
스택 [A][B][A][A TOP]
A역 service: A 2개
B역 service: B 1개
A역 service 재방문: A 1개
```

## 성공·실패·재도전

- RUN 시작부터 제한 시간 진행
- 마지막 필수 화물 delivery commit 완료 즉시 성공
- 제한 시간 종료 시 미배송 화물 1개 이상이면 실패
- current route-end contract에 따른 실패 유지
- 복귀·종착지 조건 없음
- 실패 후 sealed TrackLayout 유지
- train/cargo/time/switch mutable state는 fresh attempt로 초기화
- `Retry Same Layout`과 `Edit Layout`을 구분

## First Session

```text
T1 Track Connection
→ T2 Cargo direct contact + Station cardinal-adjacent service
→ T3 LIFO/TOP reverse planning
→ T4 selective non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ VS_DEMO_01 capstone
```

T2에서 반드시 구분한다.

```text
Cargo = 그 셀을 직접 통과해 적재
Station = 상·하·좌·우 1칸을 통과해 배송
Diagonal = 배송 안 됨
```

## 핵심 재미 Guardrails

- station footprint 위에 rail을 깔아야만 배송되는 의미가 남으면 실패
- 대각선에서도 배송되면 실패
- 모든 player rail을 전역 연결해야만 RUN 가능한 구조로 되돌아가면 실패
- irrelevant disconnected island의 dangling 구조가 active RUN을 무조건 막으면 실패
- required cargo/station service가 unreachable인데 RUN이 시작되면 실패
- 추천 설계도가 자동 정답·필수 경로·추가 성과 보상처럼 보이면 실패
- 수동 적재가 짧은 반응속도 판정으로 느껴지면 실패
- 무제한 화물 때문에 TOP과 다음 연속 그룹을 읽지 못하면 실패
- 분기 조작보다 pause 반복이 실제 실행을 완전히 대체하면 실패

## Visual / Asset Guardrail

Station PNG는 이미 `ProductBoardRenderer`의 실제 consumer가 있다. SX-DEC-060 service range는 기존 station PNG + procedural indicator를 먼저 사용한다.

```yaml
new_bitmap_assets_required: 0
explanation_sheet_without_runtime_consumer: OUT_OF_SCOPE
```

## 구형 루프 상태

- endless survival: `[대체됨]`
- fuel·fuel-zero: `[폐기]`
- BOOST 홀드: `[폐기]`
- 화물 적재량 감속: `[폐기]`
- pickup respawn: `[폐기]`
- switch auto-reset: `[대체됨]`
- pre-SX-DEC-060 exact-station delivery: `[대체됨]`
- global-all-rail-connected interpretation: `[대체됨]`
- 기존 구현·테스트·Candidate 003: `[역사 증거 · post-060 acceptance 아님]`
