# SX-DEC-060 POC Acceptance Candidate 07

**Status:** `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-007
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065, SX-DEC-066, SX-DEC-067]
source_main: c0bb86efa5bad6050217ca67dd6aa9eba155dc75
artifact_workflow_run_id: 33382094895
artifact_id: 9754181081
artifact_zip_sha256: a48b689bcbe40fc229663ed8a1b254e876f210851cec43963cb8db72af6ff3ef
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: e848f9932c90210aa8e05b187dd69180c161258ad236ad0c5a278ecaa52669c4
```

Candidate 007 is the immutable machine-primary package for the player-facing bytes introduced through SX-DEC-067. It was workflow-dispatched through a temporary ref pointing only to the exact merged source commit; the run's immutable `head_sha` is `c0bb86efa5bad6050217ca67dd6aa9eba155dc75`. Candidate 006 remains immutable Route Book 01 history and is not eligible for final-user review of the changed bytes.

## Completed machine evidence

- GitHub Actions Windows Demo Export: `PASS`, exact run `33382094895` (run number `563`).
- Python contracts: `240 passed, 2 skipped`; Godot 4.7.1 headless: `120 cases, 14,053 assertions, 0 failed`.
- Windows and Android validation runtime JSON package proofs: `PASS · parsed_json=31` each.
- Independently downloaded artifact ZIP SHA-256 matches the GitHub API artifact digest. The inner EXE and PCK hashes match `SHA256SUMS.txt`.
- Independent PCK integrity: `599 / 599` verified entries, with zero MD5 mismatch, bounds error, nonzero entry flag, or trailing unverified bytes.
- Package membership includes 85 v1 and 31 v2 product-asset entries, twelve Route Book maps, and two Route Book definitions. The v2 total includes the eight SX-DEC-067 runtime-connected wayside candidates without promoting them to canonical image status.

## Validation policy and evidence ceiling

Candidate 007 follows SX-DEC-065: machine validation is primary. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or user approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. Final user review is `NOT_RUN` and may apply only to this unchanged exact candidate.

## Five-scope adversarial review

`FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED`

1. Artifact identity and source drift — Bound the exact source commit, workflow run, artifact ID, GitHub API/download ZIP digest, EXE/PCK digests, and Candidate 006's historical invalidation. **PASS**.
2. Runtime consumer and scope expansion — Checked the source delta and exact PCK for Route Book 01/02 maps, definitions, existing product assets, and eight runtime-connected SX-DEC-067 asset candidates. Candidate mint records no gameplay, map, or asset-byte mutation. **PASS**.
3. Evidence-ceiling inflation — Kept physical visual/input, audio, device, accessibility, release, and final-user-review outcomes distinct from machine proof. **PASS_WITH_BOUNDARY_RETAINED**.
4. Asset provenance and package membership — Confirmed the tracked v1/v2 prefixes and Route Book data are packaged; no generated image is promoted to canonical art by this candidate. **PASS_WITH_BOUNDARY_RETAINED**.
5. Reproducibility and fail-closed recovery — The current pointer names Candidate 007 explicitly; `RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck` resolved only Candidate 007, while the launcher retains source-ancestry and immutable-hash checks before any optional package download. **PASS**.

Official external research is `NOT_MATERIAL`: this candidate mint records already-merged game bytes and introduces no product, platform, engine, or third-party dependency change.
