# Project Base Rules Version

| Field | Value |
|---|---|
| Base repository | `alsdmlals4-eng/Base` |
| Applied line | `v9.4.3` |
| Release state | `BASE_RELEASED` |
| Release commit | `7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8` |
| Release evidence commit | `da33a350d61b8adc52df97fccc7001708a933370` |
| Pin finalization commit | `0b7c94f38d959efc0fc9442274c60b2e268a3c97` |
| Base Skill Registry SHA-256 | `693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59` |
| Project adoption date | `2026-08-02` |
| Freshness review | `SX-AUD-025 · 2026-08-06` |
| Project repository | `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle` |

`skills/SKILL_REGISTRY.json`과 `skills/PROJECT_BASE_ADAPTER.json`이 프로젝트의 선택적 공용 route와 정확한 Base release pin을 소유한다.

Base v9.4.3 release pin은 유지한다. 최신 Base `main`의 정책과 도구가 더 새롭더라도 승인·병합된 새 release lock 없이 이 문서의 적용 버전을 자동 승격하지 않는다.

## 현재 제품 보호 경계

현재 보호해야 할 제품 권위는 다음과 같다.

```yaml
decision_batch: GMB-002
product_decisions: SX-DEC-027~036
demo_decisions: SX-DEC-037~039
product_kind: FINITE_AUTHORED_DELIVERY_PUZZLE
engine: Godot 4.7.1
platforms:
  - Windows
  - Android landscape
```

- 자유 선로 건설·비용·전액 환급
- 구조적 도달 가능성 검사와 sealed run snapshot
- 수동 적재 기본·자동 적재 toggle
- unlimited LIFO stack와 TOP 연속 동일 화물 하역
- persistent branch·crossing runtime control과 점유 잠금
- 제한 시간 실패·마지막 하역 즉시 성공
- 한쪽 reciprocal 연결 최종 종착역
- same-layout fresh-runtime retry
- BUILD·RUN 중 현재 플레이 종료 확인
- Android validation launcher·feature override·package evidence 분리

## 역사 경계

다음 항목은 과거 구현·학습 증거로만 보존하며 현재 제품 보호 권위가 아니다.

- endless survival
- fuel-zero game over
- BOOST
- cargo slowdown
- capacity 8
- pickup respawn
- 15×10 always-connected generator
- switch auto-reset

Base 적용·Adapter 갱신·회귀 테스트가 위 항목을 현재 규칙으로 되살리면 정본 회귀다.

## Base main·addon·HiGodot 경계

- 최신 Base `main`은 비교·학습 대상이며 release pin과 구분한다.
- 검증·승인된 addon이 실제 문제를 해결할 때만 프로젝트별로 선택 채택한다.
- 설치됐지만 실제 소비 경로가 없는 addon은 `INSTALLED_UNUSED`로 판정한다.
- HiGodot 단일 권위는 Godot 저작·편집 mutation 경로의 중복 권위를 금지한다.
- 테스트·CI·플랫폼 서비스처럼 역할이 다른 addon은 실제 소비 경로와 비중복성이 증명될 때만 허용한다.
- PR #94의 미병합 candidate SHA와 실패 Pilot은 Base release 승격 증거가 아니다.

## 보호 경로

- `project.godot`
- `game/**`
- `assets/**`
- `기획서/**`

이 경로의 제품 의미를 바꾸는 변경은 현재 Decision·Evidence·감사와 GitHub/Notion 정본 경계를 확인한 뒤 진행한다. Google Sheet 동기화는 더 이상 current gate가 아니다.

## 데이터·증거 경계

`GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE`

- 기존 Google Sheet는 일반 작업에서 읽기·쓰기·동기화·결정 입력에 사용하지 않는다.
- 과거 Sheet ID/URL/sync 기록은 `docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json` 같은 historical migration evidence에만 보존한다.
- 자동·export PASS는 Android 실기기·Windows 물리 입력·사람 이해 PASS가 아니다.
- Android Device Smoke·Five-person Comprehension·Production Cutover는 각각 별도 Gate다.
