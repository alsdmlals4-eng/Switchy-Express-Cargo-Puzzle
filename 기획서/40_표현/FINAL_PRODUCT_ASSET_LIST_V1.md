# Final Product Asset List v1

**Decision:** `SX-DEC-053`  
**Art direction:** `E+D HYBRID · NEO-ARCADE READABILITY`  
**Source candidate pack:** `art/production_candidates/ed_hybrid_v1/`  
**Future promoted root:** `art/product_assets/ed_hybrid_v1/`  
**State:** `USER_APPROVED_DIRECTION · PRODUCTION_CHECKLIST · NOT_RUNTIME_INTEGRATED`

## Promotion legend

- `P0` — required before first product-asset promotion batch is considered complete.
- `P1` — required before polished runtime POC.
- `P2` — meta/decoration or later quality pass.
- `AS_IS?` — inspect current candidate first; promote without pixel revision only if it passes SX-DEC-053 checks.
- `REVISE` — same role, but revision is expected before promotion.

## A. Core world

| ID | Target filename | Role | Required states/variants | Priority | Default disposition |
|---|---|---|---|---|---|
| CORE-01 | `core_train_locomotive_blue_normal_v01.png` | hero locomotive | normal | P0 | AS_IS? |
| CORE-02 | `core_wagon_cargo_red_normal_v02.png` | red trailing wagon | normal | P0 | REVISE smaller |
| CORE-03 | `core_wagon_cargo_blue_normal_v02.png` | blue trailing wagon | normal | P0 | REVISE smaller |
| CORE-04 | `core_wagon_cargo_yellow_normal_v02.png` | yellow trailing wagon | normal | P0 | REVISE smaller |
| CORE-05 | `core_cargo_star_red_normal_v01.png` | red pickup | normal | P0 | AS_IS? |
| CORE-06 | `core_cargo_star_blue_normal_v01.png` | blue pickup | normal | P0 | AS_IS? |
| CORE-07 | `core_cargo_star_yellow_normal_v01.png` | yellow pickup | normal | P0 | AS_IS? |
| CORE-08 | `core_station_red_normal_v01.png` | red station | base + match overlay contract | P0 | AS_IS? |
| CORE-09 | `core_station_blue_normal_v01.png` | blue station | base + match overlay contract | P0 | AS_IS? |
| CORE-10 | `core_station_yellow_normal_v01.png` | yellow station | base + match overlay contract | P0 | AS_IS? |
| CORE-11 | `core_rail_straight_normal_v01.png` | committed straight | normal | P0 | AS_IS? |
| CORE-12 | `core_rail_curve_normal_v01.png` | committed curve | normal | P0 | AS_IS? |
| CORE-13 | `core_rail_crossing_normal_v01.png` | committed crossing | normal | P0 | AS_IS? |
| CORE-14 | `core_rail_switch_three_way_normal_v01.png` | committed 3-way switch | selected/inactive/locked overlays | P0 | AS_IS? |
| CORE-15 | `core_marker_start_normal_v01.png` | route start | normal | P0 | AS_IS? |
| CORE-16 | `core_marker_route_end_normal_v01.png` | route end | normal | P0 | AS_IS? |

### Core proportion rule

- locomotive = 100% hero reference;
- trailing wagon initial visual footprint = approximately 70–75%;
- wagon must remain clearly subordinate while cargo color/shape and coupling stay readable;
- art-scale tuning must not alter domain collision/route rules.

## B. RUN / LIFO

| ID | Target filename | Role | Required states | Priority | Default disposition |
|---|---|---|---|---|---|
| RUN-01 | `run_stack_empty_v01.png` | stack HUD | empty | P0 | split/revise from atlas |
| RUN-02 | `run_stack_top_highlight_v01.png` | TOP emphasis | active TOP | P0 | split/revise from atlas |
| RUN-03 | `run_stack_next_group_v01.png` | next unload group | grouped highlight | P0 | REVISE if absent |
| RUN-04 | `run_stack_plus_n_v01.png` | compressed count | `+N` / 32+ pattern | P0 | split/revise from atlas |
| RUN-05 | `run_stack_unloading_v01.png` | unload state | unloading | P0 | split/revise from atlas |
| RUN-06 | `run_switch_arrow_left_selected_v01.png` | selected direction | left | P0 | split from atlas |
| RUN-07 | `run_switch_arrow_center_selected_v01.png` | selected direction | center | P0 | REVISE/add |
| RUN-08 | `run_switch_arrow_right_selected_v01.png` | selected direction | right | P0 | REVISE/add |
| RUN-09 | `run_switch_locked_v01.png` | occupied switch | locked | P0 | split/revise |
| RUN-10 | `run_train_cargo_strip_v01.png` | compact world train strip | recent/TOP + compression | P0 | REVISE wagon scale |
| RUN-11 | `run_load_mode_off_v01.png` | load mode | off | P0 | split/revise |
| RUN-12 | `run_load_mode_on_v01.png` | load mode | on | P0 | split/revise |
| RUN-13 | `run_combo_feedback_static_v01.png` | combo reduced-motion | static | P1 | AS_IS? |

## C. BUILD

| ID | Target filename | Role | Required states | Priority | Default disposition |
|---|---|---|---|---|---|
| BUILD-01 | `build_track_straight_valid_ghost_v01.png` | valid ghost | valid | P0 | split from atlas |
| BUILD-02 | `build_track_straight_invalid_ghost_v01.png` | invalid ghost | invalid | P0 | split from atlas |
| BUILD-03 | `build_track_curve_valid_ghost_v01.png` | curve ghost | valid | P0 | split from atlas |
| BUILD-04 | `build_track_curve_invalid_ghost_v01.png` | curve ghost | invalid | P0 | REVISE/add |
| BUILD-05 | `build_selection_outline_v01.png` | edit selection | selected | P0 | REVISE/add |
| BUILD-06 | `build_rotate_affordance_v01.png` | rotate control | available/pressed | P0 | REVISE/add |
| BUILD-07 | `build_remove_affordance_v01.png` | remove control | available/pressed | P0 | REVISE/add |
| BUILD-08 | `build_track_palette_v01.png` | track palette frame | normal/selected | P0 | AS_IS? |
| BUILD-09 | `build_ghost_route_v01.png` | suggested route | shown | P0 | AS_IS? |
| BUILD-10 | `build_cost_hud_v01.png` | construction cost HUD | neutral/threshold miss | P0 | AS_IS? |
| BUILD-11 | `build_preflight_ready_v01.png` | preflight | ready | P0 | split/revise |
| BUILD-12 | `build_preflight_warning_v01.png` | preflight | warning | P0 | split/revise |
| BUILD-13 | `build_preflight_blocking_v01.png` | preflight | blocking | P0 | split/revise |

## D. Reusable controls

| ID | Target filename | State | Priority | Source |
|---|---|---|---|---|
| UI-01 | `ui_button_frame_square_blue_normal_v01.png` | normal | P0 | current atlas |
| UI-02 | `ui_button_frame_square_blue_hover_v01.png` | hover | P0 | current atlas |
| UI-03 | `ui_button_frame_square_blue_pressed_v01.png` | pressed | P0 | current atlas |
| UI-04 | `ui_button_frame_square_blue_selected_v01.png` | selected | P0 | current atlas |
| UI-05 | `ui_button_frame_square_blue_disabled_v01.png` | disabled | P0 | current atlas |
| UI-06 | `ui_button_frame_square_blue_locked_v01.png` | locked | P0 | current atlas |
| UI-07 | `ui_button_frame_square_blue_focus_v01.png` | keyboard/gamepad focus | P0 | current atlas |

All controls must preserve a minimum usable touch target at runtime. PNG dimensions alone do not prove the 48dp runtime gate.

## E. Feedback / VFX

| ID | Target filename/family | Feedback | Priority | Notes |
|---|---|---|---|---|
| VFX-01 | `vfx_cargo_pickup_*` | pickup | P1 | star disappears from world after committed pickup |
| VFX-02 | `vfx_cargo_unload_*` | unload | P1 | TOP-first causal motion |
| VFX-03 | `vfx_combo_*` | combo | P1 | do not obscure next input |
| VFX-04 | `vfx_route_select_*` | branch selection | P1 | short directional confirmation |
| VFX-05 | `vfx_success_*` | success | P1 | energetic E polish |
| VFX-06 | `vfx_failure_*` | generic failure | P1 | clear without excessive screen shake |
| VFX-07 | `vfx_route_end_*` | ROUTE_END | P1 | cause-specific |
| VFX-08 | `vfx_time_expired_*` | TIME_EXPIRED | P1 | cause-specific |
| VFX-09 | `vfx_reduced_motion_static_*` | motion-equivalent states | P1 | information parity required |

## F. Shells and meta

| ID | Target | Required states | Priority | Default disposition |
|---|---|---|---|---|
| SHELL-01 | stage briefing shell | normal | P1 | REVISE/add |
| SHELL-02 | pause shell | normal | P1 | REVISE/add |
| SHELL-03 | exit confirm shell | normal | P1 | REVISE/add |
| SHELL-04 | success result shell | text-safe blank | P1 | AS_IS? |
| SHELL-05 | failure result shell | text-safe blank | P1 | AS_IS? |
| SHELL-06 | retry/edit/title action group | normal/pressed/disabled | P1 | REVISE/add |
| META-01 | stage node | locked/open/completed | P1 | REVISE from meta atlas |
| META-02 | star state | 0/1/2/3 | P1 | REVISE from meta atlas |
| META-03 | badge state | NEW/BEST | P2 | REVISE/add |
| META-04 | chapter card | locked/open/completed | P2 | REVISE/add |
| META-05 | archive primitive | normal/favorite/uncleared filter | P2 | REVISE/add |
| META-06 | leaderboard gate | locked/3-star-open | P2 | REVISE/add |

## G. Environment decoration — bounded set

Environment decoration is secondary and must never reduce track readability. Initial P2 set may include:

- crate;
- barrel;
- short fence;
- lamp;
- direction sign;
- grass tuft;
- small rock;
- drain/grate;
- platform prop;
- tiny workshop prop.

Limit the first pass to about 10 reusable props. Do not make unique scenery per level before core/readability/runtime gates pass.

## H. Promotion checklist per asset

Before any file moves to `art/product_assets/ed_hybrid_v1/`:

- [ ] Role is still current in product canon.
- [ ] Candidate source and SHA/provenance are recorded.
- [ ] Disposition is `PROMOTE_AS_IS`, `PROMOTE_AFTER_REVISION`, or `REPLACE`.
- [ ] Transparent assets have alpha-capable PNG data.
- [ ] No localized text is baked into image pixels.
- [ ] Color-only communication has shape/icon reinforcement.
- [ ] Gameplay-scale silhouette check passes.
- [ ] Reduced Motion equivalent exists where motion carries information.
- [ ] Runtime integration is still marked separately until actually performed.

## I. First implementation batch

The first production batch should be limited to:

1. locomotive;
2. three smaller cargo wagons;
3. three cargo stars;
4. three stations;
5. four committed rail types;
6. start / route-end marker;
7. RUN stack/switch/train-strip essentials;
8. seven reusable button states.

Do not begin decorative P2 environment production before this batch is promoted and statically validated.
