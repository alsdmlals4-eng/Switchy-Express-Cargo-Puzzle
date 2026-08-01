# Post-VS02 Adversarial Audit

Audit ID: `SX-AUD-003`
Date: `2026-08-01`
Primary implementation: PR `#12`, commit `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
Runtime enforcement fix: PR `#13`, commit `4e435a1a6d10ab146197671049da80709fd18c1f`
Related Decisions: `SX-DEC-003`, `SX-DEC-006`, `SX-DEC-007`, `SX-DEC-008`, `SX-DEC-013`

## Work Mode·Skill

- `REVIEW`: Issue #5 수용 조건과 실제 제품 하위 루프를 대조
- `BUILD`: 차단 Finding을 TDD 회귀 수정
- `REVIEW`: Project Contract·Godot Actions·PR diff·정본·Sheet drift 재검증
- 주 책임 Skill: `running-adversarial-review-and-refinement`
- 보조 Skill: `reviewing-and-validating-project-changes`, `auditing-canonical-reference-freshness`, `synchronizing-local-and-github-state`, `maintaining-project-context-and-handoff`

## 검증된 구현 사실

- 기관차가 선택된 RailGraph 출구를 연속 이동
- 현재 구간 출구는 출발 시 잠겨 이동 중 분기 입력으로 방향이 튀지 않음
- 최대 8개 화차가 1칸 간격의 제한된 경로 이력을 따라 보간 이동
- 큰 delta에서도 모든 칸 경계를 순서대로 처리
- 칸 진입 이벤트는 실제 통과 시각을 기록
- `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE` 색상+모양 타입
- 화물칸 최대 8개, LOAD 중에만 수거, BOOST 요청 시 LOAD 비활성
- 빨강·파랑·노랑 역 각 2개, 총 6개
- 역은 분기기와 시작 칸을 피하고 같은 타입 역 간 그래프 거리 5칸 이상
- 맵 위 타입별 화물 최소 4개
- 기차·화차·전방 2칸·역·분기기·기존 화물·직전 위치 스폰 금지
- 1초 지연 재생성·결정론·`SPAWN_DEFERRED` 복구
- `R,R,B,R` 적재 시 `R,B,R,R` 하역 순서
- 같은 타입 top 연속 그룹만 LIFO 하역
- 실제 기차 진입이 수거·맵 제거·스택 변경·역 하역을 구동
- Project Contract 통과
- Godot headless `9 cases / 6915 assertions / 0 failures`

## Findings

| ID | 심각도 | 판정 | 증거 | 처리 |
|---|---|---|---|---|
| SX-FIND-012 | P0 | 단위 모듈만 존재하고 실제 배송 루프 결합 없음 | 초기 PR #12에서 기차·스폰·스택·역 테스트가 독립적 | `DeliveryLoop`와 train→pickup→stack→station→unload 통합 테스트 추가 |
| SX-FIND-013 | P0 | runtime 최소 화물 유지 누락 | 수거는 pending respawn을 만들지만 DeliveryLoop가 `process()` 미호출 | PR #13에서 매 frame 처리·점유/전방 제외·상태 노출 |
| SX-FIND-014 | P0 | 이동 중 분기 상태 변경 시 목표 선로 snapping | `target_cell()`이 매 조회마다 스위치 상태 재계산 | 현재 구간 target lock과 회귀 테스트 추가 |
| SX-FIND-015 | P1 | 빠른 frame의 이벤트 시각 왜곡 | 여러 칸을 건너도 모든 이벤트가 frame 종료 시각 | 칸 경계별 시간 분할 처리 |
| SX-FIND-016 | P1 | pending 요청 false `SPAWNED` | 다른 보정으로 최소량이 이미 충족된 경우 | `SATISFIED`와 실제 `SPAWNED` 분리 |
| SX-FIND-017 | P1 | 이력 무한 증가 위험 | 화차 추종을 장기 운행할 때 메모리 증가 가능 | capacity+안전 여유로 route history 제한 |
| SX-FIND-018 | P1 | 경제·게임오버 미구현 | 배송 이벤트는 있으나 점수·연료 소비자가 없음 | 다음 Issue #6 / VS-03 범위로 고정 |
| SX-FIND-019 | P1 | 제품 화면 미구현 | 도메인 로직만 있고 실제 RailBoardView·HUD 없음 | Issue #6 후반 또는 후속 UI Gate에서 런타임 증거 요구 |
| SX-FIND-020 | P1 | Android·실기·플레이테스트 미검증 | Linux headless 검증만 수행 | G4·G5까지 `NOT_RUN` 유지 |

## 적대적 검토 결론

### PASS

- 연결 철도망 위 기관차·화차 주행
- 선택 분기와 실제 이동 일치
- LOAD 선택 적재
- 색상+모양 화물 타입
- 역 6개 배치
- 타입별 최소 화물 수량의 실제 runtime 복구
- 최대 8칸 LIFO 하역
- 배송 하위 루프 통합

### 아직 PASS 아님

- 시간별 기본 속도 상승
- 화물 수에 따른 감속
- BOOST 가속·추가 연료 소비
- 배송 점수·연료 보상
- 연료 0 게임오버
- 무입력 영구 생존 방지 시뮬레이션
- 게임 HUD·결과 화면·재시작·최고 기록
- Android export·성능·시각 가독성·플레이테스트

## SWOT → 행동

| 축 | 관찰 | 행동 |
|---|---|---|
| Strength | 노선 선택과 LIFO 적재 순서가 실제 배송 루프로 결합됨 | 경제 시스템은 DeliveryLoop 이벤트를 단일 입력으로 사용 |
| Strength | 결정론적 역·화물 배치와 대규모 headless 검증 확보 | 밸런스 시뮬레이션을 seed 반복으로 자동화 |
| Weakness | 현재 속도는 수동 주입이며 진행 난이도 곡선이 없음 | `RunBalance` 순수 함수와 `RunController`를 분리 |
| Weakness | 제품 화면 없이 로직 완료를 체감하기 어려움 | 경제 통합 후 placeholder HUD와 RailBoardView를 실제 main scene에 연결 |
| Opportunity | 정확한 칸 진입 시각이 빠른 배송 보너스에 활용 가능 | frame delta가 달라도 동일 점수 결과를 회귀 테스트 |
| Threat | 화물 감속이 생존 시간을 늘리는 exploit가 될 수 있음 | 연료 drain은 실제 시간 기준, 무입력·중량별 시뮬레이션 |
| Threat | BOOST가 항상 정답이거나 무가치할 수 있음 | 동일 route에서 일반/BOOST의 시간·연료·점수 효율 비교 |

## 다음 P0 — VS-03

1. 순수 `RunBalance`: 속도·화물 감속·연료 drain·BOOST·배송 보상
2. `RunController`: DeliveryLoop 이벤트를 점수·연료·combo로 변환
3. 연료 0 게임오버와 입력 정지
4. 180초 무입력 시뮬레이션과 영구 생존 방지
5. 게임 HUD ViewModel·결과 요약·재시작·로컬 최고 기록
6. 최소 placeholder gameplay scene에서 LOAD·BOOST·분기·HUD 연결

## Gate 판정

- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: `PASS`
- `G3_CORE_RUNTIME_PROVEN`: `PARTIAL`
  - RailGraph·분기: `PASSED`
  - 기차·화차·화물·역·LIFO 배송 하위 루프: `PASSED`
  - 연료·점수·속도·BOOST·게임오버: `NOT_STARTED`
- `G4_TARGET_QUALITY_SLICE`: `NOT_STARTED`
- 다음 Goal: GitHub Issue `#6`, `CODEX_GOAL_VS_03.md`
