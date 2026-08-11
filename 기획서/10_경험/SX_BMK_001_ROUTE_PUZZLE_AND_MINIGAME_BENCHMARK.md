# SX-BMK-001 · Route Puzzle / Railway Mini-game Benchmark

상태: `PROPOSED · PLANNING_EVIDENCE_ONLY · NO_NEW_PRODUCT_DECISION`

작성일: `2026-08-11 KST`

현재 제품 권위는 그대로 유지한다.

- Product baseline: `GMB-002`
- Current decisions: `SX-DEC-027~055`
- Phase B: `SX-AUD-047 · PASS`
- Build authority: `AUTHORIZED`
- `SX-DEC-055` runtime implementation: `NOT_STARTED`

이 문서는 사용자 요청에 따라 Phase C 구현을 잠시 진행하지 않는 동안, 노선·철도·경로·물류 퍼즐과 짧은 미니게임을 벤치마킹해 **어떤 설계를 강화하고 어떤 설계를 의도적으로 거절할지** 정리하는 제안 문서다. 아래 `BMK-Rxx`는 Decision ID가 아니며 승인 전에는 제품 정본을 변경하지 않는다.

---

## 1. 현재 Switchy Express가 이미 가진 차별점

현재 정본의 핵심은 다음이다.

```text
선로 건설로 화물 조우 순서를 설계한다
→ 적재 선택으로 LIFO 스택을 만든다
→ 분기 전환으로 방문 순서를 실행한다
→ TOP의 연속 동일 화물을 하역해 Combo를 만든다
→ 시간·비용·점수에서 서로 다른 최적해를 찾는다
```

벤치마크 게임 다수는 `경로 그리기`, `교통량`, `신호 조작`, `한정 공간`, `객차 순서` 중 하나를 중심 제약으로 사용한다. Switchy Express는 **공간 경로가 데이터 구조(LIFO)의 순서를 직접 만든다**는 두 번째 퍼즐층이 있다는 점이 가장 강한 차별점이다.

내부 설계 모델은 다음처럼 두는 것을 권장한다.

```text
BUILD = 프로그램 작성
Cargo encounter order = 입력 순서
LIFO stack = 메모리 상태
Switch = 실행 중 branch
RUN = 프로그램 실행
RESULT / EDIT = 디버깅
```

플레이어에게 이 기술 용어를 그대로 보여줄 필요는 없지만, 시스템 추가 여부를 판단하는 내부 기준으로 유용하다.

---

## 2. Benchmark set

검색·대조일: `2026-08-11`

| Benchmark | 관찰한 핵심 | Switchy Express에 유효한 교훈 | 그대로 복제하면 안 되는 부분 |
|---|---|---|---|
| Mini Metro | 역 사이 노선을 그려 성장하는 수요를 처리, 제한 자원, 재설계, 매우 압축된 노선도 표현, 여러 모드 | 복잡한 상태를 작은 기호·선·색/형태로 압축하고 현재 문제를 즉시 읽게 한다 | endless failure loop와 랜덤 성장 수요는 현재 finite authored puzzle과 충돌 |
| Mini Motorways | 도로 재설계, 제한 upgrade, Creative/Endless/Expert, Daily/Weekly Challenge | 같은 기본 조작을 유지하면서 challenge cadence와 map personality를 만든다 | permanent road/limited upgrade를 main campaign 기본 규칙으로 가져오면 free-build/refund contract와 충돌 |
| Railbound | 240+ 수제 퍼즐, main path는 완만하고 분기된 optional puzzle은 더 어려움, tunnel/barrier/switch를 점진 도입 | `접근 가능한 본선 + 선택형 고난도 지선` 구조, 한 번에 한 규칙을 익히고 조합하는 레벨 설계 | 충돌 방지/다중 객차 자체를 핵심으로 가져오면 LIFO 화물 정체성이 흐려짐 |
| Cosmic Express | 작은 authored map, 한 번에 한 승객, 목적지 순서가 경로 정답을 만든다 | 작은 공간에서도 `방문 순서` 하나로 깊은 퍼즐을 만들 수 있음. 짧은 Yard puzzle에 적합 | capacity=1을 가져오면 unlimited LIFO라는 현재 차별점이 사라짐 |
| Spooky Express | 200+ 수제 퍼즐, 한 번에 한 승객, track self-cross 금지, 각 승객 목적지, diorama 단위의 명확한 테마 | 각 스테이지의 제약을 눈에 보이는 한 문장으로 설명하고, 테마는 규칙보다 topology를 바꾸는 데 사용 | self-cross 금지/capacity=1을 global rule로 가져오지 않음 |
| Train Valley 2 | level 기반 철도망 건설, 교통/효율/비용, 50-level company mode, editor/Workshop | authored progression + 효율 최적화 + 향후 UGC 가능성 | tycoon economy, 다중 열차 교통 관리, locomotive progression은 현재 scope를 크게 흐림 |
| Conduct THIS!/Together | 매우 단순한 start/stop/switch 입력, 충돌 회피, 시간 압박, 짧은 action puzzle | 분기 상태를 아주 명확하게 보여주고 짧은 execution drill을 만드는 방법 | main game을 반응속도/충돌 action game으로 바꾸지 않음; pause와 planning-first 철학 유지 |
| Rail Route | build + dispatch + sensors/router automation, Timetable/Rush Hour/Endless, editor/Workshop | 미래 editor와 고난도 dispatch mode의 참고, 초반은 단순하고 mastery에서 깊어지는 계층 | 신호/계약/자동화 tech tree는 casual finite cargo puzzle에 과도함 |
| Railway Dispatcher | signal/route/timetable, overtaking/turnback, scoring, station editor | `현재 route / 다음 충돌 위험 / timing`의 시각적 명료성 참고 | 실제 철도 interlocking simulation은 의도적으로 제외 |
| Please Fix The Road | 레벨마다 제한된 도구 집합, 삽입/삭제/회전/교환 등으로 A→B를 해결하는 짧은 퍼즐 | 짧은 micro-puzzle에서 `이번 문제에 필요한 조작만 남기는 것`이 강력함 | 제한 tool inventory를 main build에 적용하면 현재 cost/refund 기반 자유 건설과 충돌 |

### Source pointers

- Mini Metro — Steam store, `About This Game`
- Mini Motorways — Steam store, `About This Game`
- Railbound — Steam store, `About This Game`
- Cosmic Express — Steam store, `About This Game`
- Spooky Express — Steam store, `About This Game`
- Train Valley 2 — Steam store, `About This Game`
- Rail Route — Steam store, `About This Game`
- Railway Dispatcher — Steam store, `About This Game`
- Conduct franchise — Northplay official site / Conduct THIS official site
- Please Fix The Road — Steam store, `About This Game`

이 문서는 store/official descriptions가 직접 지지하는 기능만 benchmark fact로 사용하고, 그 아래의 Switchy Express 적용안은 별도의 설계 추론으로 분리한다.

---

## 3. Benchmark synthesis

### 3.1 Main game은 finite authored puzzle을 유지한다

`Mini Metro/Motorways`의 endless/network-survival 구조는 매력적이지만 현재 `GMB-002`의 finite delivery pivot을 되돌릴 이유가 없다. 오히려 `Railbound / Cosmic Express / Spooky Express`처럼 **작고 의도적으로 설계된 문제에서 하나의 규칙을 깊게 쓰는 방식**이 현재 제품과 더 잘 맞는다.

권장:

- main campaign = authored finite maps
- difficulty = 규칙 추가보다 기존 규칙 조합 증가
- random/procedural = Daily/Weekly 같은 별도 반복 콘텐츠에 한정
- endless survival = 계속 non-current

### 3.2 쉬운 본선 + 어려운 선택 지선이 현재 챕터 구조에 잘 맞는다

현재 승인된 `3개 중 2개 clear → 다음 묶음` 구조를 유지하면서, 각 챕터에 progression을 막지 않는 **optional Mastery Spur**를 한 개 붙이는 것이 좋다.

```text
Chapter Core A ─┐
Chapter Core B ─┼→ 2 clear → next chapter
Chapter Core C ─┘
        └→ optional Mastery Spur
```

Mastery Spur는 새 규칙을 소개하지 않는다. 해당 챕터에서 배운 규칙을 더 촘촘하게 조합한다.

### 3.3 메인 난이도는 3축으로 분해한다

한 스테이지에서 세 축을 동시에 올리지 않는다.

1. **Topology Complexity** — blocked cell, loop, crossing, branch, revisit, late bridge/tunnel
2. **Stack Entropy** — cargo type alternation, TOP block 가능성, 같은 색 group 설계 난이도
3. **Execution Branching** — switch 수, switch timing window, 방문 순서 선택 수

Core stage는 한 축을 주로 올리고, chapter exam/mastery stage만 두세 축을 결합한다.

### 3.4 Planning-first를 보호한다

Conduct 계열의 `tap fast / collision avoid` 재미는 참고하되 main product에 가져오지 않는다.

- train start/stop 직접 제어 추가 안 함
- collision game 추가 안 함
- no-pause를 main rule로 추가 안 함
- switch는 실행 판단이지만 짧은 반응속도 시험으로 설계하지 않음
- 실패 원인은 `계획/예측 오류`가 주가 되어야 함

---

## 4. Proposed design recommendations

## BMK-R01 · Core positioning language

상태: `PROPOSED · HIGH_PRIORITY`

내부 제품 문장을 다음처럼 압축한다.

> **노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.**

마케팅 문구 확정이 아니라 feature triage용 design thesis다.

새 기능이 다음 질문에 `YES`가 아니면 우선순위를 낮춘다.

1. 노선이 화물 조우 순서를 더 의미 있게 만드는가?
2. LIFO/TOP을 더 잘 계획하게 만드는가?
3. 분기를 계획의 실행으로 느끼게 만드는가?
4. 실패 후 더 나은 노선으로 재설계하게 만드는가?

---

## BMK-R02 · BUILD Route Probe / Encounter Strip

상태: `PROPOSED · HIGH_PRIORITY`

### 문제

현재 핵심 재미는 `노선 → 조우순서 → LIFO`인데, 초보자는 선로를 공간 연결로만 보고 **화물 순서를 만드는 도구**라고 이해하지 못할 수 있다.

### 제안

BUILD에서 요청형 `Route Probe`를 제공한다.

- 플레이어가 만든 현재 선로와 현재 switch 선택을 따라 `start → cycle/terminal`까지 한 경로를 추적
- 그 경로에서 만나는 `cargo / station / switch` 아이콘을 순서대로 작은 strip에 표시
- cycle이면 `LOOP` marker
- 막힘이면 `DEAD END` marker
- 사용자가 branch를 바꾸면 즉시 다시 계산

### 절대 보여주지 않는 것

- 최적 노선
- 정답 switch sequence
- 최종 unload order 정답
- 별 3개 route
- 어떤 cargo를 skip해야 하는지

즉 **플레이어가 만든 계획의 결과를 읽게 할 뿐, 답을 만들지는 않는다.**

### 기존 contract와의 관계

기존 request-only hint 철학과 잘 맞고, safe ghost보다 더 직접적으로 core causality를 가르치지만 solution authority는 갖지 않는다.

---

## BMK-R03 · Prediction → Execution → Debrief loop

상태: `PROPOSED · HIGH_PRIORITY`

각 run을 세 단계의 학습 루프로 명확히 한다.

```text
BUILD
Route Probe로 내가 만든 조우 순서를 예상
        ↓
RUN
실제 Stack / TOP / load mode / switch state 관찰
        ↓
RESULT
Actual Encounter Trace로 무엇이 실제로 일어났는지 확인
        ↓
EDIT
같은 노선을 유지한 채 수정
```

`Actual Encounter Trace`는 해결책을 제시하지 않고 사건을 기록한다.

예:

```text
A pickup
→ B pickup
→ A station PASS (TOP=B)
→ switch East
→ B station unload 1
→ A station unload 1
```

실패 문구는 `잘못된 노선입니다`가 아니라 **원인 상태**를 보여준다.

- `TIMEOUT · 2 cargo remain`
- `A station passed · TOP was B`
- `cargo C never encountered`

이 제안은 향후 Five-person comprehension에서 원인-결과 학습을 직접 측정할 수 있다.

---

## BMK-R04 · Yard Labs — 기존 시스템만 쓰는 짧은 미니게임

상태: `PROPOSED · HIGH_PRIORITY`

별도 arcade game을 만드는 대신 main mechanics를 한 요소씩 격리한 **30~90초 TEST_VALUE** 연습 퍼즐을 둔다.

### A. Stack Lab

목표: LIFO/TOP만 익힌다.

- 선로는 이미 배치됨
- switch 거의 없음
- cargo/station 수 소형
- manual/auto load를 써서 요구되는 delivery order를 만든다
- 시간 압박 최소

배우는 것:

`먼저 만난 것 ≠ 먼저 내리는 것`

### B. Switch Lab

목표: 실행 중 route branch를 익힌다.

- 선로는 이미 배치됨
- auto-load 기본
- 1~3 switch
- 적재 순서와 station 순서를 보고 branch를 실행
- train start/stop 조작은 추가하지 않음

배우는 것:

`switch는 반사신경 버튼이 아니라 계획한 방문 순서를 실행하는 장치`

### C. Builder Lab

목표: BUILD topology/cost를 익힌다.

- cargo/station 요구는 단순
- 한두 개 geometry/attribute만 허용
- 안전 route와 더 좋은 route가 둘 다 존재
- run은 짧고 결과 확인 위주

배우는 것:

`연결만 되면 끝이 아니라 조우 순서와 비용이 다르다`

### Lab guardrails

- main campaign clear를 요구하지 않음
- 독점 능력/업그레이드 보상 없음
- 새 gameplay rule 없음
- leaderboard 없음(초기)
- completion badge/stamp는 cosmetic-only 후보
- lab을 잘해도 core stage를 자동 해결하지 않음

---

## BMK-R05 · Optional Mastery Spur

상태: `PROPOSED · MEDIUM_HIGH_PRIORITY`

Railbound의 `relaxed main path + harder fork` 구조를 현재 chapter bundle에 적용한다.

- chapter마다 최대 1개
- progression requirement 아님
- 새 rule 없음
- 기존 rules의 더 높은 결합 난이도
- 처음에는 hint level 1만 사용 가능, 필요하면 기존 request-only hint contract를 그대로 적용
- 보상은 cosmetic stamp / completion mark 정도만 후보

목적:

- casual player를 막지 않고 expert puzzle depth 제공
- main 3-map chapter를 과도하게 어렵게 만들 필요 감소
- 이후 user-generated puzzle 난이도 기준의 reference set으로 사용 가능

---

## BMK-R06 · Tutorial 1~10 상세 커리큘럼

상태: `PROPOSED · HIGH_PRIORITY`

현재 `SX-DEC-034`의 1~10 tutorial 틀을 실제 학습 순서로 채우는 제안이다.

| Stage | 주 학습 | 새로 강조하는 것 | 의도적으로 안 넣는 것 |
|---|---|---|---|
| 1 첫 배송 | BUILD→RUN→Delivery | start, basic rail, one cargo, one station | LIFO 혼합/분기 |
| 2 역순 | LIFO/TOP | A→B 적재가 B→A 하역 요구를 만듦, Retry/Edit | Combo/복수 분기 |
| 3 묶음 배송 | contiguous unload + Combo | 같은 cargo를 묶을 이유 | 비용 최적화 |
| 4 골라 싣기 | manual vs auto load | skip/revisit, load-mode 상태 | 복수 switch |
| 5 첫 분기 | switch selected/locked | 사전 선택→실행 결과 | 비용/attribute |
| 6 다시 방문 | branch + station revisit | stack과 방문 순서 결합 | 새로운 geometry |
| 7 설계비 | cost/refund/safe ghost | 안전 route와 더 좋은 route 구분 | speed track |
| 8 선로 성격 | normal/fast/cheap | 속도 vs 비용 tradeoff | one-way/turnaround |
| 9 교차와 분기 | crossing vs switch + preflight | topology 읽기, dead-end/reachability | 새 scoring rule |
| 10 종합 시험 | learned rules combination | time/cost/score 세 최적축 맛보기 | 새 rule 없음 |

권장 Lab unlock:

- Stage 3 후 Stack Lab
- Stage 5 후 Switch Lab
- Stage 7 후 Builder Lab

튜토리얼은 설명을 늘리는 대신 **문제 자체가 한 규칙을 강제로 보여주게** 설계한다.

---

## BMK-R07 · Result screen = 세 개의 개인 최적해 + Route Fingerprint

상태: `PROPOSED · HIGH_PRIORITY`

현재 Speed / Economy / Score stars가 서로 다른 해를 요구한다는 강점을 결과 화면에서도 유지한다.

한 개의 종합 등급보다 다음을 우선한다.

```text
Fastest PB
Cheapest PB
Highest Score PB
```

이번 run이 어떤 PB를 갱신했는지 별도로 표시한다.

### Route Fingerprint 후보

- track cost
- travel time
- score
- total rail tiles
- switch count / switch changes
- station revisits
- max stack depth
- cargo type transitions in stack
- max combo
- pause count

### 중요한 원칙

- 개발자 정답과 직접 비교하지 않음
- 단일 global efficiency score로 합치지 않음
- 플레이어가 `내 가장 빠른 노선`, `내 가장 싼 노선`, `내 가장 높은 점수 노선`을 각각 기억할 수 있게 함

이는 현재 3-star 누적 설계가 실제로 여러 노선을 재설계하게 만드는 장치다.

---

## BMK-R08 · Daily / Weekly 상세 방향

상태: `PROPOSED_REFINEMENT_OF_APPROVED_SX_DEC_035`

Mini Motorways의 Daily/Weekly 반복 구조는 이미 승인된 `SX-DEC-035` 방향을 지지한다.

초기 권장:

- Daily = 짧은 fixed-seed authored-quality map
- Weekly = 더 큰 fixed-seed map 또는 2~3개의 동일 테마 set 후보
- 기간 중 모든 플레이어는 동일 seed/ruleset
- unlimited retry 유지
- 초기 launch는 **variant rule 없이 base rules만** 사용
- challenge-exclusive gameplay power 없음
- 종료 후 archive practice 유지

새 modifier는 core human validation 이후 별도 승인한다.

---

## BMK-R09 · Shareable Route Card

상태: `PROPOSED · FUTURE_LOW_RISK`

Mini 계열에서 자신이 만든 네트워크 자체가 결과물이 되는 점을 참고한다.

온라인 backend 없이도 결과 화면에서 다음을 한 장으로 저장할 수 있다.

- map thumbnail
- player route
- Speed / Cost / Score
- max combo
- seed/map id
- optional route fingerprint

첫 구현 우선순위는 낮지만, **노선을 만든 자부심**을 외부로 보이게 하는 저위험 retention/social layer다.

---

## BMK-R10 · Editor / Workshop은 미래 확장으로만 유지

상태: `PROPOSED · POST_VALIDATION_ROADMAP`

Railbound, Train Valley 2, Rail Route, Railway Dispatcher가 editor/Workshop을 장기 콘텐츠 확장으로 사용한다는 점은 중요하다.

현재 `MapDefinition`과 player `TrackLayout` 분리가 이미 editor-friendly 방향이다. 하지만 지금 editor UI를 만들면 scope가 너무 커진다.

권장 순서:

```text
finite core human validation
→ authored campaign content pipeline 안정화
→ map schema/editor-readiness audit
→ internal editor
→ only then UGC/share/workshop 검토
```

지금 필요한 것은 editor가 아니라 **authored map data가 future editor를 막는 하드코딩을 하지 않는 것**이다.

---

## 5. Explicit rejects / do-not-import list

아래는 benchmark에서 재미있더라도 현재 제품에 그대로 가져오지 않는다.

### REJECT-MAIN-01 · Endless survival demand growth

Mini Metro/Motorways의 핵심이지만 `GMB-002 finite authored delivery puzzle`을 다시 흐린다.

### REJECT-MAIN-02 · Multi-train collision action

Conduct/Railbound의 일부 긴장을 가져오면 main loop가 planning → reflex로 이동한다.

### REJECT-MAIN-03 · Real signaling/interlocking/contract automation

Rail Route/Railway Dispatcher 수준의 rail-sim complexity는 현재 casual puzzle positioning에 과도하다.

### REJECT-MAIN-04 · Cargo capacity 1 / small hard capacity

Cosmic/Spooky의 강한 제약이지만 현재 unlimited LIFO를 제거해 가장 독특한 부분을 훼손한다.

### REJECT-MAIN-05 · Main-mode limited track inventory / irreversible placement

Please Fix The Road / Mini Motorways Expert에서 유효하지만 현재 free build + per-piece cost + full refund와 충돌한다.

### REJECT-MAIN-06 · Tycoon progression / locomotive stat economy

Train Valley 2의 방향은 재미있지만 현재 puzzle clarity보다 meta progression이 커진다.

### REJECT-NOW-07 · UGC editor before core validation

콘텐츠 양을 늘리기 전에 문제 품질 기준과 human comprehension을 먼저 고정한다.

---

## 6. Proposed chapter archetypes

이름은 작업명이며 미승인이다. 새 시스템이 아니라 이미 승인된 topology/system 조합을 콘텐츠 테마로 사용하는 예다.

| Chapter archetype | 주 난이도 축 | 중심 조합 |
|---|---|---|
| Junction Park | Execution Branching | switch / crossing / revisit |
| Cargo Yard | Stack Entropy | alternating cargo / manual load / contiguous groups |
| Budget Hills | Topology + Economy | blocked zones / cheap vs normal / route length |
| Express District | Speed optimization | fast segments / path length / Combo acceleration |
| Loop Works | Stack + revisit | loop / repeated station visit / branch planning |
| Grand Terminal | Combined exam | topology + stack + switch, no new rule |

bridge/tunnel/one-way/turnaround은 기존 current decision의 late-map 후보 범위 안에서만 별도 콘텐츠 승인 후 사용한다.

---

## 7. Proposed usability / comprehension experiments

숫자는 제품 정본이 아니라 `TEST_VALUE`다.

### EXP-BMK-01 · Route causality

질문:

> 플레이어가 선로를 단순 연결이 아니라 cargo encounter order를 설계하는 도구로 이해하는가?

비교:

- A: current BUILD only
- B: request-only Route Probe + Encounter Strip

관찰:

- 첫 run 전 다음 3~4 cargo encounter 예측
- 첫 실패 후 어느 rail segment를 수정하는지
- hint 없이 route→stack 관계를 말로 설명 가능한지

### EXP-BMK-02 · Yard Lab transfer

질문:

> 격리 연습이 실제 campaign 문제로 전이되는가?

관찰:

- Lab 직후 다음 core stage에서 같은 rule을 무설명으로 적용
- 설명을 외워 말하는 것보다 실제 route/load/switch 선택을 우선 기록

### EXP-BMK-03 · Mastery Spur separation

질문:

> core campaign 난이도를 억지로 올리지 않고 expert depth를 제공하는가?

관찰:

- optional spur 진입률
- 포기 후 core progression 복귀율
- hint 사용량
- core stage와 spur의 solve attempts 차이

### EXP-BMK-04 · Multiple-solution motivation

질문:

> Speed / Cost / Score PB를 분리하면 같은 맵을 다른 노선으로 다시 설계하는가?

관찰:

- clear 후 즉시 Edit 선택률
- 두 번째 성공에서 route topology가 바뀌는 비율
- 한 map에서 획득한 서로 다른 PB route 수

---

## 8. Priority recommendation

### P0 — 기획 확정 후보

1. `BMK-R01` core positioning / feature triage language
2. `BMK-R02` request-only Route Probe / Encounter Strip
3. `BMK-R03` Prediction → Execution → Debrief loop
4. `BMK-R04` Stack / Switch / Builder Yard Labs
5. `BMK-R06` Tutorial 1~10 curriculum
6. `BMK-R07` three PBs + Route Fingerprint result model

### P1 — 콘텐츠 구조 확정 후보

7. `BMK-R05` optional Mastery Spur
8. chapter archetype set
9. `BMK-R08` Daily/Weekly launch refinement

### P2 — post-validation roadmap

10. `BMK-R09` shareable Route Card
11. `BMK-R10` editor/UGC readiness

---

## 9. Recommended product shape after benchmark

아직 미승인 제안이지만 가장 일관된 구조는 다음이다.

```text
CAMPAIGN
  1~10 Tutorial
    + Stack Lab
    + Switch Lab
    + Builder Lab

  11+ Chapters
    Core A / B / C
    clear any 2 → next chapter
    + optional Mastery Spur

REPEAT
  Daily fixed-seed
  Weekly fixed-seed
  Archive practice

RESULT LEARNING LOOP
  Build Route Probe
  → Run Stack/TOP/Switch presentation
  → Encounter Trace / cause
  → Edit
  → three independent PB routes

FUTURE
  Shareable Route Card
  Editor / UGC after core validation
```

이 구조는 main gameplay를 늘리지 않고 **기존 핵심의 학습·난이도·반복·표현 구조를 깊게 만드는 방향**이다.

---

## 10. Approval boundary

현재 이 문서의 모든 `BMK-Rxx`는 `PROPOSED`다.

사용자 승인 전:

- `SX-DEC-056+` 생성 금지
- current core gameplay 변경 금지
- implementation plan 변경 금지
- Phase C 코드 작업 금지
- current tutorial/challenge Decision을 이 제안으로 자동 덮어쓰기 금지

사용자가 특정 recommendation을 승인하면 해당 범위만 Decision ID로 승격하고 GitHub current authority와 configured Google Sheet에 같은 ID로 동기화한다.
