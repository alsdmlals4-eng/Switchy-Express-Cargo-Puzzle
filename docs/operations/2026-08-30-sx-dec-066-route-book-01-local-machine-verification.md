# SX-DEC-066 Route Book 01 local machine verification

**Status:** `MERGED_MAIN_MACHINE_VERIFIED · PR_260 · SX60-POC-ACCEPT-006_PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN`

**Date:** 2026-08-30 KST
**Scope owner:** [`SX_DEC_066_CURATED_ROUTE_BOOK_01.md`](../decisions/SX_DEC_066_CURATED_ROUTE_BOOK_01.md)
**Implementation commits:** `d1d2087` (definition contract) → `49574b249cf4cfa675d4ba804851bfeb5e317dff` (six maps, flow, consumers, and tests)

## Purpose and boundary

The user approved the recommended Route Book 01 direction after the twelve-product public-source reverse-engineering record. This operation record retains local machine state and adds normal PR #260 merge plus the exact candidate sequence: Route Book product bytes merged to `main@9af5a8c46d29ea6781f9ee06008d7c7d2cde1877`; exact workflow run `33308989848` passed and minted `SX60-POC-ACCEPT-006`. It does not claim physical device, human/player study, or final user review evidence.

The user-selected validation policy remains machine-primary: five-person comprehension and player-experience studies are not required completion gates. They are not silently relabelled as passed. A final user review is still meaningful only for a named exact post-change candidate.

## Implemented player flow

```text
Title → Stage Book → select one of six fixed stages
      → existing Briefing → BUILD → RUN → factual Result
      → Retry Same Route | Edit Route | Stage Book | Next Stage
```

- `T1 → T2 → T3 → T4 → T5 → T6 → VS_DEMO_01` remains intact and independent; no T7 was created.
- The six fixed schema-v3 maps are `RB01_SERVICE_SIDINGS`, `RB02_REVERSE_ORDER`, `RB03_RETURN_MANIFEST`, `RB04_LOAD_WINDOW`, `RB05_FORK_LOCK`, and `RB06_PORT_CIRCUIT`.
- Every Route Book stage hides `RECOMMENDED_LAYOUT`, has no save, lock, unlock, score, reward, rank, generator, editor, daily/weekly, Yard Lab, Mastery, asset, audio, or core-rule addition.
- Existing Build/Run/HUD/route-control/result consumers are reused. Four-locale strings (`ko`, `en`, `ja`, `zh-Hans`) and the responsive direct-selection/result actions are added in their existing owners.

## Exact local machine evidence

| Check | Result | What it demonstrates | What it does not demonstrate |
| --- | --- | --- | --- |
| Project operating contract | `PASS` | Project-local operating-owner and contract consistency. | Merge, CI, package, or runtime-player evidence. |
| Python regression | `263 passed, 1 skipped` | Cross-project static/contract regression on the local implementation source. | Godot viewport, export, or device behavior. |
| Godot 4.7.1 headless suite | `118 cases, 0 failed, 13,791 assertions` | Route Book definition, maps, machine witnesses, direct flow, recovery, four-locale/UI contracts, responsive layout, and all pre-existing game regression. | Physical Windows/audio, Android device, human usability, or final user approval. |
| Godot exit diagnostics | `CLEAN for this run` | The final complete run exited without the new ObjectDB/resource-leak warnings. | A release/runtime performance result. |
| Route Book machine witnesses | `PASS` within the 118-case run | Each stage's intended finite success route and at least one meaningful counterexample execute through the actual finite session/run controllers. | A unique/optimal solution claim or solution reveal. |

The initial complete Route Book run exposed `92 ObjectDB` and `20 resource` exit warnings. The RB04 witness callback had captured its own `FiniteRunSession` through the delivery-loop signal, creating a reference cycle. The correction captures only the input-state dependency; the final full run above has no exit leak warning. This is a corrected local machine finding, not a hidden warning acceptance.

## Fresh remote and protected-workstream check

- Fresh `origin/main` readback on 2026-08-30 KST resolved to `28e85546a41734d3d243c79a76960b066f730889`.
- The local implementation history is `63ae5a6` (approved benchmark) → `d1d2087` → `49574b249cf4cfa675d4ba804851bfeb5e317dff`.
- The complete source diff is confined to Route Book data, localization, GDScript/scene flow, tests, and its registered owners. No Base pin, production image/audio, plugin, first-session content, or core finite owner is included.
- Read-only open-PR inspection found protected PR #174 and separate PR #254 still present and unchanged. This operation neither modified nor created a PR.

## Five full-scope adversarial review loops

| Loop | Failure assumption | Evidence and disposition |
| --- | --- | --- |
| 1 — product scope | The optional Route Book changes the protected first session or adds a new core rule. | Diff, `FirstSessionStagePolicy` reuse, direct flow tests, and the full suite show an independent six-stage surface with T1–T6/`VS_DEMO_01` unchanged. No core owner changed. **PASS**. |
| 2 — map/finite semantics | A stage can look valid while violating schema-v3, cargo exact-contact, cardinal service, LIFO, preflight, or occupied-switch lock. | Six JSON map contracts plus actual `FiniteBuildSession` / `FiniteRunSessionFactory` machine witnesses cover success and decision-specific failure counterexamples. **PASS**. |
| 3 — player flow/readability | Title selection, recovery, or responsive actions can expose an invalid route, a hidden recommendation, or an unreachable action. | Direct title→Stage Book→RB03→Result→RB04 flow and 960×540 / 2560×1080 control-layout tests pass. All Route Book stages omit `RECOMMENDED_LAYOUT`. **PASS_AT_MACHINE_EVIDENCE_CEILING**. |
| 4 — asset/provenance/import drift | The content pack could pull in an unapproved art, audio, or plugin change. | Intended implementation paths are data, GDScript, scene, localization, and tests only; no production asset, audio, plugin, or Base pin is staged. Godot-generated `.import` cache changes are deliberately excluded from commits. **PASS**. |
| 5 — evidence inflation | Automated success could be written as physical, player, or release evidence. | Documentation identifies local implementation commits, exact merged main, hosted CI/package Candidate 006, and retains physical/device/final-user states. Protected PR #174 and PR #254 are untouched. **PASS_WITH_BOUNDARY_RETAINED**. |

## Evidence ceiling and next safe gate

```yaml
route_book_01_definition_and_stage_data: IMPLEMENTED_LOCAL_COMMIT_d1d2087_AND_49574b2
route_book_01_project_contract: PASS
route_book_01_python_regression: PASS_263_PASSED_1_SKIPPED
route_book_01_full_headless_godot: PASS_118_CASES_13791_ASSERTIONS
route_book_01_godot_exit_leak_warning: NOT_PRESENT_IN_FINAL_RUN
route_book_01_first_session_scope: MACHINE_REGRESSION_PROTECTED
route_book_01_new_production_assets_or_audio: NONE
route_book_01_merged_main: PASS · PR_260 · main_9af5a8c46d29ea6781f9ee06008d7c7d2cde1877
route_book_01_hosted_ci: PASS · PR_260_HEAD_CHECKS_AND_EXACT_MAIN_READBACK
route_book_01_export_and_package_integrity: PASS · workflow_33308989848 · PCK_571_OF_571
route_book_01_exact_post_change_candidate: SX60-POC-ACCEPT-006 · PREPARED_PACKAGE_VERIFIED
route_book_01_windows_physical_and_audio: NOT_RUN
route_book_01_android_device: NOT_RUN
route_book_01_five_person_and_player_experience: NOT_REQUIRED_BY_SX_DEC_065
route_book_01_final_user_review: NOT_RUN
route_book_01_release_cutover: NOT_RUN
```

The implementation and machine-primary candidate sequence are complete. The only optional acceptance action is final user review on unchanged Candidate 006. No physical/device claim was performed in this operation.
