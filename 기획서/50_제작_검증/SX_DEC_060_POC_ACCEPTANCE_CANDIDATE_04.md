# SX-DEC-060 POC Acceptance Candidate 04

Status: \`PREPARED_PACKAGE_VERIFIED · HUMAN_PHYSICAL_EVIDENCE_NOT_RUN\`

## Exact package identity

Machine-readable authority: \`evidence/acceptance/sx60_poc_accept_004_artifact.json\`

\`\`\`yaml
candidate_id: SX60-POC-ACCEPT-004
decision_ids: [SX-DEC-060, SX-DEC-062, SX-DEC-064]
source_main: 58b99f261c3576150ab275bb041d744c69b83538
artifact_workflow_run_id: 33190345143
artifact_workflow_run_number: 526
artifact_id: 9693500347
artifact_name: switchy-express-windows-demo-58b99f261c3576150ab275bb041d744c69b83538
artifact_expires_at: 2026-09-11T16:32:34Z
artifact_zip_sha256: 04e230e3d62c518b3d76ae4938964d2a1234a82949b7e2f4af4a3a447822f303
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 3325f11115fdf3fc57e39bb35c545d115217614eb1e58607934edacf0c6b0839
\`\`\`

\`artifact_id / artifact_name / artifact_expires_at = EPHEMERAL_DELIVERY_METADATA\`.
\`artifact/API digest + downloaded ZIP/EXE/PCK SHA-256 = DURABLE_CONTENT_IDENTITY\`.

The exact-main workflow dispatch completed successfully. The artifact API digest and independently downloaded ZIP SHA-256 match, and the downloaded \`SHA256SUMS.txt\` matches the independently hashed Windows EXE/PCK. Windows and Android packaged runtime JSON proof both report \`PASS · parsed_json=27\`.

## Deep package audit and asset-count reconciliation

\`evidence/acceptance/sx60_poc_accept_004_pck_deep_audit.json\` records the final verifier invocation.

- Godot PCK v4: 500 of 500 payload hashes verified; zero MD5 mismatch, bounds error, unsupported entry flag, or unverified trailing byte.
- 73 semantic product PNGs plus six runtime-presentation PNGs equal 79 tracked product PNGs. The exact PCK contains 79 product PNG imports and 79 referenced CTEX entries, with zero missing or orphan references.
- Candidate 004 includes the previously approved SX-DEC-064 procedural active-route lighting bytes. The candidate mint itself changes no gameplay rule, map/data, bitmap asset, audio, or deferred-package authorization.

## Candidate boundary

Candidate 003 is immutable exact package evidence for \`main@8bce715b5045afebfb04d38108d2e3f7353e1b10\`, but SX-DEC-064 changed player-facing route-readability code at \`2b98c0b070f2d8670b6432ac769a130bdd83bc39\`. Candidate 003 is therefore \`HISTORICAL_SUPERSEDED_BY_SX_DEC_064_PRODUCT_BYTE_CHANGE\`; it is not a physical/human proof for Candidate 004.

The following remain \`NOT_RUN\`: developer self-run; Windows physical/input scenarios; physical visual readability; audio perceptual QA; Android device; five-person comprehension; player experience; production cutover. Package, artifact, and JSON proof do not promote any of them.

PR #174 remains \`READ_ONLY\`. No bitmap assets were created.
