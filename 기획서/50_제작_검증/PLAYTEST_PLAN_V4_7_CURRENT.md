# Playtest Plan · v4.7 Historical Authority Wrapper

```yaml
status: HISTORICAL_PRE_SX_DEC_060_PLAYTEST_WRAPPER · NOT_CURRENT_AUTHORITY
base_research_contract: 기획서/50_제작_검증/PLAYTEST_PLAN.md
sx_dec_059_delta: 기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md
successor_current_authority: 기획서/50_제작_검증/PLAYTEST_PLAN.md#current-phase-5-scope--sx-dec-060061
product_authority: GMB-002 · SX-DEC-027~059
user_planning_complete: GRANTED · 2026-08-20 KST
sx_dec_059_implementation: MERGED_MAIN_VERIFIED · PR_158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
notion_post_merge_readback: PASS
acceptance_candidate: SX59-ACCEPT-001 · PREPARED
acceptance_candidate_owner: 기획서/50_제작_검증/SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md
developer_self_run_record: 기획서/50_제작_검증/SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md
five_person_gate_changed: false
human_evidence: NOT_RUN
```

이 문서는 기존 `PLAYTEST_PLAN.md`의 상세 연구 방법·severity·threshold·session evidence 형식을 삭제하거나 재작성하지 않고, **v4.7 / SX-DEC-059 당시 무엇이 current였는지**를 보존하는 thin wrapper다. SX-DEC-060/061 이후 current Phase 5 실행 상태와 candidate identity는 이 문서를 사용하지 않고 base research contract의 `Current Phase 5 scope`를 사용한다.

## 1. Preserved base contract

다음은 기존 `PLAYTEST_PLAN.md`를 그대로 재사용한다.

- exact acceptance build identity.
- human study 전 same-build physical smoke.
- minimum 5 analyzable first-contact sessions.
- behavior → prediction → explanation → transfer.
- neutral moderator probe.
- solution coaching prohibition.
- `INTERVENTION_CONTAMINATED` 분리.
- color + shape + text / TOP / switch accessibility observation.
- Retry vs Edit causal understanding.
- threshold: N=5일 때 4/5, N>=6일 때 `ceil(N×0.8)`.
- P0/P1 unresolved finding 0 for PASS.
- build identity change가 learning target에 영향을 주면 human evidence 자동 승계 금지.
- 개인정보 최소화 / public repo에 raw video/audio 업로드 불필요.

## 2. SX-DEC-059 additive observations

`SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`의 `SX59-FS-01~15`를 base observation과 함께 사용한다.

특히:

```text
T1 preflight self-correction
T2 manual pickup prerequisite + cargo/station identity
T3 TOP prediction + BUILD reverse planning
T4 intentional non-load + revisit model
T5 auto convenience + auto-off decision
T6 switch prediction + occupied lock
Capstone independent transfer
Result Retry/Edit distinction
Session replay/replan desire
```

## 3. Evidence sequence

```text
AUTOMATED CONTRACT: PASS · MERGED_MAIN_VERIFIED
→ acceptance candidate integrity: PASS · SX59-ACCEPT-001
→ developer self-run / screen QA: NOT_RUN
→ exact acceptance build designation: BLOCKED_BY_SELF_RUN
→ reviewed physical smoke on that same build: NOT_RUN
→ Five-person first-contact comprehension: NOT_RUN
→ evidence review
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

자동화/export/developer self-run은 human/player-experience PASS가 아니다. `SX59-ACCEPT-001`은 후보 artifact이며 self-run 전에는 정식 acceptance build가 아니다.

## 4. Acceptance candidate

v4.7 당시 Windows candidate:

```yaml
candidate_id: SX59-ACCEPT-001
artifact_workflow_run: 32489922889 · Windows Demo Export #257
artifact_id: 9449351686
artifact_zip_sha256: 30bd8ce9f2e057bede06145c4ff05d46a0cfdb04e239e55f45547862dc3b0264
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: f8c8f805fe8475a87a3fd5c93a3c461aedc40068d2d43932cfddd44e44ef25b6
artifact_integrity: PASS
package_runtime_json: PASS · parsed_json=26
candidate_status: PREPARED · PENDING_DEVELOPER_SELF_RUN
```

상세 hash/provenance/invalidating condition은 `SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md`가 소유한다.

## 5. Platform interpretation

기존 `PLAYTEST_PLAN.md`의 historical Android validation APK와 Android-oriented evidence는 역사/플랫폼 evidence로 보존한다.

SX-DEC-059 implementation은 PR #158로 당시 GitHub `main`에 병합됐지만:

- merged automated evidence는 developer self-run이 아니다.
- Windows artifact integrity PASS는 Windows physical runtime PASS가 아니다.
- PC self-run은 Android device evidence가 아니다.
- Android physical smoke는 별도 `NOT_RUN` Gate다.
- human round의 exact platform/build identity는 실제 테스트 round를 고정할 때 기록한다.
- 동일한 learning/UI/input 의미를 테스트하는 round에서는 physical smoke와 human evidence가 같은 exact build identity를 사용한다.

## 6. Historical v4.7 status

```yaml
sx_dec_059_implementation: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
notion_post_merge_readback: PASS
acceptance_candidate: SX59-ACCEPT-001 · PREPARED
candidate_integrity: PASS
developer_self_run: NOT_RUN
acceptance_build: NOT_YET_DESIGNATED · BLOCKED_BY_SELF_RUN
physical_smoke: NOT_RUN
windows_physical: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## 7. Historical v4.7 next action

```text
execute SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md on SX59-ACCEPT-001
→ if PASS, designate exact Windows acceptance build
→ same-build physical smoke
→ first-contact human round
```

No PASS claim may exceed this evidence ceiling.
