# Finite Delivery First Vertical Slice Contract

```yaml
status: VALIDATION_PREP_PASS · MANUAL_GATES_OPEN
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
current_audit: SX-AUD-018
current_main: abc75abd00765ba6ea3aa471c29962f314963be5
implementation_state: FP-01_PASS · FP-02_PASS · TASK_11_PASS · TASK_12_AUTOMATED_PASS · VALIDATION_PREP_PASS
default_entrypoint: LEGACY_RUNTIME_DEFAULT
next_gate: ANDROID_APK_EXPORT → ANDROID_SMOKE → FIVEPERSON_COMPREHENSION
cutover_status: BLOCKED
```

## 1. 계약 목적

이 계약은 첫 번째 유한 배송 퍼즐 Slice의 구현 완료 범위와 제품 전환 조건을 정의한다. 자동 테스트 성공, 검증 준비 성공, 실제 제품 승인을 분리하며 재현 가능한 Android build·실기기 조작성·처음 보는 사용자의 이해 증거 없이 finite Slice를 기본 런타임으로 전환하지 않는다.

권위 문서:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `docs/superpowers/specs/2026-08-04-finite-puzzle-definition-of-ready-design.md`
- `docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md`
- `docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md`
- `docs/superpowers/plans/2026-08-05-finite-validation-harness.md`
- `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`

## 2. First Slice 포함 범위

### FP-01 · 선로 건설

- authored `FiniteMapDefinition` schema v2
- player `TrackLayout` identity와 solution signature
- 직선·곡선·분기·교차 설치
- 설치·회전·교체·철거·전체 초기화
- 조각별 건설비와 철거 전액 환급
- 구조 검사: 시작 연결, 필수 역·화물 도달 가능성, dangling edge, crossing, branch exit, permanent trap
- PASS 후 최종 배치 봉인

### FP-02 · 유한 배송 런

- 기차 자동 운행
- 수동 LOAD 홀드와 자동 적재 토글
- 무제한 LIFO CargoStack
- cargo point 적재 전용, station 하역 전용
- TOP 연속 동일 화물 자동 하역
- 하역 표시 최대 1초
- 정확한 제한 시간 성공·실패 판정
- 이동·하역 중 pause integrity
- 동일 배치 fresh runtime 재시도
- map·solution·attempt identity 분리

### 제품 화면

- BUILD / RUNNING / UNLOADING / PAUSED / SUCCESS / FAILURE 상태
- 현재 건설비와 추천 비용
- preflight 주된 실패 이유와 문제 cell
- 화물의 색상+형상+텍스트 중복 표현
- LIFO TOP 명시
- 최소 48×48dp 상당 조작 영역
- RUNNING/UNLOADING에서 branch 직접 탭
- PAUSED에서 확인 외 조작 금지

## 3. 대표 통합 증명

대표 proof map에서 UI 명령으로 canonical Alpha 배치를 만들고 다음을 증명했다.

```text
load contact order: A → B → A → A
unload groups: 2 → 1 → 1
required behavior: A station revisit under LIFO
terminal result: SUCCESS within finite limit
```

교차 선로의 차선 격리, branch 사전 설정·점유 잠금·재시도 초기화, 실패 후 배치 보존도 자동 검증에 포함된다.

## 4. 제외 범위

첫 Slice 완료 판정에 다음을 포함하지 않는다.

- 가속·저비용·일방통행·회차·터널·교량 선로
- Combo 가속·점수 보상
- 별·랭킹·캠페인·튜토리얼 챕터
- 일일·주간 도전과 online service
- UGC
- 최종 아트 패키지
- 대표 맵 외 광범위 balance 승인

이 기능들은 `SX-DEC-030~036`의 제품 정본에는 존재하지만 후속 FP package에서 구현한다. First Slice 테스트가 해당 기능 구현 완료를 의미하지 않는다.

## 5. Legacy 격리

다음 endless 구현은 `[대체됨 · 역사 증거]`로 보존한다.

- fuel·fuel-zero
- BOOST
- cargo capacity 8
- cargo-count slowdown
- timed pressure와 difficulty authority
- pickup respawn
- branch auto-reset
- endless survival score

legacy 테스트는 회귀 방지에는 사용하지만 finite 제품 증거 수에 합산하지 않는다. finite와 legacy 규칙을 한 player-facing session에서 혼합하지 않는다.

## 6. 검증 Gate

| Gate | 상태 | 기준 |
|---|---|---|
| AUTOMATED CORE | PASS | Contract #490, Godot #451, `60 cases · 10,382 assertions · 0 failures` |
| VALIDATION PREP | PASS | PR #62/#63, Contract #508, Godot #464, `63 cases · 10,714 assertions · 0 failures` |
| APK EXPORT | NOT_RUN | `Android Validation` preset과 launcher는 준비됐으나 실제 export 기록·APK hash 없음 |
| ANDROID | NOT_RUN | 실기기/공식 emulator landscape smoke 전체 항목 미실행 |
| HUMAN | NOT_RUN | 같은 validation APK를 사용한 5명 검증 미실행 |
| BALANCE | NOT_RUN | First Slice production cutover 필수 Gate 아님 |
| ONLINE | NOT_RUN | First Slice 범위 밖 |
| FINAL ART | NOT_RUN | 후속 제작 Gate |

세부 실행·기록 형식은 `FP_01_02_IMPLEMENTATION_AUDIT.md`와 `SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`를 따른다.

## 7. Validation 준비 완료 계약

검증 준비 package는 다음을 제공한다.

1. `Android Validation` debug export preset
2. `validation_harness` custom feature에만 연결되는 launcher main-scene override
3. 실제 finite proof Slice를 그대로 mount하는 `PROOF` mode
4. Presenter/View 기반 `STACK_8`, `STACK_16`, `STACK_32`
5. 정확한 token 수, 하나의 final/rear TOP, 색상+형상+텍스트 검사
6. invalid mode·unknown argument fail-closed 검사
7. production base main과 `game/main/main.tscn` 불변 검사
8. password·keystore·SDK·사용자 경로 부재 검사

validation harness는 제품 콘텐츠, 캠페인 맵, 저장 데이터, 제품 기본 진입점으로 취급하지 않는다. package identifier는 validation 전용으로 격리한다.

## 8. Cutover 조건

다음 조건이 모두 충족돼야 별도 production-cutover PR을 생성할 수 있다.

1. AUTOMATED CORE PASS
2. VALIDATION PREP PASS
3. APK export 성공과 SHA-256 기록
4. ANDROID PASS
5. HUMAN PASS
6. Critical/Important 결함 0
7. unresolved review thread 0
8. REQUEST_CHANGES 0
9. validation build SHA·APK hash·기기·사람 증거 기록
10. GitHub 권위 문서와 correct Google Sheet same-ID 동기화

production cutover는 `game/main/main.tscn`과 필요한 최소 어댑터만 변경한다. legacy 파일 삭제는 별도 migration package다.

## 9. Android 검증 진입점 원칙

제품 base main은 계속 legacy runtime을 사용한다.

```ini
run/main_scene="res://game/main/main.tscn"
run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"
```

- `Android Validation` preset만 `validation_harness` feature를 활성화한다.
- export source는 main `abc75abd00765ba6ea3aa471c29962f314963be5`로 고정한다.
- Godot·export-template·Android SDK 버전, 명령, APK SHA-256을 기록한다.
- `PROOF`와 `STACK_8/16/32` mode를 같은 APK에서 실행한다.
- 수동 Gate 통과 후 production-cutover PR에서 전환을 다시 검토한다.

## 10. Rollback

- PR #55~#60과 #62~#63은 package별로 추적 가능하다.
- production cutover 전에는 legacy 기본 진입점이 유지되므로 validation 준비 병합만으로 사용자 제품이 바뀌지 않는다.
- validation feature override 또는 preset 문제가 있으면 PR #63 merge를 되돌려도 core implementation은 보존된다.
- cutover 후 문제가 발생하면 진입점 커밋만 되돌리고 finite 구현·테스트는 진단 가능한 상태로 보존한다.
- old endless 파일을 삭제하지 않는다.

## 11. 현재 결론

```text
FINITE CORE IMPLEMENTATION: PASS
FINITE PRODUCT SURFACE: PASS
INTEGRATED AUTOMATION: PASS
VALIDATION PREPARATION: PASS
ANDROID APK EXPORT: NOT_RUN
ANDROID: NOT_RUN
HUMAN: NOT_RUN
DEFAULT CUTOVER: BLOCKED
```

다음 권위 작업은 `Android Validation` preset으로 APK를 재현 가능하게 export하고 Android smoke와 5명 comprehension 검증을 실제 수행하는 것이다.
