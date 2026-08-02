# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 연결된 철도망을 달리는 화물열차에서 필요한 화물을 선택 적재하고, 분기기를 전환해 알맞은 스테이션을 방문하며, 마지막에 실은 화물부터 연속 하역해 연료와 점수를 이어가는 모바일 가로형 무한 생존 퍼즐입니다.

## 현재 상태

- 단계: `VERTICAL_SLICE_IN_PROGRESS`
- VS-01 철도 기반: `IMPLEMENTED · PASSED`
- VS-02 기차·화물·역·LIFO: `IMPLEMENTED · PASSED`
- 제품 baseline: `4e435a1a6d10ab146197671049da80709fd18c1f`
- 자동 검증 기반: Godot headless `9 cases / 6915 assertions / 0 failures`
- GMB-001: `CLOSED · SX-DEC-017~026`
- Decision merge: PR #29 · `9b63421a5ab4d57adbfcf69d2b6e1bf8e3d17496`
- Definition of Ready: `SX-AUD-005 · PASS · SYNCED`
- DoR merge: PR #35 · `82fd3eeb1915e6ceedb2f5330b27e903064d6eb5`
- DoR evidence: `EV-USER-016`
- Codex: `READY_FOR_BUILD · VS03-01_ONLY`
- 최초 구현 package: `VS03-01 · run lifecycle/economy/difficulty`
- 제품 구현: `NOT_STARTED`
- 목표 플랫폼: Android / Google Play, 가로형

## 최초 읽기 순서

```text
AGENTS.md
→ 기획서/00_프로젝트_허브/START_HERE.md
→ 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
→ 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
→ 기획서/50_제작_검증/VS03_DEFINITION_OF_READY_AUDIT.md
→ docs/superpowers/specs/2026-08-02-vs03-execution-architecture-design.md
→ docs/superpowers/plans/2026-08-02-vs03-build-segmentation.md
→ docs/superpowers/plans/2026-08-02-switchy-express-current-vertical-slice.md
→ 기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ 기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

## 실행 구조

```text
VS03-01 authoritative run lifecycle/economy/difficulty
→ VS03-02 compact footprint and DeliveryLoop occupancy seam
→ VS03-03 target3 maps/session/restart/selection
→ VS03-04 Profile transactions/records/cosmetics/unlocks/rewards
→ VS03-05 product scene/camera/HUD/result/browsers
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

공통 hotspot package는 병렬로 진행하지 않으며, 각 package는 이전 package merge 뒤에 시작합니다. 현재 실행 권위는 `VS03-01` 하나뿐입니다.

## DoR 핵심 보정

- 현재 custom runner의 `func run()` 계약만 사용
- compact footprint를 optional occupancy provider로 기존 DeliveryLoop에 연결
- Main은 호스트, PlayScene은 composition root, RunController는 lifecycle authority
- MapDefinition에 explicit start/incoming/reconstruction inputs 저장
- RunSessionFactory는 fully configured session만 성공 반환
- movement/event/fuel-zero boundary order 고정
- ProfileStore + ProfileTransactionService 단일 writer
- VS-03은 3개 공식 맵만; target100과 `F58` closure는 Production

## 운영 원칙

- GitHub Markdown·JSON이 상세 책임 원본입니다.
- Google Sheets는 사용자용 GDD 작업면이며 GitHub 정본을 대체하지 않습니다.
- ChatGPT는 기획·구조·데이터 설계·Issue·Codex Goal·적대적 검토를 담당합니다.
- Codex는 승인된 package만 구현합니다.
- `READY_FOR_BUILD`는 구현 완료가 아니며, 별도 Codex 작업이 시작되기 전 제품 구현은 `NOT_STARTED`입니다.
- 실행하지 않은 runtime·Android·사람·온라인 테스트를 PASS로 보고하지 않습니다.
- 중요 player-facing choice가 새로 발생할 때만 Decision/Grill Me를 추가합니다.
- wrong `19Ff...` Sheet는 수정하지 않습니다.
