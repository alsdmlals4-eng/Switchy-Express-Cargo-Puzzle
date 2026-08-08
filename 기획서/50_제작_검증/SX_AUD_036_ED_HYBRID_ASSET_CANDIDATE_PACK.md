# SX-AUD-036 · E+D Hybrid Asset Candidate Pack Audit

**Decision:** `SX-DEC-051`  
**Status:** `CANDIDATE_PACKAGE_CREATED · PR_EXACT_HEAD_VALIDATION_PENDING`  
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

## TDD / validation contract

The branch contains:

- `tests/test_ed_hybrid_asset_pack.py`
- `tools/validate_ed_hybrid_asset_pack.py`

The tests require the six families, critical roles, and named RUN/BUILD/control slices. The validator checks PNG signature/dimensions, alpha declaration, path boundary, uniqueness, and runtime/final approval flags.

Actual PR exact-head results are not inferred here. They remain pending until GitHub Actions reports them for the final PR validation identity.

## Godot/runtime authority boundary

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite integration is part of this audit. Connected HiGodot and physical runtime evidence remain NOT_RUN.

## Current verdict

`CANDIDATE_CONTENT_READY_FOR_PR_VALIDATION · RUNTIME_POC_DEFERRED`
