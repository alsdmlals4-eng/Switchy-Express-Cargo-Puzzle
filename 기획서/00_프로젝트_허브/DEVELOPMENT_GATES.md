# Development Gates

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- [x] 프로젝트 제목 확정
- [x] 플랫폼·엔진 방향 확정
- [x] 저장소와 실제 Switchy Express Google Sheets 확인
- [x] 잘못 제공된 타 프로젝트 Sheet를 변경 대상에서 제외

## G1 — CORE_CONFIRMED

Status: `PASS`

- [x] 핵심 루프 사용자 승인
- [x] 적재·분기·하역·연료·점수 구조 승인
- [x] LIFO 하역 승인
- [x] 가로형 연결 철도망 승인
- [x] 시각 방향 승인
- [x] `SX-DEC-014` 하역 그룹 Combo 의미 승인

## G2 — VERTICAL_SLICE_CONTRACT_APPROVED

Status: `PASS`

- [x] 대표 경험과 포함·제외 범위 작성
- [x] 초기 시험값과 성공 기준 작성
- [x] VS-01 Issue #4 완료
- [x] VS-02 Issue #5 완료
- [x] Base v9.4 운영 계약 적용
- [x] Combo와 speed bonus의 의미 분리

## G3 — CORE_RUNTIME_PROVEN

Status: `PARTIAL`

완료:

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트
- [x] 15×10 연결 철도망 로직
- [x] 2·3단계 분기 로직
- [x] seeds 1~100 연결·막다른길·분기 밀도 검사
- [x] 5칸 경로 미리보기와 실제 다음 칸 일치
- [x] 직진 우선 기본 노선과 통과 뒤 초기화
- [x] 연속 기관차 이동과 최대 8개 화차 추종
- [x] LOAD 선택 적재와 capacity 8 LIFO stack
- [x] 색상별 화물 최소 4개와 스테이션 6개
- [x] 금지 칸·지연 재생성·deferred 회복
- [x] LIFO 동일 타입 연속 그룹 하역
- [x] DeliveryLoop 런타임 최소 화물 회복
- [x] Godot headless `9 cases / 6915 assertions / 0 failures`

남음:

- [ ] `SX-DEC-014` Combo 계산·max_combo 구현
- [ ] 시간 기반 속도·연료
- [ ] 화물 감속·BOOST 경제
- [ ] 배송 점수·연료 보상
- [ ] 무입력 상태의 유한 생존 검증
- [ ] 게임오버·결과·즉시 재시작
- [ ] 최고 점수·최장 생존·최대 Combo 저장
- [ ] 저장 손상·버전 fallback 계약

다음 실행 후보: Issue #6. 단, `PLANNING_AND_REVIEW_COMPLETE_GATE` 전에는 Codex Build를 시작하지 않는다.

## G3P — TOTAL_PLANNING_AND_REVIEW_COMPLETE

Status: `IN_PROGRESS`

- [x] 최신 main·실제 구현·최근 PR·Issue 복원
- [x] Post-VS02 정본 드리프트 확인·복구
- [x] Google Sheets post-VS02 동기화·12탭 재조회
- [x] 상세 수치를 `RECOMMENDED_DEFAULT / TEST_VALUE`로 관리하는 권한 확인
- [x] 전체 기획 Coverage Matrix 작성
- [x] 분야 간 1차 충돌 적대적 검토
- [x] `SX-DEC-014` Combo 의미 확정
- [x] 안전 보완과 구형 Skill·Plan·Registry 참조 복구
- [ ] `SX-DEC-014` canonical commit Sheet 동기화
- [ ] `SX-DEC-015` 화물–화차 관계 확정
- [ ] 후속 Grill Me Decision 필요성 재검증·완료
- [ ] VS-03 범위·수용 기준·저장·UX 책임 최종 일치
- [ ] Codex Definition of Ready

## G4 — TARGET_QUALITY_SLICE

Status: `NOT_STARTED`

- [ ] 실제 플레이 Scene과 모바일 가로형 HUD
- [ ] 승인 시각 방향의 제품 적용
- [ ] 분기 상태와 실제 경로 화면 일치
- [ ] 색상+모양 이중 부호
- [ ] `COMBO ×N`과 speed bonus의 의미 분리
- [ ] `SX-DEC-015`에 따른 화차·화물 표현
- [ ] 48dp 터치 영역과 Android safe area
- [ ] Reduced Motion·mute·haptic-off
- [ ] 대표 플레이 캡처
- [ ] Android export·실기 성능

## G5 — PLAYTEST_EVIDENCE

Status: `NOT_STARTED`

- [ ] 10분 soak
- [ ] 최소 5명 첫 경험 테스트
- [ ] 행동 계측과 인터뷰
- [ ] LIFO·Combo·분기 이해율 기준 충족
- [ ] 승인된 MUST_FIX 회귀 테스트
- [ ] `PASS / REVISE / PIVOT / STOP`
- [ ] Production 진입 결정
