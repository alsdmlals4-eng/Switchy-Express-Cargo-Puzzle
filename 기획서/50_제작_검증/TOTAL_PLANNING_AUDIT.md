# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · SX-DEC-014/015_SYNCED · SX-DEC-016_CANON_IN_PROGRESS
baseline_main: 867563bb7bb69cfbb7343ef734585dd034ad7a64
combo_decision_commit: ca50538652c72cbb282d7818990e92a0dfe79c9a
compact_token_decision_commit: b8742253247da25a0190f80b898b9bbe6ec6a1cf
onboarding_decision_commit: CANONICAL_PR_PENDING
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: SX-DEC-014/015_SYNCED · SX-DEC-016_PENDING_CANONICAL_MERGE
codex_state: CODEX_NOT_READY
number_policy: RECOMMENDED_DEFAULT_OR_TEST_VALUE
user_decision_policy: ONE_MATERIAL_GRILL_ME_AT_A_TIME
merge_policy: SX-DEC-016_CATCH_UP_THEN_10_APPROVAL_BATCHES
operating_protocol: SX-OPS-001
```

## 목적

VS-03 구현 전에 프로젝트의 제품·경험·시스템·콘텐츠·UX·표현·세계·데이터·저장·검증·제작 기획을 실제 구현과 대조한다. 검증된 안전 보완은 자동 반영하고, 프로젝트 방향을 달리 만드는 충돌만 Grill Me Decision으로 닫는다.

`SX-DEC-016`까지의 승인분은 catch-up으로 즉시 병합·Sheet 동기화한다. 이후 `SX-DEC-017`부터는 Grill Me 승인 10건마다 `SX-OPS-001`의 pre-merge 전수 감사와 Sync Closure를 수행한다.

## 보호 강점

- 자동 운행 중 적재·분기·LIFO를 동시에 계획하는 핵심 조합
- 15×10 전체 연결·막다른길 없음
- 직진 우선·preview parity·segment target lock
- 색상+모양 화물·역
- 최대 적재 8·결정론적 배치·bounded failure·deferred recovery
- compact token으로 적재량·LIFO를 표시하면서 긴 열차의 화면 점유를 억제
- 실제 첫 run에서 규칙을 행동 직후 가르치는 상황형 온보딩
- 귀엽고 친근한 프리미엄 캐주얼 철도 방향
- 짧은 모바일 세션과 기록 경쟁
- 제품 결과와 UI 모션의 권위 분리
- Godot 4.7.1·Android 가로형 기준

## Coverage Matrix

| 영역 | 현재 상태 | 확인된 강점 | 공백·충돌 | 판정 |
|---|---|---|---|---|
| 프로젝트·운영 | `SX-DEC-014/015` GitHub·Sheet 동기화 완료, `SX-OPS-001` 승인 | 10건 배치와 사전 전수감사 계약 명확 | 프로토콜의 첫 실제 적용은 GMB-001 | OPERATING_PROTOCOL_APPROVED |
| 제품·타깃 | 모바일 캐주얼·짧은 세션·기록 경쟁 | 제품 약속은 선명함 | 목표 세션 시간·첫 세션 기대 결과는 실측 전 수치 | TEST_VALUE_REQUIRED |
| 핵심 플레이 | 자동운행→LOAD→분기→LIFO | Combo·compact token 의미 확정 | 실제 생존 경제 미구현 | READY_FOR_PLAN |
| 화물·화차 | 화물 1개=compact token 1개 | 적재량·LIFO 순서를 세계 안에서 표시 | 작은 token 가독성·곡선·점유는 미검증 | DECISION_CLOSED_THEN_TEST |
| 생존 경제 | 시간·무게·BOOST 위험 교환 | Combo와 speed bonus 분리 | 수치는 미검증 | TEST_VALUE_REQUIRED |
| 실패·복구 | 연료 0→결과→재시작 | 즉시 재도전 방향 명확 | 결과 화면의 실패 원인·학습 정보 우선순위 미정 | NEXT_MATERIAL_DECISION_CANDIDATE |
| 온보딩 | 실제 첫 run 상황형 단계 학습 | 별도 튜토리얼 맵 없이 행동과 설명 결합 | 구현·Android·사람 증거 없음 | SX-DEC-016_CONFIRMED_THEN_TEST |
| UX·HUD | 상단 상태·하단 입력·경로 강조 | 첫 LOAD/분기 safe pause·Help 경계 확정 | 실제 UI 밀도·일시정지 경험 미검증 | READY_FOR_PLAN |
| 아트·모션 | 승인 콘셉트·compact token·모션 비권위 | 시각 Pillar 명확 | 실제 자산·카메라·밀도·이펙트 미검증 | TEST_IN_VERTICAL_SLICE |
| 오디오·햅틱 | 정보 우선순위·fallback 권장 계약 | mute·haptic-off에도 P0/P1 정보 보존 | 실제 자산·사람 반응 미검증 | AUTO_FIXED_THEN_TEST |
| 세계·서사 | 토끼 기관사·미니어처 철도 | 제품 호감과 테마에 충분 | VS 상세 이름·서사 | DEFERRED_WITH_BOUNDARY |
| 데이터·저장 | best score/time/max_combo·onboarding preference 분리 | 의미와 schema 경계 명확 | 손상·버전 fallback 실제 구현 없음 | READY_FOR_PLAN |
| 텔레메트리 | 핵심 이벤트·cargo_type·token·onboarding fields | 원인 분리 가능 | 실제 event log 미구현 | AUTO_FIXED_THEN_BUILD |
| 플레이테스트 | 5명+·핵심 과제·구체 명수 | LIFO·Combo·token·onboarding 이해 측정 가능 | 실제 표본 없음 | AUTO_FIXED_THEN_TEST |
| 성능·접근성 | 60 FPS·48dp·색+모양 | 목표 품질 Gate 존재 | 기기·해상도·사람 증거 없음 | BLOCKED_UNVERIFIED |
| 제작·인계 | VS-03A→VS-03B→VS-04 | 책임 분리·테스트 순서 명확 | 총기획 후속 Decision과 evidence 미완료 | CODEX_NOT_READY |

## Finding Ledger

| ID | 유형 | 문제 | 영향 | 판정 | 처리 |
|---|---|---|---|---|---|
| SX-AUD-004-F01 | PLANNING_CONFLICT | Combo가 단일 하역 그룹인지 배송 streak인지 불명확 | 점수·HUD·저장 차단 | CONFLICT_FIXED | `SX-DEC-014` 사용자 승인·GitHub/Sheet SYNCED |
| SX-AUD-004-F02 | UNDERDESIGN | cargo count와 visible wagon 관계 미정 | 실루엣·무게 가독성·점유·애니메이션 충돌 | CONFLICT_FIXED | `SX-DEC-015` compact token 사용자 승인·GitHub/Sheet SYNCED |
| SX-AUD-004-F03 | UNDERDESIGN | 첫 세션 학습 순서·도움 방식 미정 | 이해 실패가 판단 실패로 오인될 위험 | CONFLICT_FIXED_IN_CANON | `SX-DEC-016` 실제 첫 run 상황형 온보딩 승인 |
| SX-AUD-004-F04 | STALE_REFERENCE | 프로젝트 Skill이 Post-VS01과 구형 구현 경계 사용 | 잘못된 사실 복원 | CONFLICT_FIXED | Post-VS02·총기획 기준으로 갱신 |
| SX-AUD-004-F05 | MEASUREMENT_GAP | 5명 표본에 70%·50% 기준 | 반올림 자의성 | CONFLICT_FIXED | 퍼센트+실제 명수·ceil 규칙 병기 |
| SX-AUD-004-F06 | ACCESSIBILITY_RISK | telemetry가 color만 기록 | 색상+모양 오류 원인 분리 불가 | CONFLICT_FIXED | cargo_type·color·shape 기록 |
| SX-AUD-004-F07 | UNDERDESIGN | 오디오·햅틱 사건 우선순위 부재 | fallback과 정보 설계 단절 | IMPROVED | P0/P1/P2 권장 계약 작성 |
| SX-AUD-004-F08 | UNPROVEN_ASSUMPTION | 속도·연료·보상·목표 세션 수치 | 영구 생존·상시 BOOST·피로 위험 | RESEARCH_OR_TEST_REQUIRED | TEST_VALUE·시뮬레이션·플레이테스트 |
| SX-AUD-004-F09 | PRODUCTION_RISK | 역6·화물12+·분기·HUD의 실제 밀도 미검증 | 작은 화면 정보 과부하 | TEST_IN_VERTICAL_SLICE | VS-03B 캡처·Android 검증 |
| SX-AUD-004-F10 | MISSING_CANON | 총기획 감사·Decision Queue 책임 문서 부재 | 기획 보완 추적 불가 | CONFLICT_FIXED | 이 문서를 current 감사로 등록 |
| SX-AUD-004-F11 | STALE_REFERENCE | 마스터 Plan이 복구를 IN_PROGRESS, 구형 main 표시 | 완료 작업 재실행·잘못된 구현 기준 | CONFLICT_FIXED | 후속 상태 전파·새 planning companion 작성 |
| SX-AUD-004-F12 | AUTHORITY_CONFLICT | 총기획 감사와 Post-VS02 감사를 모두 CURRENT로 표시 | 현행 감사 선택 불명확 | CONFLICT_FIXED | 총기획 감사 CURRENT·Post-VS02 HISTORICAL |
| SX-AUD-004-F13 | UX_DENSITY_RISK | 1 cargo=1 full-cell wagon은 최대 적재 시 열차가 8칸 늘어남 | 경로·역·spawn 가시성 저하 | CONFLICT_FIXED | 1:1 compact token·최대 trailing 3칸 |
| SX-AUD-004-F14 | SPAWN_FAIRNESS_RISK | token을 시각만 압축하고 spawn 점유를 8칸 유지할 가능성 | 가용 pickup 공간 불필요 감소 | CONFLICT_FIXED_IN_PLAN | compressed footprint를 점유 권위로 정의 |
| SX-AUD-004-F15 | ACCESSIBILITY_RISK | token 축소로 shape 식별이 사라질 가능성 | 색각 사용자·LIFO 판단 실패 | TEST_REQUIRED | 0/1/4/8·곡선·Android 가독성 Gate |
| SX-AUD-004-F16 | TEST_VALUE_DRIFT | Decision 한 문장에 2.25칸, 파생 계약·Sheet에 2.18칸 표기 | 구현자가 다른 기하값 선택 | CONFLICT_FIXED | 권장 TEST_VALUE 2.18칸으로 통일 |
| SX-AUD-004-F17 | ONBOARDING_AUTHORITY_RISK | tutorial overlay나 animation이 pickup·pause·step 완료를 소유할 가능성 | 중복 보상·잠금·resume 오류 | CONFLICT_FIXED_IN_SPEC | OnboardingState는 domain event 소비, UI는 표시만 담당 |
| SX-AUD-004-F18 | EVIDENCE_CONTAMINATION | 0.5× 연료·난이도 정지 first-run을 일반 밸런스 증거로 섞을 가능성 | 생존 경제 결론 왜곡 | AUTO_FIX_ELIGIBLE | assisted_first_run flag로 telemetry·분석 분리, 일반 run 별도 검증 |
| SX-AUD-004-F19 | OPERATING_DRIFT_RISK | 10건 대기 중 Sheet가 main보다 앞서면서 SYNCED로 오표기될 가능성 | 정본·Sheet 권위 혼선 | CONFLICT_FIXED_IN_PROTOCOL | `APPROVED_PENDING_BATCH_MERGE`와 branch commit 사용 |
| SX-AUD-004-F20 | BATCH_SCOPE_RISK | 10건 PR에 11번째 Decision·무관 리팩터링이 잠입할 가능성 | 승인 범위 왜곡·검토 불가 | CONFLICT_FIXED_IN_PROTOCOL | 10번째 승인 후 Freeze, changed-file·Decision inventory Gate |

## 확정 Decision — SX-DEC-014

```text
Combo = 한 번의 역 도착에서 stack top부터 연속 하역된 동일 cargo_type 개수
max_combo = 한 판에서 기록한 최대 Combo
빠른 연속 배송 = Combo가 아닌 별도 speed_bonus 시험 차원
```

판정: `CONFLICT_FIXED · GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

## 확정 Decision — SX-DEC-015

```text
화물 1개 = 작은 토큰형 화차 1개
0화물 = 기관차만
front→rear token order = stack bottom→top
rear token = 다음 LIFO 하역 대상
8 token chain = 2.18칸 TEST_VALUE
trailing spawn footprint = 최대 3칸 TEST_VALUE
```

판정: `CONFLICT_FIXED · GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED`.

## 확정 Decision — SX-DEC-016

```text
별도 튜토리얼 맵 없음
실제 첫 무한 run에서 단계별 상황 학습
LOAD → compact token → 분기 → mixed-stack LIFO → Combo → 저연료 BOOST
첫 LOAD와 첫 분기만 safe full pause 허용
first-run assist: fuel drain 0.5×, escalation pause, max 120s TEST_VALUE
완료·skip·timeout 후 일반 run으로 연속 전환
```

책임 정본:

- `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`
- `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`

판정: `CONFLICT_FIXED_IN_CANON · SHEET_PENDING_CANONICAL_MERGE · IMPLEMENTATION_NOT_STARTED`.

## 운영 확정 — SX-OPS-001

```text
SX-DEC-016까지 catch-up 병합
그 이후 Grill Me 승인 10건마다 canonical batch PR 병합
10번째 승인 후 GitHub main·PR·Issue·Goal·Plan·Gate·Registry·Sheet 12탭 전수 확인
적대적 Finding P0/P1 0 + exact-head checks success + review thread 0에서만 병합
canonical merge 후 Sheet 12탭 readback PASS와 Sync Closure PR 병합까지 batch 완료
```

책임 정본:

- `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`

판정: `OPERATING_PROTOCOL_APPROVED · ACTIVE_AFTER_CURRENT_CATCH_UP`.

## Decision Queue

1. `SX-DEC-014` Combo 정의 — `CONFIRMED · SYNCED · CLOSED`
2. `SX-DEC-015` compact wagon token 관계 — `CONFIRMED · SYNCED · CLOSED`
3. `SX-DEC-016` 실제 첫 run 상황형 온보딩 — `CONFIRMED · CANON_IN_PROGRESS`
4. `SX-DEC-017` 결과 화면의 실패 원인·다음 행동 정보 — `NEXT_GRILL_ME · GMB-001 SLOT 1`
5. 세계·마스코트 상세 범위 — `DEFERRED_WITH_BOUNDARY`

## 자동 보완 반영

- 프로젝트 Skill의 읽기 순서·구현 경계를 Post-VS02로 갱신
- 플레이테스트 퍼센트에 실제 명수·ceil 판정 병기
- telemetry를 cargo_type·color·shape·unload_group_size 기반으로 확장
- Combo와 speed bonus를 점수·HUD·저장·telemetry에서 분리
- compact token의 token_count·rear_token_type·trailing_footprint 계측 추가
- 온보딩 event와 `assisted_first_run` 분석 분리
- 오디오·햅틱 사건 우선순위와 mute/haptic-off fallback 권장 계약 작성
- 목표 세션 시간·경제·token 기하·온보딩 assist 수치는 `TEST_VALUE`로 유지
- 10건 batch pending 상태와 main SYNCED 상태를 분리

## 현재 Gate 판정

- `G2_IMPLEMENTED_FOUNDATION`: PASS
- `G3_CORE_LOOP_IMPLEMENTED`: PARTIAL
- `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`: NOT_READY
- `G4_TARGET_QUALITY_VERTICAL_SLICE`: NOT_READY
- `CODEX_DEFINITION_OF_READY`: NOT_READY

현재 차단:

```text
SX-DEC-016 canonical merge + Sheet closure
→ SX-DEC-017부터 GMB-001 10건 Decision batch
→ 남은 필수 Decision 0 재판정
→ VS-03 Codex Definition of Ready
```

## 다음 작업

1. `SX-DEC-016`과 `SX-OPS-001` canonical PR exact-head 검증
2. 병합 직전 main·Sheet·PR 적대적 전수 대조
3. canonical 병합 후 같은 Decision/Evidence와 merge commit을 Sheet에 기록
4. 12탭 readback PASS 후 Sync Closure PR 병합
5. `GMB-001` ledger를 0/10으로 시작하고 `SX-DEC-017`을 한 건만 질문

## 결론

`SX-DEC-014/015`는 GitHub와 Google Sheets에서 `PASS · SYNCED`다. `SX-DEC-016`과 `SX-OPS-001`은 사용자 승인됐으나 현재 PR과 Sheet closure가 끝나기 전까지 `CANON_IN_PROGRESS`다. 제품 구현·Android·사람 검증은 여전히 `NOT_STARTED / NOT_RUN`이며 `CODEX_NOT_READY`를 유지한다.
