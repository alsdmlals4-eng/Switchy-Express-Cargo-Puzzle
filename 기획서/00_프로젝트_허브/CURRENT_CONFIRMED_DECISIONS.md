# Current Confirmed Decisions

Last updated: `2026-08-02`
Original decision baseline: `dadb5ca0a3acc3ba6e730f7a9de438f0bd8ebe59`
VS-01 canonical sync: `7500ccea1cddd6c163965a44370b653bbc176f85`
VS-02 implementation: `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
VS-02 runtime recovery: `4e435a1a6d10ab146197671049da80709fd18c1f`
Base v9.4 adoption: `539d2bae18d20e303649f047b9df69e8e224b2e7`
Post-VS02 canonical recovery: `8245e22905d64e22b599fe009bbb660d005392ed`
Post-VS02 Sheet closure: `474bef445c2cf5e501bd7478e26a5b8d0dfe26f1`
Total Planning Combo Decision: `ca50538652c72cbb282d7818990e92a0dfe79c9a`
Combo Sheet closure: `11c6914b0fdcfb946c85e303d05017a77b969e55`
Compact Wagon Token Decision: `b8742253247da25a0190f80b898b9bbe6ec6a1cf`
First-Session Onboarding Decision: `CANON_IN_PROGRESS`

| Decision ID | 분야 | 현재 결정 | 근거 | 상태 |
|---|---|---|---|---|
| SX-DEC-001 | 제품 | 정식 프로젝트 제목은 `Switchy Express: Cargo Puzzle`이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-002 | 경험 | 목표는 무한 운행에서 오래 생존하고 최고 점수를 경쟁하는 것이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-003 | 경험 | 기차는 자동 운행하며 플레이어는 `LOAD`, 분기기 탭, `BOOST`를 조작한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-004 | 맵 | 가로형 15×10 맵에서 모든 선로는 하나의 네트워크로 연결되고 막다른길을 허용하지 않는다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-005 | 맵 | 갈림길에는 2단계 또는 3단계 분기기를 배치하고 활성 선로 방향을 명확히 표시한다. 현재 격자 그래프는 한 접근 방향에서 최대 3개 출구 상태를 지원한다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-006 | 콘텐츠 | 빨강·파랑·노랑 스테이션을 색상별 2개씩 일반 선로에 배치한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-007 | 콘텐츠 | 맵에는 각 색상 화물이 항상 최소 4개 존재하며 적재된 화물은 다른 유효 선로 위치에 재생성된다. | 사용자 승인·PR #12·#13 | CONFIRMED |
| SX-DEC-008 | 시스템 | 화물은 마지막에 실은 것부터 내리는 LIFO이며 같은 색이 연속되면 그룹으로 하역한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-009 | 시스템 | 배송은 점수와 연료를 주며 시간 경과에 따라 기본 속도와 연료 소모가 증가하고 연료 0에서 종료된다. | 사용자 승인 | CONFIRMED |
| SX-DEC-010 | 시스템 | 적재 화물 수가 많을수록 기차가 느려지고 BOOST는 속도를 높이는 대신 연료를 추가 소모한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-011 | 표현 | 부드럽고 둥근 프리미엄 캐주얼 3D 카툰, 친근한 토끼 기관사, 선명한 선로·분기 UX를 사용한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android/Google Play, 가로형 화면을 초기 기술 기준으로 사용한다. | 프로젝트 기본값·PR #9 | CONFIRMED |
| SX-DEC-013 | 분기 UX | 분기기의 기본 A노선은 가능한 경우 현재 진행 방향의 직진을 우선하며, 미리보기 첫 칸과 실제 다음 칸은 항상 일치해야 한다. | 사용자 권장안 일괄 승인·PR #9 | CONFIRMED |
| SX-DEC-014 | 점수·피드백 | `Combo`는 한 번의 역 도착에서 stack top부터 연속 하역된 동일 화물 타입의 개수다. `max_combo`는 한 판의 최대 하역 그룹 크기이며, 빠른 연속 배송은 Combo가 아니라 별도 `speed_bonus` 시험 차원이다. | 사용자 권장안 승인 · EV-USER-002 | CONFIRMED |
| SX-DEC-015 | 화물·화차 UX | 적재 화물 1개를 작은 토큰형 화차 1개로 표시하되 최대 8개 토큰 열은 권장 시험값 2.18칸으로 압축하고, 생성 금지 점유는 압축 footprint만 사용한다. | 사용자 권장안 승인·토큰형 보정 · EV-USER-003 | CONFIRMED |
| SX-DEC-016 | 첫 세션 UX | 별도 튜토리얼 맵 대신 실제 첫 무한 운행에서 LOAD→compact token→분기→mixed-stack LIFO→Combo→저연료 BOOST를 상황형으로 가르치며, 첫 LOAD와 첫 분기에서만 안전 정지를 허용한다. | 사용자 권장안 승인 · EV-USER-004 | CONFIRMED |
| SX-OPS-001 | 운영 | `SX-DEC-016`까지 catch-up 병합 후 Grill Me 승인 10건마다 canonical batch PR을 병합하고, 직전 GitHub·Sheet·PR 전수 대조와 적대적 검토를 필수 Gate로 수행한다. | 사용자 명시 지시 · EV-USER-005 | CONFIRMED_OPERATION |

## 구현·검증 추적

| Decision ID | 구현 상태 | 검증 상태 | 증거 | 남은 범위 |
|---|---|---|---|---|
| SX-DEC-003 | PARTIAL | PARTIAL_PASS | 자동 운행·LOAD·BOOST 우선 입력 계약: PR #12/#13 | BOOST 속도·연료 효과, 제품 입력 UI |
| SX-DEC-004 | IMPLEMENTED | PASSED | PR #9 / seeds 1~100 | 맵 다양성·실제 플레이 가독성 |
| SX-DEC-005 | IMPLEMENTED_LOGIC | PASSED_LOGIC | PR #9 / preview mismatch 0 | 런타임 선로·레버·화살표 |
| SX-DEC-006 | IMPLEMENTED | PASSED | PR #12 / 색상별 2개·총 6개·거리 검사 | 런타임 시각·사람 가독성 |
| SX-DEC-007 | IMPLEMENTED | PASSED | PR #12/#13 / 최소 수량·금지 칸·지연 회복 | 장시간 starvation·soak |
| SX-DEC-008 | IMPLEMENTED | PASSED | PR #12 / LIFO stack·station·DeliveryLoop | 점수·연료 보상·HUD 표현 |
| SX-DEC-009 | NOT_STARTED | NOT_RUN | Issue #6 | 속도·연료·점수·게임오버 |
| SX-DEC-010 | INTERFACE_ONLY | NOT_RUN | BOOST 우선 입력 계약만 존재 | 감속·BOOST 경제와 exploit 검증 |
| SX-DEC-011 | APPROVED_DIRECTION | HUMAN_RUNTIME_NOT_RUN | 사용자 승인 콘셉트·Visual Direction | 제품 UI·아트·Android 캡처 |
| SX-DEC-012 | IMPLEMENTED_BASELINE | PARTIAL | Godot 4.7.1 headless 6915 assertions | Android export·실기·성능 |
| SX-DEC-013 | IMPLEMENTED | PASSED | PR #9·#12 / locked route·preview parity | 런타임 시각 검증 |
| SX-DEC-014 | DOMAIN_SEMANTICS_CONFIRMED | NOT_STARTED | 사용자 승인 · 기존 `try_unload().count`가 입력 근거 | RunBalance 보상·HUD 피드백·`max_combo` 저장·telemetry |
| SX-DEC-015 | PLANNING_SPEC_APPROVED | NOT_STARTED | PR #24 / `b8742253247da25a0190f80b898b9bbe6ec6a1cf` | compact token ViewModel·fractional path follow·compressed occupancy·Android 가독성 |
| SX-DEC-016 | PLANNING_SPEC_APPROVED | NOT_STARTED | `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md` | state machine·first-run assist·overlay·help·telemetry·Android/human validation |
| SX-OPS-001 | OPERATING_PROTOCOL_APPROVED | ACTIVE_AFTER_CATCH_UP | `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md` | GMB-001에서 10건 단위 운영 검증 |

## Evidence 원장

| Evidence ID | 내용 | GitHub 증거 | 상태 |
|---|---|---|---|
| EV-USER-002 | Combo를 단일 역 도착의 동일 타입 연속 하역 개수로 확정하고 빠른 배송을 별도 `speed_bonus`로 분리 | 사용자 승인·PR #18 / `ca50538652c72cbb282d7818990e92a0dfe79c9a` | CONFIRMED_USER_DECISION |
| EV-USER-003 | 화물 1개를 작은 토큰형 화차 1개로 표시하고 긴 열차로 인한 가시성 저하를 막도록 압축 표현 | 사용자 승인·PR #24 / `b8742253247da25a0190f80b898b9bbe6ec6a1cf` | CONFIRMED_USER_DECISION |
| EV-USER-004 | 실제 첫 run에서 LOAD·token·분기·LIFO·Combo·BOOST를 단계적으로 가르치는 상황형 온보딩 A안 승인 | 2026-08-02 사용자 승인·현재 planning PR | CONFIRMED_USER_DECISION |
| EV-USER-005 | 지금까지 승인분 병합 및 이후 Grill Me 10건마다 사전 전수 감사 후 병합 | 2026-08-02 사용자 운영 지시·현재 planning PR | CONFIRMED_USER_OPERATION |
| EV-VS01-001 | Godot·RailGraph·분기 기반 | PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2` | VALIDATED |
| EV-VS02-001 | 기차·화차·화물·역·LIFO | PR #12 / `0738d9c10e431a43e7a2f34590369c3f17d1f8a5` | VALIDATED |
| EV-VS02-FIX-001 | DeliveryLoop 안의 최소 화물 재생성 회복 | PR #13 / `4e435a1a6d10ab146197671049da80709fd18c1f` | VALIDATED |
| EV-BASE-V94-001 | Base v9.4 운영·UI 모션 계약 적용 | PR #15 / `539d2bae18d20e303649f047b9df69e8e224b2e7` | VALIDATED_AUTOMATED_ONLY |
| SX-AUD-002 | Post-VS01 적대적 감사 | `POST_VS01_ADVERSARIAL_AUDIT.md` | HISTORICAL |
| SX-AUD-003 | Post-VS02 정본·구현·Sheet 적대적 감사 | `POST_VS02_ADVERSARIAL_AUDIT.md` | HISTORICAL |
| SX-AUD-004 | 총기획 Coverage·충돌 감사 | `TOTAL_PLANNING_AUDIT.md` | CURRENT |

## SX-DEC-014 파생 계약

- `combo_count = unloaded_count`이며 한 번의 `station_arrived` 처리 안에서만 계산한다.
- 다른 역 도착까지 유지되는 Combo streak state는 만들지 않는다.
- `max_combo = max(previous_max_combo, combo_count)`다.
- 빠른 배송 여부는 `seconds_since_delivery`로 계산하는 `speed_bonus`이며 Combo를 증가·유지·리셋하지 않는다.
- 빈 역 도착이나 타입 불일치는 `combo_count = 0`, 점수·연료 보상 0이다.
- HUD는 성공 하역 시 `COMBO ×N` 피드백을 표시하고 결과 화면은 `MAX COMBO`를 표시한다. 지속 표기 위치·시간은 VS-03B의 시각 시험값이다.

## SX-DEC-015 파생 계약

- `compact_wagon_token_count == cargo_stack.size()`이며 범위는 0~8이다.
- 화물 0개에서는 기관차만 표시하고 빈 토큰 화차는 표시하지 않는다.
- 기관차 쪽부터 뒤쪽까지의 토큰 순서는 stack bottom→top이며, 가장 뒤 토큰이 다음 LIFO 하역 대상이다.
- 적재는 뒤에 토큰 1개를 추가하고 유효 하역은 뒤쪽의 동일 타입 연속 토큰 그룹을 제거한다.
- 토큰은 색상+모양 이중 부호를 가진다.
- 권장 시험값은 body 0.22칸, 중심 간격 0.28칸, 8개 최대 열 길이 2.18칸, trailing 점유 최대 3칸이다.
- 화물 8개를 선로 8칸 점유로 해석하지 않는다. 생성 금지는 기관차와 압축 토큰 열이 실제로 교차하는 칸만 사용한다.
- CargoStack 변경과 토큰 count/order·점유 갱신은 같은 도메인 단계에서 완료하며 모션 완료 신호는 권위를 갖지 않는다.
- HUD Unload Order의 첫 항목은 가장 뒤 토큰·CargoStack top과 항상 일치해야 한다.
- 세부 크기·간격은 `TEST_VALUE`이며, 8개 식별 가능·최대 trailing 3칸·경로 가독성 유지 조건 안에서 조정할 수 있다.

## SX-DEC-016 파생 계약

- 별도 튜토리얼 맵·가짜 보상·튜토리얼 전용 LIFO/Combo 공식은 만들지 않는다.
- 실제 첫 run에서 `LOAD → token 의미 → 첫 분기 → mixed-stack LIFO → Combo → 저연료 BOOST` 순서로 안내한다.
- 첫 LOAD와 첫 분기 접근에서만 full simulation safe pause를 요청할 수 있다. 일반 branch slow motion은 추가하지 않는다.
- first-run assist는 연료 소모 0.5×, 난이도 상승 정지, 최대 120초를 권장 `TEST_VALUE`로 사용한다.
- core 완료·skip·120초 중 먼저 발생한 시점에 assist를 종료하고 3초 동안 일반 balance로 복귀한다.
- OnboardingState는 domain event를 소비하지만 pickup·route·unload·score·fuel·Combo를 직접 변경하지 않는다.
- 완료 후 Help는 다시 볼 수 있으나 spawn 보정·연료 완화를 재활성화하지 않는다.
- 자동 검증과 Android·5명+ 사람 검증 전까지 구현·품질 PASS를 주장하지 않는다.

## SX-OPS-001 배치 병합 계약

- `SX-DEC-016`까지는 catch-up으로 즉시 canonical 병합·Sheet 동기화한다.
- 다음 정규 batch `GMB-001`은 `SX-DEC-017`부터 Grill Me 승인 10건을 센다.
- 승인 직후 batch branch·draft PR·Sheet에 같은 Decision/Evidence를 `APPROVED_PENDING_BATCH_MERGE`로 기록한다.
- 10번째 승인 후 새 질문을 중단하고 GitHub main·batch PR·Issue·Goal·Plan·Gate·Registry·Sheet 12탭을 전수 대조한다.
- P0/P1 open finding 0, unresolved review thread 0, exact-head required checks success일 때만 canonical PR을 병합한다.
- 병합 후 Sheet에 canonical merge commit을 기록하고 12탭 readback PASS 뒤 Sync Closure PR까지 병합해야 batch가 CLOSED다.
- 운영 상세는 `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`가 책임 정본이다.

## 수치·기획 결정 규칙

- 속도·연료·점수·보상·타이밍·토큰 기하·온보딩 assist 상세 수치는 사용자 지시에 따라 GPT 권장안으로 작성한다.
- 해당 수치는 플레이테스트 전까지 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`다.
- 프로젝트 코어·대표 경험·주요 UX·콘텐츠 의미·실패와 보상 의미가 갈리는 선택은 Grill Me로만 확정한다.
- 기존 승인 Decision을 기술 세부 질문으로 다시 묻지 않는다.

## 동기화 상태

- GitHub latest synchronized planning main before `SX-DEC-016`: `b8742253247da25a0190f80b898b9bbe6ec6a1cf`
- Google Sheets: Adapter의 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- `SX-DEC-014/015`: `GITHUB_SHEET_SYNCED`
- `SX-DEC-016`, `EV-USER-004`, `SX-OPS-001`, `EV-USER-005`: `GITHUB_CANON_IN_PROGRESS · SHEET_PENDING_CANONICAL_MERGE`
- compact token·onboarding 런타임·Android·사람 검증: `NOT_STARTED / NOT_RUN / HUMAN_NOT_RUN`
- 제공된 `19Ff...` 시트는 다른 프로젝트이며 변경하지 않았다.
- `CODEX_NOT_READY`

## 폐기·대체된 후보

- 자동차·스네이크 직접 조작안은 현재 기차 노선 조작안으로 대체됨.
- FIFO 하역안은 LIFO 하역안으로 대체됨.
- 세로형 화면안은 가로형 화면안으로 대체됨.
- 15×15·14×9 맵 후보는 최종 15×10 기준으로 대체됨.
- 좌표 순서에 의존하는 기본 분기안은 `SX-DEC-013`의 직진 우선 기본 노선으로 대체됨.
- 연속 배송 streak를 Combo로 부르는 후보는 `SX-DEC-014`에 의해 제외되며 필요 시 별도 Delivery Chain Decision으로만 재도입한다.
- 화물당 한 칸짜리 full-size wagon과 항상 표시되는 빈 8화차 후보는 `SX-DEC-015`의 compact token 방식으로 대체된다.
- 별도 고정 튜토리얼 판과 설명 화면만 제공하는 후보는 `SX-DEC-016`의 실제 첫 run 상황형 온보딩으로 대체된다.
