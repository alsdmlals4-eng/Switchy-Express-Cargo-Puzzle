# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 연결된 철도망을 달리는 화물열차에서 필요한 화물을 선택 적재하고, 분기기를 전환해 알맞은 스테이션을 방문하며, 마지막에 실은 화물부터 연속 하역해 연료와 점수를 이어가는 모바일 가로형 무한 생존 퍼즐입니다.

## 현재 상태

- 프로젝트 단계: `VERTICAL_SLICE_IN_PROGRESS`
- 프로젝트 코어: `CORE_CONFIRMED`
- VS-01 철도 기반: `IMPLEMENTED · PASSED`
- VS-02 기차·화차·화물·역·LIFO: `IMPLEMENTED · PASSED`
- VS-02 런타임 화물 재생성 복구: `IMPLEMENTED · PASSED`
- Base 운영 계약: `v9.4.0`
- 최근 제품 구현: PR #13 / `4e435a1a6d10ab146197671049da80709fd18c1f`
- 최근 운영 계약 적용: PR #15 / `539d2bae18d20e303649f047b9df69e8e224b2e7`
- 자동 검증: Project Contract PASS, Godot headless `9 cases / 6915 assertions / 0 failures`
- 현재 제품 게이트: `G3_CORE_RUNTIME_PROVEN · PARTIAL`
- 현재 작업: `TOTAL_PLANNING · POST_VS02_CANONICAL_RECOVERY`
- 다음 구현 후보: Issue #6 / VS-03 생존 경제·HUD
- Codex 상태: `CODEX_NOT_READY` — 총기획 감사와 필요한 Grill Me Decision을 먼저 닫음
- 목표 플랫폼: Android / Google Play, 가로형
- POC: HTML 규칙 검증 참고 자료이며 제품 코드·런타임 증거가 아님
- 사용자 GDD: 저장소 Adapter에 고정된 Switchy Express Google Sheets

## 최초 읽기 순서

```text
AGENTS.md
→ 기획서/00_프로젝트_허브/START_HERE.md
→ 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
→ 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
→ 기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md
→ 기획서/10_경험/CORE_GAMEPLAY.md
→ 기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
→ 기획서/40_표현/VISUAL_DIRECTION.md
→ 기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ docs/superpowers/plans/2026-08-01-switchy-express-vertical-slice.md
→ 기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md
```

## 운영 원칙

- GitHub Markdown·JSON이 상세 책임 원본입니다.
- Google Sheets는 사용자용 GDD 작업면이며 GitHub 정본을 대체하지 않습니다.
- ChatGPT는 총기획·구조·데이터 설계·Issue·Codex Goal·적대적 검토를 담당합니다.
- Codex는 총기획·검수 Gate가 닫힌 뒤 승인된 Godot 구현 계약만 수행합니다.
- 상세 데이터 수치는 `RECOMMENDED_DEFAULT` 또는 `TEST_VALUE`로 시작하고 테스트로 조정합니다.
- 프로젝트 코어·대표 경험·주요 UX·콘텐츠 의미가 갈리는 결정만 Grill Me로 사용자에게 질문합니다.
- 구현·검증·발행·사람 검수 상태를 서로 혼동하지 않습니다.
- 승인 Decision과 주요 구현 상태는 같은 Decision ID로 GitHub 정본과 연결된 Google Sheets에 동기화합니다.
