# Changelog

## 2026-08-01 — Post-VS02

- Issue #5 / PR #12 완료
- 기관차 연속 이동·현재 구간 target lock·큰 delta 칸별 처리 구현
- 최대 8개 화차의 제한된 경로 이력 추종과 보간 구현
- `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE` 화물 타입 구현
- LOAD 선택 적재·BOOST 입력 우선·최대 8칸 LIFO 스택 구현
- 색상별 역 2개·총 6개 결정론적 배치와 동색 거리 5칸 보장
- 맵 위 타입별 화물 최소 4개·1초 재생성·금지 칸·deferred 복구 구현
- 실제 기차 진입 기반 수거→스택→역→LIFO 하역 통합
- 칸별 정확한 event time과 전후 하역 ViewModel 구현
- PR #12 Commit `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
- 병합 후 적대적 검토에서 runtime 재생성 처리 누락 발견
- PR #13에서 DeliveryLoop의 최소 화물 자동 복구·현재 열차/전방 2칸 제외 보완
- PR #13 Commit `4e435a1a6d10ab146197671049da80709fd18c1f`
- Godot headless `9 cases / 6915 assertions / 0 failures`
- Post-VS02 적대적 감사 `SX-AUD-003` 작성
- 다음 실행을 Issue #6 / `CODEX_GOAL_VS_03.md`로 전환

## 2026-08-01 — Post-VS01 Sheet Sync Closed

- Google Sheets 12개 표준 GDD 탭에 canonical Commit `7500ccea1cddd6c163965a44370b653bbc176f85` 반영
- Decision `SX-DEC-001~013`, Evidence `EV-VS01-001`, Audit `SX-AUD-002` 동기화
- 허브·작업순서·결정 원장·근거·감사·GDD 요약·경험·시스템·표현·제작 검증 재조회
- 첫 배치의 빈 셀 오프셋 문제를 감사 루프에서 발견하고 승인·정본 경로·Commit·상태 필드를 복구
- 재조회 결과 `PASS · SYNCED`

## 2026-08-01 — Post-VS01

- Issue #4 / PR #9 완료
- Godot 4.7.1 프로젝트·1920×1080 가로형 main scene 생성
- 결정론적 15×10 RailGraph와 2단계·3단계 분기 구현
- seeds 1~100 연결·막다른길·cycle·분기 밀도 검증
- 직진 우선 기본 A노선 `SX-DEC-013` 확정
- 5칸 경로 미리보기와 실제 다음 칸 일치 검증
- Godot Script Error가 종료 코드 0으로 누락되는 CI false-green 차단
- Godot headless `3 cases / 934 assertions / 0 failures`
- 구현 Commit `801632949d28564528e38d83dac59cccc6f06fb2`
- Post-VS01 적대적 감사 `SX-AUD-002` 작성
- 정본·감사 Commit `7500ccea1cddd6c163965a44370b653bbc176f85`

## 2026-08-01 — Project Bootstrap

- 프로젝트 이름 `Switchy Express: Cargo Puzzle` 확정
- Base v9.3 프로젝트 운영체계 설치 및 PR #1 병합
- 현재 승인 결정 `SX-DEC-001`~`SX-DEC-012` 원장 생성
- 핵심 경험·시스템·시각 방향 정본 생성
- Vertical Slice 계약·플레이테스트 계획·TDD 구현 계획 생성
- GitHub Actions `Project Contract` 검사 추가 및 통과
- Google Sheets GDD 12개 핵심 tab 구성
- GitHub 결정 Commit `dadb5ca0a3acc3ba6e730f7a9de438f0bd8ebe59`와 Sheet 상태 동기화
