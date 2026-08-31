# SX-DEC-067 Candidate 007 machine-package verification

**Status:** `PREPARED_PACKAGE_VERIFIED · CURRENT_POINTER_CONTRACT_READBACK_PASS · FINAL_USER_REVIEW_NOT_RUN`

## Authority and exact source

`SX-DEC-067` changed player-facing product bytes at `main@c0bb86efa5bad6050217ca67dd6aa9eba155dc75`, invalidating Candidate 006 for current review. The `Windows Demo Export` workflow only accepts a branch/tag reference for a manual dispatch, so the ephemeral ref `codex/sx067-candidate-source-20260831` was created to point directly at that immutable commit. Its workflow run recorded the same exact `head_sha`; no product, map, scene, asset, or workflow byte was changed to make the dispatch possible.

```yaml
candidate_id: SX60-POC-ACCEPT-007
source_main: c0bb86efa5bad6050217ca67dd6aa9eba155dc75
workflow_run_id: 33382094895
workflow_run_number: 563
artifact_id: 9754181081
artifact_api_digest_and_downloaded_zip_sha256: a48b689bcbe40fc229663ed8a1b254e876f210851cec43963cb8db72af6ff3ef
windows_pck_sha256: e848f9932c90210aa8e05b187dd69180c161258ad236ad0c5a278ecaa52669c4
android_validation_pck_sha256: 5e127d1ec3ad584a5cc89a2d65f5b5a2f122911b92eef5c03a8852b85b18005d
```

## Machine verification

| Scope | Exact result |
| --- | --- |
| Hosted Python contracts | `PASS · 240 passed, 2 skipped` |
| Hosted Godot 4.7.1 headless | `PASS · 120 cases, 14053 assertions, 0 failed` |
| Windows/Android package runtime JSON | `PASS · parsed_json=31` each |
| ZIP/API/inner digest binding | `PASS` |
| Independent Windows PCK integrity | `PASS · 599/599` entries; zero MD5, bounds, flag, or trailing-byte failures |
| Route Book packaging | `PASS · 12 map JSON + 2 definition JSON` |
| Product asset packaging | `PASS · v1=85, v2=31` PCK entries; v2 includes 8 SX-DEC-067 runtime-connected candidates |

The local audit was run on the artifact PCK after download, using `tools/verify_godot_pck_integrity.py`; it did not infer package identity from the prior Candidate 006 record.

## Five-scope adversarial review

1. **Source/artifact substitution:** exact source, workflow `head_sha`, run, artifact, archive digest, and inner hashes agree. **PASS**.
2. **Consumer/package omission:** Route Book 02 data and wayside product candidates are present alongside retained Route Book 01 content. **PASS**.
3. **Scope leakage:** Candidate mint adds only evidence routing; source package is the previously merged SX-DEC-067 product commit. **PASS**.
4. **Evidence inflation:** no physical, audio, device, accessibility, player-experience, or final-user PASS was recorded. **PASS_WITH_BOUNDARY_RETAINED**.
5. **Recovery/launcher behavior:** the explicit-pointer `-ContractCheck` resolved only Candidate 007 after the pointer update; the temporary dispatch ref was then removed. **PASS**.

Official external research is `NOT_MATERIAL`: the work is a bounded evidence/package verification of already merged bytes.
