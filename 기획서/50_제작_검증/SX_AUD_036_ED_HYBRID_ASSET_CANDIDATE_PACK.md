# SX-AUD-036 · E+D Hybrid Asset Candidate Pack Audit

**Decision:** `SX-DEC-051`  
**Status:** `FIRST_PR_VALIDATION_COMPLETE · FINAL_HEAD_RECHECK_REQUIRED`  
**Date:** 2026-08-08 KST

## Scope audited

`art/production_candidates/ed_hybrid_v1/` contains 16 tracked PNG production candidates across six families. `.gdignore` keeps the candidate tree outside current Godot runtime import authority.

## Candidate counts

| Family | Count | Main roles |
|---|---:|---|
| core_world | 4 | blue locomotive, red/blue/yellow smaller wagons |
| run_lifo | 5 | stack HUD, switch states, train strip, load mode, combo |
| build_states | 2 | placement preview, track palette |
| controls | 1 | seven common interaction states |
| vfx | 1 | static/Reduced Motion feedback primitives |
| shells_result_meta | 3 | success shell, failure shell, progress/meta |
| **Total** | **16** | |

## Provenance

`manifest.json` records approved conversation reference source filenames and SHA256 values. Tracked candidates are derivatives/crops/compositions for project review and remain `NOT_FINAL_ASSET_APPROVED`.

Primary source hashes recorded in the manifest include:

- `네온_기차_퍼즐_게임_자산_시트.png` → `edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d`
- `화려한_기차_퍼즐_게임_ui_스타일_가이드.png` → `2ccc02770db4e8c62f7309e8c00294a7fd0adcf4999413821b58e2473dd693d8`
- `컬러풀_모바일_게임_ui_에셋_시트.png` → `34f4fefeabdd0030b0689868899cd71e4cf694e475f12280bb75ea61aa25d6d7`
- `캐주얼_퍼즐게임_미션_ui_세트.png` → `c2ca43f57fec86d1434c893a5f6f39d2b16567c26f0ce895581490c3a00a5fa4`
- `imagegen.png` → `739b1caacd691851a29e6cb6b0803e37d0413d5cdce69b1ff6df634806b8fa3b`

## Visual/adversarial review

Technical findings fixed inside approved scope:

- generated text/labels removed from reusable train/switch candidates;
- success/failure shells rebuilt as text-safe blank panels;
- progress/meta primitives rebuilt without generated localized copy;
- locomotive remains the visual vehicle anchor while wagons remain clearly smaller;
- selected/locked switch states and button states use form/treatment differences, not hue-only semantics;
- static feedback candidates preserve meaning for Reduced Motion use.

No third-party branded IP, commercial game UI skin, or named living-artist/studio imitation was intentionally used as the target style.

## TDD / focused static validation

The branch contains:

- `tests/test_ed_hybrid_asset_pack.py`
- `tools/validate_ed_hybrid_asset_pack.py`

The tests require the six families, critical roles, and named RUN/BUILD/control slices. The validator checks PNG signature/dimensions, alpha declaration, path boundary, uniqueness, and runtime/final approval flags.

Fresh focused execution against the candidate bytes used for GitHub blobs:

- `python -m pytest tests/test_ed_hybrid_asset_pack.py -q` → **PASS · 3/3 tests**
- `python tools/validate_ed_hybrid_asset_pack.py` → **PASS · 16 assets validated for SX-DEC-051**

## First PR validation identity and CI

PR: `#113`  
Base SHA: `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
First review head SHA: `469ece8910967abd7b3a422108eee56cb51d18f3`  
First test-merge SHA observed by the Godot workflow: `f92ffc0044f742b23c891e9e47552ed2b1fa76ee`

First validation runs:

- Project Contract `31260051466` → **PASS**
- GUT 9.7.1 Tests `31260051452` → **PASS**
- Validate Thin Adapter Migration `31260051455` → **PASS**
- Godot Tests `31260051463` → first attempt **FAIL only at real-project live-editor Pilot with `RUNTIME_TIMEOUT · project regression timeout`**; standalone headless regression in the same job was **PASS · 92 cases · 11,494 assertions**.

### Timeout root-cause investigation

The failure was treated as a technical failure, not ignored:

1. the first error was read from the job log and isolated to the Pilot's nested project-regression subprocess;
2. the PR changed no Godot runtime/pilot implementation files;
3. the same standalone regression on the PR test merge passed 92/92 with 11,494 assertions;
4. baseline `main` Godot run `31254615620` had the same Pilot PASS, with its nested regression completing in about 9.9 seconds;
5. the candidate art tree is under `art/production_candidates/.gdignore` and is not current runtime content.

Single hypothesis: transient CI nested-regression hang rather than source regression.

Minimal hypothesis test: rerun the same failed Godot job **without source changes**. Result: rerun job `93109984618` → **PASS**, including headless regression and real-project live-editor Pilot. Therefore the initial timeout is classified as `TRANSIENT_CI_RUNTIME_TIMEOUT · REPRODUCTION_NOT_CONFIRMED` rather than a product/source regression.

Because this audit update itself changes the PR head, the above is historical first-head evidence only. The final PR head must receive a fresh exact validation set before merge.

## Godot/runtime authority boundary

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite integration is part of this audit. Connected HiGodot and physical runtime evidence remain NOT_RUN.

Windows physical runtime, Android device, human comprehension, runtime integration/POC, and final product-asset approval remain deferred.

## Current verdict

`CANDIDATE_CONTENT_READY · FIRST_PR_VALIDATION_COMPLETE · FINAL_HEAD_RECHECK_REQUIRED · RUNTIME_POC_DEFERRED`
