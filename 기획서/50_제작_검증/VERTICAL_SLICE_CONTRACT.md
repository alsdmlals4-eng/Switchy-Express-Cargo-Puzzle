# Vertical Slice Contract

```yaml
status: REPLACED · HISTORICAL_EVIDENCE_PRESERVED
replacement_reason: GMB-002_FINITE_DELIVERY_PRODUCT_BASELINE
current_product_authority: 기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md
current_audit: SX-AUD-012
implementation_state: OLD_CORE_MERGED · NEW_CORE_NOT_ALIGNED
next_gate: FINITE_PUZZLE_DEFINITION_OF_READY
```

## 중요

이 파일의 기존 endless survival Vertical Slice 계약은 `[대체됨]`이다. PR #37/#41/#46/#49와 관련 테스트는 당시 계약을 구현한 `[역사 증거]`로 유지한다. 새 제품의 선로 건설·유한 배송·무제한 적재·별·랭킹 구현 완료를 의미하지 않는다.

## 대체된 old package order

```text
VS03-01 run lifecycle/economy/difficulty
→ VS03-02 compact footprint
→ VS03-03 map/session/restart/selection
→ VS03-R1 difficulty alignment
→ VS03-05A playable surface
→ VS03-04 Profile
→ VS03-05B result/browser
→ VS03-06 onboarding
→ VS03-07 integration
```

상태: `[대체됨]`

- VS03-01/02/03/R1 merge·test 사실은 보존
- VS03-05A 이후 자동 진행 금지
- 기존 Issue·Goal·plan이 old order를 current로 표시하면 replacement register를 우선

## 새 Vertical Slice 재정의 목표

새 DoR은 최소 다음 질문을 닫아야 한다.

1. 지형·역·화물과 player TrackLayout의 identity 분리
2. 선로 설치·회전·철거·업그레이드 UX
3. 분기·교차·일방통행·회차 graph contract
4. 구조적 시작 검사와 trap detection
5. 무제한 CargoStack의 domain·저장·표현 계약
6. 수동/자동 적재 전환과 pickup 판정
7. 최대 1초 가시 하역과 Combo 가속
8. 제한 시간 성공·실패 seal과 pause integrity
9. 건설비·별·3종 리더보드 ruleset identity
10. 1~10 튜토리얼 대표 스테이지와 최소 3개 본편 맵
11. 추천 설계도와 예상 비용
12. legacy fuel/BOOST/difficulty 코드의 제거·격리·재사용 계획

## 새 Slice 권장 범위

### FP-01 · Track construction domain

- MapDefinition/BuildSurface/TrackLayout
- 비용·철거·연결 그래프
- preflight reachability/trap 검사

### FP-02 · Finite delivery run

- manual/auto loading
- unlimited LIFO
- station skip/unload
- time limit/success/failure/pause

### FP-03 · Combo and track performance

- speed/budget/one-way/turnaround
- unload animation contract
- Combo acceleration and score

### FP-04 · Tutorial and authored maps

- tutorial 1~10 data
- main representative maps
- ghost recommended route

### FP-05 · Stars and local records

- speed/cost/score stars
- accumulated unlock
- local 3-board records
- ruleset versioning

### FP-06 · Product surface and evidence

- build/run/result HUD
- Android landscape
- accessibility/localization
- balance simulation and human test

온라인 리더보드·일일/주간 backend·백분위 보상·archive service는 local core 이후 별도 production package다.

## 보호 경계

새 DoR 전 허용:

- 기획 정본·Sheet·Issue·spec·plan 업데이트
- legacy code inventory와 재사용 분석
- non-mutating prototype evidence

새 DoR 전 금지:

- old VS03-05A 구현 계속 진행
- fuel/BOOST를 새 제품에 임시로 남긴 채 product surface 구현
- 완성형 generated graph를 player-built track처럼 위장
- capacity 8을 새 제품 기본으로 유지
- 새 규칙을 테스트 없이 current implementation으로 표시

## 검증 상태

```text
GMB-002 planning approval: PASS
SX-AUD-012 core alignment: PASS_WITH_REPLAN_REQUIRED
new product runtime: NOT_STARTED
new product tests: NOT_RUN
Android/human/balance: NOT_RUN
online challenge/leaderboard: NOT_RUN
```
