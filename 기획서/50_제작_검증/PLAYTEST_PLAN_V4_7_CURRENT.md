# Playtest Plan · v4.7 Current Authority Wrapper

```yaml
status: CURRENT_V4_7_PLAYTEST_AUTHORITY
base_research_contract: 기획서/50_제작_검증/PLAYTEST_PLAN.md
sx_dec_059_delta: 기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md
product_authority: GMB-002 · SX-DEC-027~059
user_planning_complete: GRANTED · 2026-08-20 KST
sx_dec_059_implementation: MERGED_MAIN_VERIFIED · PR_158
sx_dec_059_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
notion_post_merge_readback: PASS
five_person_gate_changed: false
human_evidence: NOT_RUN
```

이 문서는 기존 `PLAYTEST_PLAN.md`의 상세 연구 방법·severity·threshold·session evidence 형식을 삭제하거나 재작성하지 않고, **v4.7 / SX-DEC-059에서 무엇이 current인지**만 덧씌우는 thin wrapper다.

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
→ developer self-run / screen QA
→ exact acceptance build identity
→ reviewed physical smoke on that same build
→ Five-person first-contact comprehension
→ evidence review
→ EXPAND / REWORK / REPEAT_SLICE / HOLD / STOP
```

자동화/export/developer self-run은 human/player-experience PASS가 아니다.

## 4. Platform interpretation

기존 `PLAYTEST_PLAN.md`의 historical Android validation APK와 Android-oriented evidence는 역사/플랫폼 evidence로 보존한다.

SX-DEC-059 implementation은 PR #158로 현재 GitHub `main`에 병합됐지만:

- merged automated evidence는 developer self-run이 아니다.
- PC self-run은 Android device evidence가 아니다.
- Android physical smoke는 별도 `NOT_RUN` Gate다.
- human round의 exact platform/build identity는 실제 테스트 round를 고정할 때 기록한다.
- 동일한 learning/UI/input 의미를 테스트하는 round에서는 physical smoke와 human evidence가 같은 exact build identity를 사용한다.

현재 acceptance build/platform은 `UNASSIGNED`다.

## 5. Current status

```yaml
sx_dec_059_implementation: MERGED_MAIN_VERIFIED
implementation_merge_pr: 158
implementation_merge_main: 162e8a0a5e8ddc8472e74a6152e87dc12008e34c
notion_post_merge_readback: PASS
developer_self_run: NOT_RUN
acceptance_build: UNASSIGNED
physical_smoke: NOT_RUN
windows_physical: NOT_RUN
android_device: NOT_RUN
five_person_comprehension: NOT_RUN
player_experience: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## 6. Current next action

```text
developer self-run / screen QA
→ record exact acceptance build identity when physical validation is prepared
→ same-build physical smoke
→ first-contact human round
```

No PASS claim may exceed this evidence ceiling.
