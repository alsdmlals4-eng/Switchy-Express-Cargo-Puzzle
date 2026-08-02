# Grill Me 10건 배치 병합 프로토콜

```yaml
protocol_id: SX-OPS-001
evidence_id: EV-USER-005
status: ACTIVE · GITHUB_SHEET_SYNCED
owner: PROJECT_OWNER + PLANNING_AGENT
batch_size: 10_GRILL_ME_APPROVALS
completed_catch_up: CATCH-UP-001 · SX-DEC-014~016
current_batch_id: GMB-001
current_batch_range: SX-DEC-017~026
current_batch_count: 10/10
current_batch_state: FROZEN · PREMERGE_ADVERSARIAL_AUDIT
implementation_merge_policy: NO_PRODUCT_IMPLEMENTATION_UNLESS_SEPARATELY_APPROVED
next_decision: BLOCKED_UNTIL_GMB001_CLOSED
```

## 1. 목적

Grill Me는 한 건씩 승인하지만 10건을 하나의 canonical batch로 병합한다. 대화에만 승인이 남는 문제와 한 건마다 main·Sheet·Closure를 반복하는 문제를 동시에 막는다.

## 2. 현재 경계

- `CATCH-UP-001 · SX-DEC-014~016`: PR #27과 Sheet 12탭 readback으로 CLOSED.
- `GMB-001`: `SX-DEC-017~026`, `EV-USER-006~015`, 정확히 10/10.
- PR #29: frozen pre-merge audit.
- 올바른 Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`.
- Sheet: 10/10 frozen readback PASS, canonical merge SHA 미기록.
- 제품 코드·Scene·Resource·asset 변경은 승인되지 않았다.
- `SX-DEC-027`은 batch closure 전 금지한다.

## 3. 승인 직후 상태

각 승인 직후:

1. Decision/Evidence ID 확정.
2. batch branch·Draft PR에 spec/plan/ledger 기록.
3. 같은 ID를 올바른 Sheet에 기록.
4. `APPROVED_PENDING_BATCH_MERGE` 또는 10번째에는 `FROZEN_PENDING_BATCH_AUDIT`.
5. main SHA가 아니라 branch head와 PR 번호 사용.
6. 제품 구현은 별도 승인 없으면 변경하지 않음.

`SYNCED`는 canonical merge와 Sheet readback 뒤에만 사용한다.

## 4. Batch Ledger

| Batch | 범위 | 승인 | 상태 | PR | Sheet | Closure |
|---|---|---:|---|---|---|---|
| CATCH-UP-001 | SX-DEC-014~016 | 3/3 | CLOSED | #18/#24/#27 | SYNCED | 완료 |
| GMB-001 | SX-DEC-017~026 | 10/10 | FROZEN_AUDIT | #29 | FROZEN_PENDING_AUDIT | 미완료 |

## 5. Freeze 허용 변경

- 누락 consumer 반영
- stale reference·충돌·중복·오탈자 수정
- Registry·Gate·Plan·Issue·Sheet 정합성 수정
- PR review·CI 실패 대응
- audit evidence 기록

금지:

- 11번째 Decision
- 새 기능 범위
- 제품 구현
- 무관 리팩터링
- runtime/Android/human evidence의 허위 PASS

## 6. Pre-Merge 전수 확인

### GitHub main/branch

- default branch와 baseline SHA
- main 외부 변경·behind 상태
- Decision/Evidence 중복·누락
- CURRENT/HISTORICAL 상태
- Issue·Plan·Gate·Registry·Active Context·Roadmap·execution prompt 소비자
- changed-file inventory와 전체 patch
- product code/Scene/Resource/asset 변경 0
- stale `0/10`, `NEXT SX-DEC-017`, pending marker 검색

### Pull Request

- exact head
- exactly 10 decisions, no SX-DEC-027
- Project Contract success
- Godot Tests success
- unresolved review threads 0
- REQUEST_CHANGES 0
- mergeable
- expected-head protected merge

### Google Sheet

Workbook ID와 제목을 먼저 확인하고 12개 탭을 모두 읽는다.

```text
00_프로젝트_허브
01_작업순서
02_현재_확정결정
03_근거_라이브러리
04_누락_충돌_감사
05_GDD_요약
06_시각_작업면
10_경험
20_시스템_콘텐츠
30_세계_서사
40_표현
50_제작_검증
```

확인:

- SX-DEC-017~026와 EV-USER-006~015
- spec/plan paths
- final branch head before merge
- 역사 행 보존
- `30_세계_서사` 무변경
- wrong `19Ff...` Sheet 미변경
- pending/frozen을 premature `SYNCED`로 표시하지 않음

## 7. 적대적 검토 관점

1. 사용자 승인 왜곡
2. Decision 간 충돌
3. consumer 누락
4. UI/animation/tutorial 권위 침범
5. 자동 테스트로 Android/human/online 품질 과장
6. 승인 범위 잠입
7. 역사 계약 손실
8. GitHub/Sheet drift
9. 측정 불능
10. 10건 외 batch 오염
11. VS 로컬 범위를 온라인 플랫폼 구축으로 팽창
12. UGC가 official progression/economy를 오염
13. identity 충돌과 replay/idempotency 실패
14. moderation/privacy/anti-abuse 준비 과장

P0/P1은 병합 전 수정한다. 실제 실행이 필요한 미검증 항목은 `NOT_RUN`으로 후속 Gate에 넘길 수 있다.

## 8. GMB-001 감사 정본

- `GMB-001_DECISION_LEDGER.md`
- `GMB-001_PREMERGE_AUDIT.md`
- `../00_프로젝트_허브/GMB-001_CANONICAL_DECISIONS.md`

현재 확인된 핵심 보정:

- VS-03 local scope와 Production/online UGC scope 분리.
- endless survival에 generic completion rate를 적용하지 않음.
- `F58` generator target-100은 `NOT_MET` 유지.
- UGC community signal은 비경제적이며 official rewards/records/discovery와 분리.

## 9. Canonical Merge Gate

```text
stale consumer 0
+ P0/P1 open 0
+ behind 0
+ planning-only inventory
+ exact-head Project Contract success
+ exact-head Godot Tests success
+ review thread 0
+ REQUEST_CHANGES 0
+ final Sheet frozen readback PASS
= MERGE_AUTHORIZED
```

병합 시 expected head SHA를 지정한다.

## 10. Sheet Closure와 Sync Closure PR

Canonical merge 직후:

1. merge SHA를 캡처한다.
2. 관련 Decision/Evidence/operation/audit 행을 canonical merge SHA와 `SYNCED`로 갱신한다.
3. 12탭을 다시 읽고 history·world/narrative 보존을 확인한다.
4. Active Context·Gate·Roadmap·Registry·Adapter의 closure 상태를 작은 Sync Closure PR로 갱신한다.
5. Closure PR exact-head Project Contract·Godot·inventory·threads를 검증하고 병합한다.
6. GMB-001을 `CLOSED`로 전환한다.
7. 다음 batch는 별도 사용자 작업에서 0/10으로 시작한다.

## 11. 중단 조건

- 올바른 Sheet 미확인
- Decision/Evidence 누락·중복
- unresolved conflict/behind
- required checks 실패·미실행
- unresolved review thread·REQUEST_CHANGES
- P0/P1 open
- 승인되지 않은 제품 변경
- Sheet readback mismatch
- runtime/Android/human/online evidence 허위 PASS

## 12. 완료 정의

```text
10 approvals
→ frozen audit PASS
→ canonical PR merge
→ Sheet canonical SHA + 12-tab PASS
→ Sync Closure PR merge
→ GMB-001 CLOSED
```
