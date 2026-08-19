# SX-DEC-059 · Release-Near First-Session Vertical Slice

```yaml
decision_id: SX-DEC-059
status: USER_APPROVED_DIRECTION · DETAILED_PLAN_CURRENT · IMPLEMENTATION_NOT_AUTHORIZED
date: 2026-08-20 KST
approval_reference: "current chat · 권장안 승인, 연속작업 진행"
work_mode: PLAN
product_baseline: GMB-002
protected_decisions:
  - SX-DEC-027~058
protected_open_pr:
  - "#154 · READ_ONLY"
implementation_gate: USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION
```

## 결정

새 기능 확장을 우선하지 않는다. `GMB-002` finite delivery core와 병합된 `SX-DEC-055` semantic runtime을 사용해 **첫 플레이 8~12분 안에 `선로 계획 → 적재 순서 → LIFO → manual/auto load → 분기 → 결과 해석 → 재설계`가 하나의 shipping-intent 경험으로 연결되는 release-near Vertical Slice**를 먼저 완성·검증한다.

## 선택 구조

```text
Tutorial 1 · 기본 선로 연결
→ Tutorial 2 · 화물/역
→ Tutorial 3 · LIFO
→ Tutorial 4 · 수동 적재
→ Tutorial 5 · 자동 적재 전환
→ Tutorial 6 · 분기
→ VS_DEMO_01 · 종합 Capstone
```

현재 승인된 Tutorial 1~10의 순서를 바꾸지 않는다. 첫 Slice는 1~6까지만 사용하고 Tutorial 7~10은 후속으로 남긴다.

## 핵심 경험 가설

플레이어는 선로 자체를 푸는 것이 아니라 **선로가 만드는 조우 순서와 스택을 계획하고, RUN에서 그 계획을 실행·수정한다.**

성공 시:
- `내가 만든 계획대로 움직였다`는 통제감
- LIFO가 맞아떨어질 때의 정리/해결 쾌감
- 다른 해법이나 더 나은 순서를 시도하고 싶은 욕구

실패 시:
- 정답을 받는 대신 `왜 이번 계획이 실패했는지`를 실제 발생 사건으로 이해
- Retry same layout 또는 Edit layout으로 한 요소를 바꾸어 재도전

## 실패 학습

전체 `SX-DEC-056A` 구현 권한을 확장하지 않는다.

Slice가 요구하는 최소 범위는 **actual-event causal debrief 1건**이다.

예:

```text
B역 도착 · TOP=A → 하역하지 못함
ROUTE_END · 미배송 A 1개
TIMEOUT · 미배송 B 1개
```

금지:
- 정답 노선
- 추천 switch sequence
- 최적 적재 순서
- solver
- PB/Fingerprint를 Slice 명목으로 선구현

향후 056A는 같은 runtime event seam을 확장하는 방식으로 연결한다.

## 벤치마크 처분

| Reference | 채택 | 변형 | 제외 |
|---|---|---|---|
| Railbound | 플레이로 규칙 학습, 개념 점진 노출, 쉬운 수정 | LIFO 첫 필요 시 1줄 contextual copy 허용 | finger-paint 입력 복제, 완전 무문자 강제 |
| Cosmic Express | 완만한 난이도 곡선, 동일 코어 조합 심화 | BUILD/LIFO/switch만 먼저 조합 | 새 특수 선로를 첫 세션에 추가 |
| Mini Metro/Motorways | 경로 계획이 이후 결과를 만든다는 인과, 최소 시각 언어 | finite authored puzzle의 Plan→Run 대비 강화 | endless pressure / survival 구조 |

## 시간 Budget · TEST_VALUE

```yaml
T1: 45~60s
T2: 45~60s
T3: 60~90s
T4: 60~90s
T5: 60~90s
T6: 75~105s
capstone_first_attempt: 180~240s
recommended_total: 8~12m
safe_range: 7~15m
warning: ">15m before first capstone result"
```

수치는 튜닝 값이며 코어 결정이 아니다.

## 정보 위계

### BUILD
1. Board / 설치 가능 상태
2. 현재 화물·역 목표
3. Track placement validity
4. build cost / preflight
5. RUN CTA

### RUN
1. Train + route
2. Stack + TOP
3. manual/auto load state
4. switch state / occupied lock
5. remaining cargo + time

### RESULT
1. success/failure reason
2. actual-event causal debrief
3. relevant TOP / remaining cargo
4. Retry same layout
5. Edit layout

랭킹·Daily/Weekly·Mastery는 첫 Slice의 1차 정보 위계에서 제외한다.

## 시각화 필요자료

```yaml
VIS-SX-059-01:
  type: FLOW
  priority: P0
  purpose: T1~T6→Capstone 흐름 검수
  production: TEXT_MERMAID_FIRST
VIS-SX-059-02:
  type: UI_SCREEN
  priority: P1
  purpose: Capstone RUN 정보 위계
  production: BRIEF_REQUIRED_NOT_GENERATED
VIS-SX-059-03:
  type: UI_SCREEN
  priority: P1
  purpose: Failure Debrief 화면
  production: BRIEF_REQUIRED_NOT_GENERATED
VIS-SX-059-04:
  type: STORYBOARD
  priority: P2
  purpose: T1~T6 단계별 UI 노출
  production: OPTIONAL_IF_01_TO_03_SUFFICIENT
```

이미지 생성은 별도 명시 요청 전 수행하지 않는다.

## 범위 제외

- full SX-DEC-056A Route Probe/PB/Fingerprint
- SX-DEC-056B score/max-combo
- SX-DEC-057 Yard Lab/Mastery
- SX-DEC-058 Daily/Weekly generation pipeline
- shareable Route Card
- editor/UGC
- backend/leaderboard
- historical endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset
- Base repin
- PR #154 변경/흡수

## Evidence ceiling

```yaml
TECH_EVIDENCE: AVAILABLE_AND_TO_BE_EXTENDED
UI_EVIDENCE: TO_BE_REVALIDATED_ON_RELEASE_NEAR_SLICE
DEVELOPER_SELF_RUN: NOT_RUN_ON_THIS_NEW_SLICE
HUMAN_USABILITY_EVIDENCE: NOT_RUN
PLAYER_EXPERIENCE_EVIDENCE: NOT_RUN
```

자동 테스트·개발자 self-run으로 first-contact 재미/이해 PASS를 주장하지 않는다.

## Pre-build blocker

### Godot AI authority drift

current main 실제 `addons/godot_ai/plugin.cfg`는 `3.1.4`이나 `docs/tooling/local_godot_tooling_state.json`은 `3.1.3`이다. PR #153은 이 정합성을 다루었지만 병합되지 않았다.

`PLANNING_CAN_CONTINUE · BUILD_PRECHECK_MUST_RECONCILE`.

### Work instruction drift

현재 채팅은 사용자가 제공한 v4.7 지시를 따른다. 프로젝트 GitHub는 아직 v4.5 r2를 current work instruction으로 가리킨다.

`BUILD 전에 authority reconciliation 필요`이며, 현재 상태를 이미 v4.7 동기화 완료라고 표현하지 않는다.

## 다음 Gate

```text
SX-DEC-059 detailed planning
→ screen/content/data contract
→ Visual briefs inventory
→ final planning adversarial review
→ user explicit "기획 완료"
→ fresh PowerShell / Codex BUILD package
```

현재 판정: `PLAN_CONTINUES · BUILD_NOT_AUTHORIZED`.
