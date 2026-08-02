# Changelog

## 2026-08-02 — Post-VS02 Canonical Recovery · Sheet Pending

- 실제 구현 상태를 PR #12·#13·#15 기준으로 복원
- VS-02 기차·화차·화물·스테이션·LIFO 완료와 런타임 재생성 복구 기록
- Evidence `EV-VS02-001`, `EV-VS02-FIX-001`, `EV-BASE-V94-001` 등록
- Post-VS02 적대적 감사 `SX-AUD-003` 추가
- README·START_HERE·Active Context·Decisions·Gates·Roadmap·분야 본책·구현 계획 갱신
- 완료된 `CODEX_GOAL_VS_02.md`를 역사 실행문으로 전환
- `CODEX_GOAL_VS_03.md`를 `PLANNING_DRAFT · CODEX_NOT_READY`로 추가
- Issue #6을 VS-03A 생존 경제 / VS-03B 제품 화면의 순차 패키지로 명확화
- Issue #7은 기록 구현이 아니라 지속성·soak·Android·플레이테스트 검증을 소유하도록 정리
- 상세 데이터 수치는 `RECOMMENDED_DEFAULT / TEST_VALUE`, 중요 기획 충돌은 Grill Me로 처리
- 제공된 `19Ff...` Sheet가 다른 프로젝트임을 확인하고 수정 대상에서 제외
- 실제 Switchy Express Sheet는 Adapter의 `1EpQ...`
- Sheet 상태를 `GITHUB_UPDATE_PENDING_SHEET`로 전환
- canonical merge commit을 Sheet에 반영·재조회한 뒤 별도 Sync Closure PR로 `SYNCED`를 닫을 예정

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
- 재조회 결과 `PASS · SYNCED`

## 2026-08-01 — Post-VS01

- Issue #4 / PR #9 완료
- Godot 4.7.1 프로젝트·15×10 RailGraph·2/3단계 분기 구현
- 직진 우선 기본 A노선 `SX-DEC-013`
- Godot headless `3 cases / 934 assertions / 0 failures`
- Post-VS01 감사 `SX-AUD-002`

## 2026-08-01 — Project Bootstrap

- 프로젝트 이름 `Switchy Express: Cargo Puzzle` 확정
- Base v9.3 프로젝트 운영체계 설치 및 PR #1 병합
- 현재 승인 결정 `SX-DEC-001`~`SX-DEC-012` 원장 생성
- Vertical Slice 계약·플레이테스트 계획·TDD 구현 계획 생성
- Google Sheets GDD 12개 핵심 tab 구성
