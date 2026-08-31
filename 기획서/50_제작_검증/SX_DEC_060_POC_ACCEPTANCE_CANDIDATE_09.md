# SX-DEC-060 POC Acceptance Candidate 09

**Status:** `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-009
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065, SX-DEC-066, SX-DEC-067, SX-DEC-068]
source_main: 1ac3099d9ab1451323cca2935547f82d210b50b4
artifact_workflow_run_id: 33396533310
artifact_id: 9759591197
artifact_zip_sha256: fe90c0b85abfa23684ac07b1cfb391e3b56e3f6f912180bd9702311b3fbefc22
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 5f5de90db1587f07c8e44e9ae1c8efcde8db6bd3c222785bf4f8eea5a4478d8c
```

Candidate 009 is the immutable machine-primary package for the title-wordmark’s user-approved canonical-status product bytes at exact source `1ac3099d9ab1451323cca2935547f82d210b50b4`. The workflow was dispatched through a temporary ref that resolves exactly to that commit; Candidate 008 remains immutable historical evidence for its own pre-canonical-status package bytes.

## Completed machine evidence

- GitHub Actions Windows Demo Export: `PASS`, exact run `33396533310` (run number `575`).
- Python contracts: `250 passed, 2 skipped`; Godot 4.7.1 headless: `120 cases, 14,125 assertions, 0 failed`.
- Windows and Android validation runtime JSON package proofs: `PASS · parsed_json=31` each.
- Independently downloaded artifact ZIP SHA-256 equals GitHub’s API digest. The inner EXE and PCK hashes equal `SHA256SUMS.txt`.
- Independent PCK integrity: `575 / 575` verified entries, zero MD5 mismatch, bounds error, nonzero entry flag, or trailing unverified byte.
- Package membership includes 85 v1 and 32 v2 product-asset entries, twelve Route Book maps, and two Route Book definitions. The compiled title-wordmark texture, its source import descriptor, and the canonical asset manifest are inside the exact PCK.
- Export hygiene crosscheck: `evidence/` and `output/` have zero PCK entries.

## Validation policy and evidence ceiling

Candidate 009 follows SX-DEC-065: machine validation is primary. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or production-cutover approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. Final user review is `NOT_RUN` and may apply only to this unchanged exact candidate.

The title wordmark is `USER_APPROVED_CANONICAL_PRODUCT_ASSET_RUNTIME_CONNECTED · USER_PIXEL_APPROVED · CANON_REGISTERED`. Its promotion applies only to the tracked PNG and its verified `TitleLogo` consumer; it does not grant release clearance or transfer physical/device/human evidence.

## Five full-scope adversarial review loops

`FIVE_FULL_SCOPE_ADVERSARIAL_REVIEW_LOOPS_CLOSED`

1. **Artifact identity and source drift** — Bound exact source, workflow run, artifact ID, API/download ZIP digest, and EXE/PCK digests. **PASS**.
2. **Consumer and canonical-status omission** — Confirmed the wordmark’s sole `TitleLogo` consumer, PCK import/CTEX entries, and canonical manifest state while preserving maps, finite rules, actions, and saves. **PASS**.
3. **Export integrity and hygiene** — Independently verified all 575 PCK entries and proved `evidence/` and `output/` are absent. **PASS**.
4. **Evidence-ceiling inflation** — Kept pixel approval/canonical promotion separate from physical visual/input, audio, device, accessibility, human/player, release, and final-user-review outcomes. **PASS_WITH_BOUNDARY_RETAINED**.
5. **Reproducibility and fail-closed recovery** — The explicit pointer names Candidate 009 and immutable package digests; Candidate 008 is retained as history rather than inferred as current. **PASS**.

Official external research is `NOT_MATERIAL`: this candidate mint verifies already-approved project bytes and introduces no new product, platform, engine, or third-party dependency.
