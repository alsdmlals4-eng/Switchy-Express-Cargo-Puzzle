# Top-down unification implementation

Spec: docs/superpowers/specs/2026-09-10-core-preserved-art-and-experience-replan.md (latest top-view amendment).
User approved representative blue roof and blue lid and instructed unification.

## Global Constraints

- Strict vertical 90-degree orthographic world objects. No facade, side face or camera tilt in motion.
- Preserve finite core, maps, selected slate board, title identity, coordinate and service semantics.
- September 12 amendment: the exact eleven selected remaining object/decor candidates are now pixel-approved too.
  Their integration is still pending; rejected scenic/superseded outputs are not approved.
- Existing dirty/import/UID files and unrelated PRs are protected. Explicit-path staging only. No direct main push or bypass.
- Real-alpha validation, tests and runtime evidence are separate from user pixel approval.

## Task 1: Approved blue consumers and overhead motion

Work in the existing codex/topdown-art-direction-20260911 worktree.
Read current project authority and relevant design/image/Godot/TDD skills before mutation.
Copy exact approved files evidence/design/topdown-20260911/station-blue-candidate.png and cargo-blue-candidate.png into a new art/product_assets/topdown_v1/ family; do not edit their pixels. Register provenance, SHA-256 and approval in that family's manifest.json.
Connect ProductBoardRenderer station_blue and cargo_blue to them. Account for their transparent padding without enlarging cargo relative to the existing CARGO_MARKER_SCALE 0.62 design. Keep semantic anchors unchanged.
Remove the active oblique blue cargo_lift frames. Adapt CargoPickupAnimation and renderer to animate the approved flat blue lid through presentation-only position/opacity, without revealing sides, rotating the camera, creating substitute pixel art or changing domain event timing. Preserve pause, reduced-motion, Retry/Edit cancellation and local pickup/unload anchoring. Inspect current code first; if the interface requires a different bounded design, report the precise concern to controller before making it.
RED-first tests must exercise approved texture paths, frame/presentation behavior, pause/resume/reduced motion/cancel invariants and provenance bytes. Update affected existing assertions without weakening semantic checks. Add a family/consumer regression against oblique lift reactivation.
Own only art/product_assets/topdown_v1/, affected renderer/animation scripts and related tests. Do not modify planning owners, evidence/design/topdown-20260911, other art families, shared tooling or live editor (controller owns runtime capture).
Run focused tests during iteration and full GDScript/Python regression once before commit. Do not run concurrent Godot processes with another test owner: notify controller before full suite. Use existing tests/run_tests.gd and tests/python, no invented filters.
Self-review, explicit-stage own files, commit; no push. Write command/output RED and GREEN evidence and concerns to the specified report. Never dispatch subagents.

## Task 2: Remaining candidate preparation and authority update

Controller produces other required station/cargo/decor/scenic candidates using image model only. Inspect top-view geometry, true alpha, silhouettes and consumer paths. Persist selected deliverables with prompts, hashes, dimensions and dispositions in existing topdown evidence owner. Record the two exact approvals in Decisions, Active Context and spec. New unseen pixels stay candidates. No local background removal or new renderer primitive substitute.

## Task 3: Integration review and delivery

Independent task review then exact source runtime capture, five-pass full-scope review, regression readback. Finish normal current-task PR path when approved implementation passes; do not merge candidate approval claims. Derived PDF refresh follows final family adoption, not incomplete replacement. Report outstanding new-pixel disposition explicitly.
