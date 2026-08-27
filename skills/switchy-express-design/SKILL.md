---
name: switchy-express-design
description: Use for Switchy Express finite-delivery gameplay, track construction, cargo encounter order, cardinal station service, reachable-network preflight, unlimited LIFO, persistent branch, first-session validation, Android device smoke, five-person comprehension, readability, retry, or product validation work.
---

# Switchy Express Design and Validation Discipline

## Purpose

이 Skill은 `Switchy Express: Cargo Puzzle`의 현 finite 제품 기획·검토·검증을 책임진다. 과거 endless 구현, VS03 계획, 오래된 Android-first gate, pre-SX-DEC-060 exact-station delivery를 current 제품 권위로 부활시키지 않고, 현재 승인 결정·실제 finite code·post-change evidence를 연결한다.

## Read First

1. fresh Base latest completed `main` + Base root `AGENTS.md`
2. Base current `skills/SKILL_REGISTRY.json` + generated active map
3. fresh project `main`, latest commit, all Open/Draft PRs
4. exact Project Notion Home
5. project `AGENTS.md`
6. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
7. `기획서/00_프로젝트_허브/START_HERE.md`
8. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
9. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
10. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
11. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
12. current Decision owner; for current product work read `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`
13. actual finite code, Scenes, data and tests

`CURRENT_CONFIRMED_DECISIONS.md` owns current approved decisions, `ACTIVE_CONTEXT.md` owns current state/next action, and `DEVELOPMENT_GATES.md` owns gate dependencies. Historical adapters/plans/audits/candidates are rollback/provenance evidence, not automatic current authority.

## Current Product Authority

```text
build the needed rail network
→ create cargo encounter order
→ manual/automatic exact-cell cargo loading
→ unlimited LIFO
→ route and persistent branch execution
→ pass one cardinal tile beside a station
→ unload matching contiguous TOP group
→ finite-time completion
→ evidence-safe result / retry / edit
```

### Current invariants

- authored finite delivery stage
- free track construction except blocked/off-track service cells
- per-piece construction cost and full refund during BUILD
- preflight validates the start-reachable RUN component
- not every placed rail piece must join one global connected component
- every required cargo must be reachable by the active RUN component
- every required station must have at least one reachable cardinal service cell
- station service iff `abs(dx) + abs(dy) == 1`
- only `UP / RIGHT / DOWN / LEFT` one tile count; diagonal and station footprint do not
- station is an off-track service object in the SX-DEC-060 schema-v3 target
- cargo pickup remains exact-cell contact
- automatic train movement
- manual LOAD hold and auto-load toggle
- unlimited LIFO cargo stack
- last-loaded cargo is TOP
- only a contiguous same-type TOP group unloads at a matching station
- persistent branch state with direct branch tap before occupation
- occupied branch lock
- no track construction or removal during RUN
- finite timer failure while undelivered cargo remains
- immediate success when the final cargo commits delivery
- same-layout retry with fresh mutable runtime and attempt identity
- color plus silhouette plus text encoding
- landscape touch targets and safe-area requirements
- cosmetic-only fairness; no power progression
- UI, motion and presentation never own gameplay, score, save or identity authority

### Current Gate authority

```text
PRE-SX-DEC-060 FINITE AUTOMATED CORE: HISTORICAL PASS
SX-DEC-059 IMPLEMENTATION: MERGED_MAIN_VERIFIED · PRE-SX-DEC-060
SX59-POC-ACCEPT-003 PACKAGE/PCK/73 TEXTURES: HISTORICAL PASS
SX-DEC-060 USER RULE: APPROVED
SX-DEC-060 DESIGN/TDD/CODEX HANDOFF: PREPARED
SX-DEC-060 RUNTIME IMPLEMENTATION: MERGED_MAIN_VERIFIED · PR #188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
SX-DEC-060 FULL AUTOMATED REGRESSION: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
SX-DEC-060 FIVE-PASS REVIEW: CLOSED · SX-AUD-071
POST-060 EXACT CANDIDATE: SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · source main 0e882764b837d13282a7642b115948d4e061d163
SX60-POC-ACCEPT-001: HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
WINDOWS PHYSICAL POST-060: NOT_RUN_CURRENT_EXACT_CANDIDATE_002 · SX60-POC-ACCEPT-001_AUTOMATION_OBSERVATION_HISTORICAL_ONLY
ANDROID DEVICE POST-060: NOT_RUN
FIVE-PERSON POST-060: NOT_RUN
PLAYER EXPERIENCE POST-060: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

Current validation sequence:

```text
SX60-POC-ACCEPT-002 human physical self-run
→ Windows physical smoke + audio perceptual QA
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

Pre-SX-DEC-060 Candidate 003 hashes/integrity remain exact historical evidence and do not transfer to new gameplay bytes.

## SX-DEC-060 station / preflight contract

### Station service

```gdscript
var delta := train_cell - station_cell
var serviceable := absi(delta.x) + absi(delta.y) == 1
```

- `UP`, `RIGHT`, `DOWN`, `LEFT`: serviceable.
- same station cell: not serviceable.
- diagonals: not serviceable.
- distance 2+: not serviceable.
- matching TOP: current contiguous-group unload.
- mismatched TOP: no unload.

### Reachable-network preflight

Preflight is RUN safety/required-coverage validation, not a global topology linter.

```text
start/incoming traversal
→ compute reachable states/cells
→ all required cargo reachable
→ each station has >=1 reachable cardinal service cell
→ reachable switch/crossing/trap semantics valid
```

A fully unreachable rail island with no required cargo/service role does not block RUN. A disconnected component containing required cargo does block RUN. An invalid structure that the train can actually enter remains a blocker.

### Schema / data

- target current map schema after implementation: `FiniteMapDefinition v3`.
- station placements do not require a rail anchor.
- station footprints are non-buildable/off-track.
- cargo retains direct-contact semantics.
- overlapping station service ownership fails closed until another Decision explicitly defines priority.
- active maps/witnesses/solution identities must be explicitly migrated; historical schema-v2 bytes are not silently reinterpreted.

## Consumer-first visual asset contract

Production image work must be justified by an actual game consumer.

Current `ProductBoardRenderer` already consumes approved station assets:

```text
core_station_red_normal_v01.png
core_station_blue_normal_v01.png
core_station_yellow_normal_v01.png
```

For SX-DEC-060:

```text
existing station PNG consumer
→ procedural four-cardinal service indicator
→ deterministic renderer descriptor tests
→ ZERO new bitmap assets
```

Do not produce explanation sheets, full-screen mockups, or decorative images without a real runtime node/key/path consumer. When a future concrete bitmap slot is proven necessary, the user-approved automatic policy applies:

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
visual_continuity: existing E+D Hybrid / Neo-Arcade visual language
```

Generate only the required bitmap, keep the existing E+D Hybrid / Neo-Arcade visual language, save the tracked local asset plus the Notion Visual/Asset record, record provenance/SHA-256, and read the Notion destination back. No per-image approval request is needed.

## First-session authority

Current flow remains:

```text
T1 Track Connection
→ T2 Cargo direct contact + Station cardinal-adjacent delivery
→ T3 LIFO/TOP reverse planning
→ T4 selective manual non-load + revisit
→ T5 Auto ON safe / OFF decision
→ T6 switch execution
→ VS_DEMO_01 capstone
→ Result / Retry / Edit
```

T2 must distinguish:

```text
Cargo: pass through its tile to load.
Station: pass through one of four cardinal adjacent tiles to deliver.
Diagonal: no delivery.
```

Keep locales `ko / en / ja / zh-Hans`; `zh-Hant` remains deferred. No raw key or text-in-PNG.

## Material user decisions

Ask only when a choice changes:

- finite core loop or LIFO meaning
- BUILD/RUN authority
- cargo loading semantics
- station service radius/shape beyond approved exact-cardinal rule
- multi-station overlap priority behavior
- timer success/failure meaning
- major UX/accessibility interaction
- content scope, monetization, online policy or production cutover

Do not ask for facts available in canon, code, tests, package evidence, current records, or the already approved exact-cardinal rule.

## Legacy Implementation Boundary

The following are `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`:

- endless survival
- fuel and fuel-zero ending
- player BOOST input and BOOST uptime
- capacity eight cargo limit
- cargo-count slowdown
- pickup respawn
- switch auto-reset after passage
- timed speed/fuel pressure escalation
- old endless score authority
- old exact-station-contact semantics where a station footprint itself is a rail/delivery anchor
- global-connectedness interpretations superseded by SX-DEC-060

Legacy code/tests/docs may remain for history/migration analysis but do not define post-060 product completion.

## Architecture Boundaries

- `FiniteMapDefinition`: finite map/schema + station service data derivation
- `FiniteMapLoader`: buildable surface projection
- `FiniteTrackGraphBuilder`: sealed routing graph; no v3 station footprint rail piece
- `FiniteBuildSession`: BUILD edits, validation and sealing
- `TrackLayout`: authored/player track value
- `FiniteTrackGraph`: sealed routing graph
- `PreflightValidator`: start-reachable RUN safety + required coverage
- `FiniteGameplayInputState`: manual/auto loading intent
- `UnlimitedCargoStack`: finite LIFO authority
- `FixedCargoField`: non-respawning authored cargo
- `Station`: cargo-type match + service predicate
- `FiniteDeliveryLoop`: contact and unload event integration
- `FiniteRunController`: timer, lifecycle, pause and outcome authority
- `FiniteRunSessionFactory`: fresh attempt object graph and identity
- `FiniteSlicePresenter`: read model only
- `FiniteSliceView`: visual state and input intent only
- `ProductBoardRenderer`: visual projection only
- `FirstSessionDefinition/StagePolicy/Director/Copy`: presentation-side onboarding owners

Presentation must not mutate layout, cargo, delivery, timer, result, retry identity or saves except through approved command boundaries.

## Deferred Package Boundary

```text
SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
```

Current implementation must not smuggle Route Probe/PB/Fingerprint, score/max-combo, Yard Labs/Mastery, or fixed-seed challenge pipeline into the product.

## Actual Test Contract

Use the repository custom runner:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Each suite follows the repository current test harness. Do not invent unsupported single-suite runners or test APIs.

Relevant static contracts include:

```bash
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
```

Also run the current SX-DEC-060 canonical freshness/map/witness/package contracts after they exist. Never report an unexecuted command as PASS.

## Adversarial Review Lenses

- exact-cardinal math accidentally includes diagonals/station cell/distance 2+
- cargo exact-contact semantics accidentally changed
- LIFO meaning inverted/reduced to FIFO or stack capped
- station remains hidden rail anchor under schema v3
- active maps silently keep v2 semantics
- global topology lint still blocks irrelevant disconnected islands
- reachable invalid switch/crossing becomes ignored
- station service overlap silently overwrites one station
- renderer becomes gameplay authority
- new explanatory/non-consumed bitmap slips into production assets
- service overlay hides rail/cargo/train/switch/preflight state
- first-session T2 teaches old exact-station contact
- raw localization key or locale parity drift
- Candidate 003 historical evidence overstated as post-060 acceptance
- 056–058 absorbed
- PR #174 modified
- Base repinned
- package/device/human evidence inflated

Run minimum five full-scope loops for substantive implementation and continue until no unresolved current-scope finding remains.

## PR Gate

Before merging a current-task implementation PR:

1. refresh Base completed main + project main + exact Notion Home + all Open/Draft PRs;
2. verify only approved SX-DEC-060 scope changed;
3. verify PR #174 untouched;
4. verify every new bitmap has a concrete runtime consumer and is preserved in both the tracked project-local path and Notion;
5. observe RED→GREEN evidence for production behavior;
6. run full exact-head Godot/static/package checks;
7. run minimum five adversarial loops and fix findings;
8. verify current GitHub canon + Notion same Decision ID agree;
9. preserve evidence ceiling exactly;
10. merge only when required rulesets/checks/review are clean, then re-read merged main + Notion.
