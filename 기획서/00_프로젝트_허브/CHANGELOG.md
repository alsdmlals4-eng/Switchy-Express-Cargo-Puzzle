# Changelog

## 2026-08-02 — Post-VS02 Sheet Sync Closed

- PR #16 canonical recovery commit `8245e22905d64e22b599fe009bbb660d005392ed`를 실제 Switchy Express Google Sheets에 반영
- `SX-DEC-001~013`, `EV-VS02-001`, `EV-VS02-FIX-001`, `EV-BASE-V94-001`, `SX-AUD-003` 동기화
- 허브·작업순서·결정·근거·감사·GDD 요약·시각 작업면·경험·시스템·세계·표현·제작 검증 12개 탭 재조회
- 재조회 결과 동일 Decision ID·의미·상태·commit SHA 일치
- Audit 재검증 상태 `PASS · 12탭 재조회 완료`
- Sheet·GitHub 상태를 `SYNCED`로 전환
- 잘못 제공된 `19Ff...` 타 프로젝트 Sheet는 변경하지 않음
- 다음 단계는 `AB-TP01` 전체 기획 Coverage·적대적 검토·Grill Me Decision Queue

## 2026-08-02 — Post-VS02 Canonical Recovery · Sheet Pending

- 실제 구현 상태를 PR #12·#13·#15 기준으로 복원
- VS-02 기차·화차·화물·스테이션·LIFO 완료와 런타임 재생성 복구 기록
- Evidence `EV-VS02-001`, `EV-VS02-FIX-001`, `EV-BASE-V94-001` 등록
- Post-VS02 적대적 감사 `SX-AUD-003` 추가
- README·START_HERE·Active Context·Decisions·Gates·Roadmap·분야 본책·구현 계획 갱신
- 완료된 `CODEX_GOAL_VS_02.md`를 역사 실행문으로 전환하되 기존 실행 계약 전문 보존
- `CODEX_GOAL_VS_03.md`를 `PLANNING_DRAFT · CODEX_NOT_READY`로 추가
- Issue #6을 VS-03A 생존 경제 / VS-03B 제품 화면의 순차 패키지로 명확화
- Issue #7은 기록 구현이 아니라 지속성·soak·Android·플레이테스트 검증을 소유하도록 정리
- 상세 데이터 수치는 `RECOMMENDED_DEFAULT / TEST_VALUE`, 중요 기획 충돌은 Grill Me로 처리
- 제공된 `19Ff...` Sheet가 다른 프로젝트임을 확인하고 수정 대상에서 제외
- 실제 Switchy Express Sheet는 Adapter의 `1EpQ...`
- Sheet 상태를 `GITHUB_UPDATE_PENDING_SHEET`로 전환
- canonical merge commit을 Sheet에 반영·재조회한 뒤 별도 Sync Closure PR로 `SYNCED`를 닫을 예정
- 적대적 재검토에서 기존 Changelog 세부 이력 축약을 회귀로 판정하고 원문 기록을 복원

## 2026-08-01 — Base v9.4 Adoption

- PR #15 병합
- Base v9.4 identity·AI 작업 흐름·UI 모션 계약 적용
- 제품 코드·게임 규칙·Sheet는 변경하지 않음
- Project Contract와 Godot full regression PASS
- Android·사람·provider·Sheet write는 `NOT_RUN / HUMAN_NOT_RUN`

## 2026-08-01 — VS-02 Runtime Recovery

- PR #13 병합
- DeliveryLoop에서 pending cargo respawn 처리
- 현재 열차·화차와 전방 2칸 제외
- 최소 화물 수량의 실제 런타임 회복 검증
- Godot `9 cases / 6915 assertions / 0 failures`

## 2026-08-01 — VS-02

- Issue #5 / PR #12 완료
- 연속 기관차 이동과 최대 8개 화차 경로 이력 추종
- LOAD 선택 적재·색상+모양 cargo·capacity 8 LIFO stack
- 색상별 역 2개·pickup 최소 4개
- 결정론적 배치·금지 칸·1초 지연·deferred 회복
- LIFO 하역 ViewModel과 DeliveryLoop 통합
- Godot `9 cases / 6908 assertions / 0 failures`

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
