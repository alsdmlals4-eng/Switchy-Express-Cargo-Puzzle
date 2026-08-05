# FP-01/02 First Slice Implementation Audit

```yaml
audit_id: SX-AUD-017
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
source_main_sha: 3a4aeaa63561f78e6b1065c80bda9a64af220051
implementation_prs: PR #55~#60
status: AUTOMATED_PASS · VALIDATION_PREREQUISITES_BLOCKED
default_entrypoint: LEGACY_RUNTIME_DEFAULT
cutover_status: BLOCKED
next_gate: VALIDATION_HARNESS + ANDROID_EXPORT_PRESET
```

## 1. 판정 요약

첫 Slice의 자동 구현 범위는 완료됐다. UI 명령으로 선로를 건설하고, 구조 검사를 통과한 배치를 봉인해 유한 런을 시작하며, `A → B → A → A` 적재와 `2 → 1 → 1` 하역을 통해 LIFO 재방문 해답을 완료하는 경로가 통합 테스트로 증명됐다.

그러나 자동 테스트는 실제 Android 조작성이나 처음 보는 사용자의 규칙 이해를 증명하지 않는다. 또한 저장소에는 Android export preset과 `TOP 8/16/32` 가독성 검증 fixture가 아직 없다. 따라서 현재 상태는 `AUTOMATED_PASS · VALIDATION_PREREQUISITES_BLOCKED`이며 바로 수동 검증을 시작할 수 있는 상태가 아니다.

| Gate | 상태 | 근거 | 전환 영향 |
|---|---|---|---|
| AUTOMATED | PASS | Project Contract #490, Godot Tests #451, `60 cases · 10,382 assertions · 0 failures` | 검증 준비 package 진행 가능 |
| VALIDATION PREP | BLOCKED | `export_presets.cfg` 없음, 8/16/32 stack fixture 없음 | Android/HUMAN 실행 차단 |
| ANDROID | NOT_RUN · BLOCKED_PREREQUISITES | 재현 가능한 APK·기기 기록 없음 | cutover 차단 |
| HUMAN | NOT_RUN · BLOCKED_BY_BUILD | 동일 검증 build 없음 | cutover 차단 |
| BALANCE | NOT_RUN | 대표 맵 외 광범위 조정은 First Slice 범위 밖 | 현재 cutover 필수 Gate 아님 |
| ONLINE | NOT_RUN | 서비스·리더보드 backend는 First Slice 범위 밖 | 현재 cutover 필수 Gate 아님 |
| FINAL ART | NOT_RUN | 임시 Godot Control 사용 | 후속 제작 Gate |

## 2. 자동 구현 증거

### 2.1 최종 자동 Gate

```text
main: 3a4aeaa63561f78e6b1065c80bda9a64af220051
PR: #60 · MERGED
Project Contract: #490 PASS
Godot Tests: #451 PASS
Test summary: 60 cases · 0 failed · 10,382 assertions
Review: unresolved thread 0 · REQUEST_CHANGES 0
```

### 2.2 증명된 제품 경계

- 실제 View 명령이 `FiniteBuildSession`을 편집한다.
- canonical Alpha 배치를 UI 명령만으로 만들 수 있다.
- 구조 검사 PASS 후 배치가 봉인되고 fresh attempt가 생성된다.
- 자동 적재 접촉 순서는 `A → B → A → A`다.
- 하역 그룹은 `2 → 1 → 1`이며 A역 재방문이 필요하다.
- 배송 이벤트는 불변 값으로 한 번 관찰되고 런 컨트롤러가 같은 이벤트를 소비한다.
- pause는 시계·열차 보간·화물 필드·LIFO 스택을 동결한다.
- crossing은 수평·수직 선로를 섞지 않는다.
- branch는 사전 설정 가능하고, 열차 점유 중 잠기며, 재시도에서 초기 상태로 돌아간다.
- RUNNING/UNLOADING에서는 branch 자체를 탭해 직접 전환한다.
- PAUSED에서는 보드 탭이 상태를 바꾸지 않는다.
- 실패 후 동일 배치를 보존한 fresh runtime 재시도가 가능하다.
- finite 결과에는 legacy fuel·BOOST·endless score가 없다.

### 2.3 적대적 검토에서 수정한 중요 결함

| 결함 | 재현 | 수정 |
|---|---|---|
| 존재하지 않는 `TrackLayout.has_piece()` 호출 | Godot Tests #448 FAIL | `piece_at(cell) != null` 권위 API 사용 |
| 운행 중 branch 직접 탭이 아닌 별도 버튼 의존 | Godot Tests #450 신규 단언 FAIL | RUNNING/UNLOADING 보드 탭으로 즉시 cycle, PAUSED 무조작 |

## 3. 수동 검증 준비 Gate

### 3.1 현재 준비 누락

저장소 대조 결과 다음 선행 조건이 없다.

1. 루트에 `export_presets.cfg`가 없어 재현 가능한 Android export 구성이 없다.
2. finite authored map은 `data/maps/fp_core_proof_01.json` 1개이며 화물은 4개다.
3. 계획이 요구한 `TOP 8/16/32` 상태를 만들 수 있는 authored QA map 또는 비제품 presentation harness가 없다.
4. finite Slice는 아직 기본 진입점이 아니므로 validation 전용 launcher/entrypoint가 필요하다.

이 누락을 해결하기 전에는 Android Gate를 단순 `NOT_RUN`이 아니라 `NOT_RUN · BLOCKED_PREREQUISITES`로 기록한다.

### 3.2 다음 준비 package 설계 경계

검증 준비 package는 제품 규칙을 추가하지 않고 다음만 제공해야 한다.

- 재현 가능한 Android debug export preset
- main에 병합하지 않는 validation 전용 entrypoint 또는 launcher
- 실제 proof Slice 실행 모드
- Presenter/View만 사용해 8·16·32 stack을 표시하는 비제품 가독성 모드
- validation scene 부팅·모드별 token 수를 검사하는 headless test
- 제품 `game/main/main.tscn`과 기본 진입점 불변 테스트

이 package의 harness와 export 설정은 제품 기능이나 콘텐츠로 계산하지 않는다. 별도 설계·TDD·리뷰 Gate를 거쳐야 한다.

## 4. Android 검증 실행 계약

### 4.1 빌드 무결성

현재 제품 main 진입점은 legacy runtime이다. Android 검증을 위해 main을 조기 전환해서는 안 된다.

검증 빌드는 다음 방식만 허용한다.

1. 검증 준비 package가 병합된 main에서 별도 `validation/fp-android-smoke` 브랜치를 만든다.
2. validation 전용 launcher와 Android debug preset만 사용한다.
3. 브랜치 SHA와 APK SHA-256을 기록한다.
4. validation 브랜치는 main에 병합하지 않는다.
5. 모든 필수 Gate PASS 후 별도의 production-cutover PR에서 기본 진입점 변경을 다시 검토한다.

로컬 미커밋 변경으로 만든 APK는 소스 재현성이 떨어지므로 정식 PASS 증거로 사용하지 않는다.

### 4.2 환경 기록

| 필드 | 기록값 |
|---|---|
| Validation branch SHA | NOT_RUN |
| Source main SHA | `3a4aeaa63561f78e6b1065c80bda9a64af220051` |
| Export preset / template version | BLOCKED_MISSING_PRESET |
| APK SHA-256 | NOT_RUN |
| Godot version | `4.7.1-stable` |
| Device / emulator | NOT_RUN |
| Android version | NOT_RUN |
| Resolution / density | NOT_RUN |
| Orientation | landscape |
| Input method | touch |
| Recording references | NOT_RUN |
| Tester | 최소 식별자만 기록; 개인정보 금지 |

### 4.3 Android smoke 항목

모든 항목은 `PASS`, `FAIL`, `NOT_RUN`, `BLOCKED` 중 하나로 기록한다. 일부 항목만 실행한 경우 전체 Android Gate는 PASS가 아니다.

| ID | 검증 항목 | 성공 기준 | 상태 | 증거·관찰 |
|---|---|---|---|---|
| AND-01 | place | 빈 buildable cell에 선택 조각이 한 번 설치됨 | NOT_RUN | |
| AND-02 | rotate | 선택 조각이 90도 회전하고 시각·graph가 일치함 | NOT_RUN | |
| AND-03 | replace | 기존 조각 교체가 중복 설치 없이 반영됨 | NOT_RUN | |
| AND-04 | remove | 조각 제거와 전액 환급이 즉시 반영됨 | NOT_RUN | |
| AND-05 | clear | player layout만 제거되고 authored anchor는 유지됨 | NOT_RUN | |
| AND-06 | preflight feedback | Start 비활성, 주된 실패 이유 1개, 문제 cell 식별 가능 | NOT_RUN | |
| AND-07 | manual load hold | 화물 통과 중 홀드한 경우에만 적재됨 | NOT_RUN | |
| AND-08 | switch while loading | LOAD 홀드와 branch 탭을 동시에 수행할 수 있음 | NOT_RUN | multi-touch 실기기 증거 필요 |
| AND-09 | occupied switch lock | 열차가 branch 위에 있을 때 탭이 경로를 바꾸지 않음 | NOT_RUN | |
| AND-10 | auto-load toggle | 운행 중 ON/OFF가 즉시 읽히고 다음 접촉부터 적용됨 | NOT_RUN | |
| AND-11 | TOP readability 8 | 8개 적재에서 rear/TOP과 순서를 구분 가능 | BLOCKED | 8-stack harness 없음 |
| AND-12 | TOP readability 16 | 16개 적재에서 rear/TOP과 순서를 구분 가능 | BLOCKED | 16-stack harness 없음 |
| AND-13 | TOP readability 32 | 32개 적재에서 rear/TOP과 순서를 구분 가능 | BLOCKED | 32-stack harness 없음 |
| AND-14 | pause during movement | 시계·열차·화물이 정지하고 Resume 후 동일 상태에서 계속됨 | NOT_RUN | |
| AND-15 | pause during unload | 하역 표시·시계가 정지하고 중복 commit 없이 계속됨 | NOT_RUN | |
| AND-16 | failure preserves layout | 제한 시간 실패 뒤 기존 배치가 유지됨 | NOT_RUN | |
| AND-17 | same-layout retry | fresh runtime으로 동일 배치를 다시 시작함 | NOT_RUN | |
| AND-18 | touch target | 핵심 명령을 오탭 없이 반복 조작할 수 있음 | NOT_RUN | |
| AND-19 | landscape layout | HUD·보드·버튼이 겹치거나 화면 밖으로 나가지 않음 | NOT_RUN | |
| AND-20 | stability smoke | 대표 해답 3회 연속 실행 중 crash·script error 없음 | NOT_RUN | |

### 4.4 Android Gate 판정

```text
PASS: validation prerequisites PASS + AND-01~20 전부 PASS + 영상/스크린샷 + branch SHA + APK hash
FAIL: 실행 가능한 상태에서 하나 이상의 필수 항목 FAIL
BLOCKED: export preset·launcher·필수 fixture가 없어 실행 불가
NOT_RUN: 실행 가능하지만 아직 수행하지 않음
```

## 5. 5명 이해도 검증 계약

### 5.1 진행 원칙

- 정답 노선이나 `A → B → A → A` 해답을 미리 알려주지 않는다.
- 진행자는 조작 불능·버그 외에는 해답 힌트를 제공하지 않는다.
- 참가자 이름·연락처 등 불필요한 개인정보를 저장하지 않는다.
- 참가자는 `P01`~`P05` 같은 최소 식별자로 기록한다.
- 같은 validation build SHA와 같은 proof map을 사용한다.
- 진행자의 해석 대신 참가자의 설명과 실제 행동을 분리해 기록한다.

### 5.2 참가자별 기록

| Participant | Device | Last-loaded cargo is TOP 설명 | A 재방문 이유 설명 | 실패 후 edit+retry 수행 | 성공 원인 귀인 | 주요 오해 | 상태 |
|---|---|---|---|---|---|---|---|
| P01 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P02 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P03 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P04 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |
| P05 | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | | NOT_RUN |

### 5.3 필수 질문과 관찰

1. “지금 화물 중 다음 역에서 먼저 내려갈 화물은 무엇이며, 왜 그런가?”
2. “A/B/A/A 순서로 실었다면 왜 A역을 한 번 더 방문해야 하는가?”
3. 실패 후 별도 안내 없이 배치를 수정하고 같은 배치 재시도를 구분해 사용하는가?
4. 성공한 참가자는 성공 원인을 경로·적재 선택·LIFO 이해로 설명하는가, 반사 속도 운으로 설명하는가?
5. 색상 없이 형상·텍스트만으로 화물과 TOP을 구분할 수 있는가?

### 5.4 HUMAN Gate 판정

```text
HUM-01: 4/5 이상이 마지막 적재 화물이 TOP이라고 설명
HUM-02: 4/5 이상이 A/B/A/A에서 A 재방문 이유를 설명
HUM-03: 4/5 이상이 실패 후 edit와 retry를 수행
HUM-04: 성공자의 다수가 성공을 route/loading/LIFO에 귀인
HUM-05: 반복되는 치명적 오해가 없거나 수정 계획과 재검증이 기록됨
```

`HUM-01~05`가 모두 충족돼야 HUMAN Gate를 PASS로 기록한다. 기준 미달은 실패를 숨기지 않고 오해 유형·UI/규칙 수정·재검증 계획으로 전환한다.

## 6. Cutover Gate

production cutover PR은 아래 조건이 모두 충족되기 전에는 생성하지 않는다.

- [x] AUTOMATED PASS
- [ ] VALIDATION PREP PASS
- [ ] ANDROID PASS
- [ ] HUMAN PASS
- [ ] 모든 Critical/Important 결함 0
- [ ] unresolved review thread 0
- [ ] REQUEST_CHANGES 0
- [ ] validation build와 production-cutover source의 차이 검토 완료
- [ ] correct Google Sheet에 동일 evidence/audit ID 동기화

Cutover 시 허용되는 제품 변경은 `game/main/main.tscn`과 필요한 최소 어댑터뿐이다. legacy 파일은 삭제하지 않으며, finite와 legacy 규칙을 한 세션에서 혼합하지 않는다.

## 7. 증거 제출 형식

실기기·사람 검증 후 이 문서에 다음을 추가한다.

```text
Validation preparation PR/SHA:
Validation branch SHA:
Export preset/template version:
APK SHA-256:
Device matrix:
Android result: PASS | FAIL
Human result: PASS | FAIL
Recording references:
Critical/Important findings:
Required fixes and retest SHA:
Final cutover recommendation: APPROVE | BLOCK
```

증거 파일이나 영상은 저장소에 대용량 바이너리로 직접 커밋하지 않는다. 접근 가능한 링크·파일 ID·해시만 기록한다.

## 8. 현재 결론

```text
AUTOMATED: PASS
VALIDATION PREP: BLOCKED
ANDROID: NOT_RUN · BLOCKED_PREREQUISITES
HUMAN: NOT_RUN · BLOCKED_BY_BUILD
BALANCE: NOT_RUN
ONLINE: NOT_RUN
FINAL ART: NOT_RUN
CUTOVER: BLOCKED
```

다음 작업은 validation harness와 Android export preset의 설계·TDD 구현이다. 준비 package가 검증된 뒤 Android smoke와 5명 comprehension을 실행한다.
