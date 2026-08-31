# SX-DEC-060 POC Acceptance Candidate 10

**Status:** `PREPARED_PACKAGE_VERIFIED · MACHINE_PRIMARY_ACCEPTANCE_READY · FINAL_USER_REVIEW_NOT_RUN`

## Exact candidate

```yaml
candidate_id: SX60-POC-ACCEPT-010
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064, SX-DEC-065, SX-DEC-066, SX-DEC-067, SX-DEC-068, SX-DEC-069]
source_main: 79323ff0175b674c594d18dfd6d28a8e9951f5bd
artifact_workflow_run_id: 33415291733
artifact_id: 9766817524
artifact_zip_sha256: e90e735e6f3571e6e10e075759983021bec006d5636f8f292a5437775a2beefc
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: e326a7fab45e939d912d1c4ceed37e9cd959eed769530e8972b39c8a1c3468d3
```

Candidate 010 is the immutable machine-primary package for the merged SX-DEC-069 player-facing bytes at exact source `79323ff0175b674c594d18dfd6d28a8e9951f5bd`. Candidate 009 remains immutable evidence only for its pre-SX-DEC-069 canonical-wordmark source `1ac3099d9ab1451323cca2935547f82d210b50b4`; it is not eligible for a final review of the changed product bytes.

## Completed machine evidence

- GitHub Actions Windows Demo Export: `PASS`, exact run `33415291733` (run number `584`) on `main` at the exact source SHA.
- Python contracts: `254 passed, 2 skipped`; Godot 4.7.1 headless: `120 cases, 14,133 assertions, 0 failed`.
- Windows and Android validation runtime JSON package proofs: `PASS · parsed_json=31` each.
- Independently downloaded artifact ZIP SHA-256 equals GitHub’s API digest. The inner EXE and PCK hashes equal `SHA256SUMS.txt`.
- Independent PCK integrity: `591 / 591` verified entries, zero MD5 mismatch, bounds error, nonzero entry flag, or trailing unverified byte.
- Package membership includes 85 v1 and 40 v2 product-asset entries, twelve Route Book maps, two Route Book definitions, the eight transparent v02 import descriptors, `ProductBoardRenderer`, and the asset manifest.
- Export hygiene crosscheck: `evidence/` and `output/` have zero PCK entries.
- The fail-closed pointer contract and no-launch package recheck both passed for Candidate 010.

## Validation policy and evidence ceiling

Candidate 010 follows SX-DEC-065: deterministic machine verification is primary. It is not a Windows physical run, visual inspection, audio-perceptual result, Android-device result, accessibility result, release result, or production-cutover approval. `five_person_comprehension` and `player_experience` are `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; they are not pending gates. Final user review is `NOT_RUN` and may apply only to this unchanged exact candidate.

The title wordmark remains `USER_APPROVED_CANONICAL_PRODUCT_ASSET_RUNTIME_CONNECTED · USER_PIXEL_APPROVED · CANON_REGISTERED`. The eight SX-DEC-069 wayside/cargo/disposal assets are separately `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON · USER_PIXEL_REVIEW_PENDING`. Package inclusion proves consumer packaging, not pixel approval, physical display, device behavior, accessibility, human/player experience, release clearance, or production cutover.

## Five full-scope adversarial review loops

`FIVE_FULL_SCOPE_ADVERSARIAL_REVIEW_LOOPS_CLOSED`

1. **Artifact identity and source drift** — Bound exact `main` source, workflow run, artifact ID, API/download ZIP digest, and EXE/PCK digests. **PASS**.
2. **Consumer and candidate-state omission** — Verified all eight v02 transparent import descriptors, `ProductBoardRenderer`, and the manifest in the PCK while retaining the v02 `USER_PIXEL_REVIEW_PENDING` state. **PASS**.
3. **Export integrity and hygiene** — Independently verified all 591 PCK entries and proved `evidence/` and `output/` are absent. **PASS**.
4. **Evidence-ceiling inflation** — Preserved the approved title-wordmark state while keeping v02 pixel review, physical visual/input, audio, device, accessibility, human/player, release, and final-user-review outcomes separate. **PASS_WITH_BOUNDARY_RETAINED**.
5. **Reproducibility and fail-closed recovery** — The explicit pointer names Candidate 010 and immutable package digests; Candidate 009 is retained as history rather than inferred as current. **PASS**.

Official external research is `NOT_MATERIAL`: this candidate mint verifies already-approved project bytes and introduces no new product, platform, engine, or third-party dependency.
