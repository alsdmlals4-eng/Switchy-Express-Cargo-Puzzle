# SX-BMK-001 · Route Puzzle / Railway Mini-game Benchmark

상태: `HISTORICAL_PLANNING_EVIDENCE · NO_CURRENT_PRODUCT_DECISION`

> 이 benchmark의 current-decision span, Tutorial 1~10, score/star/leaderboard, and implementation-status claims are historical to 2026-08-11. Current product/visual authority is GMB-002 amended by SX-DEC-060 and SX-DEC-061; this file may be consulted only as discovery evidence.

작성일: `2026-08-11 KST`

현재 제품 권위는 그대로 유지한다.

- Product baseline: `GMB-002`
- Current decisions: `SX-DEC-027~055`
- Phase B: `SX-AUD-047 · PASS`
- Build authority: `AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE`
- `SX-DEC-055` runtime implementation: `NOT_STARTED`
- Phase C execution: user temporarily deferred because Codex quota is unavailable

이 문서는 사용자 요청에 따라 Phase C 구현을 잠시 진행하지 않는 동안, 노선·철도·경로·물류 퍼즐과 짧은 미니게임을 벤치마킹해 **어떤 설계를 강화하고 어떤 설계를 의도적으로 거절할지** 정리하는 제안 문서다.

아래 `BMK-Rxx`는 Decision ID가 아니다. 사용자 승인 전에는 제품 정본, 현재 튜토리얼 순서, Daily/Weekly 생성 규칙, 구현 계획을 변경하지 않는다.

---

## 0. Canon alignment — 이 benchmark가 바꾸지 않는 것

벤치마크 전에 현재 승인된 제품 계약을 다시 대조했다.

### 현재 핵심 약속

```text
화물 배치·역 위치 읽기
→ 선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 분기 전환으로 역 방문 순서 실행
→ 같은 화물 연속 하역 Combo 만들기
→ 시간·건설비·점수 중 목표에 맞춰 재설계
```

### 현재 승인된 Tutorial 1~10 순서

`GMB-002 / SX-DEC-034`의 현재 순서를 기준으로 한다.

1. 기본 선로 연결
2. 화물과 대응 역·자동 하역
3. LIFO
4. 수동 적재
5. 자동 적재 전환
6. 분기 조작
7. Combo와 출발 가속
8. 가속·저비용 선로와 비용
9. 회차 중심 복합 노선
10. 건설·LIFO·분기·Combo·비용·시간 종합 시험

`BMK-R06`은 이 순서를 **교체하는 제안이 아니라 각 단계의 문제 설계·피드백·Lab 연결을 보강하는 제안**이다.

### 현재 승인된 Daily / Weekly

- campaign은 수작업 authored map
- Daily 1개 / Weekly 1개는 fixed-seed 절차 생성 map
- 같은 기간에는 모든 플레이어가 같은 map/ruleset
- unlimited retry
- 종료 후 archive practice

`BMK-R08`은 procedural/fixed-seed 계약을 유지한 채 생성 품질과 launch rule만 보강한다.

### 현재 유지되는 보호선

- unlimited cargo LIFO 유지
- 직접 가속/감속 없음
- RUN 중 선로 편집 없음
- pause 허용
- switch는 실행 판단이지만 반사신경 시험으로 만들지 않음
- free build + piece cost + full refund 유지
- endless/fuel/BOOST/capacity-8/respawn/switch auto-reset은 계속 non-current

---

## 1. Switchy Express가 이미 가진 차별점

벤치마크 게임 다수는 다음 중 하나를 중심 제약으로 사용한다.

- 경로 그리기
- 교통량/혼잡
- 신호/분기 조작
- 제한된 공간
- 승객/객차 순서
- 자원/비용 최적화

Switchy Express는 그 위에 **공간 경로가 데이터 구조인 LIFO 스택의 순서를 직접 만든다**는 두 번째 퍼즐층이 있다.

현재 차별점을 가장 짧게 표현하면 다음과 같다.

> **노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.**

내부 설계 모델은 다음처럼 볼 수 있다.

```text
BUILD = 계획 작성
Cargo encounter order = 입력 순서
LIFO stack = 누적 상태
Switch = 실행 중 branch
RUN = 계획 실행
RESULT / EDIT = 원인 확인과 재설계
```

플레이어에게 이 기술 용어를 그대로 노출할 필요는 없다. 새 기능이 핵심을 강화하는지 판단하는 내부 모델로 사용한다.

---

## 2. Benchmark set

검색·대조일: `2026-08-11`

| Benchmark | 관찰한 핵심 | Switchy Express에 유효한 교훈 | 그대로 가져오지 않을 것 |
|---|---|---|---|
| Mini Metro | 노선을 그리고 재설계하며 성장하는 수요를 처리, 제한 자원, 압축된 노선도 표현, 여러 모드 | 복잡한 네트워크 상태를 작은 기호·선·형태로 압축해 즉시 읽게 한다 | endless failure loop와 랜덤 수요를 main campaign으로 도입하지 않음 |
| Mini Motorways | 도로 재설계, 제한 upgrade, Creative/Endless/Expert, Daily/Weekly Challenge | 같은 기본 조작으로 반복 challenge와 map personality를 만든다 | permanent road/limited upgrade를 main 기본 규칙으로 가져오지 않음 |
| Railbound | 240+ handcrafted puzzles, 비교적 편한 main path와 더 어려운 optional fork, tunnel/barrier/switch 점진 도입 | 접근 가능한 본선 + 선택형 고난도 지선, 한 번에 한 규칙을 학습하고 조합 | 다중 객차 충돌 자체를 핵심으로 가져오지 않음 |
| Cosmic Express | 작은 authored map, 한 번에 한 승객, 목적지 순서가 경로 정답을 만듦 | 작은 공간에서도 방문 순서 하나로 깊은 퍼즐 가능 | capacity=1을 가져오지 않음 |
| Spooky Express | 200+ handcrafted puzzles, 한 번에 한 승객, self-cross 금지, 뚜렷한 diorama 테마 | 문제의 제약을 한눈에 읽게 하고 topology로 테마 차이를 만든다 | self-cross 금지/capacity=1을 global rule로 만들지 않음 |
| Train Valley 2 | level 기반 철도망 건설, 효율/비용, 50-level mode, editor/Workshop | authored progression + 효율 최적화 + 장기 UGC 가능성 | tycoon economy, 다중 열차 traffic, locomotive stat progression 제외 |
| Conduct THIS!/Together | 단순 start/stop/switch, 충돌 회피, 짧은 action puzzle | switch 상태·진행 방향을 즉시 읽게 만드는 execution clarity | main game을 반응속도/충돌 action game으로 변경하지 않음 |
| Rail Route | build + dispatch + sensors/router automation, 여러 mode, editor/Workshop | mastery가 깊어지는 계층과 future editor 참고 | signal/contract/automation tech tree 제외 |
| Railway Dispatcher | signal/route/timetable, overtaking/turnback, scoring, editor | 현재 route와 다음 위험/timing을 분명하게 보이는 법 참고 | 실제 interlocking simulation 제외 |
| Please Fix The Road | 레벨마다 제한된 tool set으로 A→B 연결, 삽입/삭제/회전/교환 등 micro puzzle | 짧은 연습 문제에서는 필요한 조작만 남기는 것이 강력함 | limited inventory/irreversible placement를 main BUILD에 도입하지 않음 |

### Source pointers

- Mini Metro — Steam official store / About This Game
- Mini Motorways — Steam official store / About This Game
- Railbound — Steam official store / About This Game
- Cosmic Express — Steam official store / About This Game
- Spooky Express — Steam official store / About This Game
- Train Valley 2 — Steam official store / About This Game
- Rail Route — Steam official store / About This Game
- Railway Dispatcher — Steam official store / About This Game
- Conduct franchise — Northplay official site / Conduct THIS official page
- Please Fix The Road — Steam official store / About This Game

Benchmark fact와 Switchy Express 적용 추론을 분리한다. 외부 게임의 기능이 존재한다는 사실만으로 우리 제품에 채택하지 않는다.

---

## 3. Benchmark synthesis

### 3.1 Main game은 finite authored puzzle을 유지한다

Mini Metro/Motorways의 endless/network-survival 구조는 강력하지만 현재 `GMB-002` finite delivery pivot을 되돌릴 이유가 없다.

현재 제품에는 Railbound/Cosmic Express/Spooky Express처럼 **의도적으로 설계된 작은 문제에서 기존 규칙을 깊게 쓰는 방식**이 더 잘 맞는다.

권장:

- main campaign = authored finite maps 유지
- difficulty = 새 시스템 증가보다 기존 규칙 조합 증가
- procedural = 승인된 Daily/Weekly lane에 한정
- endless survival = 계속 non-current

### 3.2 쉬운 본선 + 어려운 선택 지선

현재 승인된 `3개 중 2개 clear → 다음 묶음` 구조는 casual 접근성을 이미 확보한다.

여기에 progression을 막지 않는 optional `Mastery Spur`를 붙이는 방식을 제안한다.

```text
Chapter Core A ─┐
Chapter Core B ─┼→ 2 clear → next chapter
Chapter Core C ─┘
        └→ optional Mastery Spur
```

Mastery Spur는 새 규칙을 소개하지 않는다. 해당 챕터에서 배운 규칙을 더 촘촘하게 결합한다.

### 3.3 난이도는 3축으로 분해한다

한 스테이지에서 모든 축을 동시에 올리지 않는다.

1. **Topology Complexity**
   - blocked cell
   - loop
   - crossing
   - branch
   - revisit
   - late bridge/tunnel/turnaround

2. **Stack Entropy**
   - cargo type alternation
   - TOP block 가능성
   - 같은 종류 contiguous group 설계
   - stack depth
   - skip/revisit 필요성

3. **Execution Branching**
   - switch 수
   - switch 선택 순서
   - 방문 순서 후보 수
   - switch lock 순간

Core stage는 한 축이 주제가 되게 하고, chapter exam/Mastery Spur만 두세 축을 결합한다.

### 3.4 Planning-first를 보호한다

Conduct 계열에서 참고할 것은 조작 명료성이지 반사신경 구조가 아니다.

- train start/stop 직접 제어 추가 안 함
- collision avoidance main rule 추가 안 함
- no-pause main rule 추가 안 함
- switch timing은 충분히 읽을 수 있는 범위로 둠
- 실패 원인은 `계획/예측 오류`가 주가 되어야 함

---

## 4. Proposed design recommendations

## BMK-R01 · Core positioning / feature triage language

상태: `PROPOSED · HIGH_PRIORITY`

내부 feature triage 문장:

> **노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.**

새 기능이 아래 질문 중 대부분에 `YES`가 아니면 우선순위를 낮춘다.

1. 노선이 화물 조우 순서를 더 의미 있게 만드는가?
2. LIFO/TOP을 더 잘 계획하게 만드는가?
3. 분기를 계획의 실행으로 느끼게 만드는가?
4. 실패 후 더 나은 노선으로 재설계하게 만드는가?

---

## BMK-R02 · BUILD Route Probe / Encounter Strip

상태: `PROPOSED · HIGH_PRIORITY`

### 문제

핵심 재미는 `노선 → 조우 순서 → LIFO`인데 초보자는 선로를 공간 연결로만 보고, **화물 순서를 만드는 도구**라고 이해하지 못할 가능성이 있다.

### 제안

BUILD에서 요청형 `Route Probe`를 제공한다.

- 플레이어가 만든 현재 선로와 현재 switch 선택을 따라 `start → cycle/terminal`까지 한 경로를 추적
- 해당 경로에서 만나는 `cargo / station / switch` 아이콘을 순서대로 작은 strip에 표시
- cycle이면 `LOOP` marker
- 막힘이면 `DEAD END` marker
- branch를 바꾸면 즉시 다시 계산
- 요청하지 않으면 화면을 차지하지 않음

### 절대 보여주지 않는 것

- 최적 노선
- 정답 switch sequence
- 최종 unload order 정답
- 3-star route
- 어떤 cargo를 skip해야 하는지

즉 플레이어가 만든 계획의 **결과를 읽게 할 뿐 답을 만들지 않는다.**

### 기존 계약과의 관계

현재 request-only hint 철학, safe ghost 비정답 원칙과 양립 가능하다.

---

## BMK-R03 · Prediction → Execution → Debrief loop

상태: `PROPOSED · HIGH_PRIORITY`

각 run의 학습 구조를 다음처럼 명확하게 한다.

```text
BUILD
내가 만든 route/encounter를 예상
        ↓
RUN
실제 Stack / TOP / load mode / switch state 관찰
        ↓
RESULT
Actual Encounter Trace로 실제 사건과 원인 확인
        ↓
EDIT
같은 노선을 유지한 채 수정
```

`Actual Encounter Trace`는 해결책을 주지 않고 실제 사건만 기록한다.

예:

```text
A pickup
→ B pickup
→ A station PASS · TOP=B
→ switch East
→ B station unload 1
→ A station unload 1
```

실패 피드백도 정답 대신 원인 상태를 보여준다.

- `TIMEOUT · 2 cargo remain`
- `A station passed · TOP was B`
- `cargo C never encountered`

이 구조는 현재 baseline의 `남은 화물 / 막는 TOP / 문제 분기 / 비효율 구간` 피드백과 같은 방향이며, 더 체계적인 debrief 후보로 본다.

---

## BMK-R04 · Yard Labs — 기존 시스템만 쓰는 짧은 미니게임

상태: `PROPOSED · HIGH_PRIORITY`

별도 arcade game을 만드는 대신 main mechanics를 한 요소씩 격리한 **30~90초 TEST_VALUE** 연습 퍼즐을 제안한다.

### A. Stack Lab

목표: LIFO/TOP과 적재 선택을 격리한다.

- 선로는 대부분 prebuilt
- switch 거의 없음
- cargo/station 수 소형
- manual/auto load를 사용
- 시간 압박 최소

배우는 것:

`먼저 만난 화물 ≠ 먼저 내리는 화물`

현재 tutorial에서 manual/auto가 모두 소개된 Stage 5 이후 unlock 후보.

### B. Switch Lab

목표: 실행 중 branch 선택을 격리한다.

- 선로는 prebuilt
- auto-load 기본 후보
- 1~3 switch
- 적재/역 순서를 보고 branch를 실행
- train start/stop 조작은 추가하지 않음

배우는 것:

`switch는 반사신경 버튼이 아니라 계획한 방문 순서를 실행하는 장치`

현재 switch가 소개되는 Stage 6 이후 unlock 후보.

### C. Builder Lab

목표: topology/cost/track attribute를 격리한다.

- cargo/station 요구는 단순
- 이미 배운 geometry/attribute만 사용
- 안전 route와 더 좋은 route가 모두 존재
- RUN은 짧고 결과 확인 위주

배우는 것:

`연결만 되면 끝이 아니라 조우 순서·비용·속성이 달라진다`

현재 fast/cheap/cost가 소개되는 Stage 8 이후 unlock 후보.

### Lab guardrails

- main campaign progression requirement 아님
- 새 gameplay rule 없음
- 독점 능력/업그레이드 보상 없음
- 초기 leaderboard 없음
- completion badge/stamp는 cosmetic-only 후보
- Lab 해답을 campaign 해답으로 복사해 주지 않음

---

## BMK-R05 · Optional Mastery Spur

상태: `PROPOSED · MEDIUM_HIGH_PRIORITY`

Railbound의 접근 가능한 main path + 더 어려운 optional fork에서 가져오는 구조적 교훈이다.

제안:

- chapter마다 최대 1개
- progression requirement 아님
- 새 rule 없음
- 해당 chapter rules의 높은 결합 난이도
- 기존 request-only hint contract 유지
- reward는 cosmetic stamp/completion mark 정도만 후보

목적:

- casual player를 막지 않고 expert depth 제공
- core 3-map bundle을 억지로 어렵게 만들 필요 감소
- 이후 level-quality benchmark set으로 활용 가능

---

## BMK-R06 · Approved Tutorial 1~10 refinement

상태: `PROPOSED_REFINEMENT_OF_APPROVED_SX_DEC_034 · HIGH_PRIORITY`

**중요:** 현재 승인된 tutorial 순서를 변경하지 않는다. 아래는 각 승인 stage가 무엇을 실제 행동으로 증명하게 만들지 보강하는 제안이다.

| Current Stage | 승인된 주제 | Benchmark-driven 문제 설계 보강 | 이번 stage에서 과도하게 섞지 않을 것 |
|---|---|---|---|
| 1 | 기본 선로 연결 | start→cargo→station의 짧은 한 경로를 직접 만들고 BUILD→RUN→success 한 사이클을 경험 | mixed stack, switch, 비용 최적화 |
| 2 | 화물·대응 역·자동 하역 | cargo icon과 station identity를 연결하고 matching TOP이면 자동 하역되는 것을 눈으로 확인 | manual load, LIFO 혼합 문제 |
| 3 | LIFO | 자동 적재 중심으로 A→B가 TOP=B를 만든다는 것을 예측하고 역순 하역을 경험 | Combo 최적화, switch |
| 4 | 수동 적재 | 지나가는 화물을 일부러 skip하고 재방문하여 TOP을 바꾸는 짧은 문제 | auto toggle 비교, 복수 switch |
| 5 | 자동 적재 전환 | manual/auto 상태 차이를 같은 작은 topology에서 비교하고 상태 표시를 확실히 읽음 | 복수 분기, 비용 속성 |
| 6 | 분기 조작 | selected/locked 상태, 미리 선택한 branch와 실제 방문 결과의 인과를 증명 | 짧은 반사신경 window |
| 7 | Combo·출발 가속 | 같은 종류 contiguous TOP group을 만들고 한 번의 역 방문에서 묶음 하역 후 가속을 관찰 | fast/cheap track까지 동시에 최적화 |
| 8 | 가속·저비용·비용 | 동일한 배송 요구에 fast/normal/cheap 조합으로 speed/cost tradeoff를 비교 | 회차 중심 복합 topology |
| 9 | 회차 중심 복합 노선 | 이미 배운 load/LIFO/switch/attribute와 turnaround를 결합해 구조적 preflight와 재방문을 증명 | 새로운 scoring rule |
| 10 | 종합 시험 | 건설·LIFO·분기·Combo·비용·시간을 한 map에서 종합하되 새 rule은 없음 | 새로운 geometry/rule |

### Lab unlock 제안

- Stage 5 clear → Stack Lab
- Stage 6 clear → Switch Lab
- Stage 8 clear → Builder Lab

### Tutorial presentation rule

설명을 늘리는 대신 문제 자체가 한 인과를 보여주게 한다.

- Stage 3+: `TOP 예상` 같은 짧은 prediction prompt 후보
- 실패 후 정답 route 대신 실제 원인 state를 보여줌
- request-only hint 3단계는 현재 baseline 그대로 유지
- `BMK-R02 Route Probe`가 승인되더라도 tutorial 정답 자동 노출 금지

---

## BMK-R07 · Result screen = 세 개의 개인 최적해 + Route Fingerprint

상태: `PROPOSED · HIGH_PRIORITY`

현재 Speed / Economy / Score stars가 서로 다른 해를 요구한다는 강점을 결과 화면에서도 유지한다.

한 개의 종합 등급보다 다음 개인 기록을 분리해서 보여주는 것을 제안한다.

```text
Fastest PB
Cheapest PB
Highest Score PB
```

이번 run이 어떤 PB를 갱신했는지 별도로 표시한다.

### Route Fingerprint 후보

- track cost
- completion time
- score
- total rail tiles
- switch count / switch changes
- station revisits
- max stack depth
- cargo type transitions in stack
- max combo
- pause count

### 중요한 원칙

- 개발자 정답 route와 직접 비교하지 않음
- 다른 플레이어 route를 자동 공개하지 않음
- 단일 global efficiency score로 합치지 않음
- 현재 leaderboard privacy/solution-protection 계약 유지
- 플레이어가 `내 가장 빠른 노선`, `내 가장 싼 노선`, `내 최고 점수 노선`을 서로 다른 설계로 기억하게 함

---

## BMK-R08 · Daily / Weekly launch refinement

상태: `PROPOSED_REFINEMENT_OF_APPROVED_SX_DEC_035 · MEDIUM_HIGH_PRIORITY`

현재 approved contract인 **fixed-seed procedural map**을 유지한다.

초기 권장:

- Daily = 짧은 fixed-seed procedural map 1개
- Weekly = 더 큰 fixed-seed procedural map 1개
- 생성 후 solvability/preflight/content-quality validator를 통과한 seed만 publish 후보
- 같은 기간 모든 플레이어는 동일 seed/ruleset
- unlimited retry 유지
- archive practice 유지
- initial launch에서는 challenge-exclusive modifier를 추가하지 않음
- challenge-exclusive gameplay power/reward 없음

즉 benchmark에서 가져오는 것은 cadence와 반복 동기이지 authored campaign과 procedural challenge의 경계를 섞는 것이 아니다.

새 modifier는 core human validation 이후 별도 Decision으로 검토한다.

---

## BMK-R09 · Shareable Route Card

상태: `PROPOSED · FUTURE_LOW_RISK`

Mini 계열에서 자신이 만든 네트워크 자체가 결과물이 되는 점을 참고한다.

온라인 backend 없이도 결과 화면에서 다음을 한 장으로 저장하는 후보:

- map thumbnail
- player route
- Speed / Cost / Score
- max combo
- map id / challenge seed
- optional Route Fingerprint

목적은 competitive solution 공개가 아니라 **내가 만든 노선에 대한 소유감과 공유 가능성**이다.

초기 구현 우선순위는 낮다.

---

## BMK-R10 · Editor / Workshop은 post-validation roadmap

상태: `PROPOSED · POST_VALIDATION_ROADMAP`

Railbound, Train Valley 2, Rail Route, Railway Dispatcher의 editor/Workshop 지원은 장기 콘텐츠 확장 관점에서 참고 가치가 있다.

현재 `MapDefinition`과 player `TrackLayout` 분리는 editor-friendly 방향이다. 하지만 지금 editor UI를 만들면 core validation보다 scope가 먼저 커진다.

권장 순서:

```text
finite core human validation
→ authored campaign content pipeline 안정화
→ map schema/editor-readiness audit
→ internal editor
→ only then UGC/share/workshop 검토
```

지금 필요한 것은 editor가 아니라 **future editor를 막는 하드코딩을 피하는 것**이다.

---

## 5. Level-design grammar proposal

상태: `PROPOSED · CONTENT_PLANNING_TOOL`

새 gameplay rule이 아니라 authored map을 설계할 때의 내부 언어다.

### 5.1 한 스테이지의 Primary Question

각 core stage는 가장 먼저 한 문장으로 답할 수 있어야 한다.

예:

- `어떤 화물을 먼저 만나야 마지막 TOP이 맞아지는가?`
- `이 station은 지금 방문해야 하는가, 나중에 다시 와야 하는가?`
- `같은 cargo를 묶기 위해 어느 branch를 선택해야 하는가?`
- `더 빠른 route와 더 싼 route가 왜 다른가?`

한 core stage에 Primary Question이 2개 이상이면 분리 가능성을 먼저 검토한다.

### 5.2 Difficulty budget

초기 content tuning용 TEST_VALUE:

```text
Core tutorial / early chapter
- primary difficulty axis: 1
- secondary pressure: 0~1

Normal chapter
- primary axis: 1
- secondary pressure: 1

Chapter exam
- primary axes combined: 2

Mastery Spur
- axes combined: 2~3
- new rule: 0
```

숫자는 product value가 아니라 authoring discipline을 위한 TEST_VALUE다.

### 5.3 좋은 실패 조건

좋은 실패는 플레이어가 다음 시도에 바꿀 것을 떠올릴 수 있어야 한다.

좋은 예:

- `A역을 지났지만 TOP=B였다`
- `C화물을 한 번도 만나지 않았다`
- `같은 cargo가 stack에서 두 group으로 갈라졌다`
- `cheap route는 비용 별을 얻었지만 시간 별에는 늦었다`

나쁜 예:

- 무엇이 틀렸는지 알 수 없는 timeout
- 짧은 reaction miss 한 번으로 전체 plan이 무너짐
- 정답 route를 알아야만 이해 가능한 실패

---

## 6. Optional minigame/Lab package

상태: `PROPOSED · NO_NEW_RULES`

### Stack Lab family

- topology는 거의 고정
- cargo/station 배치만 바뀜
- objective는 `TOP`, `skip`, `revisit`, `contiguous group`
- 난이도는 stack entropy로만 증가

예시 archetype:

```text
LAB-S1 · Reverse Two
A → B pickup / B → A delivery

LAB-S2 · Skip One
A → B → C encounter 중 B를 건너뛰어 target TOP 만들기

LAB-S3 · Group Three
A cargo 세 개를 하나의 contiguous TOP group으로 만들기
```

실제 map/content는 별도 승인 후 제작한다.

### Switch Lab family

- track은 prebuilt
- cargo logic은 단순
- switch 1 → 2 → 3개로 증가
- selected/locked/next branch를 읽는 것이 목적
- no start/stop collision action

예시 archetype:

```text
LAB-J1 · One Choice
LAB-J2 · Revisit Branch
LAB-J3 · Two Decisions, One Plan
```

### Builder Lab family

- cargo logic은 단순
- topology/cost/attribute 비교가 목적
- 현재 승인된 rail types만 사용
- limited inventory 같은 새 rule 없음

예시 archetype:

```text
LAB-B1 · Two Routes
normal short vs cheap long

LAB-B2 · Fast Segment
fast tile을 어디에 써야 time PB가 달라지는지 비교

LAB-B3 · Refund and Reroute
full refund를 이용해 실패 후 빠르게 재설계
```

---

## 7. Optional Mastery Spur package

상태: `PROPOSED`

Mastery Spur는 chapter core와 동일한 rule set을 사용하되 다음 중 2개 이상을 결합한다.

- revisit required
- deeper stack
- cargo type alternation 증가
- switch decision 2개 이상
- cost/speed tradeoff
- route topology ambiguity

금지:

- chapter에서 배우지 않은 새 rail type
- no-pause
- irreversible build
- hidden target
- exclusive progression reward

---

## 8. Proposed chapter archetypes

이름은 작업명이며 미승인이다. 이미 승인된 시스템 조합을 콘텐츠 테마로 묶는 예다.

| Chapter archetype | 주 난이도 축 | 중심 조합 |
|---|---|---|
| Junction Park | Execution Branching | switch / crossing / revisit |
| Cargo Yard | Stack Entropy | alternating cargo / manual load / contiguous groups |
| Budget Hills | Topology + Economy | blocked zones / cheap vs normal / route length |
| Express District | Speed Optimization | fast segments / path length / Combo acceleration |
| Loop Works | Stack + Revisit | loop / repeated station visit / branch planning |
| Grand Terminal | Combined Exam | topology + stack + switch, no new rule |

bridge/tunnel/one-way/turnaround은 current approved late-map scope 안에서만 사용하며, benchmark가 자동 도입 권한을 주지 않는다.

---

## 9. Result / replay motivation proposal

상태: `PROPOSED`

현재 3-star 설계가 단순 clear 후 종료되지 않게 하려면 결과 화면이 다음 질문을 만들어야 한다.

```text
이번에는 성공했다.
그럼 더 빠르게 할 수 있나?
더 싸게 할 수 있나?
더 좋은 Combo로 할 수 있나?
```

### 세 PB를 별도 memory로 유지하는 이유

- 한 dominant route로 수렴하는 것을 방지
- 같은 map의 다른 topology를 다시 만들 이유 제공
- 현재 guardrail인 speed/cost/score 다양성 측정과 연결

### Route Fingerprint는 설명이지 등급이 아니다

Fingerprint는 player route의 특징을 보여주는 값이지 또 하나의 종합 score가 아니다.

---

## 10. Proposed usability / comprehension experiments

모든 수치는 `TEST_VALUE`다.

### EXP-BMK-01 · Route causality

질문:

> 플레이어가 선로를 단순 연결이 아니라 cargo encounter order를 설계하는 도구로 이해하는가?

비교:

- A: current BUILD only
- B: request-only Route Probe + Encounter Strip

관찰:

- first run 전 다음 3~4 encounter 예측
- first failure 후 어느 rail segment를 수정하는지
- hint 없이 route→stack 관계를 행동으로 적용하는지

### EXP-BMK-02 · Yard Lab transfer

질문:

> 격리 연습이 campaign 문제로 전이되는가?

관찰:

- Lab 직후 다음 core stage에서 같은 rule을 설명 없이 적용
- verbal explanation보다 실제 route/load/switch choice 우선 기록

### EXP-BMK-03 · Mastery Spur separation

질문:

> core campaign 난이도를 억지로 올리지 않고 expert depth를 제공하는가?

관찰:

- optional spur 진입률
- 포기 후 core progression 복귀율
- hint 사용량
- core stage와 spur solve attempts 차이

### EXP-BMK-04 · Multiple-solution motivation

질문:

> Speed / Cost / Score PB를 분리하면 같은 map을 다른 노선으로 다시 설계하는가?

관찰:

- clear 후 즉시 Edit 선택
- 두 번째 성공에서 route topology 변경
- 한 map에서 서로 다른 PB route 수

### EXP-BMK-05 · Debrief usefulness

질문:

> Encounter Trace가 정답을 주지 않으면서 다음 수정 방향을 이해시키는가?

관찰:

- trace를 본 뒤 player가 수정할 rail/load/switch를 스스로 고르는지
- 같은 원인으로 연속 실패하는 횟수
- trace 없이도 transfer stage에서 원인을 찾는지

---

## 11. Explicit rejects / do-not-import list

### REJECT-MAIN-01 · Endless survival demand growth

Mini Metro/Motorways의 핵심이지만 `GMB-002 finite authored delivery puzzle`을 다시 흐린다.

### REJECT-MAIN-02 · Multi-train collision action

Conduct/Railbound 계열 긴장을 그대로 가져오면 main loop가 planning → reflex로 이동한다.

### REJECT-MAIN-03 · Real signaling/interlocking/contract automation

Rail Route/Railway Dispatcher 수준 rail-sim complexity는 current casual puzzle positioning에 과도하다.

### REJECT-MAIN-04 · Cargo capacity 1 / small hard capacity

Cosmic/Spooky의 강한 제약이지만 current unlimited LIFO를 제거해 가장 독특한 부분을 훼손한다.

### REJECT-MAIN-05 · Main-mode limited track inventory / irreversible placement

Please Fix The Road/Mini Motorways Expert에서 유효하지만 free build + piece cost + full refund와 충돌한다.

### REJECT-MAIN-06 · Tycoon progression / locomotive stat economy

Train Valley 2의 방향은 current puzzle clarity보다 meta progression이 커진다.

### REJECT-NOW-07 · UGC editor before core validation

콘텐츠 양보다 문제 품질 기준과 human comprehension을 먼저 고정한다.

### REJECT-NOW-08 · Tutorial sequence rewrite without Decision

현재 승인된 1~10 학습 순서를 benchmark 근거만으로 바꾸지 않는다.

### REJECT-NOW-09 · Daily/Weekly authored-map substitution

현재 approved fixed-seed procedural contract를 benchmark 근거만으로 authored challenge로 바꾸지 않는다.

---

## 12. Priority recommendation

### P0 — 다음 사용자 검토/승인 가치가 높은 후보

1. `BMK-R01` core positioning / feature triage language
2. `BMK-R02` request-only Route Probe / Encounter Strip
3. `BMK-R03` Prediction → Execution → Debrief loop
4. `BMK-R04` Stack / Switch / Builder Yard Labs
5. `BMK-R06` **approved tutorial sequence를 유지한** stage refinement + Lab unlock
6. `BMK-R07` three PBs + Route Fingerprint result model

### P1 — 콘텐츠 구조 후보

7. `BMK-R05` optional Mastery Spur
8. chapter archetype set
9. `BMK-R08` fixed-seed procedural Daily/Weekly quality refinement

### P2 — post-validation roadmap

10. `BMK-R09` shareable Route Card
11. `BMK-R10` editor/UGC readiness

---

## 13. Recommended product shape after benchmark

아직 미승인 제안이지만 가장 일관된 구조는 다음이다.

```text
CAMPAIGN
  Approved Tutorial 1~10 order 유지
    Stage 5 이후 Stack Lab 후보
    Stage 6 이후 Switch Lab 후보
    Stage 8 이후 Builder Lab 후보

  11+ Chapters
    Core A / B / C
    clear any 2 → next chapter
    + optional Mastery Spur

REPEAT
  Daily fixed-seed procedural map
  Weekly fixed-seed procedural map
  Archive practice

LEARNING / REDESIGN LOOP
  request-only Build Route Probe
  → Run existing Stack/TOP/Switch truth
  → Encounter Trace / cause
  → Edit
  → Fastest / Cheapest / Highest Score PB 분리

FUTURE
  Shareable Route Card
  Editor / UGC after core validation
```

이 구조의 목적은 main gameplay rule을 늘리는 것이 아니라 **현재 핵심의 학습·난이도·반복·재설계 동기**를 깊게 만드는 것이다.

---

## 14. Approval boundary

현재 이 문서의 모든 `BMK-Rxx`는 `PROPOSED`다.

사용자 승인 전:

- `SX-DEC-056+` 생성 금지
- current core gameplay 변경 금지
- approved Tutorial 1~10 순서 변경 금지
- approved Daily/Weekly fixed-seed procedural contract 변경 금지
- implementation plan 변경 금지
- Phase C 코드 작업 금지
- benchmark recommendation을 current product authority로 표기 금지

사용자가 특정 recommendation을 승인하면 **승인된 subset만** Decision ID로 승격하고, GitHub current authority와 configured Google Sheet에 같은 Decision ID로 동기화한다.
