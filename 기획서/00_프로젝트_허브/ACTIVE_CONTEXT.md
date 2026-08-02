# Active Context

## 현재 상태

- 프로젝트 이름·핵심 코어·Vertical Slice 방향은 사용자 승인 상태다.
- Base v9.4 프로젝트 운영 계약이 적용돼 있다.
- VS-01 Issue #4 / PR #9 완료.
- VS-02 Issue #5 / PR #12 완료.
- VS-02 런타임 화물 재생성 누락은 PR #13에서 복구 완료.
- Base v9.4 AI 운영·UI 모션 계약은 PR #15에서 적용 완료.
- Post-VS02 정본 복구는 PR #16 / `8245e22905d64e22b599fe009bbb660d005392ed`에서 완료.
- Post-VS02 Sheet 종료는 PR #17 / `474bef445c2cf5e501bd7478e26a5b8d0dfe26f1`에서 완료.
- `SX-DEC-014` Combo 결정은 PR #18 / `ca50538652c72cbb282d7818990e92a0dfe79c9a`에서 정본화됐다.
- `SX-DEC-014`, `EV-USER-002`, `SX-AUD-004`는 실제 Switchy Express Sheet 12개 탭 재조회까지 `PASS · SYNCED`다.
- 제품 구현 기준: `4e435a1a6d10ab146197671049da80709fd18c1f`.
- Godot 검증: `9 cases / 6915 assertions / 0 failures`.
- 제공된 `19Ff...` 시트는 다른 프로젝트이며 변경하지 않았다.
- Issue #5: CLOSED · COMPLETED.
- Issue #6: OPEN · 다음 구현 후보.
- 현재 Work Mode: `TOTAL_PLANNING · REVIEW`.
- Codex 상태: `CODEX_NOT_READY`.
- 현행 총기획 감사: `SX-AUD-004`.
- 다음 Grill Me: `SX-DEC-015` 화물 수와 표시 화차 수·점유 관계.

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
- 최대 8개 화차의 제한된 경로 이력 추종
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
- HUD·결과·telemetry·저장의 의미를 이 정의로 통일한다.

## 현재 미구현

- 시간 기반 속도 상승과 연료 소모
- 화물 적재량 감속
- BOOST 속도·추가 연료 소모
- 배송 점수·연료 보상·Combo 계산
- 무입력 유한 생존과 연료 0 게임오버
- 결과 요약·즉시 재시작
- 최고 점수·최장 생존·최대 Combo 로컬 기록
- 제품 RailBoardView·SwitchView·HUD·결과 화면
- 접근성 설정 실제 동작
- 대표 런타임 캡처
- Android export·실기 성능
- 10분 soak·사용자 플레이테스트

## 현재 총기획 작업

```text
SX-DEC-014 GitHub·Sheet SYNCED
→ SX-DEC-015 화물–화차 관계 Grill Me
→ 후속 온보딩·실패학습 Decision 필요성 재검증
→ 승인 Decision 정본·Issue·Goal·Sheet 동기화
→ Codex Definition of Ready
```

상세 수치는 사용자 지시에 따라 GPT 권장 시험값으로 작성하되 `RECOMMENDED_DEFAULT / TEST_VALUE`로 표시한다. 플레이어 판타지, 대표 경험, 주요 UX, 실패·보상 의미, 범위를 바꾸는 충돌은 사용자 Decision 없이 확정하지 않는다.

## 다음 작업

1. `SX-DEC-015` 화물–화차 관계 Grill Me
2. 승인 내용을 정본·Issue #6·Plan·VS-03 Goal·Sheet에 같은 ID로 반영
3. 첫 세션 온보딩·실패 학습 정보가 별도 Decision인지 적대적으로 재검증
4. 남은 필수 Decision이 0이면 `G3P`와 Codex Definition of Ready 판정
5. Gate 통과 이후에만 Codex Build 인계

## 주요 위험

- CargoStack capacity와 실제 화차 수·표시·spawn 점유 의미가 불명확함
- 자동 운행에서 분기 판단 시간이 부족하거나 과도하게 여유로울 가능성
- 화물 감속이 생존 최적화 exploit가 될 가능성
- BOOST가 항상 정답이거나 무가치할 가능성
- 결과·재시작 모션이 점수·연료·저장의 권위를 소유하는 회귀 위험
- 15×10 화면에서 역·화물·분기·HUD가 겹칠 위험
- 실제 맵 다양성·경로 엔트로피가 반복 플레이에 부족할 가능성
- Android·사람 이해·성능·접근성은 여전히 `NOT_RUN / HUMAN_NOT_RUN`

## 감사·동기화

- Post-VS02 감사: `SX-AUD-003` · HISTORICAL
- 현행 총기획 감사: `SX-AUD-004` · CURRENT
- 사용자 Evidence: `EV-USER-002`
- `SX-DEC-014` canonical commit: `ca50538652c72cbb282d7818990e92a0dfe79c9a`
- Sheet 12개 탭 readback: `PASS · SYNCED`
- 다음 차단 Finding: `SX-AUD-004-F02`
