# Terminal HUD guidance correction

Approved continuation: fix an observed contradiction in actual RB12 SUCCESS capture.
The phase says delivery complete while TimeLabel still asks the player to design rails.
Owner: ProductHUD.apply_model; result details remain owned by the existing result overlay.

Research NOT_MATERIAL: no new interaction or mechanic is being selected. This is a
finite-state presentation correction against actual phase data and existing copy.
ADOPT existing phase ownership; ADAPT build-only guidance; REJECT invented terminal
instructions, new localization strings, hidden timer changes and new bitmap assets.

Plan:
1. RED: four locales assert terminal/unknown guidance blank, active timer factual,
   and return to BUILD restores the existing design instruction.
2. Limit the existing design text to BUILD; leave timer and result summary unchanged.
3. Full regression, actual four-locale result captures, all12 completion captures,
   source-bound PDF refresh and Python validation.
4. Five-pass and independent review, required CI, normal merge/readback, updated package.

Pre-implementation five-pass: actual HUD consumer confirmed; no core expansion;
blank terminal slot avoids duplicate overlay wording; existing copy/art provenance;
RED must fail all four locales and no test/runtime evidence is a human approval.
