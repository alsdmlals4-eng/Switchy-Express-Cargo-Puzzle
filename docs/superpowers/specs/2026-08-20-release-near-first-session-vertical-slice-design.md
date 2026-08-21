# Switchy Express · Release-Near First-Session Vertical Slice Design

- date: `2026-08-20 KST`
- work_mode: `PLAN`
- status: `DESIGN_LOCKED_WITHIN_USER_APPROVED_DIRECTION · BUILD_NOT_AUTHORIZED`
- approval_reference: `2026-08-20 current chat · 권장안 승인, 연속작업 진행`
- proposed_decision_id: `SX-DEC-059`
- product_authority: `GMB-002 · SX-DEC-027~058`
- baseline_main: `0a88f707e1e4131ae4372929f2871d2b8a3a74b7`
- protected_open_pr: `#154 feat/p0-grid-ui-symbol-pilot-20260820 · READ_ONLY`
- implementation_gate: `USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION_REQUIRED`

## 1. Direction anchor

현재 확장 기능을 더 쌓기보다, 이미 구현된 finite delivery core와 `SX-DEC-055` semantic runtime을 이용해 **처음 보는 플레이어가 8~12분 안에 `선로 계획 → 적재 순서 → LIFO → 운행 중 분기 → 결과 해석 → 재설계`를 이해하고 다시 시도하고 싶어지는지 검증할 수 있는 shipping-intent Vertical Slice**를 먼저 완성한다.

이 Slice는 새 코어 규칙을 발명하지 않는다. 기존 Tutorial 1~10의 승인 순서를 보호하면서 **Tutorial 1~6 + 기존 `VS_DEMO_01` capstone**만 연결한다. `SX-DEC-056~058` 전체 구현, Yard Lab, Daily/Weekly, score/combo 확장, UGC는 이번 범위에서 제외한다.

## 2. Why now

현재 저장소/Notion에서 확인된 상태:

- finite delivery core: automated PASS
- `SX-DEC-055` semantic runtime POC: PR #151 merged, runtime integrated
- semantic product assets: 73 total, production complete
- Windows physical runtime: NOT_RUN
- Android device smoke: NOT_RUN
- human first-contact/comprehension: NOT_RUN
- `SX-DEC-056A/057/058`: detailed planning closed, implementation not authorized

따라서 현재 가장 위험한 미검증 가설은 **기능 존재가 아니라 첫 세션에서 코어 인과가 실제로 읽히고 재미로 이어지는가**이다.

## 3. Player value trace

```yaml
player_promise: >
  내가 만든 선로와 적재 선택이 화물 스택 순서를 만들고,
  그 순서를 읽어 분기와 배송 순서를 해결한다.
meaningful_choice:
  - 어디에 선로를 놓을지
  - 어떤 화물을 이번 통과에서 실을지
  - 자동 적재를 언제 사용할지
  - 분기를 어느 방향으로 둘지
expected_experience:
  - 첫 성공에서 "내 계획대로 움직였다"는 통제감
  - LIFO 충돌에서 "왜 통과했는지 알겠다"는 깨달음
  - 실패 뒤 정답 공개 없이 스스로 한 요소를 바꿔 다시 시도하는 욕구
research_question: >
  첫 플레이어가 TOP, 적재 순서, 역 통과/하역 이유와 분기 결과를
  외부 설명 없이 또는 한 줄 보조 설명만으로 이해하고 수정할 수 있는가?
observable_signal:
  - 현재 단계의 다음 행동을 10초 안에 찾는다
  - T3 이후 TOP 화물을 화면에서 즉시 식별한다
  - 실패 시 첫 causal contradiction을 결과 화면과 board에서 연결한다
  - 정답 노선 제공 없이 Retry/Edit 중 하나를 선택해 재시도한다
  - capstone에서 최소 한 번 스스로 계획을 수정한다
  - 성공 뒤 "다른 경로/더 나은 순서" 가능성을 인지한다
evidence_ceiling: >
  현재 자동/렌더/개발자 self-run은 TECH/UI evidence까지만 증명한다.
  first-contact HUMAN_USABILITY/PLAYER_EXPERIENCE는 실제 신규 테스터 실행 전 NOT_RUN.
slice_acceptance:
  technical_ui_ready: 모든 단계가 shipping-intent UI/asset/audio/VFX로 연결되고 blocker 0
  self_run_ready: 개발자 self-run에서 진행 불가/정보 부재/조작 dead-end 0
  human_gate: first-contact participant evidence가 생기기 전 재미/이해 PASS 금지
```

## 4. Alternative portfolio

### A · `T1~T6 + CAPSTONE` — SELECTED

승인된 튜토리얼 순서를 그대로 사용해 한 개념씩 노출하고 `VS_DEMO_01`에서 종합한다.

장점:
- 코어 규칙을 새로 만들지 않는다.
- 첫 10분 안에 BUILD/LIFO/manual-auto/switch를 모두 경험할 수 있다.
- 각 실패 원인을 특정 단계에 귀속하기 쉽다.
- 이후 Tutorial 7~10과 캠페인으로 그대로 확장할 수 있다.

위험:
- 7개 구간이 길어지면 온보딩 피로가 생긴다.

대응:
- T1~T2 `45~60s`, T3~T6 `60~90s`, capstone `180~240s`를 권장 예산으로 둔다.
- 설명 팝업을 늘리지 않고 플레이 자체로 학습시킨다.

### B · `SINGLE FULL MAP + CONTEXTUAL COACHING` — REJECT FOR FIRST VALIDATION

한 맵에서 모든 시스템을 즉시 노출하고 상황별 도움만 띄운다.

장점: 콘텐츠 제작량 최소.

기각 이유: 첫 플레이어가 건설·LIFO·manual/auto·switch를 동시에 이해해야 해서 실패 원인 분리가 어렵고, 현재 가장 중요한 첫 세션 학습 검증에 불리하다.

### C · `YARD LAB FIRST` — DEFER

`SX-DEC-057` Stack/Switch/Builder Lab을 먼저 구현해 각 규칙을 격리 학습한 뒤 본편으로 보낸다.

장점: 학습 진단력과 반복 훈련성이 높다.

보류 이유: 별도 구현 권한이 없는 057 범위를 먼저 생산하게 되고, release-near Slice 전에 콘텐츠 시스템이 팽창한다.

### D · `COMPRESSED T1/T3/T6 + CAPSTONE` — REJECT

대표 규칙만 골라 첫 세션을 더 짧게 만든다.

기각 이유: 현재 승인된 Tutorial 1~10의 점진적 순서를 건너뛰고 manual/auto load의 선행 학습을 누락시킨다.

## 5. Benchmark synthesis

### Railbound / Afterburn

채택 원리:
- 긴 onboarding text보다 플레이 가능한 초기 퍼즐에서 학습한다.
- 첫 레벨은 사실상 실패할 수 없게 만들고, 필요한 개념만 그 시점에 추가한다.
- 실수 수정/undo가 쉬워 탐색 비용을 낮춘다.

프로젝트 변형:
- Switchy는 LIFO라는 추상 규칙이 있으므로 완전 무문자 방식을 복제하지 않는다.
- 행동으로 먼저 보여주고, 첫 필요 시점에만 `TOP부터 내림` 같은 1줄 contextual copy를 허용한다.
- Railbound의 finger-paint input 자체는 복제하지 않고 현재 Switchy 입력 계약을 유지한다.

Sources:
- https://developer.apple.com/news/?id=0x08hncy
- https://developer.apple.com/design/awards/2023/
- https://afterburn.games/press/

### Cosmic Express / Train Braining

채택 원리:
- prototype보다 상용판에서 난이도 곡선을 더 완만하게 다듬는 것이 중요하다.
- 하나의 기차/경로 아이디어를 단계적으로 조합해 복잡성을 만든다.

프로젝트 변형:
- 첫 세션에서는 새로운 선로 속성/특수지형을 넣지 않고 기존 BUILD/LIFO/switch 조합만 깊게 사용한다.

Source:
- https://alan.draknek.org/games/puzzlescript/train.php

### Mini Metro / Mini Motorways

채택 원리:
- 시각 정보가 즉시 읽히는 최소 표현과 제한된 직접 개입이 경로 계획의 긴장을 만든다.
- 플레이어가 모든 것을 직접 조종하지 않아도, 경로 구조가 이후 결과를 결정한다.

프로젝트 변형:
- Switchy는 실시간 교통 시뮬레이션이 아니라 finite authored puzzle이므로 endless pressure를 가져오지 않는다.
- 대신 `BUILD에서 계획한 구조 → RUN에서 결과 관찰`의 인과를 강화한다.

Sources:
- https://dinopoloclub.com/2023/07/23/behind-the-scenes-concepting-mini-motorways/
- https://www.pockettactics.com/dinosaur-polo-club/interview

## 6. First-session content contract

### Global timing budget

```yaml
recommended_total: 8~12 minutes
safe_range: 7~15 minutes
hard_design_warning: >15 minutes before first capstone result
tuning_signal:
  - next-action search time
  - first retry time
  - hint invocation
  - accidental input count
  - stage restart count
  - capstone completion attempts
```

시간은 final requirement가 아니라 TEST_VALUE다. 핵심은 시계보다 `대표 문제 → 대표 행동 → 첫 의미 있는 선택 → 결과 → 다음 질문`이 모두 발생하는 것이다.

### T1 · 기본 선로 연결

- target: 45~60s
- taught: 설치, 연결, 실행
- design: 사용할 도구/셀을 최소화해 첫 성공을 거의 보장한다.
- text: 목표 한 줄만 허용.
- success feeling: `내가 그린 선로로 열차가 움직였다.`
- do_not_teach_yet: 철거 상세, LIFO, manual/auto, switch

### T2 · 화물과 대응 역

- target: 45~60s
- taught: 화물 pickup → 같은 타입 역에서 자동 unload
- cargo/station: color + shape + text redundant signifier 유지
- player question created: `화물이 여러 개면 어떤 순서로 내려갈까?`

### T3 · LIFO

- target: 60~90s
- taught: 마지막에 실은 화물이 TOP, 역은 TOP부터 본다.
- first abstract-rule aid: Stack panel의 TOP을 가장 강한 정보로 표시.
- contextual copy: 첫 필요 시 `TOP부터 내림` 1줄 허용.
- puzzle: 두 종류 화물을 다른 순서로 싣고 역 방문 순서를 역산한다.
- success feeling: `적재 순서를 바꾸면 같은 선로도 결과가 달라진다.`

### T4 · 수동 적재

- target: 60~90s
- taught: manual LOAD hold/release가 pickup 여부를 결정한다.
- interaction: 이미 존재하는 manual-load truth를 사용한다.
- rule: 실패를 만들기 위한 억지 미끼 화물보다, 의도적으로 선택할 이유가 보이는 배치를 사용한다.

### T5 · 자동 적재 전환

- target: 60~90s
- taught: auto-load는 접촉한 모든 화물을 싣는다.
- goal: manual과 auto가 우열이 아니라 서로 다른 계획 도구임을 보여준다.
- rule: 설정 메뉴가 아니라 RUN 안에서 전환 의미를 학습한다.

### T6 · 분기 조작

- target: 75~105s
- taught: 분기 상태 유지, 비점유 분기 사전 전환, 점유 중 lock.
- visual: selected/unselected/occupied-locked semantic state 활용.
- success feeling: `운행이 시작된 뒤에도 계획을 실행하는 선택이 남아 있다.`

### Capstone · `VS_DEMO_01`

- target: 180~240s first attempt
- required systems:
  - free BUILD
  - preflight
  - manual/auto load
  - unlimited LIFO
  - switch
  - `A → B → A → A` representative stack
  - `2 → 1 → 1` representative unload
  - success/failure
  - Retry same layout / Edit layout
- multiple solutions: 기존 `서로 다른 successful solution 2개` 계약 유지.
- no new mechanic.
- no mandatory scripted failure.

## 7. Failure-learning / Debrief contract

첫 세션의 실패는 벌점 화면이 아니라 **다음 설계를 만드는 관찰**이어야 한다.

이번 Slice는 `SX-DEC-056A`의 원리를 재사용하되 전체 Route Probe/PB/Fingerprint 구현을 끌어오지 않는다.

### Minimal actual-event debrief

결과 화면에서 solver 없이 실제 발생한 첫 causal contradiction 하나만 보여준다.

Examples:

```text
B역 도착 · TOP=A → 하역하지 못함
ROUTE_END · 미배송 A 1개
TIMEOUT · 미배송 B 1개
```

Rules:
- 실제 runtime event만 사용한다.
- 추천 경로, 다음 switch 정답, 최적 적재 순서를 제시하지 않는다.
- board의 관련 station/cargo/TOP을 같은 semantic identity로 강조할 수 있다.
- `Retry same layout`과 `Edit layout`을 모두 유지한다.
- 성공 결과에서는 정답 해설 대신 `다른 해법도 가능` 정도의 재설계 여지만 남긴다.

Disposition:
- `SX-DEC-056A_FULL`: implementation authority remains NOT_GRANTED.
- `MINIMAL_ACTUAL_EVENT_DEBRIEF_FOR_SLICE`: new `SX-DEC-059` validation-slice consumer requirement.
- domain logic duplication: FORBIDDEN.

## 8. Decision-screen information hierarchy

### BUILD

1. Board / buildable state
2. 현재 목표 화물·역 관계
3. Track tool + placement validity
4. current build cost / preflight
5. Stack는 아직 비활성/비강조
6. RUN 시작 CTA

### RUN

1. Train + current route
2. Stack + TOP
3. manual/auto load state
4. switch selected/locked state
5. remaining cargo + time
6. build tools are unavailable/collapsed

### RESULT

1. SUCCESS / FAILURE reason
2. actual-event causal debrief when applicable
3. remaining cargo / relevant TOP state
4. Retry same layout
5. Edit layout
6. secondary return/title

점수·랭킹·Daily/Weekly·Mastery는 Slice Result의 1차 정보 위계에서 제외한다.

## 9. Visual requirement inventory

이미지 생성은 이번 작업 범위가 아니다. 필요한 시각 자료를 먼저 inventory한다.

| ID | Type | Decision supported | Priority | Consumer | Status |
|---|---|---|---|---|---|
| `VIS-SX-059-01` | FLOW | T1~T6→Capstone 전체 첫 세션 흐름 | P0 | planning / Notion Flow | TEXT/MERMAID FIRST |
| `VIS-SX-059-02` | UI_SCREEN | Capstone RUN 정보 위계 | P1 | Godot UI implementation | BRIEF_REQUIRED · NOT_GENERATED |
| `VIS-SX-059-03` | UI_SCREEN | Failure actual-event Debrief | P1 | result UI | BRIEF_REQUIRED · NOT_GENERATED |
| `VIS-SX-059-04` | STORYBOARD | T1~T6 단계적 UI 노출 | P2 | tutorial content implementation | BRIEF_REQUIRED · NOT_GENERATED |

Delete test:
- `VIS-SX-059-01`: 텍스트만으로도 구현 가능하나 전체 흐름 오류 검수 때문에 유지.
- `02/03`: 정보 위계와 실제 asset 사용 판단에 시각 검토 가치가 높음.
- `04`: 01~03으로 충분하면 생성하지 않아도 됨.

## 10. Quality bar

### Controls and feedback
- 현재 core input 의미를 변경하지 않는다.
- 각 tutorial stage는 새 입력을 1개 이상 동시에 요구하지 않는다.
- 잘못된 입력은 즉시 되돌릴 수 있고, 재시작 없이 수정 가능한 경우 수정 경로를 우선한다.

### Readability
- cargo/station = color + shape + text.
- TOP은 색상만으로 구분하지 않는다.
- RUN 중 `내가 지금 바꿀 수 있는 것`과 `잠긴 것`을 같은 화면에서 구분한다.
- 화면 장식이 TOP/branch/time보다 강한 시각 우선순위를 갖지 않는다.

### Art / animation / audio
- 현재 73 semantic production assets와 `SX-DEC-055` runtime binding을 우선 재사용한다.
- 기존 `DemoEffects`/audio를 지우고 새 presentation stack을 만들지 않는다.
- pickup/unload/switch/result는 시각 + audio cue가 서로 같은 사건을 가리켜야 한다.
- Reduced Motion에서도 동일한 정보가 남는다.

### Accessibility / responsive
- Windows first validation surface에서도 eventual Android landscape의 정보 의미를 훼손하지 않는다.
- 1280×720, 1600×900, 1920×1080 existing PC contract 유지.
- localization copy는 key/data로 분리 가능한 짧은 문구만 계획한다.

## 11. Explicit exclusions

이번 Slice에서 추가하지 않는다.

- SX-DEC-056A full Route Probe / PB / Fingerprint
- SX-DEC-056B score/max-combo system
- SX-DEC-057 Yard Lab/Mastery implementation
- fast/cheap TrackPiece attribute invention
- SX-DEC-058 procedural challenge pipeline
- shareable Route Card
- editor/UGC
- leaderboard/backend
- endless/fuel/BOOST/capacity-8/cargo slowdown/pickup respawn/switch auto-reset
- Base repin
- PR #154 reusable pilot absorption/modification
- new Tool Hub / QA Evidence Studio path

## 12. Pre-build blockers and dependencies

### B1 · tooling authority drift

Observed on current main:
- actual `addons/godot_ai/plugin.cfg`: `3.1.4`
- `docs/tooling/local_godot_tooling_state.json`: still `3.1.3`
- prior PR #153 attempted reconciliation but closed unmerged.

Disposition: `PLANNING_CAN_CONTINUE · BUILD_PRECHECK_MUST_RECONCILE`.

### B2 · current v4.7 instruction sync

This chat is governed by the user-supplied v4.7 instruction. Project GitHub still points to v4.5 r2.

Disposition: do not silently pretend repository canon is already v4.7. Planning artifacts created here must name v4.7 as current user instruction evidence; repository work-instruction migration is a separate canon-sync action before implementation handoff.

### B3 · first-contact participant availability

Current reachable validation can close technical/UI/developer-self-run issues, but first-contact human evidence requires a genuinely new participant later.

Disposition: `HUMAN_USABILITY_EVIDENCE = NOT_RUN`, `PLAYER_EXPERIENCE_EVIDENCE = NOT_RUN` until that condition changes.

## 13. Five full adversarial loops

### Loop 1

Finding: T1~T6 + capstone could become a 20+ minute tutorial.

Validated: MUST_FIX for first-session representativeness.

Refine: individual time budgets + >15m warning; remove T7~T10 from this Slice.

Regression: core BUILD/LIFO/manual-auto/switch still all represented.

Better alternative search: compressed T1/T3/T6 was shorter but broke learning dependencies; rejected.

Long-term fit: T1~T6 is a prefix of the approved Tutorial 1~10, so no throwaway curriculum.

### Loop 2

Finding: copying Railbound's wordless onboarding can make LIFO opaque.

Validated: MUST_FIX because LIFO is not directly visible from track geometry.

Refine: gameplay-first + one-line contextual `TOP부터 내림` only when first required; Stack TOP gets highest semantic emphasis.

Regression: no long tutorial text wall introduced.

Better alternative: full rule popups are clearer but create reading dependency; rejected.

Long-term fit: same semantic stack language carries into campaign.

### Loop 3

Finding: forcing an intentional failure to teach Debrief could feel manipulative and mismeasure fun.

Validated: SHOULD_FIX.

Refine: no mandatory failure; Debrief activates only on actual failure.

Regression: failure-learning evidence remains available when it naturally occurs.

Better alternative: scripted failure guarantees coverage but invalidates agency; rejected.

Long-term fit: actual-event Debrief generalizes to later stages.

### Loop 4

Finding: implementing 056A to support the Slice would expand scope and duplicate future work.

Validated: MUST_FIX.

Refine: only minimal actual-event causal summary is required; it consumes existing runtime event truth, has no solver/PB/Fingerprint, and is explicitly a 059 Slice consumer requirement rather than full 056A authorization.

Regression: 056A future scope remains intact.

Better alternative: no Debrief at all reduces implementation but leaves failure learning untestable; rejected.

Long-term fit: future 056A can extend the same event seam without replacing it.

### Loop 5

Finding: automated/owner self-run can create false confidence in first-contact comprehension.

Validated: MUST_FIX evidence-ceiling issue.

Refine: TECH/UI/self-run and first-contact HUMAN/PLAYER evidence are separate; no EXPAND based on self-run alone.

Regression: current inability to run external human test does not block independent planning/implementation preparation.

Better alternative: wait for external testers before any further work wastes independent production work; rejected.

Long-term fit: exact acceptance build can later be reused for first-contact human evidence.

### Loop 6 · clean re-attack after fixes

Full re-attack result:
- new core rule: none
- approved tutorial order conflict: none
- open PR #154 overlap: none in planned tracked scope
- evidence inflation: none
- 056A duplicate authority: contained
- Android/Windows shared core conflict: none
- player-facing placeholder requirement: forbidden by quality bar
- new P0/P1 design blocker: none

`CLEAN_REVIEW_EXIT_CANDIDATE: YES` for this PLAN artifact. Runtime/player evidence remains explicitly NOT_RUN and therefore implementation/product validation is not claimed complete.

## 14. Implementation-ready exit conditions for the planning package

Before any PowerShell/Codex/Godot BUILD:

1. user explicitly declares planning complete under v4.7.
2. `SX-DEC-059` is synchronized to GitHub structured canon and Project Notion.
3. v4.7 work-instruction authority drift is resolved or explicitly bounded for the handoff.
4. Godot AI 3.1.4 tooling state drift is reconciled.
5. PR #154 remains protected/read-only or is already completed and only merged-main results are consumed.
6. exact first-session stage data/content contract is closed.
7. P0/P1 UI visual briefs are reviewed; image generation remains separate explicit-user action.
8. acceptance criteria and RED-first tests are specified.

Until then: `BUILD_NOT_AUTHORIZED`.

## 15. Revisit conditions

Re-open the selected approach if any occurs:

- developer self-run consistently exceeds 15 minutes before capstone result;
- T3 LIFO cannot be understood without repeated explanatory text;
- T4/T5 manual-auto distinction has no meaningful player choice;
- capstone can be solved without understanding LIFO or switch state;
- current 73 assets cannot support required information hierarchy without replacement;
- first-contact human evidence later shows repeated causal misunderstanding;
- new merged-main reusable module results materially reduce implementation cost without changing project authority.
