# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · SX-DEC-014_SYNCED · SX-DEC-015_CONFIRMED · NEXT_GRILL_ME_SX-DEC-016
baseline_main: 11c6914b0fdcfb946c85e303d05017a77b969e55
combo_decision_commit: ca50538652c72cbb282d7818990e92a0dfe79c9a
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: SX_DEC_014_SYNCED · SX_DEC_015_PENDING_MERGE_AND_SHEET
codex_state: CODEX_NOT_READY
number_policy: RECOMMENDED_DEFAULT_OR_TEST_VALUE
user_decision_policy: ONE_MATERIAL_GRILL_ME_AT_A_TIME
```

## 목적

VS-03 구현 전에 프로젝트의 제품·경험·시스템·콘텐츠·UX·표현·세계·데이터·저장·검증·제작 기획을 실제 구현과 대조한다. 검증된 안전 보완은 자동 반영하고, 프로젝트 방향을 달리 만드는 충돌만 Grill Me Decision으로 닫는다.

## 보호 강점

- 자동 운행 중 적재·분기·LIFO를 동시에 계획하는 핵심 조합
- 15×10 전체 연결·막다른길 없음
- 직진 우선·preview parity·segment target lock
- 색상+모양 화물·역
- 최대 적재 8·결정론적 배치·bounded failure·deferred recovery
- 귀엽고 친근한 프리미엄 캐주얼 철도 방향
- 짧은 모바일 세션과 기록 경쟁
- 제품 결과와 UI 모션의 권위 분리
- Godot 4.7.1·Android 가로형 기준

## Coverage Matrix

| 영역 | 현재 상태 | 확인된 강점 | 공백·충돌 | 판정 |
|---|---|---|---|---|
| 프로젝트·운영 | 정본·Sheet 동기화 루프 운영 | 새 작업자가 VS-02 완료와 다음 Gate 복원 가능 | 새 Decision merge·Sheet closure 필요 | IN_PROGRESS |
| 제품·타깃 | 모바일 캐주얼·짧은 세션·기록 경쟁 | 제품 약속은 선명함 | 목표 세션 시간·첫 세션 기대 결과는 실측 전 수치 | TEST_VALUE_REQUIRED |
| 핵심 플레이 | 자동운행→LOAD→분기→LIFO | Combo·compact token 의미 확정 | 실제 생존 경제 미구현 | READY_FOR_PLAN |
| 화물·화차 | 화물 1개=compact token 1개 | 적재량·LIFO 순서를 세계 안에서 표시 | 작은 token 가독성·곡선·점유는 미검증 | DECISION_CLOSED_THEN_TEST |
| 생존 경제 | 시간·무게·BOOST 위험 교환 | Combo와 speed bonus 분리 | 수치는 미검증 | TEST_VALUE_REQUIRED |
| 실패·복구 | 연료 0→결과→재시작 | 즉시 재도전 방향 명확 | 결과 화면의 실패 원인·학습 정보 우선순위 미정 | NEEDS_IMPROVEMENT |
| 온보딩 | 3분 내 LIFO 이해 목표 | 테스트 가설 존재 | 분기·LOAD·LIFO·token 학습 순서와 도움 방식 미정 | USER_DECISION_REQUIRED |
| UX·HUD | 상단 상태·하단 입력·경로 강조 | Combo·speed bonus·rear token 의미 분리 | 일시정지·시간 압박 경고·온보딩 미정 | BLOCKED_BY_SX_DEC_016 |
| 아트·모션 | 승인 콘셉트·compact token·모션 비권위 | 시각 Pillar 명확 | 실제 자산·카메라·밀도·이펙트 미검증 | TEST_IN_VERTICAL_SLICE |
| 오디오·햅틱 | 정보 우선순위·fallback 권장 계약 | mute·haptic-off에도 P0/P1 정보 보존 | 실제 자산·사람 반응 미검증 | AUTO_FIXED_THEN_TEST |
| 세계·서사 | 토끼 기관사·미니어처 철도 | 제품 호감과 테마에 충분 | VS 상세 이름·서사 | DEFERRED_WITH_BOUNDARY |
| 데이터·저장 | best score/time/max_combo·schema version | max_combo 의미 확정 | 손상·버전 fallback 실제 구현 없음 | READY_FOR_PLAN |
| 텔레메트리 | 핵심 이벤트·cargo_type·token fields | 원인 분리 가능 | 실제 event log 미구현 | AUTO_FIXED_THEN_BUILD |
| 플레이테스트 | 5명+·핵심 과제·구체 명수 | LIFO·Combo·token 이해 측정 가능 | 실제 표본 없음 | AUTO_FIXED_THEN_TEST |
| 성능·접근성 | 60 FPS·48dp·색+모양 | 목표 품질 Gate 존재 | 기기·해상도·사람 증거 없음 | BLOCKED_UNVERIFIED |
| 제작·인계 | VS-03A→VS-03B→VS-04 | 책임 분리·테스트 순서 명확 | 온보딩 Decision·Sheet sync 미완료 | CODEX_NOT_READY |

## Finding Ledger

| ID | 유형 | 문제 | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| SX-AUD-004-F01 | PLANNING_CONFLICT | Combo가 단일 하역 그룹인지 배송 streak인지 불명확 | 점수·HUD·저장 차단 | CONFLICT_FIXED | `SX-DEC-014` 사용자 승인·GitHub/Sheet SYNCED |
| SX-AUD-004-F02 | UNDERDESIGN | cargo count와 visible wagon 관계 미정 | 실루엣·무게 가독성·점유·애니메이션 충돌 | CONFLICT_FIXED | `SX-DEC-015` compact token 사용자 승인 |
| SX-AUD-004-F03 | UNDERDESIGN | 첫 세션 학습 순서·도움 방식 미정 | 이해 실패가 판단 실패로 오인될 위험 | USER_DECISION_REQUIRED | `SX-DEC-016` NEXT Grill Me |
| SX-AUD-004-F04 | STALE_REFERENCE | 프로젝트 Skill이 Post-VS01과 구형 구현 경계 사용 | 잘못된 사실 복원 | CONFLICT_FIXED | Post-VS02·총기획 기준으로 갱신 |
| SX-AUD-004-F05 | MEASUREMENT_GAP | 5명 표본에 70%·50% 기준 | 반올림 자의성 | CONFLICT_FIXED | 퍼센트+실제 명수·ceil 규칙 병기 |
| SX-AUD-004-F06 | ACCESSIBILITY_RISK | telemetry가 color만 기록 | 색상+모양 오류 원인 분리 불가 | CONFLICT_FIXED | cargo_type·color·shape 기록 |
| SX-AUD-004-F07 | UNDERDESIGN | 오디오·햅틱 사건 우선순위 부재 | fallback과 정보 설계 단절 | IMPROVED | P0/P1/P2 권장 계약 작성 |
| SX-AUD-004-F08 | UNPROVEN_ASSUMPTION | 속도·연료·보상·목표 세션 수치 | 영구 생존·상시 BOOST·피로 위험 | RESEARCH_OR_TEST_REQUIRED | TEST_VALUE·시뮬레이션·플레이테스트 |
| SX-AUD-004-F09 | PRODUCTION_RISK | 역6·화물12+·분기·HUD의 실제 밀도 미검증 | 작은 화면 정보 과부하 | TEST_IN_VERTICAL_SLICE | VS-03B 캡처·Android 검증 |
| SX-AUD-004-F10 | MISSING_CANON | 총기획 감사·Decision Queue 책임 문서 부재 | 기획 보완 추적 불가 | CONFLICT_FIXED | 이 문서를 current 감사로 등록 |
| SX-AUD-004-F11 | STALE_REFERENCE | 마스터 Plan이 복구를 IN_PROGRESS, 구형 main 표시 | 완료 작업 재실행·잘못된 구현 기준 | CONFLICT_FIXED | PR #16/#17/#18/#19 상태 전파 |
| SX-AUD-004-F12 | AUTHORITY_CONFLICT | 총기획 감사와 Post-VS02 감사를 모두 CURRENT로 표시 | 현행 감사 선택 불명확 | CONFLICT_FIXED | 총기획 감사 CURRENT·Post-VS02 HISTORICAL |
| SX-AUD-004-F13 | UX_DENSITY_RISK | 1 cargo=1 full-cell wagon은 최대 적재 시 열차가 8칸 늘어남 | 경로·역·spawn 가시성 저하 | CONFLICT_FIXED | 1:1 compact token·최대 trailing 3칸 |
| SX-AUD-004-F14 | SPAWN_FAIRNESS_RISK | token을 시각만 압축하고 spawn 점유를 8칸 유지할 가능성 | 가용 pickup 공간 불필요 감소 | CONFLICT_FIXED_IN_PLAN | compressed footprint를 점유 권위로 정의 |
| SX-AUD-004-F15 | ACCESSIBILITY_RISK | token 축소로 shape 식별이 사라질 가능성 | 색각 사용자·LIFO 판단 실패 | TEST_REQUIRED | 0/1/4/8·곡선·Android 가독성 Gate |

## 확정 Decision — SX-DEC-014

```text
Combo = 한 번의 역 도착에서 stack top부터 연속 하역된 동일 cargo_type 개수
max_combo = 한 판에서 기록한 최대 Combo
빠른 연속 배송 = Combo가 아닌 별도 speed_bonus 시험 차원
```

파생 결과:

- `try_unload().count`, `combo_count`, `unload_group_size`를 같은 값으로 통일
- 배송 사이에 유지되는 Combo streak state 제거
- HUD `COMBO ×N`, 상단 run 최대 Combo, 결과 `MAX COMBO`
- `speed_bonus_applied`를 별도 telemetry 필드로 기록
- 저장은 `max_combo`만 보존

판정: `CONFLICT_FIXED · GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

## 확정 Decision — SX-DEC-015

사용자 승인·보정:

```text
화물 1개 = 작은 토큰형 화차 1개
0화물 = 기관차만
front→rear token order = stack bottom→top
rear token = 다음 LIFO 하역 대상
8 token chain = 약 2.18칸 TEST_VALUE
trailing spawn footprint = 최대 3칸 TEST_VALUE
```

핵심 이유:

1. 화물 수·감속·capacity를 세계 안에서 직접 읽을 수 있다.
2. 가장 뒤 token을 다음 하역 대상으로 보여 LIFO를 강화한다.
3. full-size 화차 8개로 길게 늘어져 경로·역·분기 가시성이 떨어지는 문제를 피한다.
4. 압축 시각과 압축 spawn footprint를 함께 정의해 공간 공정성을 유지한다.

파생 계약:

- token count는 CargoStack size와 1:1이다.
- 빈 token slot은 표시하지 않는다.
- 적재는 뒤에 token을 추가하고 하역은 뒤쪽 동일 타입 연속 그룹을 제거한다.
- token은 색상+모양을 가진다.
- CargoStack 변경과 token count/order·점유 갱신은 같은 도메인 단계에서 완료한다.
- animation completion은 적재·하역·점유 권위가 아니다.
- fractional path history로 곡선을 따라가고 순서가 바뀌지 않는다.
- 화물 8개를 8개의 full-cell 점유로 취급하지 않는다.
- HUD first unload item·rear token·CargoStack top은 항상 같다.

설계 정본:

- `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`

판정: `CONFLICT_FIXED · GITHUB_CANON_PENDING_MERGE · SHEET_PENDING · IMPLEMENTATION_NOT_STARTED`.

## Decision Queue

1. `SX-DEC-014` Combo 정의 — `CONFIRMED · SYNCED · CLOSED`
2. `SX-DEC-015` compact wagon token 관계 — `CONFIRMED · GITHUB/SHEET SYNC IN_PROGRESS`
3. `SX-DEC-016` 첫 세션 온보딩 방식 — `NOW · BLOCKS USER PLAYTEST`
4. 실패 결과 학습 정보 — `REASSESS_AFTER_SX_DEC_016`
5. 세계·마스코트 상세 범위 — `DEFERRED_WITH_BOUNDARY`

## 자동 보완 반영

- 프로젝트 Skill의 읽기 순서·구현 경계를 Post-VS02로 갱신
- 플레이테스트 퍼센트에 실제 명수·ceil 판정 병기
- telemetry를 cargo_type·color·shape·unload_group_size 기반으로 확장
- Combo와 speed bonus를 점수·HUD·저장·telemetry에서 분리
- compact token의 token_count·rear_token_type·trailing_footprint 계측 추가
- 오디오·햅틱 사건 우선순위와 mute/haptic-off fallback 권장 계약 작성
- 목표 세션 시간·경제·token 기하 수치는 `TEST_VALUE`로 유지
- compact token과 compressed footprint를 본책·VS·Playtest에 전파
- Registry의 현행 감사 권위를 `SX-AUD-004`로 단일화

## 현재 Gate

`GITHUB_UPDATE_PENDING_SHEET · SX-DEC-015 · CODEX_NOT_READY`

`SX-DEC-015`를 PR merge commit과 Google Sheets에 같은 Decision/Evidence ID로 동기화한 뒤 다음 질문 `SX-DEC-016`을 진행한다. VS-03 구현은 전체 필수 Decision과 G3P가 닫힌 뒤에만 시작한다.
