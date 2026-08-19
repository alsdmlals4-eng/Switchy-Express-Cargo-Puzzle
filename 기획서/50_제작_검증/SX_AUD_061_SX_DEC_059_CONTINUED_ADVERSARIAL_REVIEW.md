# SX-AUD-061 · SX-DEC-059 Continued Adversarial Review

```yaml
audit_id: SX-AUD-061
related_decision: SX-DEC-059
status: REVIEW_CONTINUES · ONE_USER_DECISION_BLOCKER
baseline_main: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
protected_open_pr: "#154 · READ_ONLY"
minimum_five_loops: SATISFIED_EARLIER
clean_exit: NOT_YET · GM-SX059-01_PENDING
```

## Why review continued after the initial five loops

초기 설계 문서의 1~5회 검토 뒤 코드/데이터를 더 깊게 읽었고, 새 유효 finding이 발견됐다. v4.7 계약상 최소 횟수 뒤에도 finding이 생기면 clean 상태가 될 때까지 #6..N을 계속해야 하므로 기존 `CLEAN_REVIEW_EXIT_CANDIDATE`를 최종 PASS로 사용하지 않는다.

## Loop 7 · Tutorial order vs actual loading state

### Attack

T2는 cargo/station을 가르치고 T4는 manual loading을 가르치는데 실제 input state는 manual=false, auto=false로 시작한다. T2가 load action을 모르고 run하면 pickup이 발생하지 않는다.

### Validate

`MUST_FIX · PLANNING_CONFLICT`.

현재 코드 truth:

```text
_manual_load_active = false
_auto_load_enabled = false
should_load_on_contact = auto || manual
```

### Alternatives

1. A · prerequisite action early / strategy later
2. B · tutorial-only auto assist
3. C · preloaded stack
4. D · curriculum reorder

### Recommended minimal refinement

A.

- T2: pickup에 필요한 manual action만 just-in-time 소개.
- T4: 일부 cargo를 의도적으로 skip하는 selective manual strategy를 학습.

### Verify / regression

- manual default 보존
- auto toggle 의미 보존
- Tutorial learning-goal order 보존 가능
- domain API 추가 불필요

### Better-alternative search

B/C/D 모두 실질 대안이나 false mental model, 새 domain state, canon reorder 비용이 더 크다.

### Long-term fit

T2 prerequisite→T4 strategy의 progressive disclosure는 campaign에서도 동일 manual-load contract를 재사용한다.

### State

`GM-SX059-01 · USER_DECISION_REQUIRED`.

## Loop 8 · Debrief claim exceeds current runtime evidence

### Attack

초기 059 예시 `B역 도착 · TOP=A → 하역하지 못함`은 현재 result summary만으로 자동 생성할 수 있는가?

### Validate

`MUST_FIX`.

Current `FiniteRunSummary` only owns:
- outcome
- failure_reason
- time fields
- remaining_map_cargo
- stack_size

Station mismatch detail은 056A planned observational fields가 필요하며 현재 구현되지 않았다.

### Refine

059 기본 Debrief를 evidence-safe summary로 축소:

```text
ROUTE_END · 맵에 남은 화물 N · 열차에 실린 화물 N
TIME_EXPIRED · 맵에 남은 화물 N · 열차에 실린 화물 N
```

### Regression

- 실패 원인 유형은 실제 runtime truth.
- Retry/Edit 학습 루프 유지.
- 056A station observation/PB/Fingerprint scope 선점 없음.

### Better alternative

Station mismatch detail을 위해 056A 일부를 지금 구현하는 안은 더 풍부하지만 scope creep이므로 reject.

### Long-term fit

056A가 나중에 observational event를 구현하면 동일 Result consumer를 확장 가능.

### State

`FIXED_IN_SCREEN_CONTENT_DATA_CONTRACT`.

## Loop 9 · T1 no-cargo stage cannot close on current finite success

### Attack

T1을 cargo/station 없이 별도 RUN stage로 만들면 current finite run success가 가능한가?

### Validate

`MUST_FIX DESIGN ASSUMPTION`.

Current run success는 final delivery commit으로 결정되며, zero-delivery tutorial-only success owner는 current core에 없다. 별도 fake success를 추가하면 domain을 왜곡한다.

### Alternatives

1. T1/T2 shared map, T1=BUILD/preflight lesson, T2=same-layout RUN.
2. tutorial-only fake train preview.
3. new zero-cargo run-success rule.

### Refine

1 selected.

T1/T2 같은 맵:

```text
T1 connect → preflight pass
→ layout preserved
→ T2 load cue + run
→ delivery success
```

### Regression

- finite success rule untouched
- T1 learning goal before T2 preserved
- first actual RUN reward moves to T2

### Better alternative

Fake preview/new success rule are more complex and lower evidence integrity.

### Long-term fit

Learning goal와 map을 1:1로 묶지 않는 sidecar 구조는 later tutorials에도 재사용 가능.

### State

`FIXED_IN_SCREEN_CONTENT_DATA_CONTRACT`.

## Loop 10 · Progressive disclosure can be bypassed by keyboard

### Attack

HUD button을 숨겨도 current DesktopInputAdapter가 direct command를 보낼 수 있다. Tutorial에서 hidden system을 shortcut으로 사용하면 learning evidence가 오염된다.

### Validate

`MUST_FIX`.

### Refine

`StagePolicy`가 UI visibility와 `allowed_commands`를 동시에 소유하고 ProductFiniteSlice dispatch boundary에서 input adapter 종류와 무관하게 동일 policy를 적용한다.

### Regression

- domain command semantics unchanged
- outside FirstSessionDirector에서는 policy가 neutral allow-current-core로 동작
- future Android touch도 same allowed-command contract 사용

### Better alternative

keyboard 자체를 tutorial에서 비활성화하는 방식은 PC accessibility/normal controls를 왜곡하므로 reject.

### Long-term fit

platform-neutral command policy는 Windows/Android shared-core 방향과 맞음.

### State

`FIXED_IN_SCREEN_CONTENT_DATA_CONTRACT`.

## Loop 11 · Copy/localization drift

### Attack

Current scene/HUD에 Korean/English literal이 혼재한다. 새로운 tutorial copy를 literal로 더 추가하면 v4.7 4-language contract와 향후 번역 비용이 악화된다.

### Validate

`SHOULD_FIX_NOW_AT_PLANNING_BOUNDARY`.

### Refine

- 새 first-session copy는 key로 계획.
- touched surface만 최소 localization owner 도입 후보.
- existing entire repo literal을 059에서 대량 migration하지 않음.

### Regression

- scope explosion 없음
- ko current fallback 보존 가능
- en/ja/zh-* expansion seam 확보

### Better alternative

기존 모든 UI를 동시에 localization migration하는 안은 unrelated refactor이므로 reject.

### Long-term fit

first-session key contract는 later campaign tutorial copy가 같은 owner를 확장할 수 있음.

### State

`PLANNED · exact implementation owner to close before BUILD`.

## Loop 12 · Whole-state re-attack

### Authority
- v4.7 chat authority vs repo v4.5 r2 drift: known BUILD blocker, not hidden.
- Godot AI 3.1.4 vs tooling state 3.1.3: known BUILD blocker.
- PR #154: read-only, no edits/absorption.

### Product
- GMB-002 unchanged.
- no endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset revival.
- 056/057/058 implementation not implicitly authorized.

### Player experience
- representative loop present.
- first RUN starts in T2 rather than T1, but T1 BUILD action leads directly into T2 same-layout result.
- no forced failure.
- failure debrief evidence inflation fixed.
- HUMAN/PLAYER evidence still NOT_RUN.

### Data / architecture
- tutorial metadata stays out of map schema.
- current map schema/core reused.
- new onboarding owner has independent responsibility.
- hidden-command bypass addressed by StagePolicy.

### Visual/UI
- existing 73 semantic assets first.
- no image generated yet.
- P1 visual briefs still pending after exact content lock.

### Remaining finding

Exactly one material planning decision remains:

```yaml
GM-SX059-01:
  question: T2에 manual pickup prerequisite action을 미리 노출하고 T4에서 selective strategy를 가르칠 것인가?
  recommended: A
  status: USER_DECISION_REQUIRED
```

`CLEAN_EXIT_BLOCKED_ONLY_BY_GM-SX059-01`.
