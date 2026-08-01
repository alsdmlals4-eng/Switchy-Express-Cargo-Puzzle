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
- [x] 첫 구현 Goal 승인·실행
- [x] VS-01 Issue #4 완료·PR #9 병합

## G3 — CORE_RUNTIME_PROVEN

Status: `PARTIAL`

완료:

- [x] Godot 4.7.1 프로젝트와 헤드리스 테스트
- [x] 15×10 연결 철도망 로직
- [x] 2·3단계 분기 로직
- [x] seeds 1~100 연결·막다른길·분기 밀도 검사
- [x] 5칸 경로 미리보기와 실제 다음 칸 일치
- [x] 직진 우선 기본 노선과 통과 뒤 초기화

증거:

- PR #9
- Commit `801632949d28564528e38d83dac59cccc6f06fb2`
- Godot headless `934 assertions / 0 failures`

남음:

- [ ] 기관차 이동·최대 8개 화차 추종
- [ ] 색상별 화물 최소 4개와 스테이션 6개 배치
- [ ] LIFO 하역
- [ ] 연료·점수·속도·부스터
- [ ] 무입력 상태의 유한 생존 검증
- [ ] 게임오버·재시작·로컬 기록

다음 실행: Issue #5

## G4 — TARGET_QUALITY_SLICE

Status: `NOT_STARTED`

- [ ] 모바일 가로형 UI
- [ ] 승인 시각 방향 적용
- [ ] 접근성·성능·피드백 검증
- [ ] 분기 상태와 실제 경로의 화면 일치
- [ ] 대표 플레이 캡처
- [ ] Android export·실기 성능

## G5 — PLAYTEST_EVIDENCE

Status: `NOT_STARTED`

- [ ] 최소 5명 첫 경험 테스트
- [ ] 행동 계측과 인터뷰
- [ ] MUST_FIX 해결
- [ ] Production 진입 결정
