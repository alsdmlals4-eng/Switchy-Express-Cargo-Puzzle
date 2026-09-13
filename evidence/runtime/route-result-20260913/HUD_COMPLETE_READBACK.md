# Gameplay HUD language completion

Scope/alternatives/research: docs/superpowers/plans/2026-09-13-hud-complete-locales.md.
Parent main9fd5b8e, Base observationd830c0f; v9.4.3 compatibility unchanged.
Work Mode implementation; project router/design, planning/TDD, live-editor and PDF applied.
AgentMemory connector unavailable; actual repository owners used. Existing216 imports/settings
and unrelated174/254/281 remain protected. No image generation or Base promotion.

RED hud-complete-red:129/1/16007 exit1, missing translations and unknown-as-timeout.
First GREEN attempt:129/1/16007 because old test passed DISCONNECTED but expected timeout.
Corrected fixture to explicit TIME_EXPIRED; unknown branch independently guarded.
Final hud-complete-final:129 cases/0 failed/16039 assertions/exit0.
No native crash in these invocations; earlier intermittent native failure remains unresolved.

Runtime actual Main RB08 BUILD/RUN/no-pickup ROUTE_END in4locales, physical960x540.
Original notice/history rectangle overlap reproduced4 times in hud-overlap-red.log;
notice right edge -272 keeps it on board, final runtime0 failures/exit0.
Separate64-token HUD projection uses actual theme, no background Main overlay; final row
scroll reached. This is NOT an actual64-cargo authored gameplay run. Raw runtime images,
sourceLF hashes, scene hash and capture hashes are owned by receipt.json.
Earlier result/status screenshots are replaced by current runtime observations; old logs retained.

Five-pass review: semantic/consumer lifecycle; core/scope; four-locale layout;
asset provenance(no new assets); failure/evidence. Independent review had no blocking
production finding, requested additional state assertions now included. Root image review
caught notice overlap and ambiguous stress capture backdrop, both corrected and rerun.
Remaining review closure/CI/postmerge evidence is recorded in the current-task PR.

Independent final review: no blocking finding. Screenshot ja manifest shows final TOP row;
the scalar scroll>0 check alone is weaker and is not claimed to prove last-row visibility.
BUILD capture covers EMPTY_LAYOUT, not every repair string. Python305 passed/1 skipped,
project contract PASS. Human Blueprint77pages, source-bound hash e0a47f64edfd7506846b39db330695b466feb87ec8534575bcc7d4910f15b57e;
no empty/out-of-page text, pages3/13 rendered and inspected. Prior PDF75/76 counts are historical.

Learning: translating labels is insufficient; measure sibling rectangles and actual last-row
scroll, separate injected UI stress from real gameplay. Project-only until reusable evidence.
Rollback via scoped revert PR. Whole game, human translation/UX, release NOT_COMPLETE.
