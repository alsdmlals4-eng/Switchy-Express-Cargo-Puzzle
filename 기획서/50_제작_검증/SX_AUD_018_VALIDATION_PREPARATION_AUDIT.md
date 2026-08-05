# SX-AUD-018 · Finite Validation Preparation Audit

```yaml
audit_id: SX-AUD-018
evidence_id: EV-FP-VAL-001
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
approval: user approved recommended validation approach A on 2026-08-05
design_pr: PR #62 · 94bdc5e97d21d261db22559ada51ad43594ebf74
implementation_pr: PR #63 · abc75abd00765ba6ea3aa471c29962f314963be5
implementation_head: 90ae877ad0dc05238f908e46b546ece07b869d91
status: VALIDATION_PREP_PASS
android: NOT_RUN
human: NOT_RUN
production_cutover: BLOCKED
default_entrypoint: LEGACY_RUNTIME_DEFAULT
```

## 1. 감사 질문

Task 12 자동 구현 이후 차단됐던 Android·5명 검증 준비 조건을 제품 규칙과 기본 진입점을 바꾸지 않고 재현 가능하게 제공했는가?

판정: **PASS**. 검증 준비 package는 독립 launcher, 실제 proof Slice 모드, Presenter/View 기반 8·16·32 stack 모드, Android validation custom feature·export preset, 기본 진입점·scene 불변 검사를 제공한다.

이 판정은 Android APK 생성, 기기 조작성, 사람 이해도, 제품 전환을 승인하지 않는다.

## 2. 구현 범위

### Validation launcher

- `res://tools/validation/finite/finite_validation_launcher.tscn`
- `PROOF`: 실제 `res://game/finite/main/finite_slice.tscn`을 그대로 mount
- `STACK_8`, `STACK_16`, `STACK_32`: 실제 `finite_slice_view.tscn`에 presenter model 적용
- 미지정 argument는 `PROOF`
- 명시적 잘못된 mode·argument는 `INVALID_MODE`로 fail closed
- mode 전환 시 이전 child 제거 후 새 child mount

### Stack 가독성 fixture

- 정확한 8·16·32 token
- 각 token에 cargo type·색상·형상·텍스트·index 포함
- 정확히 하나의 TOP
- final/rear token만 TOP
- map, CargoStack, delivery loop, run session, save state 미사용

### Android validation export 경계

`project.godot`의 production 기본값은 유지한다.

```ini
run/main_scene="res://game/main/main.tscn"
run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"
```

`Android Validation` preset만 `validation_harness` custom feature를 활성화한다.

```text
package id: com.alsdmlals4.switchyexpress.validation
export path: builds/switchy-express-validation.apk
```

password, keystore path, SDK path, 사용자 홈 경로는 커밋하지 않았다.

## 3. TDD 증거

| 단계 | Project Contract | Godot Tests | 판정 |
|---|---:|---:|---|
| Initial RED | #501 PASS | #457 FAIL | 기존 60 cases PASS, 신규 3 cases만 launcher·override·preset 부재로 실패 |
| Launcher partial GREEN | #504 PASS | #460 FAIL | launcher와 8/16/32 stack PASS, preset contract만 RED |
| First full GREEN | #506 PASS | #462 PASS | 63 cases · 10,712 assertions · 0 failures |
| Adversarial RED | #507 PASS | #463 FAIL | unknown command-line mode가 PROOF로 조용히 fallback |
| Final GREEN | #508 PASS | #464 PASS | 63 cases · 10,714 assertions · 0 failures |

## 4. 적대적 검토

### 수정한 중요 결함

| Finding | 위험 | 재현 | 수정 |
|---|---|---|---|
| F133 · unknown validation argument fallback | 잘못된 검증 모드가 proof로 실행되어 증거 오염 | Godot #463: expected INVALID, actual PROOF | 인자 없음과 명시적 unknown을 분리하고 unknown은 fail closed |

### 무결성 대조

- PR #63 changed files: 11
- `game/main/main.tscn`: 변경 없음
- base `run/main_scene`: legacy main 유지
- validation launcher의 save·run-session·delivery-domain 참조: 0
- validation package ID와 product package identity: 분리
- secret·password·machine path: 0
- unresolved review threads: 0
- REQUEST_CHANGES: 0
- Critical/Important remaining: 0

## 5. Gate 판정

| Gate | 상태 | 근거 |
|---|---|---|
| AUTOMATED CORE | PASS | PR #60 · 3a4aeaa6 · Contract #490 · Godot #451 · 60/10,382 |
| VALIDATION PREP | PASS | PR #62/#63 · abc75abd · Contract #508 · Godot #464 · 63/10,714 |
| APK EXPORT | NOT_RUN | preset·launcher 준비만 완료; export template·SDK 실행 증거 없음 |
| ANDROID | NOT_RUN | 실기기 또는 공식 emulator smoke 기록 없음 |
| HUMAN | NOT_RUN | 동일 build를 사용한 5명 검증 기록 없음 |
| BALANCE | NOT_RUN | First Slice 대표 proof 외 범위 |
| ONLINE | NOT_RUN | 현재 package 범위 밖 |
| PRODUCTION CUTOVER | BLOCKED | Android와 HUMAN 필수 Gate 미통과 |

## 6. 다음 실행 계약

1. `abc75abd00765ba6ea3aa471c29962f314963be5`에서 Android validation build를 생성한다.
2. export command, Godot/export-template 버전, APK SHA-256을 기록한다.
3. `PROOF` mode로 AND-01~10·14~20을 수행한다.
4. `STACK_8/16/32` mode로 AND-11~13을 수행한다.
5. 같은 build SHA와 APK를 사용해 P01~P05 comprehension 검증을 수행한다.
6. 실패가 있으면 원인·수정 SHA·재검증을 기록한다.
7. Android와 HUMAN이 모두 PASS한 뒤에만 production-cutover PR을 별도 승인한다.

## 7. 현재 결론

```text
FINITE AUTOMATED CORE: PASS
VALIDATION PREPARATION: PASS
ANDROID APK EXPORT: NOT_RUN
ANDROID DEVICE/EMULATOR: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY_RUNTIME_DEFAULT
PRODUCTION CUTOVER: BLOCKED
```

validation 준비 성공을 제품 승인으로 확대 해석하지 않는다.
