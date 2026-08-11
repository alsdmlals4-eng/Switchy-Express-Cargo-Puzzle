# SX-DEC-057 · Yard Labs and Mastery Curriculum

Status: `USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR`

Approved: `2026-08-11 KST`

Source benchmark: `SX-BMK-001 · BMK-R04/R05/R06`

Product baseline: `GMB-002`

Existing campaign authority: `SX-DEC-034`

## Decision

현재 승인된 Tutorial 1~10 순서와 `3개 중 2개 clear → 다음 묶음` 챕터 진행 구조를 유지하면서, 기존 gameplay rule을 격리해 연습하는 `Yard Labs`와 진행을 막지 않는 `Mastery Spur`를 추가하는 콘텐츠 구조를 승인한다.

새 시스템을 늘리는 것이 아니라 이미 승인된 BUILD/LIFO/load/switch/cost 규칙의 이해와 전이를 강화하는 것이 목적이다.

## 1. Tutorial 1~10 순서 보호

`SX-DEC-034 / GMB-002`의 현재 순서는 변경하지 않는다.

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

이 Decision은 순서 재작성 권위가 아니라, 각 단계가 가르친 규칙을 짧게 분리 연습하고 이후 본편에 전이시키는 추가 구조의 권위다.

## 2. Yard Labs

Yard Labs는 별도 arcade mode가 아니라 기존 규칙만 쓰는 짧은 연습 퍼즐이다.

초기 목표 세션 길이: `30~90초 TEST_VALUE`.

### 2.1 Stack Lab

목적: LIFO/TOP과 manual/auto load 선택을 격리해 익힌다.

- 선로는 미리 배치된 소형 문제를 우선한다.
- switch는 없거나 최소화한다.
- cargo/station 수를 작게 유지한다.
- manual/auto load를 이용해 필요한 stack 결과를 만든다.
- 시간 압박은 학습을 방해하지 않는 수준으로 둔다.

권장 unlock: Tutorial Stage 5 완료 후.

### 2.2 Switch Lab

목적: switch를 반사신경 버튼이 아니라 계획한 방문 순서를 실행하는 장치로 익힌다.

- 선로는 미리 배치된 소형 문제를 우선한다.
- 1~3개 switch를 중심으로 설계한다.
- load 복잡도는 낮춘다.
- train start/stop 직접 조작을 새로 추가하지 않는다.
- pause 허용 원칙을 유지한다.

권장 unlock: Tutorial Stage 6 완료 후.

### 2.3 Builder Lab

목적: 연결 가능 여부를 넘어 `조우 순서 + 비용 + 선로 속성` 차이를 익힌다.

- cargo/station 요구는 단순하게 둔다.
- 한 문제는 한두 geometry/attribute를 중심으로 한다.
- 안전한 기본 route와 더 좋은 route가 함께 존재할 수 있다.
- main BUILD의 free build + piece cost + full refund 계약은 유지한다.

권장 unlock: Tutorial Stage 8 완료 후.

## 3. Lab guardrails

- Lab clear는 campaign progression 필수가 아니다.
- Lab 전용 gameplay power / upgrade는 없다.
- Lab에서만 쓰는 새 gameplay rule은 없다.
- 초기에는 leaderboard를 두지 않는다.
- 반복 플레이를 허용한다.
- 보상은 cosmetic-only 원칙을 넘지 않는다. 정확한 cosmetic 내용은 별도 콘텐츠 승인 전까지 고정하지 않는다.

## 4. Optional Mastery Spur

각 chapter에는 최대 1개의 optional `Mastery Spur`를 둘 수 있다.

- progression requirement가 아니다.
- 새 rule을 소개하지 않는다.
- 그 chapter에서 이미 배운 rule을 더 촘촘하게 결합한다.
- main Core A/B/C의 2-clear progression을 방해하지 않는다.
- 포기 후 즉시 core progression으로 돌아갈 수 있어야 한다.
- 보상은 cosmetic-only / completion mark 범위만 허용한다.

## 5. Difficulty model

콘텐츠 난이도는 다음 3축으로 분리 관리한다.

### Topology Complexity

- blocked cell
- loop
- crossing
- branch
- revisit
- late bridge/tunnel/turnaround

### Stack Entropy

- cargo type alternation
- TOP block 가능성
- contiguous same-type group 설계 난이도
- stack depth
- skip/revisit 필요성

### Execution Branching

- switch 수
- switch 선택 순서
- 방문 순서 후보 수
- switch lock 순간

Core stage는 한 축을 주 학습으로 삼는 것을 원칙으로 한다. Chapter exam과 Mastery Spur는 이미 배운 규칙을 전제로 2~3축을 결합할 수 있다.

## 6. Content validation contract

구현/콘텐츠 제작 승인 전 delta DoR에서 최소 다음을 닫아야 한다.

1. 각 Lab이 기존 rule만 사용한다는 content schema 검증.
2. Tutorial unlock 순서가 Stage 5/6/8 보호선과 충돌하지 않는지 확인.
3. Lab completion이 campaign progression/power에 영향을 주지 않는지 확인.
4. Mastery Spur가 optional이고 2-clear progression을 막지 않는지 확인.
5. Core/Exam/Mastery의 3축 난이도 태깅 규칙.
6. Yard Lab 학습이 이후 campaign 문제에 전이되는지 사람 검증.

## 7. Authority boundary

- `SX-DEC-034` Tutorial 1~10 순서는 계속 상위 기존 권위다.
- `SX-DEC-057`은 해당 순서에 Lab/Mastery 구조를 추가하는 additive Decision이다.
- `SX-DEC-055`의 기존 Phase B BUILD authority는 이 Decision으로 확대되지 않는다.
- 실제 Yard Lab/Mastery content/runtime 구현 전 별도 delta DoR / final planning review가 필요하다.
