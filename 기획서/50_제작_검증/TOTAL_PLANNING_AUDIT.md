# Switchy Express 총기획 Coverage·충돌 감사

```yaml
audit_id: SX-AUD-004
status: IN_PROGRESS · GMB-001_10_OF_10_PREMERGE
product_baseline: 4e435a1a6d10ab146197671049da80709fd18c1f
gmb001_baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
work_mode: TOTAL_PLANNING · REVIEW
implementation_authority: PLANNING_AND_DOCUMENTATION_ONLY
sheet_state: 10/10_FROZEN · 12_TABS_READBACK_PASS
codex_state: CODEX_NOT_READY
number_policy: RECOMMENDED_DEFAULT_OR_TEST_VALUE
user_decision_policy: ONE_MATERIAL_GRILL_ME_AT_A_TIME
merge_policy: SX-OPS-001 · GMB-001_FROZEN
```

## 목적

VS-03 구현 전에 제품·경험·시스템·콘텐츠·UX·표현·데이터·저장·검증·제작 기획을 실제 구현과 대조한다. 안전한 보완은 자동 반영하고 제품 방향을 바꾸는 충돌만 사용자 Decision으로 닫는다.

`SX-DEC-014~016` catch-up은 canonical sync가 완료됐다. `GMB-001`의 `SX-DEC-017~026`은 10/10 승인·동결됐으며 `GMB-001_PREMERGE_AUDIT.md`를 통해 병합 전 전수감사를 수행한다.

## 보호 강점

- 자동 운행 중 LOAD·분기·LIFO를 동시에 계획하는 코어
- 15×10 connected railway·straight-first·preview parity
- color+shape cargo·capacity 8·bounded respawn
- one-arrival unload-group Combo
- compact token으로 적재량·rear LIFO를 표시
- actual first-run contextual onboarding
- evidence-based result learning
- active-run full-map fairness
- cosmetic-only progression과 bounded reward
- same-map retry와 공식 map discovery/reselection
- official/UGC identity·record·reward 분리
- non-economic UGC community boundary

## Coverage Matrix

| 영역 | 현재 상태 | 강점 | 남은 공백·경계 | 판정 |
|---|---|---|---|---|
| 운영 | GMB-001 10/10 frozen | 10건 batch·audit·closure 명확 | final CI/merge/Sheet closure | PREMERGE |
| 핵심 플레이 | rail/train/cargo/LIFO 기반 구현 | 코어 의미 선명 | 생존 경제·Combo runtime | READY_FOR_PLAN |
| 결과 학습 | SX-DEC-017 | 근거 1개+행동 1개·neutral fallback | telemetry/runtime/human | TEST_REQUIRED |
| 카메라 | SX-DEC-018 | FULL_MAP_READY·active full map | Android motion/input | TEST_REQUIRED |
| Profile | SX-DEC-019~021 | no power·atomic/idempotent | runtime/economy simulation | TEST_REQUIRED |
| 난이도 전달 | SX-DEC-022 | forecast/commit authority 분리 | curve/timing/localization | TEST_REQUIRED |
| 공식 맵 | SX-DEC-023~024 | same-map retry·undiscovered-first | target3/target100·browser | F58_NOT_MET |
| 기록 | SX-DEC-025 | global+per-map atomic scope | runtime migration·UI | TEST_REQUIRED |
| UGC publication | SX-DEC-025 | data-only·immutable revision·server validation | editor/backend/moderation/privacy | PRODUCTION_GATE |
| UGC community | SX-DEC-026 | non-economic·qualified play·1 recommendation | backend/journal/anti-abuse | PRODUCTION_GATE |
| 온보딩 | SX-DEC-016 | actual run·safe pause·assist separation | runtime/Android/human | TEST_REQUIRED |
| UX·표현 | 방향 승인 | UI/motion non-authority | real density/assets | TEST_REQUIRED |
| 저장·데이터 | schema 경계 계획 | IDs·transactions 분리 | corruption/migration/runtime | TEST_REQUIRED |
| 성능·접근성 | 48dp·color+shape·Reduced Motion | Gate 존재 | device/human evidence | BLOCKED_UNVERIFIED |

## 기존 Finding Ledger — SX-AUD-004-F01~F24

| ID | 문제 | 상태·처리 |
|---|---|---|
| F01 | Combo 의미 충돌 | SX-DEC-014로 해결 |
| F02 | cargo와 visible wagon 관계 | SX-DEC-015로 해결 |
| F03 | 첫 세션 학습 방식 | SX-DEC-016으로 해결 |
| F04 | stale project Skill | Post-VS02 기준 복구 |
| F05 | 5명 표본 퍼센트 자의성 | 실제 명수 병기 |
| F06 | color-only telemetry | cargo_type/color/shape 분리 |
| F07 | audio/haptic priority 부재 | P0/P1/P2 fallback 계약 |
| F08 | balance 수치 미검증 | TEST_VALUE·simulation 필요 |
| F09 | 모바일 density 미검증 | VS 캡처·Android 필요 |
| F10 | planning audit canon 부재 | 본 문서 등록 |
| F11 | stale master plan | current plan 등록 |
| F12 | audit authority conflict | SX-AUD-004 CURRENT |
| F13 | full-cell wagon 과밀 | compact token으로 해결 |
| F14 | spawn footprint 불공정 | compressed footprint 권위 |
| F15 | 작은 token 접근성 | Android/human test 필요 |
| F16 | 2.25/2.18 drift | 2.18 TEST_VALUE 통일 |
| F17 | onboarding UI authority | domain event only |
| F18 | assisted evidence contamination | segment 분리 |
| F19 | pending/SYNCED drift | branch pending status |
| F20 | 11번째 batch 범위 잠입 | 10번째 freeze |
| F21 | historical contract loss | 원문 보호선 복원 |
| F22 | VS-03C package 누락 | A→B→C 순서 복원 |
| F23 | Sheet stale consumer | readback 중 수정 |
| F24 | Finding traceability 축약 | ID·원인·영향 보존 |

## GMB-001 Finding Groups

| 범위 | IDs | 핵심 위험 | 현재 판정 |
|---|---|---|---|
| Result | F26~F30 | 원인 오판·blame·UI authority·밀도 | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Camera | F31~F35 | fairness·orientation·input·restart motion | PLANNING_FIXED · DEVICE_NOT_RUN |
| Records/Cosmetics | F36~F40 | hidden power·assist record·grind·migration | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Unlocks | F41~F45 | achievement fraud·duplicate debit·FOMO | PLANNING_FIXED · ECONOMY_NOT_RUN |
| Rewards | F46~F50 | idle farm·snowball·duplicate grant·ordering | PLANNING_FIXED · ECONOMY_NOT_RUN |
| Difficulty | F51~F55 | UI schedule authority·late warning·lifecycle | PLANNING_FIXED · RUNTIME_NOT_RUN |
| Restart/Catalog | F56~F60 | state leak·ID collision·false count·version drift | F58_NOT_MET · TARGET_AUDIT_NOT_RUN |
| Assignment/Browser | F61~F65 | repeat/starvation·overload·cycle drift | PLANNING_FIXED · FLOW_NOT_RUN |
| Records/UGC Publication | F66~F70 | cross-map fairness·official contamination·malicious upload·revision·moderation/privacy | PRODUCTION_GATES_NOT_RUN |
| UGC Community | F71~F75 | reward leak·self-play/sybil/bot·metric mismatch·exposure loop·privacy/event log | PRODUCTION_GATES_NOT_RUN |

현재 알려진 P0/P1 설계 충돌은 없다. `F58`은 구현 증거가 없으므로 명시적으로 `NOT_MET`이다.

## GMB-001 단계 보정

초기 10개 결정을 모두 즉시 VS-03에 넣으면 scope가 local Vertical Slice에서 online content platform으로 폭증한다.

### VS-03 local

- result learning·camera/run gate
- local records/cosmetic/unlock/reward representative flow
- difficulty communication
- same-map restart
- minimum 3 validated official maps·selection/reselection
- official local global/per-map records
- 기존 survival economy·compact tokens·onboarding

### Production/Online

- official 100+ catalog completion
- full UGC editor/publication/backend/server validation
- moderation/privacy/two-account playback
- UGC records/community signal journal/anti-abuse

이 분리는 Decision을 약화하지 않고 구현 순서를 현실화한다.

## Evidence 경계

다음은 planning merge 후에도 `NOT_STARTED / NOT_RUN`이다.

- GMB runtime features
- Android/localization/accessibility/human
- economy simulation
- official target3/100
- 100-entry browser
- UGC editor/backend/server validation
- moderation/privacy/two-account
- community signal backend/anti-abuse

client mock이나 headless unit test만으로 online/product quality PASS를 주장하지 않는다.

## Current Pre-Merge Gate

책임 정본: `GMB-001_PREMERGE_AUDIT.md`.

- [x] exactly 10 decisions/evidence
- [x] specs/plans/ledger
- [x] freeze/no SX-DEC-027
- [x] Sheet 10/10 frozen 12-tab readback
- [x] scope staging
- [ ] stale current consumers 0
- [ ] final exact-head Sheet re-sync
- [ ] behind 0
- [ ] planning-only inventory
- [ ] Project Contract success
- [ ] Godot Tests success
- [ ] review threads/REQUEST_CHANGES 0
- [ ] P0/P1 open 0 final
- [ ] canonical merge·Sheet closure·Sync Closure

## Decision Queue

GMB-001 closure 전 `NONE · FROZEN`.

다음 Decision은 closure 뒤 별도 batch에서 시작한다. 현재 제품 구현은 `CODEX_NOT_READY`다.
