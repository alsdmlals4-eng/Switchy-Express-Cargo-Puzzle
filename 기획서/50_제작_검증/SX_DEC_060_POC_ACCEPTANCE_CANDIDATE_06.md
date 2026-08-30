# SX-DEC-060 POC Acceptance Candidate 06

**Status:** `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-006
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065, SX-DEC-066]
source_main: 9af5a8c46d29ea6781f9ee06008d7c7d2cde1877
artifact_workflow_run_id: 33308989848
artifact_id: 9731396797
artifact_zip_sha256: fd55b69e86114e0b334983be7ae8c241a6f3709fbd9cc6fa9cdf00439fd4b888
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 1081187807e7f7a6b31cacf423e44da677d876dd5ad8ed81d3bae54a6b001311
```

This is the immutable machine-primary candidate for the product bytes after Route Book 01 merged through PR #260. Candidate 005 remains immutable historical evidence for `main@a11dfd1`; it cannot represent Route Book bytes.

## Completed machine evidence

- GitHub Actions Windows Demo Export: `PASS`, exact run `33308989848`, workflow-dispatched from the source SHA above.
- Python contracts: `235 passed, 2 skipped`; Godot 4.7.1 headless: `118 cases, 13,791 assertions, 0 failed`.
- Windows and Android validation runtime JSON package proofs: `PASS · parsed_json=30` each.
- Independently downloaded artifact ZIP digest and inner EXE/PCK hashes match the GitHub artifact and `SHA256SUMS`.
- Independent PCK integrity: `571 / 571` verified entries, zero MD5 mismatch, bounds error, nonzero entry flag, or trailing unverified bytes.
- Package membership confirms 85 v1 and 23 v2 product-asset entries plus six Route Book map JSON files and its one definition JSON.

## Validation policy and evidence ceiling

Candidate 006 follows `SX-DEC-065`: machine validation is primary. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or user approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. Final user review is `NOT_RUN` and may apply only to this unchanged exact candidate.

## Five-scope adversarial review

`FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED`

1. Artifact identity and source drift — Bound the workflow run, artifact ID, ZIP digest, source SHA, EXE/PCK digests, and historical Candidate 005 invalidation. **PASS**.
2. Runtime consumer and scope expansion — Checked the exact PCK for the six authored Route Book maps, its definition, existing product assets, and no candidate-mint gameplay, asset, or audio mutation. **PASS**.
3. Evidence-ceiling inflation — Kept physical visual/input, audio, device, accessibility, release, and final-user-review outcomes distinct from machine proof. **PASS_WITH_BOUNDARY_RETAINED**.
4. Asset provenance and package membership — Confirmed the existing approved product asset prefixes and Route Book data are packaged; no new generated art or unregistered consumer is promoted. **PASS**.
5. Reproducibility and fail-closed recovery — The current pointer names Candidate 006 explicitly; `RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck` passed and rejects absent or mismatched candidate/source identity. Its redundant local `-NoLaunch` download receipt remains `NOT_RUN`; independent download/hash/PCK evidence already binds this candidate. **PASS_WITH_BOUNDARY_RETAINED**.

Official external research is `NOT_MATERIAL`: this candidate mint records the already merged game bytes and does not introduce a product, platform, or third-party dependency change.
