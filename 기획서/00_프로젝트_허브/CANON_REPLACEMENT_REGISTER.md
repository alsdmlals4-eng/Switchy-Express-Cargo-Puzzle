# 정본 대체·보류·폐기 등록부

현재 기준선: `FINITE_DELIVERY_PUZZLE_BASELINE.md`
결정: `GMB-002 · SX-DEC-027~036`
감사: `SX-AUD-012`

이 등록부는 과거 문서와 구현 증거를 삭제하지 않으면서 현재 제품 권위를 명확히 분리한다.

## 상태 의미

- `[대체됨]`: 과거에는 유효했으나 새 정본이 같은 책임을 인수했다.
- `[보류]`: 현재 범위 밖이며 향후 재검토할 수 있다.
- `[폐기]`: 새 제품 방향과 충돌하여 구현 대상으로 사용하지 않는다.
- `[역사 증거]`: 당시 구현·테스트·감사 결과로만 유효하며 현 제품 완료 증거가 아니다.

## 현재 consumer

다음 파일은 새 기준선을 우선 참조해야 한다.

- `AGENTS.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/10_경험/CORE_GAMEPLAY.md`
- `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- `기획서/40_표현/VISUAL_DIRECTION.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/00_프로젝트_허브/ROADMAP.md`

## 대체됨

| 파일·결정 | 이유 | 새 책임 원본 |
|---|---|---|
| SX-DEC-002 | 무한 생존 제품 목적 | SX-DEC-027 |
| SX-DEC-003 | BOOST 포함 조작 체계 | SX-DEC-029/031 |
| SX-DEC-004 | 완성형 connected rail을 제품 맵으로 사용 | SX-DEC-028/030 |
| SX-DEC-006~007 | 고정 6역·지속 respawn 화물 | SX-DEC-027/031/034 |
| SX-DEC-008 중 capacity 8 | 무제한 스택 | SX-DEC-031 |
| SX-DEC-009~010 | 연료·화물 감속·BOOST | SX-DEC-027/029/032 |
| SX-DEC-013 중 통과 후 기본 복귀 | 상태 유지 분기 | SX-DEC-029/030 |
| SX-DEC-016 | 첫 endless run 온보딩 | SX-DEC-034 |
| SX-DEC-017의 연료 0 결과 문맥 | 제한 시간 미배송 실패 분석 | SX-DEC-029/034 |
| SX-DEC-022 | 시간 pressure·DifficultyDirector 제품 권위 | SX-DEC-029 |
| `기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md` | 생존·BOOST 위계 | `FINITE_DELIVERY_PUZZLE_BASELINE.md` |
| `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md` | 1~10 튜토리얼로 교체 | SX-DEC-034 |
| `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` | escalating survival 삭제 | SX-DEC-029 |
| `docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md` | old core 구현 계획 | 새 finite puzzle DoR |
| `docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md` | old playable surface | 새 finite puzzle DoR |
| `기획서/50_제작_검증/VS03_PACKAGE_STATUS.md`의 current order | old core package order | 새 finite puzzle DoR |

## 폐기

- 사용자 BOOST 홀드 입력
- 연료 소모·회복·연료 0 종료
- 화물 수에 따른 속도 감소
- 시간 경과에 따른 기본 속도·연료 압박 증가
- 적재 후 화물 재생성
- 분기 통과 후 기본 방향 자동 복귀
- 일반 제품에서 capacity 8 제한

관련 코드는 즉시 삭제 대상으로 간주하지 않는다. 재사용·제거 범위는 새 DoR과 구현 계획에서 결정하며 그전까지 `LEGACY_IMPLEMENTATION`이다.

## 보류

- UGC 맵 editor·게시·community signal
- 환적역
- 다중 열차와 충돌·신호 자동화
- 반복 도전 변형 규칙
- 온라인 리플레이 공개
- procedural campaign

## 역사 증거

다음은 당시 old core를 정확히 구현·검증했다는 증거로 유지한다.

- PR #37 / SX-AUD-006
- PR #41 / SX-AUD-008
- PR #46 / SX-AUD-010
- PR #49 / SX-AUD-011
- 해당 테스트 수·assertion·merge SHA

이 증거는 새 제품의 선로 건설·유한 배송·무제한 스택·별·랭킹 구현을 증명하지 않는다.
