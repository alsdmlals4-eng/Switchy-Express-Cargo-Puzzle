# Grill Me 10건 배치 병합 프로토콜

```yaml
protocol_id: SX-OPS-001
evidence_id: EV-USER-005
status: ACTIVE · GITHUB_SHEET_SYNCED
owner: PROJECT_OWNER + PLANNING_AGENT
batch_size: 10_GRILL_ME_APPROVALS
completed_catch_up: CATCH-UP-001 · SX-DEC-014~016
current_batch_id: GMB-001
current_batch_start: SX-DEC-017
current_batch_count: 0/10
implementation_merge_policy: NO_PRODUCT_IMPLEMENTATION_UNLESS_SEPARATELY_APPROVED
```

## 1. 목적

Grill Me 승인 한 건마다 main·Sheet·Closure PR을 반복해 작업 흐름이 지나치게 잘게 쪼개지는 것을 막으면서, 승인 내용이 대화에만 남거나 GitHub와 Google Sheet 사이에서 유실되는 것도 방지한다.

Grill Me 승인은 한 건씩 질문하고 확정하되, **10건을 하나의 canonical batch PR로 묶어 병합**한다. 10번째 승인이 들어오면 병합 직전 GitHub·Google Sheet·PR을 다시 전수 확인하고 적대적 검토 루프를 통과한 뒤 canonical 병합과 Sheet closure까지 완료한다.

## 2. 현재 경계

- `SX-DEC-014`, `SX-DEC-015`, `SX-DEC-016` catch-up은 PR #27 / `3cd13ff375a597d4eba9035af5b05e6186fb4853`과 Sheet 12탭 readback으로 완료됐다.
- 첫 정규 배치는 `GMB-001`이며 `SX-DEC-017`부터 센다. 현재 `0/10`이다.
- `SX-OPS-001` 같은 운영 규칙은 Grill Me 게임 기획 10건 카운트에 포함하지 않는다.
- 사용자가 명시적으로 즉시 병합을 지시한 경우만 배치 중간 병합 예외를 허용한다.

## 3. 승인 직후 처리

각 Grill Me 승인 직후 다음을 수행한다.

1. Decision ID와 Evidence ID를 확정한다.
2. 현재 batch branch에 설계 정본·소비자 문서·Issue·Plan 변경을 커밋한다.
3. 동일한 Decision ID를 올바른 Switchy Express Google Sheet에 기록한다.
4. Sheet 상태는 `APPROVED_PENDING_BATCH_MERGE`로 둔다.
5. Sheet의 commit 칸에는 main SHA가 아니라 해당 batch branch commit과 PR 번호를 명시한다.
6. batch ledger의 count를 1 증가시킨다.
7. 제품 코드·Scene·Resource·asset은 별도 구현 승인이 없으면 변경하지 않는다.
8. 다음 Grill Me는 기존 승인과 충돌 여부를 먼저 대조한 뒤 한 건만 제시한다.

승인 직후 main 병합과 `SYNCED` 표시는 하지 않는다. `SYNCED`는 canonical PR이 main에 병합되고 Sheet가 최종 merge commit으로 재조회된 뒤에만 사용한다.

## 4. Batch Ledger

| Batch ID | 대상 | 승인 수 | 상태 | Canonical PR | Sheet 상태 | Closure PR |
|---|---|---:|---|---|---|---|
| CATCH-UP-001 | `SX-DEC-014~016` | 3/3 | CLOSED | PR #18/#24/#27 | `PASS · 12탭 재조회 완료 · SYNCED` | PR #19/#25/현재 closure |
| GMB-001 | `SX-DEC-017`부터 다음 10건 | 0/10 | NOT_STARTED | 미생성 | main `3cd13ff…`와 SYNCED | 미생성 |

정규 batch 안에서는 승인 순서와 Decision ID를 삭제·재사용하지 않는다. 사용자가 기존 결정을 수정하면 새 Decision 또는 명시적 supersede 관계로 기록한다.

## 5. 10번째 승인 시 Freeze

10번째 승인이 확정되면 다음 Grill Me 질문을 잠시 중단하고 batch를 `FREEZE_FOR_PREMERGE_AUDIT`로 전환한다.

Freeze 이후에는 다음 수정만 허용한다.

- 누락 소비자 반영
- 충돌·중복·오탈자·stale reference 수정
- Registry·hash·문서 상태 수정
- PR review 지적 대응
- 검증 실패 수정
- Sheet와 GitHub의 Decision/Evidence/commit/status 정합성 수정

새로운 설계 범위나 11번째 Decision은 다음 batch로 넘긴다.

## 6. 병합 직전 필수 전수 확인

### 6.1 GitHub main 확인

- default branch와 최신 main SHA
- batch 시작 baseline과 현재 main 사이의 외부 변경
- CURRENT/HISTORICAL 문서 상태
- Decision·Evidence ID 중복
- Issue·Goal·Plan·Roadmap·Gate·Active Context 소비자
- project Skill 읽기 순서와 Registry raw SHA256
- Adapter의 Base pin·Sheet ID·sync 상태
- 제품 코드·Scene·Resource·asset 변경 여부
- 실행되지 않은 검증이 PASS로 잘못 표기되지 않았는지

### 6.2 Batch PR 확인

- exact head SHA
- 전체 changed-file inventory
- 전체 patch와 각 중요 파일 patch
- 승인 10건이 모두 존재하는지
- 승인되지 않은 11번째 범위가 섞이지 않았는지
- 기존 Decision을 무단 변경하거나 약화하지 않았는지
- stale 문구·구형 commit·pending marker·placeholder 검색
- unresolved review threads 0
- requested changes 0
- Project Contract success
- Godot full regression success
- 제품 변경이 포함된 경우 해당 범위의 focused test와 evidence

### 6.3 Google Sheet 확인

정확한 workbook ID `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`와 제목 `Switchy Express: Cargo Puzzle`을 먼저 확인한다.

12개 탭을 모두 읽는다.

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

확인 항목:

- 10개 Decision과 Evidence가 모두 존재
- `APPROVED_PENDING_BATCH_MERGE` 상태와 batch PR head commit 일치
- Decision 한 문장·수치·용어가 GitHub 정본과 일치
- 책임 정본 경로 존재
- 관련 GDD·경험·시스템·표현·제작 소비자 반영
- 관련 없는 행·과거 Evidence·세계/서사 데이터 보존
- 잘못 제공된 다른 프로젝트 Sheet 미변경

## 7. 적대적 검토 루프

병합 전 다음 공격 관점으로 검토한다.

1. **왜곡:** 사용자 승인을 더 넓거나 다른 의미로 해석했는가.
2. **충돌:** 두 Decision이 같은 상태·수치·용어를 다르게 정의하는가.
3. **누락:** 정본은 바뀌었지만 Issue·Goal·Plan·Gate·Sheet 소비자가 빠졌는가.
4. **권위 혼선:** UI·animation·tutorial이 gameplay 결과를 소유하게 되었는가.
5. **증거 과장:** 자동 테스트만으로 Android·사람·품질 PASS를 주장하는가.
6. **범위 잠입:** 승인되지 않은 기능·리팩터링·밸런스 영구값이 섞였는가.
7. **역사 손실:** 과거 계약·완료 evidence가 축약·삭제되었는가.
8. **동기화 drift:** GitHub와 Sheet의 Decision/Evidence/commit/status가 다른가.
9. **측정 불능:** 성공 기준·telemetry·test task가 없는가.
10. **배치 오염:** 10건 외의 새 Decision이 같은 PR에 들어왔는가.

Finding은 `AUTO_FIX_ELIGIBLE`, `USER_DECISION_REQUIRED`, `RESEARCH_OR_TEST_REQUIRED`로 분류한다.

- P0/P1 conflict 또는 누락은 병합 전에 반드시 수정한다.
- 새 사용자 선택이 필요한 P0/P1은 병합을 멈추고 Grill Me로 되돌린다.
- 실제 실행이 필요한 미검증 항목은 `NOT_RUN` 경계를 유지한 채 후속 Gate로 넘길 수 있다.

## 8. Canonical 병합 절차

1. pre-merge audit Finding을 PR body와 감사 원장에 기록한다.
2. 수정 후 exact head에서 모든 필수 check를 다시 실행한다.
3. changed-file inventory와 unresolved review thread를 다시 읽는다.
4. P0/P1 open finding 0, unresolved thread 0, required checks success일 때만 ready로 전환한다.
5. expected head SHA를 지정해 canonical batch PR을 병합한다.
6. 병합 결과 main merge commit을 기록한다.

## 9. Sheet 최종화와 Sync Closure

Canonical 병합 직후:

1. 10개 Decision/Evidence의 commit을 canonical main merge commit으로 바꾼다.
2. 상태를 `SYNCED`로 바꾸기 전 12개 탭을 다시 읽는다.
3. 일치하면 Audit에 `PASS · 12탭 재조회 완료`를 기록한다.
4. Adapter·Active Context·Decision 원장·Gate·Roadmap의 pending 상태를 닫는 작은 Sync Closure PR을 만든다.
5. Closure PR도 exact head Project Contract·Godot regression·changed-file inventory·review thread 0을 확인한다.
6. Closure PR 병합 후 batch를 `CLOSED`로 전환한다.
7. 다음 batch ledger를 0/10으로 시작한다.

Closure PR은 Grill Me 10건 카운트에 포함하지 않는다.

## 10. 중단 조건

다음 중 하나면 병합하지 않는다.

- 올바른 Sheet를 확인하지 못함
- Decision/Evidence ID 중복 또는 누락
- main과 batch branch가 해결되지 않은 충돌 상태
- required workflow 실패·미실행
- unresolved review thread 존재
- P0/P1 적대적 Finding 미해결
- 승인되지 않은 제품 코드 또는 범위 포함
- Sheet readback 불일치
- runtime·Android·사람 evidence를 실행하지 않고 PASS로 표기

## 11. 완료 정의

한 batch는 다음을 모두 만족해야 완료다.

```text
10 Grill Me approvals recorded
→ canonical batch PR adversarially reviewed
→ exact-head checks passed
→ canonical PR merged
→ Sheet updated to canonical merge commit
→ all 12 tabs reread PASS
→ Sync Closure PR checked and merged
→ ledger CLOSED and next batch reset to 0/10
```
