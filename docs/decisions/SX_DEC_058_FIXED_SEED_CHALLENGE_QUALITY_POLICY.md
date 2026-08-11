# SX-DEC-058 · Fixed-Seed Challenge Quality Policy

Status: `USER_APPROVED · PLANNING_CANON · IMPLEMENTATION_NOT_AUTHORIZED_UNTIL_DELTA_DOR`

Approved: `2026-08-11 KST`

Source benchmark: `SX-BMK-001 · BMK-R08`

Product baseline: `GMB-002`

Existing challenge authority: `SX-DEC-035/036`

## Decision

기존 `Daily 1개 / Weekly 1개 · fixed-seed procedural · same-period same map/ruleset · unlimited retry · archive practice` 계약을 유지하면서, 공개되는 seed가 수리 가능하고 읽기 쉬운 문제인지 확인하는 publication-quality gate를 추가하는 방향을 승인한다.

이 Decision은 procedural을 authored map으로 바꾸지 않으며, launch 시 challenge-exclusive gameplay modifier나 power를 추가하지 않는다.

## 1. Existing contract preserved

다음은 그대로 유지한다.

- Campaign은 handcrafted authored map.
- Daily는 기간당 1개 fixed-seed procedural map.
- Weekly는 기간당 1개 fixed-seed procedural map.
- 같은 기간 모든 플레이어가 같은 seed와 ruleset을 사용한다.
- unlimited retry를 허용한다.
- 기간 종료 후 archive practice를 허용한다.
- 보상은 cosmetic-only 원칙을 유지한다.

## 2. Publication gate

Daily/Weekly 후보 seed는 공개 전에 다음 검증을 통과해야 한다.

### 2.1 Structural validity

- 시작 상태가 유효하다.
- 필수 cargo/station이 MapDefinition 규칙을 만족한다.
- preflight 관점에서 필수 지점이 구조적으로 고립되지 않는다.
- 필수 구간 진입 후 영구 trap이 되도록 생성되지 않는다.
- seed와 ruleset identity가 동일 입력에서 결정론적으로 재생산된다.

### 2.2 Solvability

공개 seed는 최소 1개의 합법적 성공 해가 존재한다는 자동 증거가 있어야 한다.

- 검증은 runtime player hint가 아니라 content-publication pipeline의 offline authority다.
- solver/witness route는 사용자에게 노출하지 않는다.
- solver/witness는 leaderboard나 PB 비교 기준으로 사용하지 않는다.
- 성공 해가 증명되지 않은 seed는 공개하지 않는다.

정확한 solver 구현 방식과 성능 예산은 별도 delta DoR에서 결정한다. 제품 규칙은 `solvability proof required before publication`으로 고정한다.

### 2.3 Quality screening

구조적으로 풀 수 있다는 사실만으로 좋은 challenge라고 간주하지 않는다.

초기 quality screening은 다음 3축 메타데이터를 사용한다.

- Topology Complexity
- Stack Entropy
- Execution Branching

Daily는 짧은 재도전을 지원하는 범위를 우선하고, Weekly는 더 높은 조합 난이도를 허용한다. 정확한 수치 threshold는 실제 generated-set calibration과 사람 검증 전까지 `TEST_VALUE`로 유지한다.

## 3. Launch rule

초기 launch의 Daily/Weekly는 base rules만 사용한다.

금지:

- challenge-exclusive gameplay power
- challenge에서만 쓰는 cargo rule
- challenge에서만 쓰는 switch behavior
- challenge에서만 쓰는 capacity/fuel/BOOST 계열 규칙
- main rules와 다른 hidden scoring authority

향후 modifier를 도입하려면 별도 user approval + Decision이 필요하다.

## 4. Identity and fairness

- challenge identity는 `period + seed + ruleset version + map/content version`으로 재현 가능해야 한다.
- 기간 중 ruleset/content가 바뀌면 같은 challenge identity로 덮어쓰지 않는다.
- archive practice는 원래 challenge identity를 보존한다.
- cosmetic reward가 있더라도 gameplay power를 부여하지 않는다.

## 5. Validation contract

구현 승인 전 delta DoR에서 최소 다음을 닫아야 한다.

1. deterministic seed reproduction.
2. structural validity/preflight validation.
3. offline solvability proof가 최소 한 해를 찾지 못하면 publication reject.
4. solver/witness가 runtime/UI/result/leaderboard에 노출되지 않는 경계.
5. same-period same seed/ruleset identity 보존.
6. archive practice에서 원 challenge identity 재현.
7. Daily/Weekly quality screening의 TEST_VALUE calibration 계획.

## 6. Authority boundary

- `SX-DEC-035/036`의 fixed-seed/cosmetic-only 권위는 유지된다.
- `SX-DEC-058`은 publication-quality gate를 추가하는 refinement Decision이다.
- `SX-DEC-055`의 현재 Phase B BUILD authority는 이 Decision으로 확대되지 않는다.
- 실제 generator/solver/challenge pipeline 구현 전 별도 delta DoR / final planning review가 필요하다.
