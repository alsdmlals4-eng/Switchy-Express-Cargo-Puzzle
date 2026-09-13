# C1 RB08 revision 2 - execution evidence

Authority: September14 user approval and
`docs/superpowers/specs/2026-09-14-remaining-work-design.md` C1 handoff,
merged via PR309 main0c25766b5e7da109e786005f5bba792795ee8b22 before implementation.
Consumer: existing map loader -> actual Main/Product -> current board/briefing.
No global speed, economy, timer, success rule, solver, save, artwork or engine change.
RB02 keeps its original fixture; RB08 has a separate authored route.

## Problem, research and adopted structure

Old authored detour cost more and was slower. Apply the approved research synthesis:
small authored-puzzle depth, not new mechanics. Railbound's developer puzzle-pack
case is ADAPT, not copied geometry:
https://afterburn.itch.io/railbound/devlog/481366/update-20-launches-on-february-3rd
Existing caution multiplier0.55/base speed2.0/cost100/time115 remain unchanged.
One mandatory cargo caution plus four optional caution cells makes the sampled
short route cheaper and slower than its authored longer alternative.

## RED -> GREEN

- Baseline full:129 cases/16133 assertions/0 failed, exit0.
- RED unchanged-map witness: new minimum0.25sec saving assertion fails, exit1;
  all12 positive stages still SUCCESS. red.json is failed evidence, not promoted.
- Full RED:129 cases/16135 assertions/3 failed, exit1 (time, map, preview).
- GREEN focused:131 assertions,12 SUCCESS, exit0 (green.json/green-witness.log).
- GREEN full:129 cases/16135 assertions/0 failed, exit0 (green-full.log).
- Actual Main/Product window:12 SUCCESS, exit0 (window.log). Accelerated commands
  and authored fixtures, not human-paced play or template-EXE completion.
- Actual preview window:144 states,3 pointer Begin checks,0 failures, exit0.
  See ../stage-preview-window-20260913/receipt.json; accepted960/1280/1600 widths.
- New blueprint capture-binding RED:1 failed/3 passed (missing binding);
  GREEN after real post-draw capture:7 publication/preview tests passed.
- Python full discovery:310 passed/1 skipped, GODOT_BINARY explicitly set.
  A skipped test remains unexecuted, not PASS.

At step0.05/product speed2.0, direct11 pieces cost1100/7.74454545454544sec;
detour13 pieces cost1300/7.1081818181818sec. Difference0.63636363636364sec.
Both deliver BLUE then RED pickup / RED then BLUE TOP unloading successfully.
No claim that either is optimal, exhaustive, balanced by human study, or a player hint.

## Artifact correction and evidence ceiling

Python initially detected two stale published input hashes after copy/map changed.
Kept guards; reran actual preview and rebuilt the77-page source-bound PDF.
Old revision1 result/HUD screenshots are explicitly historical UI evidence.
RB08 new preview has five caution cells, new red positions, progress2/6 and current
cost/time prompt. PDF table reads actual witness metrics; map hash must match GREEN.
All77 pages rendered; five contact sheets inspected for layout, with dedicated
RB08 preview inspection. No overflow reported by paragraph/table generation.
Render intermediates are in Downloads/Switchy_삭제대기_20260914_C1 for user deletion;
no active originals were moved or deleted. Raw run logs stay byte-preserved in Git.

Independent review and exact changed-byte package/merge evidence follow below.
Final human, physical device, rights and release: NOT_RUN / separate gates.
No Base promotion: this is project-specific geometry/content evidence. Reusable
lesson is enforced locally: map/copy changes invalidate screenshot/PDF hashes,
so recapture/regenerate rather than weaken freshness checks.

## Final review and changed-byte package

Independent five-pass review found a real future-staleness gap: checking only the map
would allow old timing after a fixture/runner edit. Builder now validates every
receipt-bound input and Python independently checks them. Re-review32b7d6f: no
remaining scoped blocker. PDF remains byte-identical after this guard-only correction.

Actual first export unexpectedly included old untracked tmp/pdfs render resources.
Preserved that rejected trial under Downloads/Switchy_삭제대기_20260914_C1;
added tmp/** to both runtime presets after an export-hygiene RED. No tmp consumer
in current game/data/art. Re-export log no longer contains res://tmp/ resources.
CI34785746459 then correctly rejected the old exact-string GDScript export contract;
updated that companion expectation to the strengthened exclusion, not a weaker filter.
Earlier310pass Python evidence preceded the final freshness test; latest311pass/1skip.
Optional Pilot GODOT_BIN check remains SKIPPED_NOT_CONFIGURED (different from GODOT_BINARY).

Re-export source32b7d6fef8a5c32acf805306f9036005b7def32d, Windows Demo:
Downloads/Switchy_Playable_20260914_RB08/SwitchyExpress.exe + .pck.
EXE102982144bytes SHA2561cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244.
PCK54881028bytes SHA2566faeca55d4224171086fa14ef0ac468f46875070a8d308511a8a2b700ac620b9.
Subsequent changes are tests/evidence/docs only, not packaged game/data/art/settings.

- package-payload.log: mounted PCK JSON31,books2,stages12,BUILD entries12, exit0.
- pack-positive.json/package-completion.log:12 actual SUCCESS, exit0.
- pack-negative.json/package-negative.log: no-pickup RB01 FAILURE, expected exit1.
- pack-detour.json/package-detour.log: same package, RB08 authored detour and other11
  SUCCESS, exit0. Test-only optional driver flag; shipping resources not overlaid.
- native-startup.log: native template EXE120frames, exit0, no startup error.
- pack-rb08-result.png / pack-rb08-detour-result.png inspected: connected routes,
  actual SUCCESS UI and costs1100/1300, completion7.7/7.1. Other stage PNGs remain
  in separate user://completion output; only task-relevant RB08 pair is promoted here.

External completion runner uses --main-pack and pack-path with the same exact absolute
PCK path and OS-read hash; receipt alone does not authenticate the mounted bytes.
New rb08-detour flag uses the existing authored fixture, not a solver or outcome injection.
Initial direct/negative receipts predate that test-only flag; their own runner hashes
retain that distinction. Latest detour receipt binds the updated runner. Human/release
remain NOT_RUN. V1 native input capability unavailable through current native-disabled
computer tools; no shipping test hooks installed. No D1/D2 recurrence requiring repair.

Normal integration owner: https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/pull/310
Exact final CI and merge/postmerge are recorded on that PR, not inferred from local runs.
