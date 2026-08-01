# Switchy Express: Cargo Puzzle

**Switchy Express: Cargo Puzzle**는 연결된 철도망을 달리는 화물열차에서 필요한 화물을 선택 적재하고, 분기기를 전환해 알맞은 스테이션을 방문하며, 마지막에 실은 화물부터 연속 하역해 연료와 점수를 이어가는 모바일 가로형 무한 생존 퍼즐입니다.

## 현재 상태

- 프로젝트 단계: `VERTICAL_SLICE_IN_PROGRESS`
- 프로젝트 코어: `CORE_CONFIRMED`
- Godot 기반·RailGraph·다단계 분기: `IMPLEMENTED · PASSED`
- 기차·화물·역·LIFO·생존 경제: `NOT_STARTED`
- 최근 구현: PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2`
- 자동 검증: Project Contract PASS, Godot headless 934 assertions PASS
- 현재 제품 게이트: `G3_CORE_RUNTIME_PROVEN · PARTIAL`
- 다음 실행: Issue #5 / `CODEX_GOAL_VS_02.md`
- POC: HTML 규칙 검증 완료, 제품 코드·런타임 증거 아님
- 엔진 기준: Godot `4.7.1-stable`
- 목표 플랫폼: Android / Google Play
- 화면: 가로형
- 상세 상태: `기획서/00_프로젝트_허브/START_HERE.md`

## 최초 읽기 순서

```text
AGENTS.md
→ 기획서/00_프로젝트_허브/START_HERE.md
→ 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
→ 기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md
→ 기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md
→ 기획서/10_경험/CORE_GAMEPLAY.md
→ 기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
→ 기획서/40_표현/VISUAL_DIRECTION.md
→ 기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
→ 기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_02.md
```

## 운영 원칙

- GitHub Markdown·JSON이 상세 책임 원본입니다.
- Google Sheets는 사용자용 GDD 작업면입니다.
- ChatGPT는 기획·구조·데이터·이슈·Codex Goal·검수 역할을 담당합니다.
- Codex는 승인된 계획에 따른 실제 Godot 코드와 파일 변경을 담당합니다.
- 구현·검증·발행 상태를 서로 혼동하지 않습니다.
- 승인 결정과 주요 구현 상태는 같은 Decision ID로 GitHub 정본과 Google Sheets에 동기화합니다.
