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
