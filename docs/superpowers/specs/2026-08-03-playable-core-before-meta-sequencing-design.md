# Playable Core Before Meta Sequencing Design

```yaml
audit_id: SX-AUD-007
evidence_id: EV-USER-018
user_approval: RECOMMENDED_OPTION_C
status: APPROVED · IMPLEMENTATION_PLANS_COMPLETE · CANONICAL_MERGED · SHEET_READBACK_PASS
canonical_merge: a9368617102420639cc2bb83ee2b0c45505958a6
product_rule_change: false
current_implementation_authority: VS03-02_ONLY
```

## 1. 목적

Switchy Express의 핵심 재미를 Profile·기록·꾸미기·재화보다 먼저 실제 제품 화면에서 검증한다.

핵심 재미 우선순위는 다음과 같다.

```text
LIFO 적재 순서 계획
→ 목적 역까지의 분기 선행 결정
→ 큰 하역 그룹을 위한 위험·생존 판단
→ BOOST·배송 속도의 전술적 시간 관리
→ 결과 학습·재도전
→ 기록·꾸미기·맵 발견·UGC
```

기존 `VS03-04 Profile → VS03-05 product surface` 순서는 구조적으로 단순하지만, 플레이 가능한 화면에서 핵심 재미를 확인하기 전에 장기 진행 시스템을 먼저 완성할 위험이 있다.

## 2. 승인된 실행 순서

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact token/TrainFootprint/DeliveryLoop occupancy
→ VS03-03 target3 maps/session/restart/selection
→ VS03-R1 difficulty authority alignment
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

`VS03-R1`은 새 플레이어 규칙이 아니라 `SX-AUD-007-F87`을 닫는 안전 교정 package다. 실제 속도·연료 압력 경계와 `DifficultyDirector` forecast/commit schedule을 일치시킨다. 현재 VS03-02를 중단시키지 않으며 VS03-03 merge·sync 뒤, VS03-05A 전에 실행한다.

## 3. VS03-05A — 최소 플레이 가능 핵심 화면

### 목표

Meta와 persistence 없이도 다음 질문에 답할 수 있는 첫 제품 화면을 만든다.

> 화물을 어떤 순서로 실었는지, 어떤 분기를 미리 바꿔야 하는지, 큰 하역 그룹을 위해 위험을 감수하는 판단이 실제 화면에서 명확하고 재미있는가?

### 포함

- `PlayScene` composition root
- 전체 철도망 board 표시
- 기관차와 compact wagon token 표시
- rear token과 HUD next-unload parity
- 분기기 상태·preview·target lock 표시
- LOAD·BOOST·분기 semantic input
- score·fuel·speed·elapsed·last/max Combo 최소 HUD
- PREP slight zoom과 `FULL_MAP_READY`
- active run fixed full-map camera
- 난이도 persistent band의 최소 read-only 표시
- Reduced Motion instant/static parity

### 제외

- Profile 저장
- global/per-map record commit
- cosmetic currency·wallet·unlock·goal
- collection/equip UI
- 결과 원인 분석·record/reward receipt 표시
- map browser와 discovered-map 관리 UI
- onboarding overlay·assist
- Android/HUMAN PASS 주장

### 권위 경계

- UI는 `RunState`, `RunSummary`, `CargoStack`, `TrainFootprint`, map/session receipt를 읽기만 한다.
- Scene·Tween·animation completion은 cargo, score, fuel, difficulty, run end, discovery, record, reward 권위가 아니다.
- 입력은 semantic intent만 전달한다.
- 임시 Profile·wallet·record mock을 제품 권위처럼 만들지 않는다.
- persistence가 없으므로 앱 재시작 후 진행 보존을 약속하지 않는다.

### 최소 인수 기준

자동 검증:

- Scene smoke load 성공
- main은 `PlayScene` host만 담당
- `FULL_MAP_READY` 전 run progression 0
- token count/order/rear parity
- switch preview first cell과 실제 next parity
- HUD 값과 domain 값 parity
- animation on/off trace parity
- difficulty band 표시 on/off가 simulation을 변경하지 않음
- save/Profile 코드 의존 0

기기·사람 검증 준비 기준:

- 0/1/4/8 token 캡처 가능
- rear token과 HUD next item을 같은 화면에서 식별 가능
- 분기 상태·preview·열차 위치를 동시에 읽을 수 있음
- LOAD·BOOST·분기 입력에 chord가 필요하지 않음
- 최소 Android landscape 해상도에서 critical HUD가 board를 가리지 않음

실제 Android·사람 PASS는 Issue #7까지 `NOT_RUN`이다.

## 4. VS03-04 — Profile와 장기 진행

VS03-05A가 core surface smoke와 자동 parity를 통과한 뒤 시작한다.

Profile package는 기존 책임을 유지한다.

- 단일 `ProfileStore`
- 단일 `ProfileTransactionService`
- global/per-map records
- cosmetics·unlock modes·wallet·goals
- bounded reward calculation
- idempotent operation journal
- map discovery/recent/favorites/automatic bag persistence
- onboarding preference persistence

VS03-05A는 Profile schema를 선점하거나 임시 저장 형식을 만들지 않는다.

## 5. VS03-05B — 결과·collection·map browser

Profile transaction receipt가 존재한 뒤 다음 presentation을 구현한다.

- 결과 화면
- 실패 원인 1개·다음 행동 1개·neutral fallback
- committed current-map/global record 표시
- committed reward receipt 표시
- cosmetic collection/equip
- discovered map browser
- same-map restart/new run/select discovered map actions

결과·collection·browser는 Profile transaction을 호출하지 않고 immutable receipt와 read-only ViewModel을 소비한다.

## 6. VS03-R1 — 난이도 경계 권위 정렬

### 문제

현재 시험값은 다음처럼 분리돼 있다.

```text
speed pressure boundary: 30초
fuel pressure boundary: 45초
default DifficultyDirector commit: 30초
```

45초 계열의 실제 연료 압력 변화가 forecast/commit 없이 발생하면 `DifficultyDirector schedule/commit 단독 권위` 계약과 충돌한다.

### 교정 방향

- `RunBalance`는 수치 공식을 소유하고 `DifficultyDirector`는 모든 실제 pressure boundary의 schedule을 소유한다.
- 30초와 45초가 겹치는 경계는 하나의 authoritative timestamp에서 필요한 변화들을 묶는다.
- presentation은 immutable forecast/commit event만 읽는다.
- exact 내부 수식은 UI에 노출하지 않는다.
- pause/restart/assist에서 schedule parity를 보존한다.

### 필수 테스트

- 30초 speed-only commit
- 45초 fuel-only commit
- 60초 speed-only commit
- 90초 speed+fuel combined commit
- 경계 전 forecast lead
- large delta에서 ordered multi-boundary commit
- pause 중 commit 0, resume wall-clock catch-up 0
- restart schedule reset
- event timestamp와 `RunState.elapsed_seconds` 일치
- warning presentation on/off simulation trace parity

## 7. 벤치마크 적용 원칙

- Mini Metro: 점진적 압력과 학습 가능한 실패만 참고한다.
- Conduct THIS!: 적은 입력과 즉각적인 분기 피드백만 참고한다.
- Railbound: 객차 순서·경로 인과 가독성만 참고한다.
- Train Valley 2: 공식 콘텐츠와 사용자 제작 콘텐츠의 단계 분리만 참고한다.
- Rail Route: authoritative routing model과 presentation 분리만 참고한다.

도입하지 않는 것:

- 철도망 건설이 핵심이 되는 구조
- 충돌 회피 반사신경 중심 구조
- tycoon·자동화·signal 운영 깊이
- core 검증 전 UGC scale 확대

## 8. 실패·롤백

### VS03-05A 실패

다음 중 하나면 Profile로 넘어가지 않고 core surface를 수정한다.

- rear token과 HUD unload order를 읽지 못함
- 분기 preview와 실제 이동 인과가 불명확함
- same-color selective loading만 반복하는 것이 압도적으로 유리함
- BOOST 반사 조작이 LIFO 계획을 압도함
- full-map view에서 token·switch·station을 동시에 읽을 수 없음

### 롤백

- VS03-05A는 Profile·save migration을 만들지 않으므로 package 단위 revert 가능
- product scene 실패 시 headless run core와 domain tests는 보존
- camera는 instant full-map fallback
- difficulty presentation은 숨겨도 authoritative schedule은 유지

## 9. 구현 계획

```text
docs/superpowers/plans/2026-08-03-vs03-core-first-resegmentation.md
docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md
docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md
```

## 10. 증거 경계

이 승인으로 완료되는 것:

- package sequencing 결정
- 05A/05B 책임 분리
- F91 해결
- F87 교정 계약과 구현 계획
- canonical GitHub merge and correct Sheet readback

완료되지 않는 것:

- 제품 코드
- Android runtime
- 10분 soak
- 경제 simulation
- compact-token 사람 가독성
- 5명 이상 플레이테스트
- target100
- online UGC

## 11. 현재 판정

```text
F91: RESOLVED_BY_USER_APPROVAL · OPTION_C
F87: IMPLEMENTATION_PLAN_COMPLETE · IMPLEMENTATION_NOT_STARTED
sync: CANONICAL_MERGED · SHEET_READBACK_PASS
current build authority: VS03-02_ONLY
```
