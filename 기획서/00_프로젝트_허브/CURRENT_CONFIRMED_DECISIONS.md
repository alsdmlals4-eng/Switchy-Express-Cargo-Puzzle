# Current Confirmed Decisions

Last updated: `2026-08-05`

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_batch: GMB-002
current_decisions: SX-DEC-027~036
current_execution_authority: FP-DOR-001 · EV-USER-021
current_evidence: EV-FP-VAL-001
current_audit: SX-AUD-018
current_main: abc75abd00765ba6ea3aa471c29962f314963be5
planning_state: MERGED_AND_SYNCED
implementation_state: TASK_12_AUTOMATED_PASS · VALIDATION_PREP_PASS · LEGACY_RUNTIME_DEFAULT
validation_prep_state: PASS
manual_gate_state: APK_EXPORT_NOT_RUN · ANDROID_NOT_RUN · HUMAN_NOT_RUN
cutover_state: BLOCKED
next_gate: ANDROID_APK_EXPORT → ANDROID_SMOKE → FIVE_PERSON_COMPREHENSION
sheet_state: SX-AUD-018_SYNC_PENDING
old_vs03_execution_order: REPLACED · HISTORICAL_EVIDENCE
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 분기 전환으로 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 시간·건설비·점수별 후속 재설계와 기록 경쟁
```

현재 첫 Slice는 Combo 보상·별·랭킹 전 단계다. `A → B → A → A` 적재와 `2 → 1 → 1` 하역으로 LIFO 재방문 핵심을 증명한다.

## Current Authority Files

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/GMB_002_APPROVAL_LEDGER.md`
- `docs/superpowers/specs/2026-08-04-finite-puzzle-definition-of-ready-design.md`
- `docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md`
- `docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md`
- `docs/superpowers/plans/2026-08-05-finite-validation-harness.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`
- `기획서/00_프로젝트_허브/CANON_REPLACEMENT_REGISTER.md`

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | First Slice 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐을 주 제품으로 한다. | AUTOMATED PASS |
| SX-DEC-028 | 건설 | 건설 불가 구역 외 자유 선로 건설, 조각별 비용, 시간 정지, 전액 환급, 추천 비용을 적용한다. | 핵심 건설 PASS · ghost route 후속 |
| SX-DEC-029 | 운행·판정 | 구조 검사, 운행 중 건설 금지, 제한 시간 실패, 마지막 하역 성공, 확인 전용 pause를 적용한다. | AUTOMATED PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차를 기본으로 하고 성능·특수·지형 선로는 후속 package로 확장한다. | 기본 4종 PASS · 나머지 후속 |
| SX-DEC-031 | 적재·LIFO | 수동 홀드·자동 적재 토글, 무제한 스택, 정차 없는 적재, TOP 연속 그룹 하역을 적용한다. | AUTOMATED PASS |
| SX-DEC-032 | Combo | 하역 그룹 수를 Combo로 삼아 최대 1초 하역과 후속 가속·점수 보상을 적용한다. | 그룹·1초 PASS · 보상 후속 |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 3종 리더보드를 적용한다. | NOT_STARTED · 후속 FP |
| SX-DEC-034 | 캠페인 | 1~10 튜토리얼과 테마 챕터·챕터 시험을 적용한다. | NOT_STARTED · 후속 FP |
| SX-DEC-035 | 반복 도전 | 일일·주간 고정 시드 도전과 기간 기록을 운영한다. | ONLINE NOT_RUN · 후속 production |
| SX-DEC-036 | 진행·공정성 | 꾸미기만 보상하고 성능 강화와 타 플레이어 노선·리플레이 공개를 금지한다. | 원칙 유지 · 보상 구현 후속 |

## First Slice Implementation Status

### 완료된 자동 코어 범위

- authored map schema v2
- player TrackLayout identity와 거래형 편집
- 직선·곡선·분기·교차 graph
- 구조 검사와 permanent trap 차단
- proof map과 canonical Alpha/Beta solution
- 수동/자동 적재
- 무제한 LIFO와 고정 화물
- station skip·TOP group unload
- 정확한 제한 시간·pause·success/failure
- 동일 배치 fresh runtime 재시도와 identity
- BUILD/RUN/RESULT 화면
- 48dp 상당 control과 색상+형상+텍스트 표현
- UI 명령 기반 end-to-end 통합
- branch 직접 탭·점유 잠금·재시도 초기화

자동 코어 증거:

```text
PR #55~#60 MERGED
main 3a4aeaa63561f78e6b1065c80bda9a64af220051
Project Contract #490 PASS
Godot Tests #451 PASS
60 cases · 10,382 assertions · 0 failures
```

### 완료된 검증 준비 범위

- production main과 분리된 validation launcher
- 실제 finite proof Slice를 mount하는 `PROOF` mode
- Presenter/View 기반 `STACK_8`, `STACK_16`, `STACK_32`
- 모든 stack fixture의 정확한 token 수와 final/rear TOP
- 색상+형상+텍스트 중복 표현 검증
- invalid mode와 unknown command-line argument fail closed
- `validation_harness` custom feature 기반 main-scene override
- 별도 Android validation package identity·debug export preset
- production `game/main/main.tscn` SHA-256 불변 검사
- secret·password·machine path 부재 검사

검증 준비 증거:

```text
PR #62 design MERGED · 94bdc5e97d21d261db22559ada51ad43594ebf74
PR #63 implementation MERGED · abc75abd00765ba6ea3aa471c29962f314963be5
Project Contract #508 PASS
Godot Tests #464 PASS
63 cases · 10,714 assertions · 0 failures
unresolved thread 0 · REQUEST_CHANGES 0
```

### 열려 있는 수동 Gate

- Android APK export: `NOT_RUN`
- Android landscape smoke: `NOT_RUN`
- 5명 comprehension validation: `NOT_RUN`
- production default cutover: `BLOCKED`

검증 준비 도구가 존재한다는 사실은 APK가 생성됐거나 실제 기기·사람 검증이 통과했다는 뜻이 아니다. 세부 실행 계약은 `SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`와 `FP_01_02_IMPLEMENTATION_AUDIT.md`를 따른다.

## Preserved Decisions

다음 기존 결정의 의미는 새 기준선에서도 유지한다.

- `SX-DEC-001`: 정식 제목 `Switchy Express: Cargo Puzzle`
- `SX-DEC-008`: 마지막 적재부터 하역하는 LIFO와 TOP 연속 동일 종류 그룹 하역. `capacity 8`은 대체됨.
- `SX-DEC-011`: 프리미엄 캐주얼 3D 카툰·토끼 기관사 방향
- `SX-DEC-012`: Godot 4.7.1·GDScript·Android·가로형
- `SX-DEC-014`: Combo는 한 번의 역 도착에서 연속 하역된 동일 화물 수
- `SX-DEC-015`: rear/TOP을 읽을 수 있는 compact token 의미. 수량 8 한정 표현은 대체됨.
- `SX-DEC-019`: cosmetic-only 공정성 원칙
- `SX-DEC-023`: 같은 조건 재도전과 immutable identity 원칙

## Superseded Decisions

| 기존 결정 | 상태 | 대체 권위 |
|---|---|---|
| SX-DEC-002 무한 생존 | `[대체됨]` | SX-DEC-027 |
| SX-DEC-003 LOAD+분기+BOOST | `[부분 대체]` | SX-DEC-029/031; BOOST 폐기 |
| SX-DEC-004 완성형 connected rail | `[대체됨]` | SX-DEC-028/030 |
| SX-DEC-006 색상별 역 2개 고정 | `[대체됨]` | authored stage content |
| SX-DEC-007 pickup 지속 재생성 | `[폐기]` | SX-DEC-031 |
| SX-DEC-008 capacity 8 | `[대체됨]` | SX-DEC-031 |
| SX-DEC-009 연료 경제·fuel-zero | `[폐기]` | SX-DEC-027/029 |
| SX-DEC-010 화물 감속·BOOST | `[폐기]` | SX-DEC-030/032 |
| SX-DEC-013 분기 통과 후 기본 복귀 | `[대체됨]` | persistent switch · SX-DEC-029/030 |
| SX-DEC-016 endless 첫 run 온보딩 | `[대체됨]` | SX-DEC-034 |
| SX-DEC-017 연료 0 결과 문맥 | `[대체됨]` | 제한 시간 미배송 실패 분석 |
| SX-DEC-022 timed pressure 제품 권위 | `[폐기]` | SX-DEC-029 |
| SX-DEC-024 endless map discovery | `[보류/재설계]` | 캠페인·도전 선택 구조 |
| SX-DEC-025~026 UGC | `[보류]` | production 재검토 |

## Legacy Implementation Boundary

다음 구현은 `[대체됨 · 역사 증거]`다.

- fuel·fuel-zero
- BOOST
- capacity 8
- cargo slowdown
- timed difficulty pressure
- pickup respawn
- switch auto-reset
- endless survival score

old tests는 old contract의 회귀 증거이며 finite 제품 PASS 수치로 합산하지 않는다. 기본 진입점은 APK export·Android·HUMAN Gate 전까지 legacy를 유지한다.

## Audit Registry

| Audit ID | 범위 | 상태 |
|---|---|---|
| SX-AUD-001~011 | 기존 endless 운영·기획·구현 | `[역사 증거]` |
| SX-AUD-012 | finite delivery pivot·정본 재정렬 | CLOSED |
| SX-AUD-013 | FP-01C→FP-02A·불변 이벤트 | PASS_WITH_NEXT_GATES |
| SX-AUD-014 | finite clock·하역·캡슐화 | PASS_WITH_NEXT_GATES |
| SX-AUD-015 | solution/attempt identity·retry | PASS_WITH_NEXT_GATES |
| SX-AUD-016 | 제품 화면·48dp·명령 경계 | PASS_WITH_NEXT_GATES |
| SX-AUD-017 | end-to-end 자동 통합·수동 Gate 계획 실행 가능성 | PASS_WITH_PREREQUISITE_BLOCKERS |
| SX-AUD-018 | validation launcher·8/16/32 fixture·Android preset·entrypoint 불변 | VALIDATION_PREP_PASS |

## Canonical Sync Evidence

- Current main: `abc75abd00765ba6ea3aa471c29962f314963be5`
- Core implementation PRs: `#55~#60 MERGED`
- Validation design/implementation: `#62/#63 MERGED`
- Project Contract: `#508 PASS`
- Godot Tests: `#464 PASS`
- Review: `unresolved thread 0 · REQUEST_CHANGES 0`
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Sheet audit: `SX-AUD-018 SYNC_PENDING`
- Wrong `19Ff...` Sheet: 변경 금지

## Current Execution Authority

```text
GMB-002 MERGED
→ FP-DOR-001 APPROVED
→ FP-01/FP-02 + Task 11/12 AUTOMATED PASS
→ VALIDATION PREPARATION PASS
→ ANDROID APK EXPORT
→ ANDROID SMOKE
→ FIVE-PERSON COMPREHENSION
→ production cutover review
```

Android APK·기기·사람 증거 전에는 finite 구현을 production default 또는 제품 검증 완료로 표시하지 않는다.
