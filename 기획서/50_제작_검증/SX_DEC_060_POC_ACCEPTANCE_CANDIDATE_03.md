# SX-DEC-060 POC Acceptance Candidate 03

Status: `PREPARED_PACKAGE_VERIFIED · HUMAN_PHYSICAL_EVIDENCE_NOT_RUN`

## Exact package identity

Machine-readable authority: `evidence/acceptance/sx60_poc_accept_003_artifact.json`

```yaml
candidate_id: SX60-POC-ACCEPT-003
decision_ids: [SX-DEC-060, SX-DEC-062]
source_main: 8bce715b5045afebfb04d38108d2e3f7353e1b10
artifact_workflow_run_id: 33159213393
artifact_id: 9680934351
artifact_name: switchy-express-windows-demo-8bce715b5045afebfb04d38108d2e3f7353e1b10
artifact_expires_at: 2026-09-11T09:25:30Z
artifact_zip_sha256: 3ba9f8f79f8a8d011ba6094c184f9643a37251eaa779f1c9ebb8e50ba90086ba
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 10481c5bafbcef32c805245134ba94745c1308cf91b1f633038fbfbef6c253f5
```

`artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA`.
`artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY`.

The artifact API digest and independently downloaded ZIP SHA-256 match. The downloaded `SHA256SUMS.txt` matches the independently hashed Windows EXE/PCK. Windows and Android packaged runtime JSON proof both report `PASS · parsed_json=27`.

## Deep package audit and asset-count reconciliation

`evidence/acceptance/sx60_poc_accept_003_pck_deep_audit.json` records the final verifier invocation.

- Godot PCK v4: 495 of 495 payload hashes verified; zero MD5 mismatch, bounds error, unsupported entry flag, or unverified trailing byte.
- Current asset truth is categorical: 73 semantic PNGs (`39 + 20 + 8 + 6`) plus six separate runtime-presentation PNGs equals 79 tracked product PNGs. The exact PCK contains 79 product PNG imports and 79 referenced CTEX entries, with zero missing or orphan references.
- This distinction corrects a stale use of `73` as a total-package count. It does not create, modify, or newly consume an image asset.
- The Candidate 003 package contains the user-approved SX-DEC-062 palette/panel/layer-order bytes. It changes no gameplay rule, map/data, bitmap asset, audio, or deferred-package authorization.

## Candidate boundary

Candidate 001 remains immutable historical package evidence for pre-route-readability bytes. Candidate 002 remains immutable prior-byte evidence and is superseded by the SX-DEC-062 player-facing runtime-composition change. Candidate 003 is the sole explicit current post-060 package route and is an exact descendant of the required product source.

NoLaunch package verification passed on 2026-08-28 in GitHub Actions Windows runner run `33161335690`; the exact Candidate 003 package was downloaded, its identity checked, and not launched. The following remain `NOT_RUN`: developer self-run; full Windows physical/input scenarios; audio perceptual QA; Android device; five-person comprehension; player experience; production cutover. NoLaunch proof does not promote any of them.

PR #174 remains `READ_ONLY`. No bitmap assets were created.
