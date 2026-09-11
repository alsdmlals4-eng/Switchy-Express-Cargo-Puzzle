# SX-DEC-070 — Night Workshop first object family

## Current implementation continuation — 2026-09-11

### Strict top-down amendment after PR #286

User "좋아 그렇게 통일해" approved the representative blue roof/lid and top-view unification.
Blue exact bytes are registered under art/product_assets/topdown_v1/manifest.json; eleven new
station/cargo/decoration candidates are still USER_DISPOSITION_PENDING. Candidate prompts, hashes,
rejections and consumer mapping live in evidence/design/topdown-20260911/candidates.json.
Core, map/service coordinates, cargo scale, selected slate board and title identity stay unchanged.
Pickup uses the same approved overhead lid with 0.24-second position/opacity, no view tilt.
Independent review exposed missing automated Resume/Retry coverage; real active Retry reproduced
a presentation cancellation defect (RED), fixed at cab1b55. GDScript 121 cases / 14,505 assertions,
zero failures; Python 262 tests / one existing skip; project contract PASS.
Live Godot source cab1b55: RB01 build, four timeline samples, Pause/Resume, SUCCESS and same-layout
Retry/Edit in evidence/runtime/topdown-20260911/. Programmatic UI/witness execution is not human play.
The full-scene model candidates changed footprints and retained side-view props, so remain rejected.
Whole-family visual completion, final user screen review, derived PDF and release stay separate.
Current-task delivery PR #287 owns exact-head remote check/merge readback; no merge is predicted here.

### UI-feedback continuation after PR #285

Base source 0708eb5306c235ec1ce251d6329c7ebfa6f2620f; Base method observation
2f93e872d9ed4fa18018ac759b01acd7d34e9b58, compatibility pin unchanged.
Current branch codex/visual-completion-20260911. No changes to finite domain, maps or asset slots.

Delivery owner: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/pull/286.
Runtime head 0d8a7fef17044e8357c5875f0a84b5e61094b1b5: all five remote checks SUCCESS,
including Windows demo export and runtime payload verification. Independent read-only review
of 0708eb5..0d8a7fe found no confirmed Critical/Important/Minor defects; recommends normal merge
with current required checks. Documentation-only closeout does not change game/tests/assets/PDF.
Exact current PR head and merge/readback evidence are recorded on PR #286, not predicted here.

- ProductHUD keeps every token in a scrollable RichTextLabel and exposes a fixed TOP contiguous
  group and authoritative total. Unload animation uses real remaining count, not stale tokens.
- Delivery event cell is transformed by the actual renderer into a local semantic overlay anchor.
  Pause stops overlay time, Retry/Edit clear old effects. Existing event catalog textures reused.
- DemoEffects no longer scales BoardRenderer/HUD or recolors the whole HUD. Bounded local opacity
  pulse targets toolbar/TOP summary/phase label. One tween per target; Pause/resume and reduced mode.
- Godot RED first: 2 failing HUD/anchor cases; then 1 failing whole-board scale/tint/reduced-mode
  case. Final successful run: 121 cases, 14,497 assertions, zero failures. Python: 261 tests, 1 skip.
- Explicit live session codex-core-preserved-replan-20260910@2922: RB01 witness, real framebuffer,
  frames 0/1/2/3, paused frame retained, SUCCESS, same-layout Retry. Separate 64-token fixture
  tests presentation only, not real domain inventory. See evidence/runtime/ui-feedback-20260911.
- One inline eval compile failure was recovered by stopping/restarting only this project and using
  tests/runtime/manifest_live_qa.gd. One concurrent regression process exited -1073741819 without
  summary; no cause claimed. Serial rerun with complete regression.log passed. Do not erase anomaly.

Five full-scope review passes, with additional emphasis in each:
1. Authority/domain/consumer/visual/lifecycle/provenance sweep: finite core and map IDs unchanged;
   failed-alpha red station remains external candidate. Other three PRs are untouched.
2. Same sweep plus render/input geometry: global board/HUD transforms exposed by RED tests;
   replaced with local bounded opacity. Coordinate anchor uses matching global transforms.
3. Same sweep plus long-list/readability: fixed summary, scroll panel, actual total, unknown kinds;
   extended text audit to include RichTextLabel. Actual 64-token render reviewed.
4. Same sweep plus pause/retry/rapid events: replaced tweens cancel cleanly; paused tweens stay
   tracked; reduced mode skips transients. Model/layout/result authority tests remain unchanged.
5. Same sweep plus derived PDF/evidence: refreshed actual screenshots, 51-page render review,
   corrected atlas caption; all assets/maps remain hash-bound. No human/release/whole-art PASS.

Research comparison: ADAPT Godot AtlasTexture region/margin/filter clipping and Aseprite's explicit
frame padding; ADOPT Factorio's geometry/connectivity review before rail art slicing. REJECT
arbitrary crop of unaligned master and RGB checkerboard as alpha. Sources:
https://docs.godotengine.org/en/4.7/classes/class_atlastexture.html
https://www.aseprite.org/docs/sprite-sheet/
https://www.factorio.com/blog/post/fff-377

New red-station generation from approved blue reference produced RGB 1254x1254, baked checkerboard;
original exec-eb20aed6-c817-48de-b995-6b2d055019a9.png stays in the generation output store.
SHA-256: 6070ea5374902bb9c00edc1a7b9d804fd0da46c47588237cba0c2a4cd08a9099.
User was asked whether free local candidate-only background removal is allowed; answer pending.
No paid API, provider migration, shared Aseprite policy change or automatic pixel approval.

Learning stays project-local: verify alpha bytes before slicing/import; preserve paused effects in
tracking; use a reusable tab-indented live QA script rather than fragile multiline inline eval.
No Base promotion: cross-project verification and current promotion contract are not satisfied.

### Protected delivery readback

PR #284 MERGED through normal merge, checked head f50290d17f8e830d57827a3ae378560a664a0339.
Merge commit 6fba0536b66ab9926f0db7a87bcd9de278711748; task checkout fast-forwarded to exact
origin/main. Game/tests/art trees are identical to the verified PR head. Six remote checks
SUCCESS: GUT, headless, project contract, thin adapter, platform/rights contract, Windows
demo export including runtime payload verification. Those contract checks are not release approval.
Unrelated local import metadata and other worktrees remain preserved, not declared clean.
The game was restarted normally after QA (run token 7, helper live, no current-run errors).
This closes only the scoped implementation above, not the complete new art/blueprint program.

The user approved finishing preparation and game implementation; earlier holds below are historical.
Bounded delta: selected slate board with neutral presentation; exhaustive red/blue/yellow/waste
labels; real ground cargo forwarding and ground+carried undelivered count; modal shells above
HUD and transient effects. No core, map, input rule, save schema or other-PR changes.

Runtime: evidence/runtime/blueprint-implementation-20260911/receipt.json and build/pickup/result
framebuffers. Explicit project run token 6 had helper_live=true and no current-run errors.
Authored RB01 witness reaches success, four blue pickup frames, paused frame preserved, Retry
preserves layout and cancels visual. Manually stepped domain clock and programmatic UI signals:
not direct human input, real-time performance, audio perception or release acceptance.

Five full-scope self-review loops (not independent reviewers):
1. Authority/consumer/core/visual/rights/import/evidence: prior holds contradicted latest user;
   added top amendments, kept four-cardinal service/LIFO/manual-auto and unrelated PRs untouched.
2. Same scope: HUD collapsed yellow/waste into blue and presenter used placeholder zero;
   reproduced with failing tests and forwarded domain state without duplicate delivery logic.
3. Same scope: old warm tint altered approved board; exact-byte copy plus neutral modulation,
   hash/source equality test; historical v02/v04 bytes and rail-port tests remain preserved.
4. Same scope: live result effect obscured text; failing layering test then modal z=20 above
   HUD z=10/effect z=8. Actual corrected framebuffer inspected; existing input lock unchanged.
5. Same scope: old tests/receipts could imply all art replaced or old evidence transferred;
   updated explicit slot expectations and bounded runtime provenance, marked old PDF STALE.
   Failed-alpha new family and unverified rail master stay out of production consumers.

Technical comparison: ADOPT explicit existing-shell Z order; REJECT deleting semantic events
or adding a second UI manager. Godot documents that Z affects drawing, not input, so the
existing shell input lock is retained independently:
https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html

Learning: header approval overlays alone do not fix downstream stale holds; corrected source
companion, replan, surface provenance and PDF evidence locator together. Project-only lesson,
not validated cross-project Base promotion. Read-only system map is embedded in human companion.
Remaining: full transparent object family, validated new rail tiles, complete UI/motion family,
updated fully rendered human PDF and exact post-merge package evidence. No all-work-complete claim.

Local verification after all code changes: Godot 4.7.1, 121 cases / 14,472 assertions / zero
failures; Python unittest 261 tests / zero failures / one environment-dependent skip; project
operating contract PASS. Added lifecycle checks cover actual RB01 pickup, unloading, success
and same-layout Retry counts. One initial test used nonexistent RETRY instead of the registered
RETRY_SAME_LAYOUT command; corrected the test fixture, not production semantics.

> Sequencing amendment (2026-09-10): latest user requests planning/review first.
> Preserve the implemented increment as unmerged review work; no further image/runtime work or merge.
> Board-only selection is recorded in Current Confirmed Decisions and the surface provenance README.

User approval: 2026-09-10 continuation following the three-object final-selection request.
Scope: train, blue off-track station, blue cargo and its four-frame pickup presentation.
Status: USER_APPROVED / CANON_REGISTERED / IMPLEMENTED / MACHINE_VERIFIED locally.
Actual visual runtime review is machine-verified at 1280x720. Protected delivery remains pending;
no release or UX acceptance. See the current evidence section below.

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

## Current execution evidence — 2026-09-10 continuation

Project validator PASS; Base remote main observed 2f93e872d9ed4fa18018ac759b01acd7d34e9b58,
without compatibility repin. PRs 281/254/174 remain read-only.

Hera status/guidance verified editor 38656 and this exact worktree. Its v1.0.0 CLI lacks the
skill-documented game PID flag. REUSE: already-approved Godot AI 3.2.0 with explicit session
codex-core-preserved-replan-20260910@2922 for runtime inspection. ADAPT: a reusable live QA
script against actual UI and controller. REJECT: shared provider upgrade or ambiguous auto-selection.
Official surface checked: https://github.com/NotNull92/hera-agent-godot

Runtime owner: tests/runtime/night_workshop_live_qa.gd (excluded from exported PCKs). Captures/receipt:
evidence/runtime/night-workshop-20260910/. Real Godot framebuffer at 1280x720;
programmatic UI signals, authored RB01 witness and manually stepped domain clock, not human input.
Actual confirmed blue pickup -> frames 0/1/2/3 -> expiry -> SUCCESS, remaining cargo 0, stack 0.
Pause retains frame; same-layout Retry cancels presentation. Captures inspected for clipping,
size and train/cargo placement. No performance, audio-perception, human or device PASS.

Five continuation review passes: (1) session scope and real source, (2) event and domain isolation,
(3) frame/pivot/readability, (4) terminal/retry/pause lifecycle, (5) provenance/evidence/export scope.
Pass 4 exposed terminal train facing snapping right when next cell disappears. Added failing
regression first, then derived facing from previous cell when stopped. Full Godot suite
121 cases / 14,156 assertions PASS; corrected result framebuffer confirms vertical facing.

One exploratory inline eval mixed spaces/tabs and caused a debugger break. It did not change
product source; stopped only this session, moved QA to a tab-indented reusable script and
relaunched. Fresh run reports live helper and no current-run errors. The earlier break is
not concealed by the otherwise empty Hera log.

New board/title surfaces are candidates under evidence/design/night-workshop-surfaces-20260910;
not production-path changes. Their pixel decision and downstream palette adaptation are separate.

## Historical pre-recovery verification

Draft delivery: PR #284. Full local Python suite: 269 PASS / 1 SKIPPED.
The first remote export run exposed one remaining SX-DEC-065 literal old-train-path assertion;
updated that exact approved consumer expectation and reran the full Python suite.
Source-alpha candidate validator and 21 asset tests also PASS. Remote checks must be read
against the latest PR head; the earlier export failure is not final delivery evidence.

Godot editor PID 38656 was attached to the isolated task worktree and main scene launched.
The installed Hera CLI v1.0.0 and local addon reject the skill's explicit game PID option.
Do not silently fall back to another runtime or upgrade shared tooling inside this art increment.
Actual object-board capture and pickup playback inspection remain NOT_RUN.
Candidate010 remains an immutable historical exact-byte package; its evidence does not transfer.
