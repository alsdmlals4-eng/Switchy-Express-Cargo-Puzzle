# Current Confirmed Decisions

Last updated: `2026-08-01`
Original decision baseline: `dadb5ca0a3acc3ba6e730f7a9de438f0bd8ebe59`
Latest implementation evidence: `801632949d28564528e38d83dac59cccc6f06fb2`
Canonical post-VS01 sync commit: `7500ccea1cddd6c163965a44370b653bbc176f85`

| Decision ID | 분야 | 현재 결정 | 근거 | 상태 |
|---|---|---|---|---|
| SX-DEC-001 | 제품 | 정식 프로젝트 제목은 `Switchy Express: Cargo Puzzle`이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-002 | 경험 | 목표는 무한 운행에서 오래 생존하고 최고 점수를 경쟁하는 것이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-003 | 경험 | 기차는 자동 운행하며 플레이어는 `짐싣기`, 분기기 탭, `부스터`를 조작한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-004 | 맵 | 가로형 15×10 맵에서 모든 선로는 하나의 네트워크로 연결되고 막다른길을 허용하지 않는다. | 사용자 승인·PR #9 구현 검증 | CONFIRMED |
| SX-DEC-005 | 맵 | 갈림길에는 2단계 또는 3단계 분기기를 배치하고 활성 선로 방향을 명확히 표시한다. Vertical Slice의 현재 격자 그래프는 한 접근 방향에서 최대 3개 출구 상태를 지원한다. | 사용자 승인·PR #9 구현 검증 | CONFIRMED |
| SX-DEC-006 | 콘텐츠 | 빨강·파랑·노랑 스테이션을 색상별 2개씩 일반 선로의 무작위 위치에 배치한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-007 | 콘텐츠 | 맵에는 각 색상 화물이 항상 최소 4개 존재하며 적재된 화물은 다른 유효 선로 위치에 재생성된다. | 사용자 승인 | CONFIRMED |
| SX-DEC-008 | 시스템 | 화물은 마지막에 실은 것부터 내리는 LIFO이며 같은 색이 연속되면 콤보 하역한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-009 | 시스템 | 배송은 점수와 연료를 주며 시간 경과에 따라 기본 속도와 연료 소모가 증가하고 연료 0에서 종료된다. | 사용자 승인 | CONFIRMED |
| SX-DEC-010 | 시스템 | 적재 화물 수가 많을수록 기차가 느려지고 부스터는 속도를 높이는 대신 연료를 추가 소모한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-011 | 표현 | 부드럽고 둥근 프리미엄 캐주얼 3D 카툰, 친근한 토끼 기관사, 선명한 선로·분기 UX를 사용한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android/Google Play, 가로형 화면을 초기 기술 기준으로 사용한다. | 프로젝트 기본값·PR #9 부트 검증 | CONFIRMED |
| SX-DEC-013 | 분기 UX | 분기기의 기본 A노선은 가능한 경우 현재 진행 방향의 직진을 우선하며, 미리보기 첫 칸과 실제 다음 칸은 항상 일치해야 한다. | 사용자 권장안 일괄 승인·적대적 검토 | CONFIRMED |

## 구현·검증 추적

| Decision ID | 구현 상태 | 검증 상태 | 증거 | 남은 범위 |
|---|---|---|---|---|
| SX-DEC-004 | IMPLEMENTED | PASSED | PR #9 / 100 seeds / 연결·막다른길·cycle 검사 | 맵 다양성·실제 플레이 가독성 |
| SX-DEC-005 | IMPLEMENTED_LOGIC | PASSED_LOGIC | PR #9 / 2·3단계 상태·5칸 preview·실제 next-cell 일치 | 런타임 선로·레버·화살표 시각화 |
| SX-DEC-012 | IMPLEMENTED_BASELINE | PARTIAL | Godot 4.7.1 headless 934 assertions | Android export·실기·성능 |
| SX-DEC-013 | IMPLEMENTED | PASSED | 직진 우선 회귀 테스트·preview parity | 런타임 시각 검증 |
| SX-DEC-003,006~010 | NOT_STARTED | NOT_RUN | 다음 Issue #5/#6 | 기차·화물·역·LIFO·생존 경제 |

## 동기화 상태

- GitHub implementation Commit: `801632949d28564528e38d83dac59cccc6f06fb2`
- GitHub canonical sync Commit: `7500ccea1cddd6c163965a44370b653bbc176f85`
- Google Sheets: `https://docs.google.com/spreadsheets/d/1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo/edit`
- Sheet·GitHub 상태: `SYNCED`
- Sheet 재조회: `2026-08-01 10:09 +09:00 · PASS`
- 감사: `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`

## 대체 관계

- 자동차·스네이크 직접 조작안은 현재 기차 노선 조작안으로 대체됨.
- FIFO 하역안은 LIFO 하역안으로 대체됨.
- 세로형 화면안은 가로형 화면안으로 대체됨.
- 15×15·14×9 맵 후보는 최종 15×10 기준으로 대체됨.
- 좌표 순서에 의존하는 기본 분기안은 `SX-DEC-013`의 직진 우선 기본 노선으로 대체됨.
