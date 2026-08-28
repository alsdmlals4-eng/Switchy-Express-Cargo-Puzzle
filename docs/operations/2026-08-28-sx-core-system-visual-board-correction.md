# Core-system visual board correction · incident / solution / lesson

**Status:** `RESOLVED_DOCUMENTATION_AND_USER_APPROVED_GITHUB_PRESERVED_PLANNING_REFERENCE · GitHub Issue #246`

## Incident

The existing planning board enumerated Title, T1–T6, and capstone/result, but did not require a viewer to see how the finite puzzle's systems cause one another. It could therefore read as a sequence of attractive scenes rather than: rail construction changes encounter order; load choice changes `TOP`; a cardinal station pass checks that `TOP`; a persistent switch commits the plan; the factual result determines Retry or Edit.

This was a documentation/visual-explanation gap. It was not evidence that the implemented systems were absent.

## Evidence

- `FiniteBuildSession` permits placement/rotation/replacement/removal only in BUILD, uses `PreflightValidator`, then seals a passed layout for RUN.
- `PreflightValidator` checks start-reachable required cargo and at least one cardinal service cell per required station; it does not solve LIFO/load/switch/time/cost decisions.
- `FiniteDeliveryLoop` loads only on exact cargo-cell contact when Manual or Auto is active, and indexes station service cells independently.
- `UnlimitedCargoStack` makes the last collected valid cargo the `TOP`; a matching station removes only its contiguous matching top group.
- `FiniteTrackGraph` exposes selected switch exit and the occupied control lock. The current switch has one approach and exactly two exits; the selection persists until changed.
- `FiniteRunController` records only success, `TIME_EXPIRED`, or `ROUTE_END` outcome facts; the retry factory creates a fresh mutable attempt from the sealed layout.

## Solution

- Added the causal player contract to `PROJECT_CORE_SCENE_VISUAL_BOARD.md`: action and information → choice/trade-off → immediate feedback → failure learning/next action for BUILD/preflight, cargo/LIFO, station, switch, and outcome/recovery.
- Added a six-panel system-first scene brief, including explicit non-implications so the image cannot silently create a station-footprint rail, diagonal service, long-train capacity, auto-reset switch, score/economy, or implementation claim.
- Generated `SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002A`, then rejected it during visual review because the switch panel falsely presented three exits.
- Generated the corrected `002B` candidate: SHA-256 `6577d7ac5e490b1303af0105ef0573cf5b4be10a52cbdd4ccecb24ec116993bc`, 1672×941 PNG. It keeps one incoming rail, two exits, and an occupied-lock overlay separate from the route geometry.
- Corrected stale SX-DEC-063 snapshot lines in `START_HERE.md`, `CURRENT_CONFIRMED_DECISIONS.md`, and `ACTIVE_CONTEXT.md`: terrain v02 is already `APPROVED_GITHUB_PRESERVED` via PR #244 and remains runtime-unconnected.
- The first PR #247 validation run found a top-level canonical-freshness test still requiring the stale SX-DEC-063 `FIRST_CANDIDATE_GENERATED_REVIEW_PENDING` line. The test now rejects that old line and requires the documented terrain-v02 GitHub-preserved state.
- The protected-change approval record now explicitly cites the user’s 2026-08-29 SX-VIS-061 correction request and includes `START_HERE.md`, which the exact protected-base delta already contained. The required `approved-protected-change` PR label is a normal policy gate, not a bypass.

## Verification boundary

- Machine structural verification: PNG decode, 1672×941 dimensions, and SHA-256 match were confirmed for `002B`; `002A` and `002B` SHA values are recorded separately.
- Semantic visual review: the final panel set was inspected against the structured contract. This review can catch an impossible switch picture, but it is **not** a Godot render test, actual UI composite, accessibility test, physical device test, human-comprehension result, or player-experience PASS.
- On 2026-08-29 KST the user approved the reviewed `002B` board. Its exact source was reread (SHA-256/dimensions match) and it is preserved as `docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png`. It remains a planning reference with no runtime consumer and is not runtime, UI, Human, Player Experience, or release proof.
- The isolated worktree initially lacked its ignored Godot import cache. The source asset bytes were intact; after a headless editor import rebuilt that cache, the unchanged full GUT runner passed. This was environment bootstrap evidence, not a repository or product change.

## Five-pass adversarial recheck

| Loop | Full-scope attack | Result after correction |
|---|---|---|
| 1 · causal completeness | Could a viewer name screens but not player action, choice, feedback, or next learning? | PASS — each core system now has the full causal contract and capstone chain. |
| 2 · rule fidelity | Could the visual merge cargo contact with station service, change LIFO, or turn preflight into a solver? | PASS — exact-cell cargo, cardinal-only station service, `TOP`, and preflight limits are explicit and tied to actual owners. |
| 3 · interaction geometry | Could the switch visual depict an impossible route count, auto-reset, or lock-as-route? | PASS after regeneration — `002A` was rejected; `002B` confines the switch to one approach/two exits and uses a separate lock overlay. |
| 4 · asset/evidence boundary | Could a planning image be mistaken for a runtime asset, implementation, or usability proof? | PASS — no consumer, repository binary, runtime change, or human claim is recorded. |
| 5 · governance/freshness | Did this preserve approved SX-DEC-060/061/062/063 scope, leave PR #174 untouched, and update stale current snapshots? | PASS — stale 063 review-pending text is corrected; no product rule or protected PR changed. |

## Lesson and Base promotion assessment

Every planning board for a system-driven game must show each core system as **player action → visible information → meaningful choice → immediate result → retry learning**, not merely as a named screen. The current Base completed main already requires Player outcome/action/choice in meaningful work slices and system/flow relationships in a storyboard. `NO_BASE_PROMOTION`: the reusable rule already exists; this incident was a project-level application gap.

## Final disposition

The user kept `002B` as a GitHub planning reference on 2026-08-29 KST. That disposition does not authorize runtime integration; the separate SX-DEC-064 procedural route-lighting change and the Phase 2 terrain-only handoff each retain their own scope and evidence gates.
