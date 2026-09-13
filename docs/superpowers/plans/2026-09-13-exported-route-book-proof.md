# Exported Route Book consumer proof

Parent main37f1575352086219602bca63f4c6d708e8d89bb4 (PR300 diagnostic-only merge).
Current approval: complete the existing game; no new maps/rules/art/save system.

## Findings / research / alternatives

The existing package checker parses first-session JSON but does not traverse the two
RouteBookCatalog entries, their stage maps/copy, or actual shell stage consumers.
Official export guidance: https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
ADOPT explicit mounted-package consumer validation. REJECT assuming a missing explicit
JSON filter means a missing file: actual PR299 export logs contain both book JSON files
and RB12, and all4 downloaded artifact hashes match. No filter change without evidence.
ADAPT the existing verifier invoked by Windows and Android proof-pack CI; no second gate.
Current PR299 artifact source tree136e6cea3a5fe93270325fc9423072f9ec780a6d equals
merged97ea477 tree. Downloaded actual EXE headless120frames and window120frames exit0.
These are startup observations, not all-stage gameplay completion or native-crash repair.

## Implementation / test sequence

1. RED: run the current verifier through a real Godot subprocess and require proof of
   both books,12 unique stages and their actual BUILD entries; current marker is absent.
2. Extend existing verifier: retain original required JSON checks; resolve current catalog,
   validate definitions, four-locale title/objective/context keys, load actual maps,
   then enter each stage through the actual main shell. Compare resulting map identity.
3. Use frame boundaries between released stage instances. No witness solutions, score,
   persistence, setting migration or production behavior change.
4. GREEN and existing full/Python regression; verify downloaded old PCK with external
   current verifier, then exact newly exported pack through normal CI.
5. Five-pass review (consumer/scope/layout/provenance/failure evidence), independent
   review, owners, normal PR/merge/readback. Keep native C0000005 explicitly NOT_FIXED.

Scope ceiling: checks data and BUILD entry, not solving12 stages, translation quality,
player experience, platform certification or release. Existing approved data are reused.
Rollback: revert verifier/test change only. No new Base promotion or deleted assets.
