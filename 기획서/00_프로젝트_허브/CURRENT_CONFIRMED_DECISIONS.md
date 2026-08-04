# Current Confirmed Decisions

Last updated: `2026-08-04`

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_batch: GMB-002
current_decisions: SX-DEC-027~036
current_evidence: EV-USER-019
current_audit: SX-AUD-012
planning_state: MERGED_AND_SYNCED · CLOSED
canon_merge: PR_50 · c06c07a529d1bd5d4de00c2f83f53edcd4f8c77d
sheet_state: FINAL_12_TAB_READBACK_PASS
implementation_state: LEGACY_RUNTIME_PRESENT · REPLAN_REQUIRED
next_gate: FINITE_PUZZLE_DEFINITION_OF_READY
old_vs03_execution_order: REPLACED
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 분기 전환으로 역 방문 순서 실행
→ 연속 동일 화물 하역 Combo
→ 시간·건설비·점수별 재설계와 기록 경쟁
```

상세 정본:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/GMB_002_APPROVAL_LEDGER.md`
- `기획서/50_제작_검증/SX_AUD_012_FINITE_DELIVERY_PIVOT_AUDIT.md`
- `기획서/00_프로젝트_허브/CANON_REPLACEMENT_REGISTER.md`

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐을 주 제품으로 한다. | CONFIRMED · GMB-002 |
| SX-DEC-028 | 건설 | 건설 불가 구역 외 자유 선로 건설, 조각별 비용, 시간 정지, 전액 환급, 반투명 추천 설계도·예상 비용을 적용한다. | CONFIRMED · GMB-002 |
| SX-DEC-029 | 운행·판정 | 모든 역·화물의 구조적 도달 가능성을 시작 조건으로 하고 운행 중 건설 금지, 제한 시간 실패, 마지막 하역 즉시 성공, 확인 전용 pause를 적용한다. | CONFIRMED · GMB-002 |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차, 일반·가속·저비용·일방통행, 회차를 사용하고 터널·교량은 후반 전용으로 둔다. | CONFIRMED · GMB-002 |
| SX-DEC-031 | 적재·LIFO | 지점당 화물 1개, 수동 홀드 기본·자동 적재 토글, 무제한 스택, 정차 없는 적재, TOP 연속 그룹 자동 하역을 적용한다. | CONFIRMED · GMB-002 |
| SX-DEC-032 | Combo | 하역 그룹 수를 Combo로 삼아 최대 1초 하역, 출발 후 일시 가속, 비누적 갱신, 점수 보너스를 적용한다. | CONFIRMED · GMB-002 |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별을 누적하고 3별 획득 시 속도·가격·점수 리더보드를 개방한다. | CONFIRMED · GMB-002 |
| SX-DEC-034 | 캠페인 | 1~10 튜토리얼, 11+ 테마 챕터, 3개 묶음 해금, 새 규칙 없는 챕터 시험을 적용한다. | CONFIRMED · GMB-002 |
| SX-DEC-035 | 반복 도전 | 일일·주간 고정 시드 도전, 무제한 재도전, 미학습 기믹 설명, 백분위 보상, 종료 맵 보관소를 운영한다. | CONFIRMED · GMB-002 |
| SX-DEC-036 | 진행·공정성 | 꾸미기만 보상하고 성능 강화와 타 플레이어 노선·리플레이 공개를 금지한다. | CONFIRMED · GMB-002 |

## Preserved Decisions

다음 기존 결정의 의미는 새 기준선에서도 유지한다.

- `SX-DEC-001`: 정식 제목 `Switchy Express: Cargo Puzzle`
- `SX-DEC-008`: 마지막 적재부터 하역하는 LIFO와 TOP 연속 동일 종류 그룹 하역. 단 `capacity 8`은 대체됨.
- `SX-DEC-011`: 프리미엄 캐주얼 3D 카툰·토끼 기관사 방향
- `SX-DEC-012`: Godot 4.7.1·GDScript·Android·가로형
- `SX-DEC-014`: Combo는 한 번의 역 도착에서 연속 하역된 동일 화물 수. 보상은 SX-DEC-032로 확장.
- `SX-DEC-015`: rear가 LIFO TOP임을 읽을 수 있는 compact token 의미. 수량 8 한정 표현은 대체됨.
- `SX-DEC-019`의 cosmetic-only 공정성 원칙
- `SX-DEC-023`의 같은 조건 재도전과 immutable map identity 원칙. identity 구조는 새 DoR에서 재설계.

## Superseded Decisions

| 기존 결정 | 상태 | 대체 결정 |
|---|---|---|
| SX-DEC-002 무한 생존 | `[대체됨]` | SX-DEC-027 |
| SX-DEC-003 LOAD+분기+BOOST | `[대체됨]` | SX-DEC-029/031 |
| SX-DEC-004 완성형 connected rail | `[대체됨]` | SX-DEC-028/030 |
| SX-DEC-006 색상별 역 2개 고정 | `[대체됨]` | authored stage content |
| SX-DEC-007 pickup 지속 재생성 | `[폐기]` | SX-DEC-031 |
| SX-DEC-008 capacity 8 | `[대체됨]` | SX-DEC-031 |
| SX-DEC-009 연료 경제·fuel-zero | `[폐기]` | SX-DEC-027/029 |
| SX-DEC-010 화물 감속·BOOST | `[폐기]` | SX-DEC-030/032 |
| SX-DEC-013 분기 통과 후 기본 복귀 | `[대체됨]` | SX-DEC-029/030 |
| SX-DEC-016 첫 endless run 온보딩 | `[대체됨]` | SX-DEC-034 |
| SX-DEC-017 연료 0 결과 문맥 | `[대체됨]` | 제한 시간 미배송 실패 분석 |
| SX-DEC-022 timed pressure 제품 권위 | `[폐기]` | SX-DEC-029 |
| SX-DEC-024 endless map discovery flow | `[보류/재설계]` | 캠페인·도전 선택 구조 |
| SX-DEC-025~026 UGC | `[보류]` | Production 재검토 |

## Audit Registry

| Audit ID | 범위 | 상태 |
|---|---|---|
| SX-AUD-001~011 | 기존 endless 기준선의 운영·기획·구현 감사 | `[역사 증거]` |
| SX-AUD-012 | finite delivery pivot, 핵심 재미·충돌·누락·지배 전략 감사 | PASS_WITH_REPLAN_REQUIRED · CLOSED |

## Canonical Sync Evidence

- Canon merge: `PR #50 · c06c07a529d1bd5d4de00c2f83f53edcd4f8c77d`
- Project Contract: `367 PASS`
- Godot Tests: `338 PASS`
- Review: `unresolved thread 0 · REQUEST_CHANGES 0`
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Sheet readback: `12 tabs PASS`
- Wrong `19Ff...` Sheet: `변경 0`

## Implementation Status

### 부분 재사용 후보

- 자동 이동과 경로 추종
- 분기 입력·target lock 일부
- CargoStack·LIFO·Station unload domain
- compact token 의미
- map/session/restart identity 기반

### Legacy implementation

- fuel·fuel-zero
- BOOST
- cargo capacity 8
- cargo-count slowdown
- timed speed/fuel pressure
- pickup respawn
- switch auto-reset
- endless score/survival loop

기존 CI와 assertion 수는 old core의 역사적 품질 증거다. 새 finite product의 구현·밸런스·Android·human evidence로 사용하지 않는다.

## Current Execution Authority

```text
GMB-002 MERGED_AND_SYNCED
→ FINITE_PUZZLE_DEFINITION_OF_READY
→ package resegmentation
→ TDD implementation
→ product/device/human validation
```

기존 `VS03-R1 → VS03-05A → VS03-04...` 순서는 `[대체됨]`이다.
