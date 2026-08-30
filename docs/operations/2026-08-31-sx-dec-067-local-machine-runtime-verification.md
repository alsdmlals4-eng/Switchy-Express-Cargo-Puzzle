# SX-DEC-067 local machine and live-runtime verification

**Recorded:** 2026-08-31 KST
**Revision under test:** local worktree `codex/wayside-hazards-salvage-20260830` based on `origin/main@17e962a8abd8505bde353cf992ef933e4f11c0d2`
**Evidence class:** local machine validation only

## Automated regression

```text
Godot: 4.7.1-stable official
runner: res://tests/run_tests.gd
result: PASS · 120 cases · 14,047 assertions · 0 failed
coverage added by SX-DEC-067:
  map optional-field validation and serialization
  caution departure-speed application and recovery
  WASTE_CRATE / DISPOSAL_YARD pairing and LIFO delivery
  retry identity with authored caution data
  renderer layer order, candidate texture loading, and snapshot transfer
  Route Book catalog, 4-locale copy, six map contracts, and six executable witnesses
  click-signal regression for book and stage cards
```

## Live Godot runtime inspection

The Hera-enabled Godot 4.7.1 editor was opened against the exact local worktree, not a concurrent Switchy worktree. Runtime inspection observed:

```text
title → semantic click “스테이지 북”
→ semantic click “스테이지 북 02 · 길가의 난관”
→ six Route Book 02 cards visible in the bounded scroll surface
→ select RB12 → build board contains five board-decoration kinds,
   an authored caution overlay, a WASTE_CRATE marker, and a DISPOSAL_YARD marker
```

The post-fix semantic book-card click completed with no runtime error. The runtime screenshot analyzer reported `nonblank: true` and `possible_clipping: false` for the Route Book 02 selection and RB12 build captures. The runtime error log was empty after the route selection and build entry.

Transient issue corrected during this run: a book-card pressed signal cleared its own node synchronously, causing `Attempted to free a locked object (calling or emitting).` The list cleanup now uses `queue_free()`, and the click-signal regression plus full suite pass prove the correction at this machine evidence level.

## Five-pass adversarial readback

| Pass | Challenge | Result |
| --- | --- | --- |
| Consumer/path | Could a candidate texture lack a real renderer slot, or could new map fields fail before the live consumer? | Corrected/verified: all eight slots are in `ProductBoardRenderer`, renderer loading tests pass, and RB12 rendered in the real product slice. |
| Visual/readability | Could decorations or new markers obscure tracks, destinations, or the selection flow? | Corrected/verified: layers place decoration below grid and rails; the RB12 build capture visibly distinguishes blocked decoration, caution overlay, W cargo marker, and disposal yard. |
| Runtime signal safety | Could dynamic book cards remove an emitting node and break real pointer input? | Finding corrected: `free()` changed to `queue_free()`; semantic book-card click and click-signal regression pass. |
| Scope/provenance | Did the change leak into first-session/Route Book 01 or quietly promote generated art? | Verified: T1–T6, VS_DEMO_01, and Route Book 01 data are untouched; the eight files remain separate candidates with SHA-256 records. |
| Evidence ceiling | Did automated import/runtime evidence get mislabeled as user, physical, or release evidence? | Verified: every owner says local machine only; candidate pixel review, package/CI/merge, physical/device/audio, final user review, and release remain unclaimed. |

## Evidence ceiling

```yaml
candidate_assets: GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON
user_pixel_review: USER_REVIEW_PENDING
local_machine_runtime: PASS
local_package_export: NOT_RUN_FOR_SX_DEC_067_BYTES
remote_ci_and_merge: NOT_RUN
windows_physical_audio_android_device: NOT_RUN
five_person_comprehension: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
player_experience_study: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
final_user_review: NOT_RUN · requires one unchanged post-change candidate
release_or_rights_promotion: NOT_RUN
```

This record does not promote the generated candidate images, prove physical-device appearance, substitute for a final user review, or transfer Candidate 006 evidence to the changed SX-DEC-067 bytes.
