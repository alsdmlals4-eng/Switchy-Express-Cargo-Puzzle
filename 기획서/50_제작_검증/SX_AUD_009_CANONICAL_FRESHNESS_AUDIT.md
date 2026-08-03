# SX-AUD-009 Canonical Freshness Audit

```yaml
audit_id: SX-AUD-009
status: PREMERGE_REVIEW
baseline_main: 6ef78fe779271321dc58198254eba91445f7799d
working_branch: sync/sx-aud-009-canonical-freshness
classification: CANONICAL_FRESHNESS · SAFE_EXECUTION_FIX
planning_conflict: NONE
user_decision_required: NO
product_rule_change: NONE
product_code_change: NONE
sheet_premerge_state: APPROVED_PENDING_MERGE
next_authority: VS03-03_ONLY
```

## 목적

Base v9.4.3 채택과 VS03-02 종료 뒤에도 일부 현행 소비자 문서와 Google Sheets 현재 행에 남아 있던 v9.4.0·VS03-02 상태를 최신 정본과 일치시킨다. 승인된 플레이어 의미, 수치, 패키지 순서, 제품 코드, 자산은 변경하지 않는다.

## 비교 기준

- 최신 사용자 지시: 기획 우선, 상세 수치 GPT 권장 기본값, 기획 충돌 Grill Me, 최대 10건 승인 배치, GitHub·Sheet 동일 ID 동기화.
- Base: v9.4.3 finalization `0b7c94f38d959efc0fc9442274c60b2e268a3c97`.
- 프로젝트 기준 main: `6ef78fe779271321dc58198254eba91445f7799d`.
- 최근 구현: PR #41, merge `cfe6d5ca0c76942720c5c12ad5dc59aaa651b915`.
- 최근 정본 폐쇄: PR #42, merge `6ef78fe779271321dc58198254eba91445f7799d`.
- 현재 package owner: `기획서/50_제작_검증/VS03_PACKAGE_STATUS.md`.
- 현재 구현 권위: `VS03-03_ONLY`.
- 올바른 사용자 GDD Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`.
- wrong Sheet `19FftrZ4WzB-CXa9Q-y25iKMhmEs1Ip4Ea3ramf2xKqM`: 변경 금지.

## 코어 판정

### 핵심 재미

```text
필요한 하역 순서를 역산해 화물을 선택 적재한다
→ LIFO top과 목적 역을 고려해 분기 경로를 선행 준비한다
→ 화물 감속·연료·BOOST 기회비용을 감수한다
→ 큰 동일 화물 하역 그룹으로 점수와 연료를 이어간다
```

### 핵심 시스템

- 선택 LOAD와 capacity 8 LIFO CargoStack
- 자동 운행과 선행 분기 결정
- 색상·모양 역과 연속 그룹 하역
- `Combo == unload_group_size`
- 시간·화물·연료 생존 경제
- BOOST 속도·연료·LOAD 기회비용
- compact token과 rear=LIFO-top 가독성

### 보조 시스템

- onboarding·HUD·camera·difficulty communication
- result learning·same-map restart·map discovery/reselection
- Profile·records·cosmetic-only progression
- target3/target100 catalog·telemetry·playtest·Production UGC

판정: 현재 핵심 재미와 시스템 위계는 유지한다. 새 기능 추가보다 VS03-03→R1→05A 순서로 실제 플레이 가능 코어를 먼저 증명하는 것이 더 강하다.

## 적대적 검토

### F94 — Base 핀 표면 불일치

- 등급: `MUST_FIX`
- 관찰: `skills/PROJECT_BASE_ADAPTER.json`과 채택 테스트는 v9.4.3을 가리키지만 `AGENTS.md`와 `docs/BASE_RULES_VERSION.md`는 v9.4.0을 표시했다.
- 위험: 작업자가 서로 다른 Base 규약을 읽고 planning-first·first-prompt·Grill Me 배치 규칙을 누락할 수 있다.
- 수정: v9.4.3 버전과 payload/evidence/finalization commit을 동일하게 기록한다.

### F95 — 현재 package 권위 불일치

- 등급: `MUST_FIX`
- 관찰: 최신 상태 문서는 VS03-03을 현재 권위로 지정하지만 `CORE_FUN_SYSTEM_HIERARCHY.md`와 `VERTICAL_SLICE_CONTRACT.md`는 VS03-02를 current/ready로 남겼다.
- 위험: Codex가 완료된 VS03-02를 재구현하거나 VS03-03 실행 범위를 잘못 해석할 수 있다.
- 수정: VS03-02를 `MERGED_AND_VERIFIED · SYNCED`, VS03-03을 `READY_FOR_BUILD · CURRENT`로 구분한다.

### F96 — Google Sheets 현재 행 드리프트

- 등급: `MUST_FIX`
- 관찰: 최신 audit 행과 프로젝트 허브는 VS03-03을 가리키지만 일부 현재 작업·Decision·제작 검증 행은 VS03-01/02 이전 상태를 표시한다.
- 위험: 시트만 읽는 사용자가 진행률과 다음 작업을 잘못 판단한다.
- 수정: 역사 행은 보존하고 현재 상태를 소비하는 행만 `SX-AUD-009` 아래 병합 전 상태로 갱신한다.

### F97 — 역사 문서의 과거 상태 문자열

- 등급: `ALLOWED_LEGACY`
- 관찰: 완료 당시의 감사·설계·계획 문서는 당시 current package를 보존한다.
- 판정: 역사 증거와 승인 맥락을 파괴하므로 일괄 치환하지 않는다. 현행 owner 우선순위가 명시된 경우 허용한다.

## 수정 범위

```text
AGENTS.md
docs/BASE_RULES_VERSION.md
기획서/00_프로젝트_허브/ROADMAP.md
기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/50_제작_검증/SX_AUD_009_CANONICAL_FRESHNESS_AUDIT.md
correct Google Sheet current-state rows
```

변경 금지·불변:

```text
project.godot
game/**
assets/**
tests/**
balance values
player-facing rules
SX-DEC-001~026 meaning
target3/target100 boundary
package sequence
wrong 19Ff... Sheet
```

## 벤치마크·현업 비교 판정

- Mini Metro에서 배울 점: 제한 자원과 점증 압박이 실패 후 설계 학습으로 연결된다.
- Conduct THIS!에서 배울 점: 적은 입력과 즉각적인 분기 피드백이 모바일 인과를 선명하게 한다.
- Railbound에서 배울 점: 화차 순서와 경로 결과를 시각적으로 명확히 연결한다.
- Rail Route에서 배울 점: 경로·신호 권위를 presentation과 분리한다.

Switchy는 위 요소를 복제하지 않고 `선택 적재 LIFO + 실시간 분기 + 생존 압력`의 결합을 보호한다. meta·UGC·콘텐츠 수가 이 결합보다 먼저 커지는 방향은 거부한다.

## 검증 Gate

병합 전 필수:

```text
latest main 대비 behind 0
변경 파일 inventory와 제품 파일 0 확인
Project Contract exact-head PASS
Godot Tests exact-head PASS
unresolved review threads 0
REQUEST_CHANGES 0
Sheet APPROVED_PENDING_MERGE readback
attack → validate-critique → regression-recheck → decision-report
```

병합 후 필수:

```text
merged main SHA 재조회
GitHub current consumers 재조회
Sheet same Audit ID 행에 merge SHA 반영
Sheet 12-tab readback
SYNCED_TO_MAIN
```

## 증거 한계

- 이번 변경은 정본 신선도 교정이며 제품 구현·밸런스 검증이 아니다.
- 새 Godot runtime·Android·사람·접근성·성능·온라인 증거를 만들지 않는다.
- `F89`, `F90`, `F92`, `F58`은 그대로 남는다.
- CI가 exact branch head에서 완료되기 전에는 PASS 또는 병합 준비 완료를 주장하지 않는다.
