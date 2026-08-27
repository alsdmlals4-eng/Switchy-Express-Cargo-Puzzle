# SX-DEC-060 POC Acceptance Candidate 02

Status: `PREPARED_PACKAGE_VERIFIED · HUMAN_PHYSICAL_EVIDENCE_NOT_RUN`

## Exact package identity

Machine-readable authority: `evidence/acceptance/sx60_poc_accept_002_artifact.json`

```yaml
candidate_id: SX60-POC-ACCEPT-002
decision_id: SX-DEC-060
source_main: 0e882764b837d13282a7642b115948d4e061d163
minimum_product_source_main: a8eee4f875a95e8da69802c4e60452df3535fe0e
artifact_workflow_run_id: 33030116761
artifact_id: 9629917429
artifact_name: switchy-express-windows-demo-0e882764b837d13282a7642b115948d4e061d163
artifact_expires_at: 2026-09-10T01:28:08Z
artifact_zip_sha256: b2602554ec28ba8597cc509c6dc2e1b61a946ca193a31673ed96bf9671c8c8e3
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: d360eb70b0182e3409b8c60a18e214e5324dd4af619e97b484d3c9dd9a27cd49
```

`artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA`.
`artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY`.

The artifact API digest and independently downloaded ZIP SHA-256 match. The downloaded `SHA256SUMS.txt` matches the independently hashed Windows EXE/PCK; Windows and Android packaged runtime JSON proof both report `PASS · parsed_json=26`.

## Deep package audit

`evidence/acceptance/sx60_poc_accept_002_pck_deep_audit.json` records the final verifier invocation.

- Godot PCK v4: 479 of 479 payload hashes verified; zero MD5 mismatch, bounds error, unsupported entry flag, or unverified trailing byte.
- Product texture package crosscheck: 73 PNG imports, 73 unique referenced CTEX entries, zero missing or orphan CTEX reference.
- This audit changes no gameplay/runtime, image, audio, or deferred-package authorization.

## Candidate boundary

Candidate 001 remains immutable historical package evidence for pre-route-readability bytes. Candidate 003 remains pre-SX-DEC-060 historical exact-byte evidence. Candidate 002 is the sole explicit current post-060 package route and is an exact descendant of the minimum product source.

The following remain `NOT_RUN`: developer self-run; full Windows physical/input scenarios; audio perceptual QA; Android device; five-person comprehension; player experience; production cutover. Package proof does not promote any of them.

PR #174 remains `READ_ONLY`. No bitmap assets were created.
