# Current Confirmed Decisions

Last updated: `2026-08-02`

```yaml
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
latest_synchronized_planning_before_gmb001: 3cd13ff375a597d4eba9035af5b05e6186fb4853
gmb001_baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
gmb001_pr: 29
gmb001_count: 10/10
gmb001_state: FROZEN · PREMERGE_AUDIT
implementation_authority: PLANNING_ONLY
codex_state: CODEX_NOT_READY
```

## Decision Registry

| Decision ID | 분야 | 현재 결정 | 근거 | 상태 |
|---|---|---|---|---|
| SX-DEC-001 | 제품 | 정식 프로젝트 제목은 `Switchy Express: Cargo Puzzle`이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-002 | 경험 | 목표는 무한 운행에서 오래 생존하고 최고 점수를 경쟁하는 것이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-003 | 경험 | 기차는 자동 운행하며 플레이어는 `LOAD`, 분기기 탭, `BOOST`를 조작한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-004 | 맵 | 가로형 15×10 맵에서 모든 선로는 하나의 네트워크로 연결되고 막다른길을 허용하지 않는다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-005 | 맵 | 갈림길에는 2단계 또는 3단계 분기기를 배치하고 활성 선로 방향을 명확히 표시한다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-006 | 콘텐츠 | 빨강·파랑·노랑 스테이션을 색상별 2개씩 일반 선로에 배치한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-007 | 콘텐츠 | 각 색상 화물은 항상 최소 4개이며 적재 후 다른 유효 선로 위치에 재생성된다. | 사용자 승인·PR #12/#13 | CONFIRMED |
| SX-DEC-008 | 시스템 | 화물은 LIFO이며 같은 색이 stack top에서 연속되면 그룹으로 하역한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-009 | 시스템 | 배송은 점수와 연료를 주며 시간에 따라 속도·연료 소모가 증가하고 연료 0에서 종료된다. | 사용자 승인 | CONFIRMED |
| SX-DEC-010 | 시스템 | 화물 수가 많을수록 느려지고 BOOST는 속도를 높이는 대신 연료를 추가 소모한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-011 | 표현 | 부드럽고 둥근 프리미엄 캐주얼 3D 카툰과 친근한 토끼 기관사를 사용한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android/Google Play, 가로형 화면을 초기 기준으로 사용한다. | 프로젝트 기본값·PR #9 | CONFIRMED |
| SX-DEC-013 | 분기 UX | 기본 A노선은 가능한 경우 직진 우선이며 preview 첫 칸과 실제 다음 칸은 일치한다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-014 | 점수·피드백 | Combo는 한 역 도착에서 연속 하역된 동일 화물 개수이며 빠른 배송은 별도 speed bonus다. | EV-USER-002 | CONFIRMED |
| SX-DEC-015 | 화물·화차 UX | 화물 1개=compact token 1개, rear token=LIFO top, compressed footprint를 사용한다. | EV-USER-003 | CONFIRMED |
| SX-DEC-016 | 첫 세션 UX | 실제 첫 run에서 LOAD→token→분기→LIFO→Combo→BOOST를 상황형으로 가르친다. | EV-USER-004 | CONFIRMED |
| SX-DEC-017 | 결과·학습 | 결과 화면은 telemetry 근거가 있는 실패 원인 1개와 다음 행동 1개를 표시하고 불확실하면 중립 fallback을 사용한다. | EV-USER-006 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-018 | 카메라 | 최초 PREP는 약한 확대를 사용하고 `FULL_MAP_READY` 뒤 run을 시작하며 active run은 고정 전체 맵이다. | EV-USER-007 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-019 | 영구 진행 | 표준 개인 기록 3종과 gameplay power 없는 cosmetic collection/equip만 허용한다. | EV-USER-008 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-020 | 해금 경제 | `DEFAULT / DUAL_PATH / CURRENCY_ONLY`를 사용하고 구매는 목표 완료를 위조하지 않는다. | EV-USER-009 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-021 | 재화 보상 | 유효 일반 run에 기본 재화와 bounded 배송·최고 Combo·표준 신기록 보너스를 지급한다. | EV-USER-010 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-022 | 난이도 전달 | authoritative 상승 전 짧은 경고와 commit 뒤 `CALM/BUSY/INTENSE` 신호를 표시한다. | EV-USER-011 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-023 | 재시작·맵 | `RESTART`는 exact same map/seed와 fresh run state를 사용하고 새 seed는 검증 official catalog 제작에 사용한다. | EV-USER-012 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-024 | 맵 선택 | `NEW RUN`은 미발견 official map을 우선 배정하고 발견 map은 직접 재선택한다. | EV-USER-013 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-025 | 기록·UGC | official global+per-map 개인 기록을 병행하고 data-only 사용자 맵을 검증·불변 revision으로 게시·공유한다. | EV-USER-014 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-DEC-026 | UGC community | favorite·검증 play·1추천·report/block·staff pick만 허용하고 reward·rating·leaderboard를 초기 제외한다. | EV-USER-015 | CONFIRMED_PENDING_GMB001_MERGE |
| SX-OPS-001 | 운영 | Grill Me 승인 10건마다 freeze·전수 감사·canonical merge·Sheet closure를 수행한다. | EV-USER-005 | CONFIRMED_OPERATION |

상세 파생 계약과 단계 구분: `GMB-001_CANONICAL_DECISIONS.md`.

## 구현·검증 추적

| Decision 범위 | 구현 상태 | 검증 상태 | 남은 범위 |
|---|---|---|---|
| SX-DEC-003~008,013 | IMPLEMENTED_OR_PARTIAL | AUTOMATED_PASS/PARTIAL | 제품 UI·실기·soak |
| SX-DEC-009~010 | NOT_STARTED / INTERFACE_ONLY | NOT_RUN | 생존 경제·BOOST exploit |
| SX-DEC-011~012 | DIRECTION/BASELINE | PARTIAL | 제품 아트·Android export·성능 |
| SX-DEC-014~016 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | Combo·compact tokens·onboarding runtime |
| SX-DEC-017~018 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | result insight·camera/run gate |
| SX-DEC-019~021 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | Profile·records·cosmetics·unlock·reward·economy simulation |
| SX-DEC-022 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | difficulty director/signal·lifecycle·localization |
| SX-DEC-023~024 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | same-map restart·target3·target100·selection/browser |
| SX-DEC-025 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | scoped records·editor·backend·server validation·moderation·two-account |
| SX-DEC-026 | PLANNING_APPROVED | NOT_STARTED / NOT_RUN | signal backend·event journal·anti-abuse·privacy·human |
| SX-OPS-001 | ACTIVE | GMB001_PREMERGE_IN_PROGRESS | merge·Sheet closure·Sync Closure PR |

Planning approval is not implementation success.

## Evidence Registry

| Evidence ID | 내용 | 상태 |
|---|---|---|
| EV-USER-002 | one-arrival unload-group Combo | CONFIRMED_USER_DECISION |
| EV-USER-003 | compact wagon token + compressed footprint | CONFIRMED_USER_DECISION |
| EV-USER-004 | actual first-run contextual onboarding | CONFIRMED_USER_DECISION |
| EV-USER-005 | 10-approval batch merge protocol | CONFIRMED_USER_OPERATION |
| EV-USER-006 | result cause + next action | CONFIRMED_USER_DECISION |
| EV-USER-007 | PREP zoom + active full map | CONFIRMED_USER_DECISION |
| EV-USER-008 | records + cosmetic-only progression | CONFIRMED_USER_DECISION |
| EV-USER-009 | goal-or-currency unlock modes | CONFIRMED_USER_DECISION |
| EV-USER-010 | bounded run cosmetic-currency rewards | CONFIRMED_USER_DECISION |
| EV-USER-011 | difficulty prewarning + persistent signal | CONFIRMED_USER_DECISION |
| EV-USER-012 | same-map restart + 100+ official target | CONFIRMED_USER_DECISION |
| EV-USER-013 | undiscovered-first official selection | CONFIRMED_USER_DECISION |
| EV-USER-014 | global/per-map records + user map publishing | CONFIRMED_USER_DECISION |
| EV-USER-015 | non-economic UGC community signals | CONFIRMED_USER_DECISION |
| EV-VS01-001 | RailGraph·switch foundation | VALIDATED |
| EV-VS02-001 | train·cargo·station·LIFO | VALIDATED |
| EV-VS02-FIX-001 | runtime pickup recovery | VALIDATED |
| EV-BASE-V94-001 | Base v9.4 project contract | VALIDATED_AUTOMATED_ONLY |

## 핵심 파생 계약

### Combo / token / onboarding

- Combo는 한 station-arrival unload group이며 streak가 아니다.
- token count == CargoStack size, rear == CargoStack top, 8-token chain 2.18칸·trailing ≤3은 `TEST_VALUE`다.
- onboarding UI는 domain event를 소비하며 gameplay·pause release·reward를 소유하지 않는다.
- assisted first run은 일반 balance/record/reward evidence와 분리한다.

### Result / camera / difficulty

- result insight는 근거가 약하면 neutral이다.
- camera transition completion은 run authority가 아니며 `FULL_MAP_READY`가 명시적 gate다.
- difficulty warning은 authoritative forecast/commit을 표시할 뿐 schedule을 변경하지 않는다.

### Profile / rewards

- cosmetic은 gameplay modifier 0이다.
- purchase는 goal achievement를 위조하지 않는다.
- reward와 record commit은 atomic·idempotent이며 global+per-map 동시 record update도 record bonus는 한 번이다.

### Map / UGC

- exact same-map restart는 fresh mutable services를 만든다.
- fallback/duplicate official layout은 100+ count에서 제외한다.
- official selection과 UGC publication은 별도 source/identity다.
- UGC package는 data only이며 executable/custom asset/ruleset override를 금지한다.
- UGC record와 community signal은 immutable revision-scoped다.
- UGC play/signal은 official records·discovery·goals·rewards에 영향을 주지 않는다.

## 단계 경계

VS-03는 local core와 최소 3 official maps를 목표로 한다. 100+ official target과 full online UGC는 Production/Online Gate다. 자세한 범위는 `GMB-001_CANONICAL_DECISIONS.md`와 `VERTICAL_SLICE_CONTRACT.md`를 따른다.

## 동기화 상태

- `SX-DEC-014~016`, `SX-OPS-001`: GitHub/Sheet `SYNCED`
- `SX-DEC-017~026`: user approved, PR #29 frozen, Sheet 10/10 frozen readback PASS, canonical main merge pending
- wrong `19Ff...` Sheet: untouched
- product code/Scene/Resource/asset change in GMB-001: none expected; final inventory required
- `CODEX_NOT_READY`

## 폐기·대체된 후보

- 자동차·스네이크 직접 조작안 → 기차 노선 조작
- FIFO → LIFO
- 세로형 → 가로형
- 15×15·14×9 → 15×10
- 좌표순 기본 분기 → 직진 우선
- 배송 streak Combo → one-arrival unload-group Combo
- full-cell wagon 8개 → compact token chain
- 별도 고정 튜토리얼 → actual first-run contextual onboarding
- UGC progression reward/creator payout/rating/leaderboard 초기안 → non-economic signals only
