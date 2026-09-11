# Strict top-down approved-blue runtime review

Product source: cab1b55c25c9b90063cb4d4ef283087f513ea793.
Godot 4.7.1 live session: codex-core-preserved-replan-20260910@2922, editor PID38656,
run_token13. Exact project path verified. Global Hera status selected another project, so the
existing documented explicit-session GodotAI fallback was used; other project sessions untouched.

## Evidence

- Existing tests/runtime/night_workshop_live_qa.gd executed in the live editor game, not headless.
- 1280x720 actual framebuffer; programmatic UI signals and authored RB01 witness/manual domain steps.
- build.png, pickup-0.png through pickup-3.png, result.png and receipt.json captured from this source.
- Four samples: opacity 1,0.745833,0.491667,0.2375; normalized Y offset 0,-0.114608,-0.159945,-0.108608.
- Pause/Resume retained timeline state; SUCCESS and same-layout Retry/Edit passed helper assertions.
- Stronger active-Retry regression lives in tests/demo/test_vertical_slice_end_to_end.gd:
  new assertion failed before correction, passed after explicit presentation cancellation hook.
- Full GDScript: 121 cases / 14,505 assertions / zero failures (implementation-report.md).
- Controller re-ran full Python after correction: 262 tests / one pre-existing skip, exit0.
  Two historical deferred-candidate CRC diagnostics remain outside runtime approval; not hidden.
- Project contract PASS. Thirteen candidate records' hashes/dimensions/modes validated; eleven pending.
- Export presets exclude evidence/** and tests/**, so unapproved candidates/review captures are not game content.

## Five-pass full-scope review

| Pass | Attack and observed evidence | Outcome |
|---|---|---|
| 1 consumer/scope | Diff touches approved blue presentation, no maps/domain semantics; new other PNGs only evidence | Pass for bounded increment, whole family incomplete |
| 2 camera/readability | Inspected build and pickup captures at native viewport; blue roof/lid top faces, retained 0.62 cargo target; no opaque rectangle/large fringe visible at this scale | Pass at captured scale only, human visual judgment separate |
| 3 lifecycle | Independent review found missing Resume/Retry proof; deterministic new Retry assertion failed, explicit cancellation fixed it; re-review clean | Corrected, 121/14505 green |
| 4 provenance/import | Exact approved hashes equal candidate bytes; Aseprite single-frame import and transparent corner readback; real Godot Texture2D consumer loads | Pass for blue pair; other eleven not runtime-verified |
| 5 evidence/cleanup | Current source/captures distinguished from PR286; shell art visibly still old and not claimed topdown; rejected new scenic generations excluded; SDD report moved to permanent owner | Full-family approval/shell/PDF still open, not a whole-product PASS |

## Task review

Independent read-only reviewer found one Important coverage gap. Fix round1 produced an actual
Retry presentation bug reproduction and correction at cab1b55. Scoped re-review found all findings
addressed, no new Critical/Important breakage. Final whole-branch/remote checks remain separate.

Final independent read-only review of 4107517..a51e3f2 found no Critical/Important
issues and approved this bounded increment for merge, subject to remote checks.
Its minor historical-report locator/pending wording was corrected; no product
bytes changed. Local main checkout has pre-existing deletion state and is not
safe for forced synchronization. Aseprite staging cleanup was blocked by the
host policy; duplicate staging files remain, while tracked sources are intact.

## Learning / retention

Project lesson: static overhead texture movement preserves approved pixel identity; "same-view"
scene prompts alone did not preserve roof footprints or eliminate small prop side faces. Prefer
explicit source-family composition for the next shell revision. Geometry-approved raw alpha may
still have faint noise: do not size sprites using any-alpha bbox or enlarge to compensate.
No Base rule was promoted; evidence here is project-specific, not a verified multi-project method.
No local background removal, new provider, core mechanics, release certification or human study.
Candidate approval, runtime appearance and release rights remain distinct gates.
