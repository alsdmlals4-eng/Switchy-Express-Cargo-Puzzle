# Approved top-down family — delivery evidence, 2026-09-12

## Scope and authority

Baseline main `2de6bd6d70335134e5b97f02ed12e35b35239634`; user approved the selected remaining eleven images, following the blue pair. Exact pixels are owned by `evidence/design/topdown-20260911/candidates.json`, not a newly generated scene. Base remote observed `2f93e872d9ed4fa18018ac759b01acd7d34e9b58`; compatibility pin unchanged. Other open PRs #281/#254/#174 remain read-only.

## Problem, comparison and implementation

The prior board mixed overhead blue objects with oblique stations/decor and scenic shell heroes. Official Godot CanvasItem/Control documentation was checked (links and ADOPT/ADAPT/REJECT in the top-down design README). Adopt existing Texture2D consumers; adapt square-unit composition to each actual Control; reject new scenic art, new game rules and asset approval by generation alone.

- `b44536f`: registered all thirteen exact approved PNGs (4 stations, 4 cargo, 5 decorations); connected eleven remaining renderer keys and all four pickup types.
- `fef77fb`: composed title/lesson/success/failure using approved textures, preserving shell APIs, copy, wordmark and input flow.
- `0bb8ce4`: corrected real-screen readability: title cargo clears the left panel; compact illustrations use 6×2 rather than 10×4. Cargo scale remains 0.62, with no padding enlargement; T2 station is cardinal-adjacent to its service rail.
- Controller: corrected seven superseded v02 consumer records, leaving caution active; updated human Blueprint and live QA helper. No game-rule/map changes or new bitmap generation.

## Five full-scope review passes

1. Scope/provenance: candidate-to-runtime byte identity, all thirteen consumers and lifecycle checks; Task 1 independent review Approved, no Critical/Important. Dimensions/mode/alpha were additionally re-derived with PIL for all thirteen and passed; adding that derivation to durable CI remains optional, not a claimed test.
2. Layout/interaction: Task 2 review and live inspection found small lesson/result objects and title cargo under UI. Before images are retained, not represented as final.
3. Failure injection/correction: actual consumer dimensions became regression inputs; readability RED produced nine failing assertions. Fix 0bb8ce4 passed actual resize signals, mode/state matrix and full regression. Task 2 re-review: all findings addressed, no Critical/Important.
4. Runtime/evidence: final 1280×720 framebuffer captures inspected after correction. RB01 success with remaining cargo=0/stack=0; pause preserves frame, resume, Retry layout/cancel and Edit; RB06/RB12 BUILD texture coverage; actual T1 preflight→T2; no-pickup T2→ROUTE_END failure. Inputs and clock are programmatic, not a human play study.
5. Ownership/publication: stale historical candidate consumers produced a failing assertion, then focused GREEN (1 passed). Approved catalog/manifest/owners reconciled. Final 54-page PDF rendered with overflow checks, runtime illustrations, atlas, rules, detailed SWOT, wireframes, flow tables and twelve map data tables. Publication hashes checked against current inputs. Whole-branch independent review is the next separate gate.

## Machine and runtime evidence

- Final product regression: **122 Godot cases / 15,281 assertions / 0 failures**; `task-2-fix1-green-godot.txt`.
- Python: **271 passed / 1 skipped**; `task-2-fix1-python-full.txt`. Includes the controller catalog correction in the prepared worktree, not only commit 0bb8ce4. The skipped case is not PASS.
- RED/GREEN task history is preserved in `task-1-report.md`, `task-2-report.md` and adjacent raw `.txt` logs. Report `.superpowers/.../*.log` locators describe original execution; identical basenames with `.txt` are the durable copies here.
- Live helper: `tests/runtime/topdown_family_live_qa.gd`; receipt and PNGs in this directory. RB06/RB12 are BUILD coverage, not completed attempts. Final runtime product source is 0bb8ce4; controller publication/catalog changes do not alter these three product scripts.
- Pickup uses static approved lids with 0.24-second presentation tween and lift 16% of marker target height. No fabricated Aseprite frames or sprite-sheet claim.
- Installed Hera CLI rejected game `--pid`; its run tracker and existing GodotAI tracker diverged. The already-adopted exact-session GodotAI stop/run restored live helper access without plugin upgrade, configuration migration or alternate project mutation.

## Evidence ceiling and cleanup

The attempted 960×540 window change was overridden by the embedded host: receipt stayed 1280×720. Those duplicate captures are disposable, not small-window evidence. Small Control geometry/resize is machine-tested; small physical viewport is **NOT_RUN**. Final user visual/audio review and platform/rights/release gates remain separate. Five-person comprehension and player-experience studies are not required by current user policy.

Unknown dirty imports, project settings and other worktrees remain protected. Only this task's finished rendering scratch and invalid duplicate capture attempt are moved into the existing user deletion holding folder with a manifest; **zero direct deletion**. This is a project-local consumer/actual-size regression improvement, not a Base promotion. No whole-game, human, device or release PASS is claimed.

Cleanup readback: 174 files / 22,302,608 bytes moved, all destination SHA-256 matched. Holding: `C:/Users/user/Desktop/Switchy_삭제대기_20260912/05_탑뷰작업_검증임시파일/manifest.json`. Prior PR288 holding batch remains unchanged. Moving files does not reclaim disk space; user deletion does.

Final controller regression repeated: `final-godot.txt` confirms 122/15,281/0. Publication Git-blob readback caught CRLF/LF differences in twelve unchanged map inputs. RED: two new publication tests failed. Corrected only text `.md/.py/.json` hash normalization, explicitly declared in receipt; PNG/PDF fingerprints remain exact raw bytes. Regeneration preserves the inspected PDF byte-for-byte (`93978663bd505b33b000b8978f9c3c431e23b895a17e9f82a51b265ad475273b`, 54 pages). Final Python suite after correction: 273 passed / 1 skipped; project contract validator passed. No map content changed.

## Independent final review and remote delivery locator

Whole-branch read-only review `2de6bd6..6027bb4e732de2a096dca231446d00ee58877670`: **Ready to merge: Yes**, no confirmed Critical/Important/Minor findings. Reviewer independently read the product scripts and regression changes, recalculated all thirteen asset/source hashes, inspected title/T2/RB12/success framebuffers, ran the two new publication tests (PASS), and checked full-range whitespace. Full Godot/Python counts were verified from controller evidence, not claimed as independently rerun. No dirty user files or other PRs were changed.

Delivery owner: [PR #289](https://github.com/alsdmlals4-eng/Switchy-Express-Cargo-Puzzle/pull/289). Its exact head, required-check conclusions and merge commit are authoritative remote readback; review approval alone is not merge proof. This review-record follow-up changes no product code, image, PDF or published input. Local main is attached to a pre-existing dirty worktree and is not forcibly reset/fast-forwarded. Current isolated branch and origin/main are compared after normal merge; unknown work remains preserved.
