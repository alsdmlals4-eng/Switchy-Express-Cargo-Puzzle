# Current Confirmed Decisions

Last updated: `2026-08-02`
Original decision baseline: `dadb5ca0a3acc3ba6e730f7a9de438f0bd8ebe59`
VS-01 canonical sync: `7500ccea1cddd6c163965a44370b653bbc176f85`
VS-02 implementation: `0738d9c10e431a43e7a2f34590369c3f17d1f8a5`
VS-02 runtime recovery: `4e435a1a6d10ab146197671049da80709fd18c1f`
Base v9.4 adoption: `539d2bae18d20e303649f047b9df69e8e224b2e7`
Post-VS02 canonical recovery: `8245e22905d64e22b599fe009bbb660d005392ed`

| Decision ID | 분야 | 현재 결정 | 근거 | 상태 |
|---|---|---|---|---|
| SX-DEC-001 | 제품 | 정식 프로젝트 제목은 `Switchy Express: Cargo Puzzle`이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-002 | 경험 | 목표는 무한 운행에서 오래 생존하고 최고 점수를 경쟁하는 것이다. | 사용자 승인 | CONFIRMED |
| SX-DEC-003 | 경험 | 기차는 자동 운행하며 플레이어는 `LOAD`, 분기기 탭, `BOOST`를 조작한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-004 | 맵 | 가로형 15×10 맵에서 모든 선로는 하나의 네트워크로 연결되고 막다른길을 허용하지 않는다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-005 | 맵 | 갈림길에는 2단계 또는 3단계 분기기를 배치하고 활성 선로 방향을 명확히 표시한다. 현재 격자 그래프는 한 접근 방향에서 최대 3개 출구 상태를 지원한다. | 사용자 승인·PR #9 | CONFIRMED |
| SX-DEC-006 | 콘텐츠 | 빨강·파랑·노랑 스테이션을 색상별 2개씩 일반 선로에 배치한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-007 | 콘텐츠 | 맵에는 각 색상 화물이 항상 최소 4개 존재하며 적재된 화물은 다른 유효 선로 위치에 재생성된다. | 사용자 승인·PR #12·#13 | CONFIRMED |
| SX-DEC-008 | 시스템 | 화물은 마지막에 실은 것부터 내리는 LIFO이며 같은 색이 연속되면 그룹으로 하역한다. | 사용자 승인·PR #12 | CONFIRMED |
| SX-DEC-009 | 시스템 | 배송은 점수와 연료를 주며 시간 경과에 따라 기본 속도와 연료 소모가 증가하고 연료 0에서 종료된다. | 사용자 승인 | CONFIRMED |
| SX-DEC-010 | 시스템 | 적재 화물 수가 많을수록 기차가 느려지고 BOOST는 속도를 높이는 대신 연료를 추가 소모한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-011 | 표현 | 부드럽고 둥근 프리미엄 캐주얼 3D 카툰, 친근한 토끼 기관사, 선명한 선로·분기 UX를 사용한다. | 사용자 승인 | CONFIRMED |
| SX-DEC-012 | 기술 | Godot 4.7.1/GDScript, Android/Google Play, 가로형 화면을 초기 기술 기준으로 사용한다. | 프로젝트 기본값·PR #9 | CONFIRMED |
| SX-DEC-013 | 분기 UX | 분기기의 기본 A노선은 가능한 경우 현재 진행 방향의 직진을 우선하며, 미리보기 첫 칸과 실제 다음 칸은 항상 일치해야 한다. | 사용자 권장안 일괄 승인·PR #9 | CONFIRMED |

## 구현·검증 추적

| Decision ID | 구현 상태 | 검증 상태 | 증거 | 남은 범위 |
|---|---|---|---|---|
| SX-DEC-003 | PARTIAL | PARTIAL_PASS | 자동 운행·LOAD·BOOST 우선 입력 계약: PR #12/#13 | BOOST 속도·연료 효과, 제품 입력 UI |
| SX-DEC-004 | IMPLEMENTED | PASSED | PR #9 / seeds 1~100 | 맵 다양성·실제 플레이 가독성 |
| SX-DEC-005 | IMPLEMENTED_LOGIC | PASSED_LOGIC | PR #9 / preview mismatch 0 | 런타임 선로·레버·화살표 |
| SX-DEC-006 | IMPLEMENTED | PASSED | PR #12 / 색상별 2개·총 6개·거리 검사 | 런타임 시각·사람 가독성 |
| SX-DEC-007 | IMPLEMENTED | PASSED | PR #12/#13 / 최소 수량·금지 칸·지연 회복 | 장시간 starvation·soak |
| SX-DEC-008 | IMPLEMENTED | PASSED | PR #12 / LIFO stack·station·DeliveryLoop | 점수·연료 보상·HUD 표현 |
| SX-DEC-009 | NOT_STARTED | NOT_RUN | Issue #6 | 속도·연료·점수·게임오버 |
| SX-DEC-010 | INTERFACE_ONLY | NOT_RUN | BOOST 우선 입력 계약만 존재 | 감속·BOOST 경제와 exploit 검증 |
| SX-DEC-011 | APPROVED_DIRECTION | HUMAN_RUNTIME_NOT_RUN | 사용자 승인 콘셉트·Visual Direction | 제품 UI·아트·Android 캡처 |
| SX-DEC-012 | IMPLEMENTED_BASELINE | PARTIAL | Godot 4.7.1 headless 6915 assertions | Android export·실기·성능 |
| SX-DEC-013 | IMPLEMENTED | PASSED | PR #9·#12 / locked route·preview parity | 런타임 시각 검증 |

## Evidence 원장

| Evidence ID | 내용 | GitHub 증거 | 상태 |
|---|---|---|---|
| EV-VS01-001 | Godot·RailGraph·분기 기반 | PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2` | VALIDATED |
| EV-VS02-001 | 기차·화차·화물·역·LIFO | PR #12 / `0738d9c10e431a43e7a2f34590369c3f17d1f8a5` | VALIDATED |
| EV-VS02-FIX-001 | DeliveryLoop 안의 최소 화물 재생성 회복 | PR #13 / `4e435a1a6d10ab146197671049da80709fd18c1f` | VALIDATED |
| EV-BASE-V94-001 | Base v9.4 운영·UI 모션 계약 적용 | PR #15 / `539d2bae18d20e303649f047b9df69e8e224b2e7` | VALIDATED_AUTOMATED_ONLY |
| SX-AUD-002 | Post-VS01 적대적 감사 | `POST_VS01_ADVERSARIAL_AUDIT.md` | HISTORICAL |
| SX-AUD-003 | Post-VS02 정본·구현·Sheet 적대적 감사 | `POST_VS02_ADVERSARIAL_AUDIT.md` | CURRENT |

## 수치·기획 결정 규칙

- 속도·연료·점수·보상·타이밍의 상세 수치는 사용자 지시에 따라 GPT 권장안으로 작성한다.
- 해당 수치는 플레이테스트 전까지 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`다.
- 프로젝트 코어·대표 경험·주요 UX·콘텐츠 의미·실패와 보상 의미가 갈리는 선택은 Grill Me로만 확정한다.
- 기존 승인 Decision을 기술 세부 질문으로 다시 묻지 않는다.

## 동기화 상태

- GitHub canonical recovery Commit: `8245e22905d64e22b599fe009bbb660d005392ed`
- Google Sheets: Adapter의 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Sheet·GitHub 상태: `SYNCED`
- Sheet 12개 탭 재조회: `2026-08-02 11:18 +09:00 · PASS`
- 제공된 `19Ff...` 시트는 다른 프로젝트이며 변경하지 않았다.

## 대체 관계

- 자동차·스네이크 직접 조작안은 현재 기차 노선 조작안으로 대체됨.
- FIFO 하역안은 LIFO 하역안으로 대체됨.
- 세로형 화면안은 가로형 화면안으로 대체됨.
- 15×15·14×9 맵 후보는 최종 15×10 기준으로 대체됨.
- 좌표 순서에 의존하는 기본 분기안은 `SX-DEC-013`의 직진 우선 기본 노선으로 대체됨.
