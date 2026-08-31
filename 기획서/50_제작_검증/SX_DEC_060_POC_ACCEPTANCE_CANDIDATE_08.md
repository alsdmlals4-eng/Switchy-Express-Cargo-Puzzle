# SX-DEC-060 POC Acceptance Candidate 08

**Status:** `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-008
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065, SX-DEC-066, SX-DEC-067, SX-DEC-068]
source_main: 53e29f874bc70a0057c310d661dc45dbecc6cf13
artifact_workflow_run_id: 33392296685
artifact_id: 9757983433
artifact_zip_sha256: f11fc0dc64ac59ce86d581bdb68e5833d79e92ec6345112c470a5f3a26b9902a
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 587559f1360c7cc532b06a6a001c09dfd1ad1373de23603cc489f6cfccc24658
```

Candidate 008 is the immutable machine-primary package for the player-facing bytes at exact `main@53e29f874bc70a0057c310d661dc45dbecc6cf13`. It includes the responsive main shell and `SX-TITLE-WORDMARK-001` as a runtime-connected image candidate. The package was workflow-dispatched through a temporary ref pointing only to that source commit; its immutable `head_sha` is the same source SHA. Candidate 007 remains exact historical package evidence for its own prior bytes and is not eligible to represent the title-wordmark build.

## Completed machine evidence

- GitHub Actions Windows Demo Export: `PASS`, exact run `33392296685` (run number `572`).
- Python contracts: `250 passed, 2 skipped`; Godot 4.7.1 headless: `120 cases, 14,125 assertions, 0 failed`.
- Windows and Android validation runtime JSON package proofs: `PASS · parsed_json=31` each.
- Independently downloaded artifact ZIP SHA-256 equals GitHub's API digest. The inner EXE and PCK hashes equal `SHA256SUMS.txt`.
- Independent PCK integrity: `575 / 575` verified entries, zero MD5 mismatch, bounds error, nonzero entry flag, or trailing unverified byte.
- Package membership includes 85 v1 and 32 v2 product-asset entries, twelve Route Book maps, and two Route Book definitions. The compiled title-wordmark texture and its source import descriptor are both inside the exact PCK.
- Export hygiene crosscheck: `evidence/` and `output/` have zero PCK entries.

## Validation policy and evidence ceiling

Candidate 008 follows SX-DEC-065: machine validation is primary. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or user approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. Final user review is `NOT_RUN` and may apply only to this unchanged exact candidate.

The title wordmark remains `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON · USER_PIXEL_REVIEW_PENDING`. Package inclusion verifies its real consumer only; it neither grants user pixel approval nor promotes the image to canon.

## Five-scope adversarial review

`FIVE_SCOPE_ADVERSARIAL_REVIEW_CLOSED`

1. **Artifact identity and source drift** — Bound exact source, workflow run, artifact ID, API/download ZIP digest, and EXE/PCK digests. **PASS**.
2. **Runtime consumer and scope expansion** — Confirmed the title candidate's actual `TitleLogo` consumer and PCK import/CTEX entries, while preserving maps, finite rules, actions, and saves. **PASS_WITH_CANDIDATE_BOUNDARY_RETAINED**.
3. **Export integrity and hygiene** — Independently verified all 575 PCK entries and proved `evidence/` and `output/` are absent. **PASS**.
4. **Evidence-ceiling inflation** — Kept physical visual/input, audio, device, accessibility, release, title-pixel approval, and final-user-review outcomes distinct from machine proof. **PASS_WITH_BOUNDARY_RETAINED**.
5. **Reproducibility and fail-closed recovery** — The current pointer names Candidate 008 explicitly and records immutable package digests; Candidate 007 is retained as explicit historical evidence rather than inferred as current. **PASS**.

Official external research is `NOT_MATERIAL`: this candidate mint records already-merged product bytes and introduces no new product, platform, engine, or third-party dependency.
