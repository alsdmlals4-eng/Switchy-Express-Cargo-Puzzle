# Grill Me 10건 배치 병합 프로토콜

```yaml
protocol_id: SX-OPS-001
evidence_id: EV-USER-005
status: ACTIVE · GMB001_CLOSED
owner: PROJECT_OWNER + PLANNING_AGENT
batch_size: 10_GRILL_ME_APPROVALS
completed_catch_up: CATCH-UP-001 · SX-DEC-014~016
completed_batch: GMB-001 · SX-DEC-017~026
canonical_decision_merge: 9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496
sheet: SYNCED · 12_TABS_READBACK_PASS
implementation_merge_policy: NO_PRODUCT_IMPLEMENTATION_UNLESS_SEPARATELY_APPROVED
next_batch: NOT_STARTED
```

## 1. 목적

Grill Me는 한 건씩 승인하지만 10건을 하나의 canonical batch로 병합한다. 대화에만 승인이 남는 문제와 한 건마다 main·Sheet·Closure를 반복하는 문제를 동시에 방지한다.

## 2. 완료된 Batch

| Batch | 범위 | 승인 | 상태 | Canonical PR/SHA | Sheet | Closure |
|---|---|---:|---|---|---|---|
| CATCH-UP-001 | SX-DEC-014~016 | 3/3 | CLOSED | #27 / `3cd13ff...` | SYNCED | 완료 |
| GMB-001 | SX-DEC-017~026 | 10/10 | CLOSED | #29 / `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496` | SYNCED · 12탭 PASS | 완료 |

GMB-001은 제품 코드·Scene·Resource·asset·runtime data를 변경하지 않았다.

## 3. GMB-001 Closure Evidence

- exactly `SX-DEC-017~026`
- exactly `EV-USER-006~015`
- no `SX-DEC-027`
- current consumers repaired
- VS local scope와 Production/online UGC scope 분리
- pre-merge audit known P0/P1 0
- final branch head behind 0
- 33 changed files, planning-only
- product files 0
- Project Contract run 195 success
- Godot Tests run 186 success
- unresolved review threads 0
- REQUEST_CHANGES 0
- expected-head protected squash merge
- correct Sheet canonical SHA 반영
- Sheet 12-tab readback PASS
- historical rows preserved
- `30_세계_서사` unchanged
- wrong `19Ff...` Sheet untouched

## 4. Evidence Boundary

GMB-001 closure가 증명하지 않는 항목:

```yaml
product_implementation: NOT_STARTED
runtime_features: NOT_RUN
android: NOT_RUN
human: NOT_RUN
localization_accessibility: NOT_RUN
economy_simulation: NOT_RUN
official_map_target_3: NOT_RUN
official_map_target_100: NOT_RUN
F58: NOT_MET
ugc_editor_backend: NOT_STARTED
moderation_privacy_two_account: NOT_RUN
community_anti_abuse: NOT_RUN
codex_state: CODEX_NOT_READY
```

Planning synchronization is not implementation success.

## 5. 다음 Batch 규칙

다음 batch는 자동으로 시작하지 않는다.

시작 시:

1. 사용자 작업에서 새로운 material Decision을 확인한다.
2. 새 batch ID를 부여한다.
3. count를 `0/10`으로 시작한다.
4. 별도 branch·Draft PR·Sheet pending 상태를 만든다.
5. 이전 GMB-001 history와 Decision SHA를 변경하지 않는다.

## 6. 일반 승인 흐름

각 승인 직후:

1. Decision/Evidence ID 확정.
2. batch branch·Draft PR에 spec/plan/ledger 기록.
3. 같은 ID를 올바른 Sheet에 기록.
4. `APPROVED_PENDING_BATCH_MERGE`.
5. 제품 구현은 별도 승인 없으면 변경하지 않는다.

10번째 승인:

```text
freeze
→ full GitHub/PR/Issue/canon/Sheet audit
→ expected-head canonical merge
→ Sheet canonical SHA/readback
→ Sync Closure PR
→ batch CLOSED
```

## 7. Freeze 검사

- 승인 의미 왜곡
- Decision 충돌·consumer 누락
- UI/animation/tutorial authority 침범
- runtime/Android/human/online evidence 과장
- 제품 변경 잠입
- 역사 손실
- GitHub/Sheet drift
- identity/replay/idempotency 실패
- VS scope를 온라인 플랫폼 범위로 폭증
- UGC official progression/economy 오염
- moderation/privacy/anti-abuse 준비 과장

P0/P1은 병합 전 수정한다. 실제 검증이 필요한 항목은 `NOT_RUN`으로 후속 Gate에 넘긴다.

## 8. 정본

- `GMB-001_DECISION_LEDGER.md`
- `GMB-001_PREMERGE_AUDIT.md`
- `../00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`
- `../00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`

## 9. 현재 다음 단계

```text
GMB-001 CLOSED
→ G3P Definition of Ready review
→ explicit READY_FOR_BUILD approval
```

`CODEX_NOT_READY` remains until explicit promotion.
