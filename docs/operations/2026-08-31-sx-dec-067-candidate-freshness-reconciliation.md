# SX-DEC-067 candidate freshness reconciliation

**Date:** 2026-08-31 KST
**Scope:** Current-candidate selection, launcher contract, current canon propagation, and regression coverage after SX-DEC-067.
**Product-source boundary:** SX-DEC-067 changed player-facing bytes at `main@c0bb86efa5bad6050217ca67dd6aa9eba155dc75`.
**Repository fresh-read:** `origin/main@28671aa08761dd6bf406fc502a86ff45c2caf60c`.
**Base fresh-read:** completed `origin/main@48dd501a10913251c4107d723bb677dae3ab9898`; no Base mutation is part of this reconciliation.

## Finding and correction

`SX60-POC-ACCEPT-006` contains valid immutable machine evidence for its exact Route Book 01 source revision, but that revision predates the player-facing SX-DEC-067 product change. The previous current pointer and several current-facing documents still selected or described Candidate 006 as the final-review route.

The current pointer is therefore corrected to fail closed:

```yaml
candidate_status: NOT_MINTED
current_candidate_id: null
minimum_product_source_main: c0bb86efa5bad6050217ca67dd6aa9eba155dc75
current_candidate_role: FAIL_CLOSED · NO_CURRENT_POST_SX_DEC_067_PACKAGE_CANDIDATE · CANDIDATE_006_HISTORICAL_ONLY
next_machine_action: MINT_EXACT_SX_DEC_067_MACHINE_PACKAGE_CANDIDATE
```

Historical Candidate 006 artifact, PCK, runtime-JSON, and self-run records remain unmodified and do not transfer to the changed bytes.

## Feasibility and research disposition

**Official external research:** `NOT_MATERIAL`. This is a source-identity and evidence-routing correction; it introduces no product rule, engine capability, third-party dependency, platform requirement, or visual direction to benchmark.

**Actual consumer/launcher boundary:** `evidence/acceptance/post_sx_dec_060_candidate.json` is consumed by `RUN_SX60_POC_SELF_RUN.ps1`. The launcher now accepts `NOT_MINTED` as a valid no-current-candidate state and reports the mint requirement without launching a package.

## Five-scope adversarial review

| Loop | Attack question | Result and correction |
| --- | --- | --- |
| 1. Authority and source identity | Could a valid Route Book 01 package be silently reused for the changed SX-DEC-067 product bytes? | Finding confirmed. Candidate 006 source `9af5a8c` predates the required minimum `c0bb86e`; the pointer now has no selected candidate and retains Candidate 006 under `historical_superseded_after_sx_dec_067`. |
| 2. Consumer and launch behavior | Could the self-run entry point infer or launch an old candidate despite the pointer change? | Finding confirmed and corrected. The launcher treats both `NOT_CREATED` and `NOT_MINTED` as fail-closed no-current states; `-ContractCheck` returns `NO_CURRENT_CANDIDATE_MINT_REQUIRED` without a package launch. |
| 3. Scope, assets, and provenance | Did the correction mutate gameplay, map data, generated art, package bytes, or immutable candidate evidence? | Clean. The scope is pointer, current canon, and regression contracts only. Candidate artifact records and approved runtime assets remain historical/unchanged. |
| 4. Runtime and visual-evidence boundary | Does this documentation/pointer correction claim Godot, import, package, physical, audio, or visual verification of the post-SX-DEC-067 bytes? | Clean. No Godot run, import, export, artifact download, physical review, audio review, or image promotion is claimed. The post-change package candidate remains `NOT_MINTED`. |
| 5. Evidence ceiling and policy | Are machine results inflated into final-user, five-person, or player-experience evidence; or do current hubs still route review to Candidate 006? | Finding confirmed and corrected. Current hubs, decision owners, GDD, skill, handoff, and final-review plan now state that Candidate 006 is historical. `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED` and `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED` remain policy states, while final user review remains `NOT_RUN` and requires a future unchanged exact candidate. |

## Verification evidence

1. RED-first regression: `tests/python/test_sx_dec_067_candidate_freshness.py` failed while the pointer selected Candidate 006, then passed after the fail-closed correction.
2. Focused regression after all current-canon corrections: `39 passed`.
3. Full Python regression: `272 passed, 1 skipped`.
4. Project operating contract: `PASS`.
5. `RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck`: `POST_SX_DEC_060_CANDIDATE_CONTRACT: NO_CURRENT_CANDIDATE_MINT_REQUIRED`.

These are machine/documentation checks. They do not produce runtime, physical device, audio, accessibility, final-user, release, or production-cutover PASS.

## Current next safe action

Merge this reconciliation first. Then, from an unchanged merged source revision at or descended from `c0bb86efa5bad6050217ca67dd6aa9eba155dc75`, mint one new exact machine package candidate through the existing export/artifact/PCK/runtime-JSON workflow. Only that candidate may become the optional final-user review target.
