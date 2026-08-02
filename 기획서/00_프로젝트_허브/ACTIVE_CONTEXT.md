# Active Context

## 현재 상태

- 프로젝트 이름·핵심 코어·Vertical Slice 방향은 사용자 승인 상태다.
- Base v9.4 프로젝트 운영 계약이 적용돼 있다.
- VS-01 Issue #4 / PR #9 완료.
- VS-02 Issue #5 / PR #12 완료.
- VS-02 런타임 화물 재생성 누락은 PR #13에서 복구 완료.
- Base v9.4 AI 운영·UI 모션 계약은 PR #15에서 적용 완료.
- 제품 구현 기준: `4e435a1a6d10ab146197671049da80709fd18c1f`.
- 최신 main: `539d2bae18d20e303649f047b9df69e8e224b2e7`.
- Godot 검증: `9 cases / 6915 assertions / 0 failures`.
- Project Contract와 Base v9.4 focused validation: PASS.
- Issue #5: CLOSED · COMPLETED.
- Issue #6: OPEN · 다음 구현 후보.
- 현재 Work Mode: `TOTAL_PLANNING · REVIEW`.
- Codex 상태: `CODEX_NOT_READY`.
- GitHub 정본과 Google Sheets는 VS-01 상태에 머물러 있었으며 현재 복구 중이다.
- Sheet 상태: `GITHUB_UPDATE_PENDING_SHEET`.
- 제공된 `19Ff...` 시트는 다른 프로젝트이므로 변경 대상에서 제외한다.
- 실제 Switchy Express GDD는 Adapter의 `1EpQ...` 시트다.

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
- LIFO 동일색 연속 그룹 하역
- 실제 stack과 동일한 하역 순서 ViewModel
- 정확한 cell-crossing 시각의 DeliveryLoop 이벤트

## 현재 미구현

- 시간 기반 속도 상승과 연료 소모
- 화물 적재량 감속
- BOOST 속도·추가 연료 소모
- 배송 점수·연료 보상·콤보 경제
- 무입력 유한 생존과 연료 0 게임오버
- 결과 요약·즉시 재시작
- 최고 점수·최장 생존·최대 콤보 로컬 기록
- 제품 RailBoardView·SwitchView·HUD·결과 화면
- 접근성 설정 실제 동작
- 대표 런타임 캡처
- Android export·실기 성능
- 10분 soak·사용자 플레이테스트

## 현재 총기획 작업

총기획은 빈 문서에서 새 게임을 발명하는 작업이 아니다.

```text
현재 결정·강점·실제 구현 복원
→ 기획 Coverage·분야 간 충돌 감사
→ 적대적 공격과 비판 재검증
→ SAFE_PLANNING_FIXES 반영
→ 중요 기획 충돌만 Grill Me
→ 정본·Issue·Plan·Sheet 동기화
→ Codex Definition of Ready 판정
```

상세 수치는 사용자 지시에 따라 GPT 권장 시험값으로 작성하되 `RECOMMENDED_DEFAULT / TEST_VALUE`로 표시한다. 플레이어 판타지, 대표 경험, 주요 UX, 실패·보상 의미, 범위를 바꾸는 충돌은 사용자 Decision 없이 확정하지 않는다.

## 다음 작업

1. Post-VS02 정본 복구 PR 검증·병합
2. canonical merge commit을 Switchy Express Sheet에 반영하고 재조회
3. Sheet Sync Closure PR
4. 전체 기획 Coverage와 분야 간 충돌 적대적 감사
5. 가장 차단적인 `USER_DECISION_REQUIRED`를 한 건씩 Grill Me
6. 승인된 기획을 본책·Issue #6·VS-03 Goal에 즉시 동기화
7. `PLANNING_AND_REVIEW_COMPLETE_GATE` 이후에만 Codex Build 인계

## 주요 위험

- 문서·Sheet가 실제 구현보다 뒤처져 잘못된 Goal을 재실행할 위험
- 속도·연료·보상 시험값이 확정 수치처럼 굳어질 위험
- CargoStack capacity와 실제 화차 수·화차 표현의 의미가 불명확할 가능성
- 자동 운행에서 분기 판단 시간이 부족하거나 과도하게 여유로울 가능성
- 화물 감속이 생존 최적화 exploit가 될 가능성
- BOOST가 항상 정답이거나 무가치할 가능성
- 결과·재시작 모션이 점수·연료·저장의 권위를 소유하는 회귀 위험
- 15×10 화면에서 역·화물·분기·HUD가 겹칠 위험
- 실제 맵 다양성·경로 엔트로피가 반복 플레이에 부족할 가능성
- Android·사람 이해·성능·접근성은 여전히 `NOT_RUN / HUMAN_NOT_RUN`

## 감사·동기화

- 최신 구현 감사: `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
- VS-01 감사 `SX-AUD-002`는 역사 증거로 보존
- 새 감사 ID: `SX-AUD-003`
- 새 Evidence:
  - `EV-VS02-001`
  - `EV-VS02-FIX-001`
  - `EV-BASE-V94-001`
- Google Sheets는 1차 PR 병합 후 같은 Evidence·Commit으로 재동기화한다.
