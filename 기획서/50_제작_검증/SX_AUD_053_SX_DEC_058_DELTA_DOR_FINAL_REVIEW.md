# SX-AUD-053 · SX-DEC-058 Delta DoR Final Review

Status: `PLANNING_REVIEW_COMPLETE · 058_DELTA_DOR_PASS_PLANNING · NO_IMPLEMENTATION_AUTHORITY`

Date: `2026-08-11 KST`

Decision: `SX-DEC-058`

Baseline project main: `0caa36cfe3a3beb0e9e74ea914f4b964d9abb816`

Base observation: `315c66eea9614c284b9c11c4d522141065dfa4b0 · REFERENCE_ONLY`; pin remains `v9.4.3`.

## 1. Review question

Can the approved Daily/Weekly fixed-seed publication-quality direction be closed to implementation-ready planning without inventing a generic optimal solver, exposing solution witnesses, requiring a backend, or importing unimplemented gameplay rules?

## 2. Fresh source inspection

- repository search finds current 058 decision/spec/roadmap planning but no current generator/solver/publisher implementation owner;
- current finite `MapDefinition`, build/preflight, LIFO/delivery, route-control and terminal domain seams are available for later exact witness replay;
- current runtime does not yet represent every approved late rule such as fast/cheap track attributes, so generated V1 profiles must consume only capabilities with authoritative runtime representation when implementation begins;
- SX-DEC-035/036 remain fixed-seed/cosmetic-only authority.

## 3. Findings / resolutions

### F193 · Deterministic random algorithm — CLOSED

Initial generator entropy is fixed to `SHA256_COUNTER_V1` with seed + named stream + counter domain separation. Engine-global RNG, frame time, locale, local clock and unordered dictionary iteration cannot affect generation.

### F194 · Global period identity — CLOSED

- Daily period key = UTC `YYYY-MM-DD`.
- Weekly period key = ISO `YYYY-Www`, Monday 00:00 UTC.
- full identity includes seed, generator version, ruleset, content profile, map SHA and publication revision.
- seed is explicit published data, not necessarily date-derived.

This gives every player one canonical challenge identity independent of local timezone.

### F195 · Solvability algorithm — CLOSED

Use `CONSTRUCTIVE_WITNESS_REPLAY_V1`, not a generic optimizer.

Generator constructs a private legal WitnessPlan with candidate map. Independent verifier replays only legal player-equivalent build/load/route-control/run actions through current finite domain authority. Real current SUCCESS is required.

Witness is existence proof only; no optimality/ranking/hint authority.

### F196 · Witness legality/budget — CLOSED

Private witness cannot mutate stack/train/cargo/station/terminal directly or bypass locked controls/time limit.

Deterministic bounds:

```text
placement/backtrack <=64
structural alternatives 2..32
entered-cell/event steps <=4096
accepted route-control changes <=128
load/input changes <=256
period candidate rejects before give-up <=256
```

Budget exhaustion = `INDETERMINATE/REJECT`, never publish.

### F197 · Nontrivial route/LIFO quality — CLOSED

Hard reject both cadences when:

- cargo types <2;
- witness max stack depth <2;
- structural layout alternatives <2;
- witness not PASS;
- map hash duplicates active accepted pool;
- private witness/runtime isolation fails.

Daily V1: exactly one T/S/E axis=2, others <=1, >=1 decision class.

Weekly V1: >=2 axes >=2, >=2 decision classes.

Decision classes: build route choice, load skip/mode, route-control change, revisit LIFO.

### F198 · Generated corpus thresholds — CLOSED

Per generator/ruleset/content-profile version:

- >=1000 Daily seeds;
- >=1000 Weekly seeds;
- 100% regeneration map-SHA parity;
- >=100 accepted per cadence;
- first 100 accepted: zero duplicate map SHA;
- no one quality signature >20% of first 100 accepted;
- accepted means structural+witness+quality PASS.

Threshold changes require versioned policy/profile update; published identity never silently changes.

### F199 · Publication immutability — CLOSED

State machine:

```text
CANDIDATE → STRUCTURAL_VALID → SOLVABLE_PROVED → QUALITY_SCREENED → PUBLISHED → ARCHIVED
PUBLISHED → WITHDRAWN
```

PUBLISHED bytes cannot mutate. WITHDRAWN affects availability only; no same-identity replacement.

### F200 · Runtime/backend boundary — CLOSED

Runtime consumes published manifest + MapDefinition only. Backend/remote delivery transport is separate authority. Missing official publication data may not cause client-local random seed fabrication.

### F201 · Witness leakage/export boundary — CLOSED

Private WitnessPlan, alternate layouts, corpus/rejection reports, developer optimum and generator debug data are development-only.

Implementation acceptance requires negative proof from exported Windows/Android package contents, not merely source path conventions.

### F202 · Planned-but-missing gameplay rule risk — CLOSED

V1 generator capability profile is derived from authoritative runtime capability at implementation time. Approved-but-not-yet-implemented rules are excluded instead of approximated.

This keeps 058 from becoming an accidental gameplay implementation owner.

## 4. Implementation plan

Owner:

`docs/superpowers/plans/2026-08-11-sx-dec-058-fixed-seed-quality-delta.md`

Ten task groups cover:

1. identity + deterministic stream;
2. candidate generator/private bundle;
3. structural validation;
4. legal witness replay;
5. quality filters;
6. 1000+1000 corpus calibration;
7. publication manifest/state machine;
8. runtime period/archive consumer;
9. witness export isolation;
10. final fairness/domain regression.

## 5. Final result

```yaml
SX_DEC_058_product_direction: USER_APPROVED
identity_contract: READY_PLANNING
prng_contract: READY_PLANNING
constructive_witness_replay: READY_PLANNING
operation_budgets: READY_PLANNING
quality_profiles: READY_PLANNING
corpus_thresholds: READY_PLANNING
publication_state_machine: READY_PLANNING
runtime_witness_isolation: READY_PLANNING
backend_transport: OUT_OF_SCOPE_SEPARATE_AUTHORITY
implementation_authority: NOT_GRANTED
SX_DEC_035_036: UNCHANGED
SX_DEC_055_build_authority: SX-DEC-055_ONLY
physical_device_human: NOT_RUN
```

With SX-AUD-051/052/053, the currently approved benchmark-derived planning R01~R08 is now closed to implementation-ready planning/detail, except explicitly named upstream runtime-capability dependencies. R09/R10 remain post-validation hold.
