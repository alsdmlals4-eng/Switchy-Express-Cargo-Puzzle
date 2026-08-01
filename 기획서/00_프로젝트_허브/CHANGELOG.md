# Changelog

## 2026-08-01 — Post-VS01 Sheet Sync Closed

- Google Sheets 12개 표준 GDD 탭에 canonical Commit `7500ccea1cddd6c163965a44370b653bbc176f85` 반영
- Decision `SX-DEC-001~013`, Evidence `EV-VS01-001`, Audit `SX-AUD-002` 동기화
- 허브·작업순서·결정 원장·근거·감사·GDD 요약·경험·시스템·표현·제작 검증 재조회
- 첫 배치의 빈 셀 오프셋 문제를 감사 루프에서 발견하고 승인·정본 경로·Commit·상태 필드를 복구
- 재조회 결과 `PASS · SYNCED`
- 다음 실행을 Issue #5 / `CODEX_GOAL_VS_02.md`로 유지

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
- 현재 Gate를 `G2 PASS · G3 PARTIAL`로 갱신
- 다음 실행을 Issue #5 / VS-02 기차·화물·역·LIFO로 전환
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
- 다음 상태를 `PLAN · CODEX_BUILD_READY`로 전환
