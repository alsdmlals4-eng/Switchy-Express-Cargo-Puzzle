# Result Failure Feedback Implementation Plan

```yaml
decision_id: SX-DEC-017
evidence_id: EV-USER-006
batch_id: GMB-001
batch_slot: 1/10
status: PLANNING_ONLY · APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
implementation_status: NOT_STARTED
```

## Goal

연료 0 결과 화면에 실제 run summary로 검증된 실패 원인 1개와 다음 행동 1개를 표시하되, 원인 신뢰도가 부족하면 중립 fallback을 사용한다. 결과 분석은 점수·기록·게임 종료·재시작 권위와 분리한다.

## Dependency Boundary

- 선행: VS-03A `RunState / RunController / RunSummary`와 연료·BOOST·배송 event.
- 병행: VS-03B 결과 화면·기록 저장.
- 후행: Issue #7 telemetry·soak·Android·사용자 검증.
- 온보딩 first-run assist 판은 `assisted_first_run`으로 별도 분석한다.

## Planned Files

파일명은 실제 코드 구조를 다시 확인한 뒤 조정할 수 있다.

```text
game/run/run_summary.gd
game/result/result_insight_analyzer.gd
game/result/result_insight.gd
game/result/result_view_model.gd
game/ui/result_panel.tscn
game/ui/result_panel.gd
game/telemetry/run_metrics_accumulator.gd

tests/result/test_result_insight_analyzer.gd
tests/result/test_result_view_model.gd
tests/integration/test_run_end_result_feedback.gd
tests/ui/test_result_panel_state.gd
```

## TDD Sequence

### Task 1 — RunSummary metrics contract

1. 실패하는 테스트로 immutable summary의 필수 수치를 정의한다.
2. 최소 필드:

```text
run_id
score
survival_seconds
max_combo
total_fuel_spent
boost_fuel_spent
time_with_cargo_count_6_plus
longest_delivery_gap_seconds
mismatched_station_arrivals
successful_delivery_count
assisted_first_run
```

3. 분모 0, 음수, NaN, 누락 필드의 정규화 규칙을 테스트한다.
4. 결과 분석을 위해 무제한 event history를 저장하지 않는다.

### Task 2 — Deterministic cause scoring

1. `BOOST_OVERUSE`, `HEAVY_LOAD_DELAY`, `DELIVERY_GAP`, `ROUTE_MISMATCH_LOOP`, `NEUTRAL` 경계 테스트를 먼저 작성한다.
2. 시험 임계값을 한 config/resource에 모은다.
3. 최고 score와 2위 margin 기준을 테스트한다.
4. 동일 summary 반복 호출의 cause parity를 검증한다.
5. analyzer 예외·유효하지 않은 입력은 `NEUTRAL`로 회복한다.

권장 인터페이스:

```gdscript
ResultInsightAnalyzer.analyze(summary: Dictionary) -> ResultInsight
```

`ResultInsight`는 다음만 노출한다.

```text
cause_code
cause_text_key
action_text_key
confidence_score
evidence_metrics
is_neutral_fallback
```

### Task 3 — ResultViewModel authority separation

1. core result fields와 insight fields를 분리한 ViewModel 테스트를 작성한다.
2. insight가 실패해도 score/time/max_combo/records/restart가 유지되는 테스트를 작성한다.
3. 저장 성공·실패와 insight 계산 성공·실패의 조합을 테스트한다.
4. UI animation completion이 result state를 변경하지 못하게 한다.

### Task 4 — ResultPanel presentation

1. 기본 표시가 원인 1줄+행동 1줄을 초과하지 않는 UI state 테스트를 작성한다.
2. `RESTART`를 primary action으로 유지한다.
3. Optional Details는 secondary이며 기본 flow를 막지 않는다.
4. 48dp, safe area, 긴 localization, Reduced Motion, mute, haptic-off를 검증한다.
5. 대표 상태 캡처:

```text
neutral fallback
boost overuse
heavy load delay
route mismatch
new record
long localization
```

### Task 5 — Telemetry and evidence isolation

1. `result_insight_shown` bounded event schema 테스트.
2. `assisted_first_run`과 일반 run 집계를 분리한다.
3. 원인 판정 실패·fallback·restart·details open을 기록한다.
4. telemetry 실패가 결과 화면과 재시작을 막지 않는 테스트를 작성한다.

### Task 6 — Integration and replay validation

1. fixed seed run summaries로 cause_code replay parity를 검증한다.
2. fuel-zero signal이 한 번만 발생하고 분석도 한 번만 수행되는지 확인한다.
3. restart 후 이전 insight가 다음 run으로 누출되지 않는지 확인한다.
4. 10분 soak에서 메모리·event history가 bounded인지 확인한다.

## Adversarial Review Checklist

- 원인과 상관관계를 인과로 과장하지 않는가.
- 결과 화면이 플레이어를 비난하지 않는가.
- assist 판이 일반 밸런스 원인 분포를 오염하지 않는가.
- BOOST 사용량처럼 측정 가능한 수치만 사용했는가.
- 두 후보가 비슷한데 임의로 하나를 표시하지 않는가.
- localization 누락이 restart를 막지 않는가.
- UI·animation이 저장·게임오버·원인 계산을 소유하지 않는가.
- 결과 분석을 위해 무제한 상세 로그를 저장하지 않는가.
- 원인 카드가 기본 결과 정보보다 시각적으로 우선하지 않는가.

## Acceptance Criteria

- 네 후보와 neutral fallback의 자동 경계 테스트 통과.
- 동률·저신뢰·손상 summary는 100% fallback.
- result insight 실패에도 score/time/max_combo/records/restart 정상.
- 기본 화면에는 cause 1개+action 1개만 표시.
- fixed summary replay cause parity 100%.
- Android 가로형에서 core stats·insight·RESTART가 동시에 읽힘.
- 사용자 5명 이상 검증 전에는 문구 품질을 `HUMAN_PASS`로 표시하지 않음.

## Rollback

- insight analyzer 또는 문구 품질에 문제가 있으면 `NEUTRAL_ONLY` feature flag로 전환한다.
- core result·record·restart는 analyzer와 독립적으로 유지한다.
- 임계값 변경은 config와 테스트만 조정하며 Decision 의미를 바꾸지 않는다.

현재 문서는 구현 명령이 아니다. `GMB-001` 10/10과 총기획 Gate가 닫히고 `CODEX_GOAL_VS_03.md`가 `READY_FOR_BUILD`로 승격되기 전에는 제품 코드를 변경하지 않는다.
