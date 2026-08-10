# v4.5 r2 canonical payload bundle

Current locator/manifest:

`PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`

Do not read an individual `payload.part*` file as a complete instruction document. The current canonical payload is the **ordered binary concatenation** defined by the root manifest. The manifest owns segment order, byte counts, SHA-256 values, Git blob identities, and the full reconstructed source identity.

This directory exists only because the connected GitHub write surface in the establishing session did not expose a safe local-file streaming argument for one 77,734-byte contents write. The bundle is content-addressed to prevent silent source rewriting.

Do not edit payload segments independently. A future r2 correction must replace the source authority intentionally, recompute the full identity, and update the root manifest/audit together.
