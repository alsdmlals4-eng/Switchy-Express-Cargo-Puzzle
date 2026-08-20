# SX-DEC-059 · First-Session Playtest Delta

```yaml
owner_decision: SX-DEC-059
base_playtest_authority: 기획서/50_제작_검증/PLAYTEST_PLAN.md
status: DELTA_CONTRACT_CURRENT · HUMAN_EVIDENCE_NOT_RUN
new_research_framework: false
five_person_gate_changed: false
implementation_authority: NOT_GRANTED
```

## 원칙

기존 `PLAYTEST_PLAN`의 다음 권위를 그대로 재사용한다.

- exact acceptance build identity
- physical smoke before human comprehension
- Five-person Comprehension minimum 5 analyzable first-contact sessions
- behavior → prediction → explanation → transfer
- neutral moderator probe
- intervention contamination
- color+shape+text accessibility observation
- Retry/Edit causal understanding

059는 release-near 첫 세션이 추가되므로 **lesson-specific observation만** 더한다.

## 증거 단계

```text
AUTOMATED CONTRACT
→ developer self-run / screen QA
→ exact acceptance build + physical smoke
→ first-contact Five-person Comprehension
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

자동화와 개발자 self-run은 HUMAN/PLAYER EXPERIENCE PASS가 아니다.

## Developer self-run gate

외부 first-contact 전에 implementation blocker를 제거하기 위한 내부 검증.

최소 시나리오:

1. T1→T6→Capstone happy path.
2. T3 LIFO wrong-order natural failure → Edit → recovery.
3. T4 first-pass overloading → recovery without solution reveal.
4. T5 Auto ON 후 decision segment 전에 OFF.
5. T6 switch occupied-lock observation + successful preselection.
6. Capstone same-layout Retry path.
7. Capstone Edit-layout path.
8. Reduced Motion same-information path.

Self-run에서 확인:
- progression dead-end 0
- hidden command bypass 0
- untranslated raw key 0
- player-facing placeholder 0
- crash/script error 0
- unsupported evidence claim 0

## Lesson-specific human observations

| ID | Lesson | Observation | 성공 신호 | 실패/재설계 신호 |
|---|---|---|---|---|
| `SX59-FS-01` | T1 | BUILD 다음 행동 찾기 | 10초 내 새 도구/board 행동 시작 | toolbar/board 의미 탐색 장기 정지 |
| `SX59-FS-02` | T1 | preflight 이해 | 문제 cell/connection을 설명 없이 수정 | Start 버튼만 반복 시도 |
| `SX59-FS-03` | T2 | manual pickup prerequisite | cue 후 직접 Load 입력으로 pickup | cargo를 반복 통과하고 pickup 원인 이해 못함 |
| `SX59-FS-04` | T2 | cargo↔station identity | station 도착 전 matching을 예측 | 색상 하나에만 의존하거나 station 의미 혼동 |
| `SX59-FS-05` | T3 | TOP prediction | station 전 TOP cargo를 예측 | unload 후에만 규칙을 사후 설명 |
| `SX59-FS-06` | T3 | reverse planning transfer | 실패 후 BUILD encounter order를 수정 | manual skip/정답 표시만 찾음 |
| `SX59-FS-07` | T4 | intentional non-load | 첫 통과 skip을 선택으로 사용 | 모든 cargo에서 습관적으로 Load 유지 |
| `SX59-FS-08` | T4 | revisit model | skip cargo가 남아 있음을 이해하고 재방문 | skip=분실/실패로 오해 |
| `SX59-FS-09` | T5 | auto convenience model | safe segment에서 Auto 활용 | Auto를 항상 켜야 하는 정답으로 오해 |
| `SX59-FS-10` | T5 | auto-off decision | ordering-sensitive 구간 전에 OFF 고려 | Auto 때문에 unwanted pickup 후 원인 미인지 |
| `SX59-FS-11` | T6 | switch state prediction | train 도착 전 선택 경로 예측 | 열차 직접 조종 버튼처럼 오해 |
| `SX59-FS-12` | T6 | occupied lock | lock을 일시적 점유 상태로 이해 | 영구 고장/비활성으로 오해 |
| `SX59-FS-13` | Capstone | independent core proof | 새 설명 없이 BUILD/LIFO/load/switch 사용 | 이전 lesson cue를 계속 기다림 |
| `SX59-FS-14` | Result | Retry vs Edit | 실패 유형에 따라 의도적으로 선택 | 두 버튼 차이 예측 못함 |
| `SX59-FS-15` | Session | replay desire | 다른 route/order 시도 의사 또는 실제 재시도 | 성공 즉시 구조적 선택이 없었다고 느낌 |

## Timing · diagnostic only

시간은 PASS 단독 기준이 아니다.

```yaml
first_meaningful_action_target: <=10s after gameplay surface appears
recommended_session: 8~12m
soft_range: 7~15m
warning: >15m before first Capstone result
```

느리더라도 고민이 명확하고 자발적이면 무조건 FAIL이 아니다. 반대로 빨라도 무작위 클릭/힌트 의존이면 이해 PASS가 아니다.

## Hint evidence

각 lesson에서 기록:

```yaml
hint_tier_used: 0 | 1 | 2
hint_requested_by_player: bool
hint_triggered_by_repeated_failure: bool
independent_after_hint: bool
```

- Tier 0 성공이 가장 강한 독립 evidence.
- Tier 1/2 사용은 실패가 아니라 friction signal.
- moderator가 정답 행동을 직접 알려주면 해당 observation은 `INTERVENTION_CONTAMINATED`.

## Minimal event/telemetry schema candidate

기술 구현 여부와 별개로 QA evidence는 아래 event identity를 기록 가능해야 한다.

```text
fs_lesson_enter
fs_context_cue_shown
fs_hint_requested
fs_preflight_pass
fs_cargo_contact
fs_cargo_pickup
fs_manual_load_state_changed
fs_auto_load_toggled
fs_station_unload
fs_switch_state_changed
fs_switch_locked_attempt
fs_terminal
fs_retry_same_layout
fs_edit_layout
fs_lesson_complete
fs_capstone_complete
```

필드 후보:

```yaml
session_alias:
build_identity:
lesson_id:
attempt_serial:
elapsed_since_lesson_start:
event_name:
phase:
manual_load_active:
auto_load_active:
stack_size:
remaining_map_cargo:
failure_reason:
hint_tier:
```

개인정보, free-text player content, exact optimal solution capture는 요구하지 않는다.

## Decision gate

### EXPAND
- core causal model을 신규 first-contact가 반복 예측/전이.
- P0/P1 usability blocker 0.
- Retry/Edit 의미 이해.
- shipping-intent UI/audio/VFX가 핵심 판단을 방해하지 않음.

### REWORK
- core는 이해되지만 특정 lesson/UI/copy/input friction이 반복.

### REPEAT_SLICE
- sample contamination, build identity drift, lesson sequence 변경 등으로 evidence가 대표적이지 않음.

### HOLD
- exact physical build/device/recruit condition 미충족.

### STOP
- 충분한 iteration 뒤에도 핵심 `선로→적재순서→LIFO→재설계` 인과가 반복적으로 이해되지 않거나 매력이 형성되지 않음.

현재 사람 판정: `NOT_RUN`.
