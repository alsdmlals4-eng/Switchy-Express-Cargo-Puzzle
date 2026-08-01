# Post-VS01 Adversarial Audit

Audit ID: `SX-AUD-002`
Date: `2026-08-01`
Reviewed implementation: PR `#9`, commit `801632949d28564528e38d83dac59cccc6f06fb2`
Related Decisions: `SX-DEC-004`, `SX-DEC-005`, `SX-DEC-012`, `SX-DEC-013`

## Work Mode·Skill

- `REVIEW`: Base·프로젝트·Google Sheets 책임 원본과 실제 구현의 누락·충돌·stale 상태 공격
- `BUILD`: 승인된 기술 기본값과 정본·상태 동기화 수정
- `REVIEW`: Project Contract·Godot 테스트·Sheet 재조회로 회귀 확인
- 주 책임 Skill: `managing-game-project-operating-system: audit → verify`
- 보조 Skill: `running-adversarial-review-and-refinement`, `reviewing-and-validating-project-changes`, `managing-design-documents`, `maintaining-project-context-and-handoff`

## 검토 범위

```text
Base v9.3 책임 원본·Skill Registry
→ 프로젝트 AGENTS·START_HERE·Active Context·Decision 원장
→ Roadmap·Development Gates·Vertical Slice Plan·Issue #4/#5
→ PR #9 diff·Godot 코드·테스트·Actions
→ Google Sheets 12개 GDD tab
→ 변경됐어야 하지만 untouched인 정본·상태·Sheet 행
```

## 검증된 구현 사실

- Godot `4.7.1-stable` 프로젝트와 1920×1080 가로형 main scene 존재
- 15×10 결정론적 RailGraph 생성
- seeds 1~100 전체 연결·막다른길 0·cycle rank 3 이상
- 2단계 분기기 4개 이상·3단계 분기기 2개 이상
- 분기 경로 최소 3칸 차이와 5칸 preview/실제 next-cell 일치
- 32회 후보 실패 뒤 결정론적 safe fallback
- 즉시 180도 반전 금지·통과 뒤 기본 상태 복귀
- 가능한 경우 직진을 기본 A노선으로 우선
- Project Contract 통과
- Godot headless `3 cases / 934 assertions / 0 failures`

## Findings

| ID | 심각도 | 판정 | 증거 | 처리 |
|---|---|---|---|---|
| SX-FIND-001 | P0 | `MISSING_DECISION_SYNC` | GitHub·Sheet가 Issue #4 대기·Godot 미시작을 계속 주장 | 본 감사 PR과 후속 Sheet 동기화에서 즉시 수정 |
| SX-FIND-002 | P0 | CI false-green 위험 | Godot이 `SCRIPT ERROR`를 출력해도 종료 코드 0이 될 수 있었음 | PR #9에서 로그 패턴을 실패로 처리하도록 수정 |
| SX-FIND-003 | P1 | Godot API 충돌 | `Object.is_connected(signal, callable)`와 무인자 프로젝트 API 충돌 | 프로젝트 API를 `is_fully_connected()`로 확정, Plan 갱신 |
| SX-FIND-004 | P1 | 기본 노선 예측성 부족 | 좌표 정렬에 따라 기본 노선이 직진이 아닐 수 있었음 | `SX-DEC-013`: 직진 가능 시 직진 우선으로 확정 |
| SX-FIND-005 | P1 | 생성 다양성 미검증 | 현재 생성기는 유효한 격자망을 만들지만 구조 변형 폭이 제한됨 | VS-02 진행을 막지 않되 VS-03 전 unique-map·route-entropy 검증 추가 |
| SX-FIND-006 | P1 | 제품 플레이 미검증 | 실제 기차·화차·화물·역·LIFO가 없음 | 다음 실행 범위를 Issue #5 / VS-02로 고정 |
| SX-FIND-007 | P1 | 시각 가독성 미검증 | 분기 상태 데이터만 있고 선로·레버·화살표 런타임 화면 없음 | VS-03 HUD·RailBoardView에서 실제 캡처와 터치 검증 |
| SX-FIND-008 | P1 | Android 증거 없음 | headless Linux 테스트만 존재 | G4에서 Android export·실기 60 FPS·10분 soak 수행 |
| SX-FIND-009 | P2 | `RailCell` 미사용 | 현재 RailGraph는 Dictionary adjacency를 사용 | Goal 필수 파일로 보존; 구조 확장 전 사용 또는 제거 판정 |

## SWOT → 행동

| 축 | 관찰 | 행동 |
|---|---|---|
| Strength | LIFO 적재 순서와 분기 판단이 직접 연결됨 | VS-02에서 실제 주행·적재·하역 통합을 가장 먼저 증명 |
| Strength | 결정론적 그래프와 headless 테스트 기반 확보 | 이후 스폰·역 배치·밸런스를 순수 로직으로 검증 |
| Weakness | 맵 구조 다양성과 실제 시각 정보량이 미검증 | unique signature·경로 길이 분포·스위치 밀도 계측 추가 |
| Weakness | 현재 main scene은 최소 부트 구조 | VS-02에서는 제품 화면을 꾸미지 않고 도메인 통합까지만 진행 |
| Opportunity | 3단계 허브로 작은 맵에서도 선택 밀도 확보 | 직진 A노선·회전 B/C노선과 5칸 preview를 UI 계약으로 유지 |
| Opportunity | 동일 seed 경쟁·일일 맵으로 확장 가능 | Vertical Slice 통과 전에는 구현하지 않고 telemetry field만 확장 가능하게 유지 |
| Threat | 화물 감속이 후반 생존 exploit가 될 수 있음 | 연료 drain은 실제 시간 기준 유지, 180초 무조작·중량 시뮬레이션 필수 |
| Threat | 색·분기 정보 과밀로 출퇴근 플레이 피로 증가 | 색+모양·굵기+화살표·48dp와 실제 첫 경험 테스트 적용 |

## 남은 기획·구현 우선순위

### P0 — VS-02

1. 선택된 선로를 따르는 기관차와 최대 8개 화차의 1칸 간격 경로 이력
2. LOAD 중에만 화물 적재, 색상별 최소 4개 유지
3. 일반 선로에 색상별 역 2개, 같은 색 역 거리 5칸 이상
4. `R,R,B,R` 적재 시 `R,B,R,R` 순서의 LIFO 연속 하역
5. 하역 순서 ViewModel과 실제 결과 일치

### P1 — VS-03 이전

1. seeds 1~100의 unique graph signature 수와 주요 경로 길이 분포
2. 분기기·역·화물 아이콘의 한 화면 혼잡도
3. 작은 Android 화면의 safe area와 48dp 터치 영역
4. 승인 콘셉트 이미지의 저장소 영구 자산 import

### 보류

- 마스코트 이름·장문 세계관
- 광고·과금·에너지·가챠
- PvP·길드·실시간 랭킹
- 지역·스킨·메타 성장

## Gate 판정

- `G2_VERTICAL_SLICE_CONTRACT_APPROVED`: `PASS`
- `G3_CORE_RUNTIME_PROVEN`: `PARTIAL`
  - Godot 기반·RailGraph·분기 로직: `PASSED`
  - 기차·화물·LIFO·연료·점수·BOOST: `NOT_STARTED`
- 다음 Goal: GitHub Issue `#5`, `CODEX_GOAL_VS_02.md`
