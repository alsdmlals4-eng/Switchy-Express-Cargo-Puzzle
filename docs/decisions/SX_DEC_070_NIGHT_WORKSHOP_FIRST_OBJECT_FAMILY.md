# SX-DEC-070 — Night Workshop first object family

User approval: 2026-09-10 continuation following the three-object final-selection request.
Scope: train, blue off-track station, blue cargo and its four-frame pickup presentation.
Status: USER_APPROVED / CANON_REGISTERED / IMPLEMENTED / MACHINE_VERIFIED locally.
Delivery and actual visual runtime review remain pending; no release or UX acceptance.

Owner: art/product_assets/night_workshop_v1/manifest.json.
Generation/source provenance: evidence/design/night-workshop-assets-20260910/README.md.
Current consumers: ProductBoardRenderer texture slots and ProductFiniteSlice confirmed delivery event.

The finite core, manual/auto pickup semantics, cardinal station service, stack and maps are unchanged.
The confirmed blue pickup event starts a bounded 240 ms presentation timeline. Pause freezes it;
Edit/Retry cancels it; rapid pickup replaces the visual; reduced motion holds the neutral pose.
Presentation never changes gameplay. Other colors retain existing art and generic feedback.

The static cargo crop and animation envelope preserve painted object scale and alignment.
Old assets remain historical, with an override pointer instead of destructive replacement.
New rail master is a candidate: exact ports, turnouts and rotation/adjacency are NOT_VERIFIED.

## Evidence and five self-review passes

1. Consumer/domain: verified actual picked_up, pickup_type and cell fields; no new callback authority.
2. Lifetime: RED test exposed processing shutdown without speed FX; fixed shared processing lifetime.
3. Visual alignment: corrected 384 px static versus 448 px animation envelope scale; source alpha inspected.
4. Provenance/scope: hash-bound approved three-object family; rail and other colors explicitly excluded.
5. Regression/evidence: changed three exact path expectations only; 121 cases / 14,152 assertions PASS
   under Godot 4.7.1. This is machine evidence, not visual motion or human PASS.

## Remaining verification

Godot editor PID 38656 was attached to the isolated task worktree and main scene launched.
The installed Hera CLI v1.0.0 and local addon reject the skill's explicit game PID option.
Do not silently fall back to another runtime or upgrade shared tooling inside this art increment.
Actual object-board capture and pickup playback inspection remain NOT_RUN.
Candidate010 remains an immutable historical exact-byte package; its evidence does not transfer.
