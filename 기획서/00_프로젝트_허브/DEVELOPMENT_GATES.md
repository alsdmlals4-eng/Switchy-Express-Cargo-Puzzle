# Development Gates

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- [x] 프로젝트 제목 확정
- [x] 플랫폼·엔진 방향 확정
- [x] 저장소·Google Sheets 확인

## G1 — CORE_CONFIRMED

Status: `PASS`

- [x] 핵심 루프 사용자 승인
- [x] 적재·분기·하역·연료·점수 구조 승인
- [x] LIFO 하역 승인
- [x] 가로형 연결 철도망 승인
- [x] 시각 방향 승인

## G2 — VERTICAL_SLICE_CONTRACT_APPROVED

Status: `PASS`

- [x] 대표 경험과 포함·제외 범위 작성
- [x] 초기 시험값과 성공 기준 작성
- [x] VS-01 Issue #4 완료
- [x] VS-02 Issue #5 완료

## G3 — CORE_RUNTIME_PROVEN

Status: `PARTIAL`

완료:

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트
- [x] 15×10 연결 철도망과 2·3단계 분기
- [x] 현재 구간 target lock·직진 우선·preview parity
- [x] 기관차 연속 이동과 최대 8개 화차 추종
- [x] LOAD 선택 적재와 최대 8개 LIFO 스택
- [x] 색상+모양 화물 타입
- [x] 색상별 역 2개·총 6개
- [x] 맵 위 타입별 화물 최소 4개와 runtime 재생성
- [x] LIFO 연속 하역과 배송 하위 루프 통합

증거:

- PR #9 · `801632949d28564528e38d83dac59cccc6f06fb2`
- PR #12 · `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
- PR #13 · `4e435a1a6d10ab146197671049da80709fd18c1f`
- Godot headless `9 cases / 6915 assertions / 0 failures`

남음:

- [ ] 시간별 기본 속도 상승
- [ ] 화물 수에 따른 감속
- [ ] 연료 drain·배송 연료 보상
- [ ] 점수·combo·빠른 배송·중량 보너스
- [ ] BOOST 가속·추가 연료 소비
- [ ] 연료 0 게임오버·입력/이동 정지
- [ ] 무입력 180초·10분 soak
- [ ] 재시작·결과 요약·로컬 기록

다음 실행: Issue #6 / `CODEX_GOAL_VS_03.md`

## G4 — TARGET_QUALITY_SLICE

Status: `NOT_STARTED`

- [ ] 기능적 모바일 가로형 gameplay scene·HUD
- [ ] 승인 시각 방향 적용
- [ ] 접근성·성능·피드백 검증
- [ ] 분기 상태와 실제 경로의 화면 일치
- [ ] 대표 플레이 캡처
- [ ] Android export·실기 성능

Issue #6에서 기능 HUD를 시작하되, 최종 시각 품질·Android 증거 전에는 G4를 통과시키지 않는다.

## G5 — PLAYTEST_EVIDENCE

Status: `NOT_STARTED`

- [ ] 최소 5명 첫 경험 테스트
- [ ] 행동 계측과 인터뷰
- [ ] MUST_FIX 해결
- [ ] Production 진입 결정
