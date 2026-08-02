# Active Context

## 현재 상태

- 프로젝트 이름·핵심 코어·Vertical Slice 방향은 사용자 승인 상태다.
- Base v9.4 프로젝트 운영 계약이 적용돼 있다.
- VS-01 Issue #4 / PR #9 완료.
- VS-02 Issue #5 / PR #12 완료.
- VS-02 런타임 화물 재생성 누락은 PR #13에서 복구 완료.
- Base v9.4 AI 운영·UI 모션 계약은 PR #15에서 적용 완료.
- Post-VS02 정본 복구·Sheet 종료는 PR #16/#17에서 완료.
- `SX-DEC-014` Combo는 PR #18/#19를 거쳐 GitHub·Sheet `SYNCED`다.
- `SX-DEC-015` compact wagon token은 PR #24/#25를 거쳐 GitHub·Sheet `SYNCED`다.
- `SX-DEC-016` 실제 첫 run 상황형 온보딩과 `SX-OPS-001` 10건 배치 운영은 PR #27 / `3cd13ff375a597d4eba9035af5b05e6186fb4853`과 Sheet 12탭 readback을 거쳐 `SYNCED`다.
- `GMB-001`은 `SX-DEC-017`부터 시작하며 현재 `0/10`이다.
- 제품 구현 기준: `4e435a1a6d10ab146197671049da80709fd18c1f`.
- 최신 synchronized planning main: `3cd13ff375a597d4eba9035af5b05e6186fb4853`.
- Godot 기존 검증: `9 cases / 6915 assertions / 0 failures`.
- 제공된 `19Ff...` 시트는 다른 프로젝트이며 변경하지 않는다.
- Issue #5: CLOSED · COMPLETED.
- Issue #6: OPEN · VS-03A/VS-03B/VS-03C 계획 범위.
- 현재 Work Mode: `TOTAL_PLANNING · REVIEW`.
- Codex 상태: `CODEX_NOT_READY`.
- 현행 총기획 감사: `SX-AUD-004`.

## 구현된 범위

### VS-01

- Godot 4.7.1 프로젝트·헤드리스 테스트 러너
- 결정론적 15×10 전체 연결 RailGraph
- 막다른길 0·cycle rank 3 이상
- 2단계 분기 최소 4개·3단계 분기 최소 2개
- 직진 우선 기본 A노선
- 즉시 180도 반전 금지
- 5칸 경로 preview와 실제 next-cell 일치
- 결정론적 safe fallback

### VS-02

- 선택된 RailGraph 경로를 따르는 연속 기관차 이동
- 최대 8개 화차 위치 계산 기반
- 이동 중 목표 분기 고정과 통과 후 분기 초기화
- `RED_STAR / BLUE_DIAMOND / YELLOW_TRIANGLE`
- capacity 8 LIFO CargoStack
- LOAD 상태에서만 적재
- BOOST 요청 시 LOAD 비활성 입력 계약
- 색상별 스테이션 2개·총 6개 결정론적 배치
- 동색 역 그래프 거리 최소 5칸
- 색상별 맵 pickup 최소 4개
- 금지 칸·직전 위치·열차 전방 2칸 제외
- 1초 지연 재생성과 `SPAWN_DEFERRED` 회복
- LIFO 동일 타입 연속 그룹 하역
- 실제 stack과 동일한 하역 순서 ViewModel
- 정확한 cell-crossing 시각의 DeliveryLoop 이벤트

## 총기획에서 확정된 추가 Decision

### SX-DEC-014 — Combo

- Combo는 한 번의 역 도착에서 연속 하역된 동일 `cargo_type` 개수다.
- `max_combo`는 한 판의 최대 하역 그룹 크기다.
- 배송 사이에 유지되는 Combo streak는 없다.
- 빠른 배송은 별도 `speed_bonus` 시험 차원이다.

### SX-DEC-015 — compact wagon tokens

- 적재 화물 1개를 작은 토큰형 화차 1개로 표시한다.
- 0화물에서는 기관차만 보인다.
- 앞→뒤 token 순서는 stack bottom→top이며 가장 뒤 token이 다음 하역 대상이다.
- 최대 8개 token chain은 권장 시험값 2.18칸, trailing 점유 최대 3칸으로 압축한다.
- 화물 8개를 full-size 선로 8칸 점유로 취급하지 않는다.
- 상세 규격: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`.

### SX-DEC-016 — actual-run contextual onboarding

- 별도 튜토리얼 맵 없이 실제 첫 무한 run을 사용한다.
- 학습 순서는 `LOAD → compact token → 분기 → mixed-stack LIFO → Combo → 저연료 BOOST`다.
- 첫 LOAD와 첫 분기에서만 full simulation safe pause를 허용한다.
- first-run assist 권장 시험값은 연료 소모 0.5×, 난이도 상승 정지, 최대 120초, 종료 후 3초 복귀다.
- OnboardingState는 실제 domain event를 소비하며 pickup·route·unload·score·fuel·Combo를 소유하지 않는다.
- 상세 설계: `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md`.
- 구현 계획: `docs/superpowers/plans/2026-08-02-first-session-contextual-onboarding.md`.

### SX-OPS-001 — Grill Me 10건 배치 병합

- `SX-DEC-016`까지의 catch-up은 canonical PR과 Sheet closure로 완료됐다.
- 정규 batch `GMB-001`은 `SX-DEC-017`부터 10건을 센다. 현재 `0/10`이다.
- 승인 직후 batch branch·draft PR·Sheet에 `APPROVED_PENDING_BATCH_MERGE`로 기록한다.
- 10번째 승인 후 GitHub main·PR·Issue·정본·Registry·Sheet 12탭을 다시 읽고 적대적 검토한다.
- exact-head checks 성공, P0/P1 open finding 0, unresolved review thread 0일 때만 병합한다.
- canonical merge commit을 Sheet에 기록하고 12탭 readback PASS와 Sync Closure PR 병합까지 batch 완료로 본다.
- 운영 정본: `기획서/50_제작_검증/GRILL_ME_BATCH_MERGE_PROTOCOL.md`.

## 현재 미구현

- compact token ViewModel·fractional path following·compressed footprint
- 시간 기반 속도 상승과 연료 소모
- 화물 적재량 감속
- BOOST 속도·추가 연료 소모
- 배송 점수·연료 보상·Combo 계산
- 무입력 유한 생존과 연료 0 게임오버
- 결과 요약·실패 학습·즉시 재시작
- 최고 점수·최장 생존·최대 Combo 로컬 기록
- 제품 RailBoardView·SwitchView·HUD·결과 화면
- OnboardingState·first-run assist·overlay·Help·telemetry
- 접근성 설정 실제 동작
- 대표 런타임 캡처
- Android export·실기 성능
- 10분 soak·사용자 플레이테스트

## 현재 총기획 작업

```text
SX-DEC-014/015/016 · SX-OPS-001 GitHub/Sheet SYNCED
→ GMB-001 시작: SX-DEC-017부터 0/10
→ 승인마다 batch branch/PR·Sheet APPROVED_PENDING_BATCH_MERGE
→ 10번째 승인 후 pre-merge adversarial audit
→ canonical merge·Sheet readback·Sync Closure
→ G3P close·VS-03 Definition of Ready
```

상세 수치는 사용자 지시에 따라 GPT 권장 시험값으로 작성하되 `RECOMMENDED_DEFAULT / TEST_VALUE`로 표시한다. 플레이어 판타지, 대표 경험, 주요 UX, 실패·보상 의미, 범위를 바꾸는 충돌은 사용자 Decision 없이 확정하지 않는다.

## 다음 작업

1. `GMB-001` slot 1인 `SX-DEC-017` 결과 화면 실패 학습을 한 건만 Grill Me한다.
2. 승인되면 동일 Decision/Evidence를 batch branch·draft PR·Sheet에 `APPROVED_PENDING_BATCH_MERGE`로 기록한다.
3. 승인 수를 1/10로 갱신하고 다음 Decision 전 충돌을 재검토한다.
4. 10번째 승인에서 새 질문을 멈추고 `SX-OPS-001` 전수 감사를 실행한다.

## 주요 위험

- compact token이 너무 작아 색상+모양을 읽지 못할 가능성
- 압축 점유 계산 누락으로 pickup이 token chain 위에 생성될 가능성
- tight turn에서 token 순서가 바뀌거나 곡선을 가로지를 가능성
- 첫 세션 안내 피로와 safe pause lock 가능성
- tutorial overlay나 animation이 단계 완료·보상을 소유하는 회귀 위험
- 0.5× assisted first run을 일반 생존 경제 증거로 혼합할 위험
- batch 대기 중 Sheet를 `SYNCED`로 오표기하거나 11번째 범위가 잠입할 위험
- 화물 감속·BOOST 경제 exploit 가능성
- 결과·재시작 모션이 점수·연료·저장의 권위를 소유하는 회귀 위험
- Android·사람 이해·성능·접근성은 여전히 `NOT_RUN / HUMAN_NOT_RUN`

## 감사·동기화

- Post-VS02 감사: `SX-AUD-003` · HISTORICAL
- 현행 총기획 감사: `SX-AUD-004` · CURRENT
- 사용자 Evidence: `EV-USER-002`, `EV-USER-003`, `EV-USER-004`, `EV-USER-005`
- `SX-DEC-016` / `SX-OPS-001` canonical commit: `3cd13ff375a597d4eba9035af5b05e6186fb4853`
- Google Sheet: `PASS · 12탭 재조회 완료 · SYNCED`
- `GMB-001`: `NOT_STARTED · 0/10 · NEXT SX-DEC-017`
- 제품 구현은 여전히 `CODEX_NOT_READY`
