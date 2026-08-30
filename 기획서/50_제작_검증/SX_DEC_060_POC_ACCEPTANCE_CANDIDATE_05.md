# SX-DEC-060 POC Acceptance Candidate 05

Status: `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact package identity

Machine-readable authority: `evidence/acceptance/sx60_poc_accept_005_artifact.json`

```yaml
candidate_id: SX60-POC-ACCEPT-005
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065]
source_main: a11dfd1a063e434ee22e8cfb7b073ebc380aa27a
artifact_workflow_run_id: 33301925424
artifact_workflow_run_number: 546
artifact_id: 9729236728
artifact_name: switchy-express-windows-demo-a11dfd1a063e434ee22e8cfb7b073ebc380aa27a
artifact_expires_at: 2026-09-13T08:36:25Z
artifact_zip_sha256: 90cb0e60bc0ddaf0124b1307647a155c5a663052673e34560e06dd4f4c1bf0ed
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: f826523a976a6a844e3bc8df8e10c24cbd4cfc015c01db282a58a6dfa5a022b6
```

`artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA`.
`artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY`.

The exact-main workflow dispatch passed: Python contracts `229 passed, 2 skipped`; Godot 4.7.1 headless tests `112 cases, 13560 assertions`; Windows export; Windows and Android validation-preset JSON proofs (`PASS · parsed_json=29` each); and artifact upload. The artifact API digest equals the independently downloaded ZIP SHA-256, while the exported `SHA256SUMS.txt` equals independently calculated EXE/PCK hashes.

## Deep package audit and approved consumer boundary

`evidence/acceptance/sx60_poc_accept_005_pck_deep_audit.json` records the final verifier invocation.

- Godot PCK v4: all 557 of 557 payload entries verified; zero MD5 mismatch, bounds error, unsupported entry flag, or unverified trailing byte.
- The package contains 85 `ed_hybrid_v1` entries and 23 `ed_hybrid_v2` entries. The v2 package contains 22 runtime PNG import records and its manifest; its non-runtime connected-rail master source is excluded.
- `ProductBoardRenderer` consumes the approved v2 terrain, train, v04 rail, station, and cargo paths. Candidate minting itself changed no gameplay, map/data, image, or audio byte; the exact source already contains the approved Core Board v04 assets and renderer consumer.

## Validation policy and evidence ceiling

Candidate 005 is the current machine-primary candidate required by `SX-DEC-065`. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or user approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. A final user review remains `NOT_RUN` and may be conducted only on this unchanged exact candidate when requested.

Candidates 001–004 are immutable historical prior-byte evidence. Candidate 004 cannot serve as a human or package proof for Candidate 005.

## Five-scope adversarial review

Result: `FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED · NO_BLOCKING_FINDING · NO_EVIDENCE_PROMOTION`

1. Artifact identity and source drift — Re-read the GitHub Actions run, artifact API digest, downloaded ZIP, `SHA256SUMS.txt`, EXE, PCK, and pointer source SHA. All bindings resolve to `a11dfd1a063e434ee22e8cfb7b073ebc380aa27a`; no digest or workflow-head mismatch was found.
2. Runtime consumer and scope expansion — Checked the actual `ProductBoardRenderer` v2 terrain/train/v04 rail/station/cargo paths against the package-prefix audit. Candidate minting adds evidence and current-state references only; it does not alter GDScript, map data, gameplay, or asset bytes.
3. Evidence-ceiling inflation — Inspected both Candidate 005 evidence owners and their regression contract. Physical visual/input, audio, device, accessibility, release, and final-user-review outcomes remain distinct. Five-person and player-experience gates are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`, not reported as passes.
4. Asset provenance and package membership — The exact PCK contains 85 v1 and 23 v2 entries, including 22 v2 runtime PNG imports and the v2 manifest. The connected rail master source is deliberately excluded from the package; no untracked or newly generated asset is promoted by this candidate record.
5. Reproducibility and fail-closed recovery — `RUN_SX60_POC_SELF_RUN.ps1 -ContractCheck` and its exact-candidate `-NoLaunch` package verification resolve Candidate 005 only. Local Python contracts, canon freshness, and project operating-contract validation pass; a missing or mismatched pointer remains fail-closed.

Official external research: `NOT_MATERIAL`. This change records an already user-approved acceptance-policy boundary and immutable machine evidence; it introduces no new product behavior, platform rule, or third-party dependency to benchmark.
