# Stage thinking iteration

Plan/research/design owner: docs/superpowers/plans/2026-09-13-stage-thinking-briefs.md.
Source baseline: 913309def20aad70e6af416a2c158e24766d6989. No map or core change.

Loop: compare Trainyard/Railbound/Cosmic Express official sources -> twelve planning questions
using actual cargo/destination/terrain features -> connect existing context_key/locale/Rules label
-> test all four locales and all twelve real selection flows -> live visual/transition review.

RED initial harness missed return_to_title between selections; not counted as valid feature RED.
That first full run also ended with native -1073741819 without TEST SUMMARY, a pre-existing
unresolved intermittent failure. Corrected valid RED: 126 cases / 15,663 assertions / 1 failed case.
GREEN: 126 cases / 15,663 assertions / 0 failed / exit 0. New flow test: 248 assertions.
Project contract PASS. Physical/human/release NOT_RUN. Native crash NOT_FIXED.

Live screenshots are actual runtime captures, not new production images or pixel approvals.
## Final correction and verification

Independent read-only reviewer completed five passes: actual map facts, core/no solver leak,
all locales, lifecycle/test coverage, visual/scope/evidence boundaries. No blocking finding.
Minor findings corrected: explicit cardinal service in RB01/RB07; Next context assertion.
RB08 now distinguishes required cargo caution contact from optional extra caution contact.
Empty optional context has a regression asserting stale text is cleared and label hidden.

Final serial runner: 126 cases / 15,669 assertions / 0 failures / native exit 0
(user://stage-thinking-final.log). New context test 251 assertions; flow test 30.
Full Python discovery (python -m pytest -q): 300 passed / 1 skipped, 11.26s.
Earlier narrower Python selection was 273/1; neither count is an engine assertion count.
python tools/validate_project_contract.py: PASS; git diff --check: no whitespace errors.

Actual editor project: codex-core-preserved-replan-20260910@eeb9, PID26468, main scene.
Programmatic live pointer Begin opens exact RB09_SALVAGE_SIDING; return/select RB02 changes
planning text. Screenshot salvage-briefing.png is 1280x720; capture_error=0; label reported
size=(632,55), minimum=(1,55). Korean screenshot inspected, Begin and copy visible.
Other languages are machine checked, not visually approved. No small/device/Human PASS.
Live helper: tests/runtime/stage_thinking_live_qa.gd. Screenshot is evidence, not new art.

Delivery: current-task PR owns exact head, remote checks, merge and post-merge readback.
This tracked document is a pre-merge receipt, not a self-referential claim about its own hash.
Preserve pre-existing dirty files, other PRs and user-only deletion policy.
Remaining: native intermittent exit diagnosis; map strategy diversity audit; viewport and
final review package refresh. Twelve briefs do not mean every game/release task is complete.
