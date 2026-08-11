# SX-DEC-058 Fixed-Seed Challenge Quality Design

Status: `USER_APPROVED_DESIGN · IMPLEMENTATION_DEFERRED`

Decision owner: `docs/decisions/SX_DEC_058_FIXED_SEED_CHALLENGE_QUALITY_POLICY.md`

## Goal

기존 Daily/Weekly fixed-seed procedural 계약을 보존하면서, 공개 seed가 재현 가능하고 구조적으로 유효하며 최소 한 개의 합법적 성공 해를 가진다는 publication-quality proof를 요구한다.

## Challenge identity

```text
ChallengeIdentity
- cadence: DAILY | WEEKLY
- period_key
- seed
- ruleset_version
- map_content_version
```

동일 identity는 동일 MapDefinition과 동일 base ruleset을 재현해야 한다.

## Publication pipeline

```text
seed candidate
→ deterministic generation
→ structural validation
→ solvability proof
→ quality screening
→ publication identity freeze
→ Daily/Weekly exposure
→ archive with same identity
```

실패한 단계가 하나라도 있으면 해당 seed는 공개하지 않는다.

## Structural validation

필수 검사:

- valid start
- required cargo/station schema validity
- required locations structurally reachable under existing preflight semantics
- no generator-created permanent trap on required route space
- deterministic regeneration from seed + version identity

이 검사는 player runtime의 성공을 보장하는 solver가 아니라 publication candidate의 구조 오류를 제거한다.

## Solvability authority

최소 한 개의 legal success witness가 있어야 한다.

설계 경계:

- proof runs offline/content pipeline에서 수행한다.
- witness route/load/switch sequence는 runtime player hint로 노출하지 않는다.
- witness는 leaderboard/PB 기준이 아니다.
- witness는 `existence proof` 역할만 한다.
- proof 실패 seed는 reject.

구현 방식은 delta DoR에서 선택하되 제품 계약은 `proof required`로 고정한다.

## Quality metadata

생성된 문제는 다음 메타데이터를 산출한다.

```text
ChallengeQuality
- topology_complexity
- stack_entropy
- execution_branching
- estimated_solution_depth
- obvious_triviality_flags[]
- readability_flags[]
```

초기 threshold는 `TEST_VALUE`이며 generated corpus와 사람 검증으로 calibration한다.

Daily 방향:

- 짧은 반복 시도
- 읽기 쉬운 primary challenge axis
- base rules only

Weekly 방향:

- 더 높은 결합 난이도 허용
- 2~3 difficulty axes 조합 가능
- base rules only

## Publication state machine

```text
CANDIDATE
→ STRUCTURAL_VALID
→ SOLVABLE_PROVED
→ QUALITY_SCREENED
→ PUBLISHED
→ ARCHIVED
```

각 상태 이동은 challenge identity를 보존한다. `PUBLISHED` 이후 같은 identity의 seed/ruleset/map version을 mutate하지 않는다.

## Runtime boundary

런타임이 알아야 하는 것은 published identity와 generated MapDefinition뿐이다.

런타임에 넘기지 않는 것:

- solver witness
- internal quality rejection notes
- alternate candidate seeds
- developer optimum

## Reward/fairness boundary

- unlimited retry 유지
- cosmetic-only reward 원칙 유지
- challenge-exclusive power 없음
- challenge-exclusive hidden scoring rule 없음
- future modifier는 별도 Decision 없이는 추가하지 않음

## Validation

1. Same ChallengeIdentity regenerates byte/semantic-equivalent map data.
2. structural invalid candidate never reaches PUBLISHED.
3. no-solvability-proof candidate never reaches PUBLISHED.
4. PUBLISHED identity is immutable.
5. archive reproduces original identity/map/ruleset.
6. solver witness is absent from runtime player-facing data.
7. Daily/Weekly cadence each exposes only the selected published candidate for that period.

## Scope boundary

이 spec은 generator/solver implementation plan이 아니다. 실제 implementation 전에 algorithm choice, performance budget, corpus size, validation command를 delta DoR에서 고정한다.
