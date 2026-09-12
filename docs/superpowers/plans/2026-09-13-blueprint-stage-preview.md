# Blueprint stage-preview synchronization

Source: merged main 853a635b42b97c1452af89d67502e1c634cd3229 (PR 293).
Authority: current continuous implementation delegation; no core, asset promotion,
other PR, renderer-provider, or release decision changes.

## Problem and chosen structure

The existing 56-page derived Blueprint predates BUILD guidance, twelve stage
thinking prompts, and the actual selected-map preview. One old sentence also
calls Undo unauthorized despite its already merged implementation.

ADOPT the existing source-bound PDF builder and editable design owner.
ADAPT the Railbound interview / Trainyard FAQ findings already researched in
the stage-preview plan: connect a short question to actual geometry, preserve
self-discovery. REJECT new illustrative art, duplicated map descriptions, and
claiming the sampled RB08 detour is faster or an optimal solution.
This is publication synchronization, not a new product design decision.

## Execution plan

1. Add a failing publication test requiring localization and preview evidence
   inputs plus a planning-question page for each of the twelve existing stages.
2. Correct stale prose in the existing Blueprint source. Add actual preview
   captures and a source-bound question page next to each map's existing data
   page; use separate pages to keep the data tables readable.
3. Bind the exact localized strings and runtime receipt used by the PDF.
   Preserve the stable PDF path, asset atlas, wireframes, and finite rules.
4. Generate once inputs are ready; inspect changed page families visually and
   check every generated page for extractable text, page count, and bounds.
5. Run publication tests and full Python regression; five-pass review covering
   source truth, scope, layout, provenance, and evidence ceilings; correct
   findings, normal PR/checks/merge, and post-merge fingerprint readback.

## Boundaries and next work

This does not resolve the intermittent native Godot access violation. Passing
full runs and native failed invocations remain separate evidence.
No files are deleted. Render intermediates remain in a task-specific directory
for user-only cleanup. PDF generation is not runtime, human, or release PASS.

## Execution receipt

- RED: new binding/page coverage test failed on absent current inputs; previous2 tests passed.
- GREEN: publication3 tests; full Python301 passed/1 skipped; operating contract PASS.
- PDF72 pages; all pages contain text; text block page-bound findings0.
- Visual inspections: actual-preview pages2/3/4, loop14, map62, question63/71;
  corrected RB10/RB12 stale progress captures using post-draw actual selection.
- Independent five-pass read-only review found no blocking issue; its temporal-evidence
  wording finding was corrected: pre-merge full PASS is distinct from post-merge native exit.
- Local reviewer passes: source question/map parity, no runtime scope expansion,
  retained asset fingerprints, table/heading/caption fit, no human/release inflation.
- No deletion; task render intermediates under tmp/pdfs/blueprint-stage-preview-20260913.
- Exact delivery/checks/merge/post-merge fingerprints belong to this unit's PR readback.
