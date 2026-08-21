# SX-AUD-066 · SX-DEC-059 Implementation and Five-Pass Review

```yaml
audit_id: SX-AUD-066
date: 2026-08-21 KST
owner_decision: SX-DEC-059
implementation_base_main: 4b37c154505ed1975735fc305a68b410877a40e0
implementation_state: IMPLEMENTED_AUTOMATED
release_target: RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE
core_rule_change: NONE
VS_DEMO_01_BYTES: UNCHANGED
PRODUCT_PNG_73: UNCHANGED
PHYSICAL_WINDOWS: NOT_RUN
ANDROID_DEVICE: NOT_RUN
FIVE_PERSON_COMPREHENSION: NOT_RUN
PLAYER_EXPERIENCE: NOT_RUN
INDEPENDENT_CODE_REVIEW: CLOSED_AFTER_CORRECTION
```

## 1. Outcome

The approved T1→T6→`VS_DEMO_01` first session is implemented as an opt-in presentation/onboarding sidecar around the existing finite-delivery product. It does not add tutorial fields to `FiniteMapDefinition`, alter LIFO/delivery/route/time rules, absorb SX-DEC-056~058, mutate the capstone map, or modify the 73 production PNGs.

The stable standalone `vertical_slice_demo.tscn` remains opt-out. `game/main/main.tscn` is the product entry and opts into the first-session flow.

## 2. Operating objective and benchmark decision

The work optimized for the most efficient long-term release-near slice, not the fastest local patch. It compared current code/PR/Notion authority with official product examples:

- Railbound: approachable finite rail puzzles, place/remove/reroute and switches — https://afterburn.games/press/ and https://store.steampowered.com/app/1967510/
- Cosmic Express: route planning is the puzzle object — https://cosmicexpressgame.com/ and https://store.steampowered.com/app/583270
- Mini Metro / Mini Motorways: readable network construction under constrained presentation — https://dinopoloclub.com/games/mini-metro/ and https://dinopoloclub.com/games/mini-motorways/
- Godot official CLI: clean runners must import project resources before headless execution — https://docs.godotengine.org/en/4.4/tutorials/editor/command_line_tutorial.html

Inference applied to Switchy: the differentiator is not a generic grid framework. It is the causal chain `route construction → encounter order → manual/auto pickup choice → unlimited LIFO TOP → route execution`. Therefore the implementation reuses the product command/domain owners and adds only lesson sequencing, staged visibility/authority, authored maps, localized copy and evidence-safe result presentation.

## 3. Core systems and implementation seams

| Core system | Player meaning | Implementation owner / method |
|---|---|---|
| Finite map | Fixed board, start direction, cargo/stations, blocked/buildable cells and time limit | `FiniteMapDefinition` schema v2 loaded by `finite_map_loader.gd`; tutorial metadata remains separate |
| Build + refund | Straight/curve/switch/crossing placement, rotation/removal/clear, full refund and cost | `FiniteBuildSession` + `TrackLayoutEditor`; first-session policy narrows tools without changing their semantics |
| Preflight | RUN only after structural connectivity is valid | `PreflightValidator`; deliberately does not solve LIFO order or reveal a solution |
| Fresh attempt | Same authored solution can be retried with new mutable runtime identities | `FiniteRunSessionFactory`; layout identity is sealed, train/cargo/input/controller are fresh per attempt |
| Train + route | Automatic continuous movement and persistent route selection with occupied lock | finite train/track graph; segment target is stable; switch/cross selection never auto-resets |
| Pickup + LIFO | Manual hold is default, Auto is optional, skipped cargo stays; unlimited last-in-first-out stack | `FiniteGameplayInputState`, fixed cargo field and unlimited cargo stack |
| Delivery + terminal | Matching contiguous TOP group unload; success when map+stack are empty; timeout/route-end failure | finite delivery loop + run controller; immutable `FiniteRunSummary` |
| Product presentation | One command convergence boundary for HUD, keyboard, board and route inputs | `ProductFiniteSlice` → session controller/presenter → HUD/board/semantic feedback |
| First session | T1/T2 shared runtime, T3~T6 authored lessons, capstone reuse, four-locale copy | `FirstSessionDefinition`, `StagePolicy`, `Director`, `Copy`, starter-layout sidecar and JSON data |
| Result/recovery | Evidence-safe failure facts, retry same layout, edit only when lesson owns editable track | current summary fields plus shell result; terminal lifecycle commands remain policy-authorized |

Durable campaign/save progression is not part of this vertical slice. Lesson progress and retry identity are session-local. Campaign persistence remains a later SX-DEC-034 integration concern.

## 4. Shipped first-session sequence

```text
T1: build a valid straight/curve route; preflight advances without RUN
→ T2: same ProductFiniteSlice/map/layout; manual pickup and matching station delivery
→ T3: plan loading order so the required cargo becomes TOP
→ T4: fixed figure-eight scaffold; skip B, deliver A, revisit and load B
→ T5: fixed figure-eight scaffold; Auto ON for safe A cargo, OFF before choice B
→ T6: read one switch's wrong initial branch, preselect delivery branch, observe occupied lock/persistence
→ CAPSTONE: unchanged VS_DEMO_01 with all learned systems available
→ Result / Retry / Edit where structurally meaningful
```

### Topology correction

The planning text initially required T4/T5 revisits with straight/curve-only free building. A route entering from an external start cannot revisit the same cargo cell using only degree-2 straight/curve topology without a branch, crossing or U-turn. Adding a new domain rule or teaching switch controls before T6 would be larger and less coherent.

The selected release-near solution is a sidecar-installed figure-eight crossing scaffold. T4/T5 hide crossing construction and the route-control overlay, so the scaffold supplies revisit topology while the lesson remains focused on pickup decisions.

The planning text also said T6 should use both switch routes in one run. Doing that cleanly requires another junction/loop and a second causal problem. The shipped first lesson instead proves one switch decision: wrong initial route → preselected delivery route → occupied lock → persistent state → success. The copy and active content contracts now describe that exact behavior.

## 5. Five adversarial passes

### Pass 1 · Authority / canon / PR state

`ADVERSARIAL_PASS_1: CLOSED`

Finding: active GitHub entrypoints still claimed `NOT_REQUESTED / NOT_STARTED`, planning SHA `0a88…`, and PR #154 `READ_ONLY`, while the user had requested implementation and all PR review.

Correction: active entrypoints now promote `USER_REQUESTED_AND_EXECUTED / IMPLEMENTED_AUTOMATED`; the pre-implementation main is recorded as history; PR #154 is explicitly audited/superseded without absorbing `game/reuse/*`.

### Pass 2 · Gameplay state / bypass / retry

`ADVERSARIAL_PASS_2: CLOSED`

Finding: StagePolicy rejected `RETRY_SAME_LAYOUT` and `EDIT_LAYOUT` in terminal phases. A failed T2 could display recovery but retry remained in `FAILURE`; fixed-layout lessons also exposed a non-functional Edit action.

Correction: terminal retry/edit are recognized lifecycle commands; fixed-layout T2/T4/T5 hide Edit; an actual T2 route-end failure now proves Retry creates a fresh running attempt with the same sealed layout.

### Pass 3 · Map topology / causal lesson / hidden route controls

`ADVERSARIAL_PASS_3: CLOSED`

Finding: T4/T5 revisit topology contradicted straight/curve-only free building; their fixed crossings still exposed the route overlay. T6 copy promised both branches although the shipped map proves one preselection decision.

Correction: fixed figure-eight starter scaffolds are canonical; route controls are hidden before T6 at the product boundary; T6 copy and content specs match `ONE_SWITCH_PRESET_SELECTION` in all four locales.

### Pass 4 · UI lifecycle / localization / accessibility

`ADVERSARIAL_PASS_4: CLOSED`

Finding: removing a lesson policy left child HUD controls hidden because `reset_stage_visibility()` cleared policy state but did not restore default visibility.

Correction: reset restores every staged child then reapplies the phase model. Regression covers standalone recommended-layout restoration, route overlay restoration, 48px visible controls, Reduced Motion information parity, color+shape+text cargo identity, four locales, locale normalization/fallback and no raw key leaks.

### Pass 5 · CI / export / package / scope

`ADVERSARIAL_PASS_5: CLOSED`

Finding A: the export include filter and mounted-pack verifier did not prove first-session sequence/localization/tutorial JSON.

Correction A: Windows and Android presets include the new runtime JSON; the mounted PCK verifier parses sequence, localization, all five tutorial maps and the previous semantic manifests.

Finding B: `all_resources` also shipped `tests/**`, GUT and the Godot AI editor plugin. The proof PCK was 3,555,208 bytes.

Correction B: both release presets exclude tests, GUT and the Godot AI editor plugin. The corrected exact-head proof PCK is 808,128 bytes, a 77.3% reduction, while all 26 required/discovered runtime JSON files still parse.

Scope readback: `VS_DEMO_01` SHA-256 is unchanged at `81bd3c5ebc48e1b9f6d6a8cc942cb5dadb4e865c8d281848c2154aaead985fd0`; product-asset diff count is zero; finite build/cargo/delivery/rail/run owners are unchanged. Only the presenter gains truthful `remaining_map_cargo` and `stack_size` fields.

### Independent post-five-pass review · causal counterexamples / real viewport geometry

`INDEPENDENT_REVIEW: CLOSED_AFTER_RED_GREEN_CORRECTION`

Finding A: the first T4/T5 figure-eight placed B before the A cargo and Station A. A player could hold Load from the start or leave Auto enabled, create `[B, A…]`, unload A first and then B, and succeed without making the lesson's claimed choice. The success witnesses proved one intended route but did not falsify the naive alternatives.

Correction A: map revision 2 and the starter scaffold now encounter `A cargo(s) → B → Station A → B revisit → Station B`. T4 load-all and T5 Auto-always-on are explicit negative witnesses and must end in `FAILURE`; selective T4, planned Auto ON/OFF T5 and manual-only T5 remain positive witnesses.

Finding B: the first responsive test checked visibility and configured minimum sizes only at one default viewport. It did not prove actual geometry or Result recovery reachability. A real 960×540 check then exposed the Result action stack below the viewport.

Correction B: the result body now uses a bounded scroll surface and Retry/Edit/Title share one horizontal 56px action row. The regression matrix exercises 1280×720, 1600×900, 1920×1080, 2560×1080 wide PC and 960×540 mobile landscape, checks actual board/HUD/control/panel rectangles, rendered ≥48px buttons, and invokes Retry and Edit at every size. Duplicate failure text was also removed from the Result body.

## 6. Before / after / expected effect

| Case | Before — regressed/current state | After — restored/improved state | Expected effect |
|---|---|---|---|
| Authority | active canon said handoff/build not started | implementation state and five-pass evidence are current | future agents resume from reality instead of restarting planning |
| Recovery | terminal policy blocked Retry/Edit | retry works; Edit is shown only for editable lessons | no progression dead-end or misleading action |
| T4/T5 causality | the first scaffold allowed load-all / Auto-always-on success | revision-2 encounter order plus negative and positive strategy witnesses | the claimed selective/Auto decision is necessary, not optional choreography |
| T6 | copy promised both routes in one run | one preselection + occupied lock + persistence | smaller, readable first switch lesson that transfers to capstone |
| Staged UI | hidden controls could remain hidden after policy removal | default HUD/route controls restore deterministically | standalone compatibility and future reuse remain safe |
| Responsive Result | configured minimum sizes at one viewport; 960×540 actions overflowed | five-size real-geometry matrix; scrollable facts + horizontal 56px recovery row | Retry/Edit/Title remain readable and reachable on standard, wide and mobile-landscape bounds |
| Package data | first-session JSON not explicitly proven in PCK | 26 runtime JSON parse proof | clean clone/export cannot omit lesson/copy data silently |
| Package size | tests/GUT/Godot AI plugin shipped in product pack | excluded; PCK 3,555,208 → 808,128 bytes | lower download/load surface and cleaner release artifact |

## 7. Automated evidence

Local exact-worktree evidence before remote PR:

```text
Godot 4.7.1 clean --import: PASS · no SCRIPT ERROR / ERROR
custom suite: 110 cases · 0 failed · 12,294 assertions
formal GUT 9.7.1: 21 tests · 21 passing · 150 assertions
mounted Windows-preset proof PCK: PASS · parsed_json=26
mounted Android-preset proof PCK: PASS · parsed_json=26
Windows proof PCK SHA-256: 37a90bf3ace45f12c62811cf21e88bb55d015418a14413aaeda4963bda303cdc
Android proof PCK SHA-256: c2f4e74296270472eea72f933d9e36c9b5ff8e2812740a93f5978d1d5fab9ea1
proof PCK size: 808,128 bytes per preset
VS_DEMO_01 protected diff: 0
73 product PNG protected diff: 0
finite core owner protected diff: 0
```

GitHub hosted exact-head checks and review-thread readback remain mandatory merge gates and are recorded on the implementation PR. Hosted Windows export proves artifact construction/package integrity, not physical Windows play.

## 8. Evidence ceiling and next gate

```text
AUTOMATED / GUT / EXPORT-PACK: PASS
PHYSICAL_WINDOWS: NOT_RUN
ANDROID_DEVICE: NOT_RUN
FIVE_PERSON_COMPREHENSION: NOT_RUN
PLAYER_EXPERIENCE: NOT_RUN
PRODUCTION_CUTOVER: BLOCKED_DEFERRED
```

Next meaningful product evidence is an exact acceptance-build identity followed by Windows physical runtime/input/audio/visual smoke, separate Android device smoke, Reduced Motion/readability observation and at least five first-contact comprehension sessions on that same build.
