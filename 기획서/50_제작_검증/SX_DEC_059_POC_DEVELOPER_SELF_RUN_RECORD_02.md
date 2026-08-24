# SX-DEC-059 · Playable POC Developer Self-Run Record 02

Date: `2026-08-24 KST`  
Status: `NOT_RUN · READY_TO_EXECUTE`

```yaml
candidate_id: SX59-POC-ACCEPT-002
artifact_evidence_owner: evidence/acceptance/sx59_poc_accept_002_artifact.json
candidate_zip_sha256: 16c81f9b42a3391a2a3dabf501cb2d6eb7e011682abdaa3f79eb8b1124836e55
candidate_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
candidate_pck_sha256: d48fe09796954f3b4f836d092b4184cb0ac33bc6f1f3b96f52166e2d6760aa0f
verdict: NOT_RUN
candidate_promotion: BLOCKED_BY_DEVELOPER_SELF_RUN
windows_physical_runtime: NOT_RUN
audio_perceptual_qa: NOT_RUN
player_experience: NOT_RUN
```

## Evidence reconciliation note

기존 record의 `c0a785...` ZIP anchor는 fresh GitHub Actions API + artifact 재다운로드와 일치하지 않아 폐기했다. 현재 self-run 대상은 machine-readable evidence owner에 고정된 content digest로만 식별한다.

Artifact ID/name/expiry는 retention에 따라 가용성이 달라지는 delivery metadata이며 self-run 판정의 장기 identity가 아니다. 실제 실행 전 확보한 ZIP/EXE/PCK가 위 digest와 모두 일치하지 않으면 **실행하지 않고 BLOCKED_PACKAGE_IDENTITY**로 기록한다.

## 사용 규칙

- 실제 `SwitchyExpressVerticalSlice.exe` 화면을 보면서 수행한다.
- 자동 테스트 결과를 self-run 결과로 복사하지 않는다.
- 각 Scenario에서 `PASS / FAIL / BLOCKED`와 관찰 사실을 기록한다.
- 해결법을 미리 보지 않고 first-session이 스스로 안내하는지 확인한다.
- 이미지 누락, UI clipping, 잘못된 icon/result art도 blocker로 기록한다.
- 실제 청취에서 cue 식별성·볼륨·반복 피로도를 별도 기록한다. 코드상 audio cue 존재만으로 perceptual audio PASS를 주장하지 않는다.

## Scenario 1 · T1→T6→Capstone happy path

```yaml
status: NOT_RUN
progression_dead_end: NOT_RUN
visual_readability: NOT_RUN
input_readability: NOT_RUN
audio_readability: NOT_RUN
notes: ""
```

확인: 레슨 `1 / 7`부터 진행해 설명 없이 Capstone까지 도달 가능한가.

## Scenario 2 · T3 wrong LIFO → Edit → recovery

```yaml
status: NOT_RUN
failure_reason_understood: NOT_RUN
edit_recovery: NOT_RUN
notes: ""
```

확인: 잘못된 적재 순서가 자연스럽게 실패하고 Result에서 노선/판단 수정으로 이어지는가.

## Scenario 3 · T4 overloading → selective non-load recovery

```yaml
status: NOT_RUN
selective_non_load_understood: NOT_RUN
solution_reveal_absent: NOT_RUN
notes: ""
```

확인: “안 싣는 것도 선택”이라는 학습이 텍스트만이 아니라 플레이로 이해되는가.

## Scenario 4 · T5 Auto ON → OFF decision

```yaml
status: NOT_RUN
auto_state_visible: NOT_RUN
decision_timing_clear: NOT_RUN
notes: ""
```

확인: Auto 상태가 시각적으로 보이고, 필요한 지점에서 OFF로 전환하는 이유가 읽히는가.

## Scenario 5 · T6 switch preselection / occupied lock

```yaml
status: NOT_RUN
switch_direction_visible: NOT_RUN
occupied_lock_understood: NOT_RUN
notes: ""
```

확인: 운행 중 분기 선택과 점유 lock의 차이가 플레이어에게 명확한가.

## Scenario 6 · Capstone Retry Same Layout

```yaml
status: NOT_RUN
same_layout_preserved: NOT_RUN
result_feedback_clear: NOT_RUN
notes: ""
```

확인: 결과 화면의 성공/실패 visual과 `Retry`가 같은 설계를 다시 실행한다는 의미가 명확한가.

## Scenario 7 · Capstone Edit Layout

```yaml
status: NOT_RUN
edit_returns_to_build: NOT_RUN
layout_edit_intent_clear: NOT_RUN
notes: ""
```

확인: `Edit`가 재실행이 아니라 계획 수정으로 돌아간다는 차이가 명확한가.

## Scenario 8 · Reduced Motion same-information

```yaml
status: NOT_RUN
same_information_identity: NOT_RUN
critical_cue_missing: NOT_RUN
notes: ""
```

확인: motion 감소 상태에서도 cargo/TOP/switch/result의 판단 정보가 유지되는가.

## Audio perceptual QA · cross-scenario

```yaml
button_build_remove_distinguishable: NOT_RUN
switch_cue_readable: NOT_RUN
pickup_unload_distinguishable: NOT_RUN
success_failure_distinguishable: NOT_RUN
train_loop_fatigue: NOT_RUN
speaker_headphone_level_balance: NOT_RUN
```

현재 runtime에는 generated cue와 train loop가 구현돼 있지만, 위 항목은 실제 청취 없이는 PASS로 승격하지 않는다.

## POC 공통 blocker 기록

```yaml
progression_dead_end: NOT_RUN
hidden_command_bypass: NOT_RUN
raw_localization_key: NOT_RUN
player_facing_placeholder: NOT_RUN
crash_or_script_error: NOT_RUN
critical_image_missing: NOT_RUN
critical_ui_clipping: NOT_RUN
critical_audio_ambiguity: NOT_RUN
unsupported_evidence_claim: NOT_RUN
p0_p1_blocker_count: NOT_RUN
```

## Promotion rule

8개 Scenario가 모두 실행되고 package identity가 일치하며 P0/P1 blocker가 0일 때만 candidate 002를 exact acceptance build로 지정한다.

```yaml
candidate_promotion: BLOCKED_BY_DEVELOPER_SELF_RUN
acceptance_build: NOT_YET_DESIGNATED
```
