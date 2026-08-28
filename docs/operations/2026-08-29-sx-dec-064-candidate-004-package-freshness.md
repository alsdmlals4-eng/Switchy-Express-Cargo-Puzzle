# SX-DEC-064 Candidate 004 package freshness and adversarial review

Status: `PACKAGE_VERIFIED · PHYSICAL/HUMAN/PLAYER NOT_RUN`

Tracking: GitHub Issue #251

## Incident / correction

| Field | Record |
| --- | --- |
| incident | The current post-060 pointer still selected Candidate 003 built from `main@8bce715b5045afebfb04d38108d2e3f7353e1b10`, although SX-DEC-064 changed player-facing active-route-lighting bytes at `2b98c0b070f2d8670b6432ac769a130bdd83bc39`. |
| risk | A Windows physical or player-reading claim could be incorrectly attached to pre-SX-DEC-064 bytes. |
| solution | Mint `SX60-POC-ACCEPT-004` from exact `main@58b99f261c3576150ab275bb041d744c69b83538`; preserve Candidate 003 as immutable prior-byte evidence; use the fail-closed pointer. |
| evidence | Windows Demo Export run `33190345143`, artifact `9693500347`, API/ZIP SHA-256 `04e230e3d62c518b3d76ae4938964d2a1234a82949b7e2f4af4a3a447822f303`; PCK SHA-256 `3325f11115fdf3fc57e39bb35c545d115217614eb1e58607934edacf0c6b0839`. |
| lesson | Any player-facing runtime byte change invalidates the current exact candidate. Package evidence must retain the source SHA, artifact digest, PCK audit, and a separate human-evidence ceiling. |

## Exact evidence

- The workflow was manually dispatched for exact `main@58b99f261c3576150ab275bb041d744c69b83538`, concluded `success`, and ran the project Python contracts, Godot headless tests, Windows export, Windows/Android runtime-JSON proof, and artifact hashing.
- The independently downloaded `SHA256SUMS.txt` agreed with the EXE and PCK hashes. The local no-launch validator downloaded the same immutable artifact, verified its live GitHub metadata and hashes, and did not start the executable.
- `tools/verify_godot_pck_integrity.py` verified the Godot 4.7.1 PCK v4: 500/500 payload entries; zero MD5 mismatch, bounds error, non-zero entry flag, or trailing unverified byte.
- The PCK has 79 product PNG imports and 79 CTEX references, with no missing or orphan reference. This is 73 semantic PNGs plus six runtime-presentation PNGs; it is not a new asset claim.

Machine-readable owners:

- `evidence/acceptance/post_sx_dec_060_candidate.json`
- `evidence/acceptance/sx60_poc_accept_004_artifact.json`
- `evidence/acceptance/sx60_poc_accept_004_pck_deep_audit.json`

## Five-pass adversarial review

| Pass | Failure assumption | Result / correction | Status |
| --- | --- | --- | --- |
| 1 — source freshness | Candidate 003 was still current after SX-DEC-064. | Candidate 003 was demoted to `HISTORICAL_SUPERSEDED_BY_SX_DEC_064_PRODUCT_BYTE_CHANGE`; Candidate 004 is the only current pointer. | Corrected |
| 2 — artifact identity | The Actions artifact could refer to a different source or a mutable download. | Workflow head SHA, artifact ID/name, API digest, independently hashed ZIP, and embedded EXE/PCK checksums agree. | PASS |
| 3 — package completeness | A valid ZIP could omit or corrupt runtime payloads or product textures. | PCK directory/hash audit passed 500/500; both JSON proofs passed; 79 PNG imports/79 CTEX references reconciled. | PASS |
| 4 — launcher safety | The verification route could select a newest artifact or launch the game accidentally. | `RUN_SX60_POC_SELF_RUN.ps1` reads only the explicit pointer, ancestry-checks it, passed `-ContractCheck`, and passed exact-artifact `-NoLaunch`. | PASS |
| 5 — evidence inflation | Export/package proof could be mistaken for visual, audio, or player validation. | Correct Switchy live-editor capture was unavailable; all physical visual, audio, Android device, five-person, and player-experience states stay `NOT_RUN`. | Retained boundary |

## External feasibility check

Material external claim: Windows export packages an executable alongside its PCK, and project export is a separate build-time verification concern. The current workflow uses Godot 4.7.1’s Windows export path; no external product or market decision was made in this task. See Godot’s official [Windows export guide](https://docs.godotengine.org/en/4.5/tutorials/export/exporting_for_windows.html) and [export workflow guide](https://docs.godotengine.org/en/4.5/tutorials/export/exporting_projects.html).

## Remaining required validation

1. Open this repository’s Switchy Express Godot project with the Hera live-editor addon enabled; the currently running unrelated Urban Legend editor must not be used.
2. Capture the same RUN state at the game viewport: selected route lights lime, unselected branch remains unlit, occupied lock remains separate crimson, and terminal states show no predictive route.
3. Run Windows physical smoke and audio-perceptual QA against Candidate 004, then the separately identified Android-device and five-person first-contact gates.

`NO_BASE_PROMOTION`: candidate IDs, exact hashes, project route-light semantics, and the active candidate pointer are project-specific. The reusable rule already exists in the Base workflow: exact player-facing bytes require exact candidate evidence.
